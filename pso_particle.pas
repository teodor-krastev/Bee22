(************************************************************************)
(*  Based on paspso by Filip Lundeholm 2010                             *)
(*  Developed by and copyright(c) Teodor Krastev 2015-2016              *)
(************************************************************************)
unit pso_particle;

interface

uses Classes, SysUtils, Math, pso_variable, System.Types, Generics.Collections,
   blk_particle, blk_subSw, UtilsU, AdjustU;

type
  TSpeed = (spdMax, spdAver, spdTop);
  rSpeedComp = record scInertia, scSocial, scCogn: double;
               end;
  { TParticle }
  TParticle = class
  private
    FFitness, FBestFitness: double;
    fIdx, fTotal, fOutCount: integer;
  public
    FVariables: TVariableList;
    Controller: TObject;
    Adjust: TAdjust; // behaviour setting
    FPos, FSpeed, FPersonalBest, mxSpeed: TDoubleDynArray;
    lastInertia, lastSocial, lastCogn: double;

    FactorBlock: TFactorBlock; // cogn & social factors
    InertiaBlock: TInertiaBlock;   // inertia models

    ClubsBlock: TClubsBlock;       // clubs topology
    BiswarmBlock: TBiswarmBlock;       // sub-swarms
    PosLimitBlock: TPosLimitBlock; // owned by ctrl

    constructor Create(variables: TVariableList; maxIterations,aIdx,aTotal: integer); overload;
    destructor Destroy(); override;
    procedure Init(ctrl: TObject; equidist: boolean = false);
    function GetProp(propName: string): double;

    function getFitness(): double;
    procedure setFitness(fitnessValue: double);
    procedure Update(const swarmBestPos: TDoubleDynArray);
    function getPosition: TDoubleDynArray;
    function Distance(ToPosition: TDoubleDynArray): double;
    function ValueOfSpeed: double;

    property Idx: integer read fIdx;
    property Total: integer read fTotal;
    property OutCount: integer read fOutCount write fOutCount;
    property Speed: TDoubleDynArray read fSpeed;
  end;

  TParticleList = class(TList<TParticle>) // sub-swarms
  private
    function MaxSpeed: double;
    function AverSpeed: double;
    function TopSpeed: double;
  public
    Adjust: TAdjust; // common params for all particles

    // particle specific models (owned by ctrl)
    InertiaBlock: TInertiaBlock;     // mostly inertia modeling
    FactorBlock: TFactorBlock; // social & cogn factor
    ClubsBlock: TClubsBlock;       // clubs topology
    BiswarmBlock: TBiswarmBlock;   // bi-swarms
    PosLimitBlock: TPosLimitBlock; // reflect outliers back

    constructor Create; overload;
    destructor Destroy; override;

    function BestPrt(forceCalc: boolean = true): TParticle;
    function WorstPrt(forceCalc: boolean = true): TParticle;
    function Add(prt: TParticle): integer; overload;
    function StdDevFitness(): double;
    function StdDevDistance(ToPosition: TDoubleDynArray): double;
    function PopFit(): double;
    function MinMaxSize(): double;
    function Speed(spd: TSpeed): double;
    function SpeedComp(normalized: boolean): rSpeedComp;
    function OutCount: integer; // total outCount
  end;

  TMultiSwarmKind = (mskClubs, mskBiswarm);

  TSubSw = class(TList<TParticleList>)
  private
    GenPrtList: TParticleList;
  public
    defMl, minML,maxML,rr, NumbRatio,
    redistUp, redistDown: integer;
    MultiSwarmKind: TMultiSwarmKind;

    function AddPart(prt: TParticle; subIdx: integer): integer;
    procedure RemovePart(prt: TParticle);
    procedure Populate(prtList: TParticleList; NumbRatio: integer = 50); // after creating all the subs
    function AverGenPrtDist: double;
    // clubs-specific
    function PartMemLevel(prt: TParticle): integer;
    procedure LeaveDownPart(prt: TParticle);
    procedure JoinUpPart(prt: TParticle);
    procedure Locality(prt: TParticle; var prtList: TParticleList);
  end;

implementation
uses MVC_U;

constructor TParticle.Create(variables: TVariableList; maxIterations,aIdx,aTotal: integer);
begin
  FVariables  := variables;
  SetLength(FPos, FVariables.Count);
  SetLength(FSpeed, FVariables.Count);
  SetLength(FPersonalBest, FVariables.Count);
  fIdx:= aIdx; fTotal:= aTotal;
end;

destructor TParticle.Destroy();
begin
  SetLength(FPos, 0);
  SetLength(FSpeed, 0);
  SetLength(FPersonalBest, 0);
  inherited Destroy;
end;

procedure TParticle.init(ctrl: TObject; EquiDist: boolean = false);
var
  i,j,k,m: integer; v: TVariable; ia: array of integer; st: double;
begin
  Controller:= ctrl;
  SetLength(mxSpeed,FVariables.Count);

  FFitness     := -Math.MaxDouble;
  FBestFitness := -Math.MaxDouble;
  if EquiDist then
  begin
    SetLength(ia,FVariables.Count);
    k:= ceil(power(total,1/FVariables.Count)-Epsilon3); // grid size
    m:= idx;
    for i := FVariables.Count - 1 downto 1 do // grid nodes - equidistant
    begin
      j:= round(power(k,i));
      ia[i]:= trunc(m/j);
      m:= m - trunc(m/j);
    end;
    ia[0]:= m mod k;
  end;

  for i := 0 to FVariables.Count - 1 do
  begin
    v := TVariable(FVariables[i]);

    // init speed and pos
    if EquiDist
    then begin
      FPos[i]:= v.AdjustedMin + (ia[i] + 0.5) * (v.AdjustedMax - v.AdjustedMin)/k;
      FSpeed[i]:= 0;
    end
    else begin // random dist
      FPos[i]:= v.AdjustedMin + random() * (v.AdjustedMax - v.AdjustedMin);
      FSpeed[i]:= (random() - 0.5) * (v.AdjustedMax - v.AdjustedMin);
    end;
  mxSpeed[i] := abs(v.AdjustedMax - v.AdjustedMin) / 2;
  end;
  fOutCount:= 0;
end;

procedure TParticle.update(const swarmBestPos: TDoubleDynArray);
var
  i: integer; v: TVariable; iMdl: IblkModel; socFactor: double;
begin
  if Assigned(FactorBlock) then FactorBlock.DoChange(idx); // social/cogn

  if Assigned(InertiaBlock) then InertiaBlock.DoChange(idx) // inertia
  else begin // default action {
    // linear desc.
    Adjust.InertiaMode:= 2;
  end; // default action }
  iMdl:= (Controller As TController).modelByFork('sub-swarms');
  if Assigned(iMdl) then iMdl.DoChange(idx)
  else begin // default action { using swarmBestPos
    for i := 0 to FVariables.Count - 1 do
    begin
      // update FSpeed
      socFactor:= Adjust.socialFactor;
      lastSocial:= socFactor * Adjust.MyRandom * (swarmBestPos[i] - FPos[i]);
      lastCogn:= Adjust.cognitiveFactor(socFactor) * Adjust.MyRandom * (FPersonalBest[i] - FPos[i]);
      lastInertia:= FSpeed[i] * Adjust.curInertia;
      FSpeed[i] := lastInertia + lastCogn + lastSocial;
    end;
  end; // default action } Sub-Swarms fork

  // SpeedLimit block (eventually)
  for i := 0 to FVariables.Count - 1 do
    // limit FSpeed
    if abs(FSpeed[i]) > mxSpeed[i] then
      FSpeed[i] := mxSpeed[i] * Math.sign(FSpeed[i]);

  // update FPos - the point of all this !
  for i := 0 to FVariables.Count - 1 do
    FPos[i] := FPos[i] + FSpeed[i];

  if Assigned(PosLimitBlock) then PosLimitBlock.DoChange(idx)
  else begin // default action {
    // PosLimit block
    for i := 0 to FVariables.Count - 1 do
    begin
      //limit FPos by randomizing trespassers
      v := TVariable(FVariables[i]);
      mxSpeed[i] := (v.AdjustedMax - v.AdjustedMin) / 2;
      if (FPos[i] >= v.AdjustedMax) or (FPos[i] <= v.AdjustedMin) then
      begin
        FPos[i] := random() * mxSpeed[i] + v.AdjustedMin;
        inc(fOutCount);
      end;
    end;
  end; // default action }
end; // update particle

function TParticle.getPosition(): TDoubleDynArray;
begin
  Result:= Copy(FPos);
end;

procedure TParticle.setFitness(fitnessValue: double);
begin
  FFitness := fitnessValue;

  if FFitness > FBestFitness then
  begin
    FBestFitness := fitnessValue;
    FPersonalBest:= getPosition();
  end;
end;

function TParticle.getFitness(): double;
begin
  Result := FFitness;
end;

function TParticle.Distance(ToPosition: TDoubleDynArray): double;
var i,d: integer; f: TDoubleDynArray; a: double;
begin
  if length(ToPosition)<>FVariables.Count then raise Exception.Create('Error: wrong dim');
  f:= getPosition();
  a:= 0;
  for i := 0 to FVariables.Count - 1 do
    a:= a + sqr(f[i]-ToPosition[i]);
  Result:= sqrt(a);
end;

function TParticle.ValueOfSpeed: double;
var spd: double;
begin
  Result:= 0;
  for spd in FSpeed do
    Result:= Result + spd*spd;
  Result:= sqrt(Result);
end;

function TParticle.GetProp(propName: string): double;
var
  pn: string;
begin
  pn:= LowerCase(propName);
  if pn='index' then Result:= Idx;
  if (pn='pos.0') and (length(FPos)>0) then Result:= FPos[0];
  if (pn='pos.1') and (length(FPos)>1) then Result:= FPos[1];
  if (pn='speed.0') and (length(FSpeed)>0) then Result:= FSpeed[0];
  if (pn='speed.1') and (length(FSpeed)>1) then Result:= FSpeed[1];
  if pn='val.of.speed' then Result:= ValueOfSpeed;
  if (pn='pers.best.0') and (length(FPersonalBest)>0) then Result:= FPersonalBest[0];
  if (pn='pers.best.1') and (length(FPersonalBest)>1) then Result:= FPersonalBest[1];
  if pn='out.count' then Result:= OutCount;
  if pn='last.inertia' then Result:= lastInertia;
  if pn='last.social' then Result:= lastSocial;
  if pn='last.cogn' then Result:= lastCogn;

end;

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
constructor TParticleList.Create;
begin
  inherited Create;
end;

destructor TParticleList.Destroy;
begin
  FreeAndNil(Adjust);
  inherited;
end;

function TParticleList.BestPrt(forceCalc: boolean = true): TParticle;
var
  prt: TParticle; fitness, swarmFitness: double; i: integer;
begin
  Result:= nil;
  swarmFitness:= -MaxDouble;
  // evaluate particles
  for i:= 0 to Count-1 do
  begin
    prt:= Items[i];
    if not Assigned(prt.Adjust) then exit;
    if forceCalc then
      fitness:= prt.Adjust.psoInf.evaluatePartIdx(prt.idx);

    if prt.GetFitness > swarmFitness then
    begin
      swarmFitness := prt.GetFitness;
      Result := prt;
    end;
  end;
end;

function TParticleList.WorstPrt(forceCalc: boolean = true): TParticle;
var
  prt: TParticle; fitness, swarmFitness: double; i: integer;
begin
  Result:= nil;
  swarmFitness:= MaxDouble;
  // evaluate particles
  for i:= 0 to Count-1 do
  begin
    prt:= Items[i];
    if not Assigned(prt.Adjust) then exit;
    if forceCalc then prt.Adjust.psoInf.evaluatePartIdx(prt.idx);

    if prt.GetFitness < swarmFitness then
    begin
      swarmFitness := fitness;
      Result := prt;
    end;
  end;
end;

function TParticleList.Add(prt: TParticle): integer;
begin
  if Assigned(Adjust) then
    prt.Adjust:= Adjust;
  inherited Add(prt);
end;

function TParticleList.StdDevFitness(): double;
var i: integer; da: TDoubleDynArray;
begin
  if Count <= 1 then
  begin
    Result:= 1; exit;
  end;
  SetLength(da, Count);
  for i:= 0 to Count - 1 do
    da[i]:= Items[i].getFitness;
  Result:= Math.StdDev(da);
end;

function TParticleList.MinMaxSize(): double;
var i,j,k: integer; da, amin, amax: TDoubleDynArray;
begin
  if Count <= 1 then
  begin
    Result:= 1; exit;
  end;
  SetLength(da, Count);
  k:= Items[0].FVariables.Count; SetLength(amin,k); SetLength(amax,k);
  for j:= 0 to k-1 do
  begin
    for i:= 0 to Count - 1 do
      da[i]:= MaxDouble;
    for i:= 0 to Count - 1 do
      da[i]:= min(da[i],Items[i].FPos[j]);
    amin[j]:= Math.MinValue(da);
    for i:= 0 to Count - 1 do
      da[i]:= -MaxDouble;
    for i:= 0 to Count - 1 do
      da[i]:= max(da[i],Items[i].FPos[j]);
    amax[j]:= Math.MaxValue(da);
  end;
  Result:= Math.MaxValue(amax)-Math.MinValue(amin);
end;

function TParticleList.StdDevDistance(ToPosition: TDoubleDynArray): double;
var i,d: integer; da: TDoubleDynArray;
begin
  if length(ToPosition) = 0 then
  begin
    Result:= 0; exit;
  end;
  if Count <= 1 then
  begin
    Result:= 1; exit;
  end;
  SetLength(da, Count);
  for i:= 0 to Count - 1 do
    da[i]:= Items[i].Distance(ToPosition);
  Result:= Math.StdDev(da);
end;

function TParticleList.PopFit(): double;
var
  i,j: integer; f,a: double; da: TDoubleDynArray;
begin
  Result:= -1; if Count = 0 then exit;

  SetLength(da, Count);
  for i:= 0 to Count - 1 do
    da[i]:= Items[i].getFitness;
  a:= mean(da); f:= 0;
  for i:= 0 to Count-1 do
    f:= max(f,abs(da[i]-a));
  f:= max(1,f);

  Result:= 0;
  for i:= 0 to Count-1 do
    Result:= Result + sqr((da[i]-a)/f);
  Result:= Result/Count;
end;

function TParticleList.MaxSpeed: double;
var i: integer;
begin
  Result:= -1;
  for i:= 0 to Count-1  do
    Result:= max(Result, Items[i].ValueOfSpeed);
end;

function TParticleList.AverSpeed: double;
var i: integer;
begin
  Result:= 0;
  for i:= 0 to Count-1  do
    Result := Result + Items[i].ValueOfSpeed;
  Result:= Result/Count;
end;

function TParticleList.TopSpeed: double;
var i,j,k,m: integer; da,ds, top: TDoubleDynArray; a: double;
begin
  k:= 5; // k top particles
  k:= EnsureRange(k, round(Count/10),Count);
  SetLength(top,k);
  SetLength(da,Count); SetLength(ds,Count);
  for i:= 0 to Count-1  do
  begin
    da[i]:= Items[i].getFitness;
    ds[i]:= Items[i].ValueOfSpeed;
  end;
  for j:= 0 to k-1  do
  begin
    a:= -MaxDouble; m:= -1;
    for i:= 0 to Count-1  do
      if da[i]>a then
        begin
          m:= i; a:= da[i];
        end;
    if m=-1 then continue;
    da[m]:= - MaxDouble;
    top[j]:= ds[m]; //Items[m].ValueOfSpeed;
  end;
  Result:= mean(top);
end;

function TParticleList.Speed(spd: TSpeed): double;
begin
  case spd of
    spdMax:  Result:= MaxSpeed;
    spdAver: Result:= AverSpeed;
    spdTop:  Result:= TopSpeed;
  end;
end;

function TParticleList.SpeedComp(normalized: boolean): rSpeedComp;
var
  i,j: integer; da: TDoubleDynArray; d: double;
begin
  SetLength(da, Count);
  for i:= 0 to Count-1 do
    da[i]:= abs(Items[i].lastInertia);
  Result.scInertia:= math.Mean(da);
  for i:= 0 to Count-1 do
    da[i]:= abs(Items[i].lastSocial);
  Result.scSocial:= math.Mean(da);
  for i:= 0 to Count-1 do
    da[i]:= abs(Items[i].lastCogn);
  Result.scCogn:= math.Mean(da);
  if not normalized then exit;
  d:= Result.scInertia + Result.scSocial + Result.scCogn;
  Result.scInertia:= 100 * Result.scInertia /d;
  Result.scSocial:= 100 * Result.scSocial /d;
  Result.scCogn:= 100 * Result.scCogn /d;
end;

function TParticleList.outCount: integer;
var i: integer;
begin
  Result:= 0;
  for i:= 0 to Count-1  do
    Result := Result + Items[i].outCount;
end;
//@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
// sub-swarms

function TSubSw.AddPart(prt: TParticle; subIdx: integer): integer;
var
  i,j: integer; adj: TAdjust;
begin
  assert(Assigned(prt));
  Result:= -1;
  if not InRange(subIdx,0,Count-1) then exit;
  if Items[subIdx].IndexOf(prt)>-1 then exit;
  j:= Items[subIdx].Add(prt); i:= Items[subIdx].Count-1;
  Result:= i;
end;

procedure TSubSw.RemovePart(prt: TParticle);
var
  i: integer;
begin
  assert(Assigned(prt));
  for i:= 0 to Count-1 do
    if Items[i].IndexOf(prt)>-1 then Items[i].Remove(prt);
end;

procedure TSubSw.Populate(prtList{total part.list}: TParticleList; NumbRatio: integer = 50); // after creating all the subs
var
  i,j,k: integer;
begin
  assert(Assigned(prtList));
  GenPrtList:= prtList;
  case MultiSwarmKind of
    mskClubs: begin
      if defML>Count then
        raise Exception.Create('Error: the default membership level cannot be bigger than club number.');

      for i:= 0 to prtList.Count-1 do
      begin
        j:= -1;
        while (j < defML) do
        begin
          k:= random(Count);
          AddPart(prtList[i],k);
          j:= PartMemLevel(prtList[i]);
        end;
      end;
    end;
    mskBiswarm: begin
      j:= round((NumbRatio * prtList.Count)/100);
      Items[0].Clear;
      for i:= 0 to j-1 do
        AddPart(prtList[i],0);
      Items[1].Clear;
      for i:= j to prtList.Count-1 do
        AddPart(prtList[i],1);
    end;
  end;
end;

function TSubSw.AverGenPrtDist: double;
var
  da: TDoubleDynArray; d: double; i,j,k: integer;
begin
  SetLength(da,Count); j:= 0;
  for i:= 0 to Count-1 do
  begin
    if Items[i].Count=0 then continue;
    da[j]:= GenPrtList.BestPrt.Distance(Items[i].BestPrt.FPos);
    inc(j);
  end;
  SetLength(da,j-1);
  Result:= mean(da);
end;
//------------------------------------------------------------------------
// Club-specific
function TSubSw.PartMemLevel(prt: TParticle): integer;
var i: integer;
begin
  Result:= 0;
  if not Assigned(prt) or (MultiSwarmKind<>mskClubs) then exit;
  for i:= 0 to Count-1 do
   if Items[i].IndexOf(prt)>-1 then inc(Result);
end;

procedure TSubSw.LeaveDownPart(prt: TParticle);
var
  i,j,k: integer;
begin
  if not Assigned(prt) or (MultiSwarmKind<>mskClubs) then exit;
  j:= PartMemLevel(prt);
  if (j < minML) or (j = 0) then exit;
  k:= 0;
  while (PartMemLevel(prt)=j) and (k < 1000) do
  begin
    i:= random(Count); inc(k);
    if Items[i].IndexOf(prt)>-1 then
      Items[i].Remove(prt);
  end;
end;

procedure TSubSw.JoinUpPart(prt: TParticle);
var
  i,j,k: integer;
begin
  if not Assigned(prt) or (MultiSwarmKind<>mskClubs) then exit;
  j:= PartMemLevel(prt);
  if j > maxML then exit;
  k:= 0;
  while (PartMemLevel(prt)=j) and (k < 1000) do
  begin
    i:= random(Count); inc(k);
    if Items[i].IndexOf(prt)>-1 then continue;
    Items[i].Add(prt);
  end;
end;

procedure TSubSw.Locality(prt: TParticle; var prtList: TParticleList);
var
  i,j,k: integer; adj: TAdjust;
begin
  if MultiSwarmKind<>mskClubs then exit;  
  assert(Assigned(prt));
  assert(Assigned(prtList));
  prtList.Clear;
  for i:= 0 to Count-1 do
  begin
    if Items[i].IndexOf(prt) = -1 then continue;
    for j:= 0 to Items[i].Count-1 do
      if prtList.IndexOf(Items[i].Items[j]) = -1 then
      begin
        prtList.Add(Items[i].Items[j]);
      end;
  end;
end;

end.

