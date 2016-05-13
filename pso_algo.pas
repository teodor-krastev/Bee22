(************************************************************************)
(*  Based on paspso by Filip Lundeholm 2010                             *)
(*  Developed by and copyright(c) Teodor Krastev 2015-2016              *)
(************************************************************************)
unit pso_algo;

interface

uses
  System.Types, Classes, SysUtils, pso_particle, pso_variable, Generics.Collections,
  Math, Forms, Dialogs, VCLTee.TeeInspector,
  TestFuncU, UtilsU, blk_algo, ReportDataU, AdjustU;

const
  defaultIterations = 300;
  defaultSwarmSize = 30;

type
// PSO and stuff

{$TYPEINFO ON}
{$METHODINFO ON}
  TPSO = class(TComponent, IPSO)
  private
    FOnBeforeIteration, FOnAfterIteration: TNotifyEvent;
    FVariables: TVariableList;
    FParticles: TParticleList;
    FSubSw: TSubSw;

    FSwarmBestEverPos: TDoubleDynArray;
    FSwarmBestEverFitness, fTolerance, fUser1: double;
    FFitnessFunction: TEvalFunc;
    FShouldStop, fRunning, fEquidist: boolean;
    FParticleCount, FIterations, FMaxIterations: integer;
    function GetShouldStop: boolean;
    function GetParticle(index: integer): TParticle;
  protected
    // interface
    function GetIterations: integer;
    function GetMaxIterations: integer;
    procedure SetMaxIterations(mi: integer);
    function GetTolerance: double;
  public
    itf: ITestFunc;
    Controller: TObject;
    Caption, TermCond: string;
    ObserverList: TObserverList;

    // algo specific created in ctrlCenter and owned by PSO
    TestFuncBlock: TTestFuncBlock;   // test function setup
    ExtFuncBlock: TExtFuncBlock;   // test function setup
    PreCalcBlock: TPreCalcBlock;     // topology-dependent pre-calc for part.update
    TermCondBlock: TTermCondBlock;   // terminal conditions

    constructor Create(aOwner: TComponent; aitf: ITestFunc);
    destructor Destroy(); override;
    procedure SetEquidist(ed: boolean);
    procedure add(variable: PDouble); overload;
    procedure add(variable: PDouble; min, max: double); overload;
    function evaluateParticle(particle: TParticle): double;
    function evaluatePartIdx(partIdx: integer): double;
    procedure GetPropNames(var PSO_PN, PartPN: string);
    function GetProp(propName: string): double;
    property Particle[index: integer]: TParticle read GetParticle;
    property OnBeforeIteration: TNotifyEvent read FOnBeforeIteration write FOnBeforeIteration;
    property OnAfterIteration: TNotifyEvent read FOnAfterIteration write FOnAfterIteration;

  published
    procedure Init(NumberOfParticles: integer = 0; ForceReset: boolean = false);
            // particle & variables init; once per optim, AFTER blocks init
            // if NumberOfParticles is the same as in the previous Init, ForceReset will recreate the particles anyway
    function GetItf: ITestFunc; // inteface to test function
    function CallExtFunc(cmd: string; prm: OleVariant): OleVariant;
    procedure setParticleCount(NumberOfParticles: integer);
    function GetVaiablesCount: integer;

    procedure optimize(maximumIterations: integer=0; aTolerance: double = 0.0);
    function getBestFitness(): double;
    procedure updateVariablesToBest();
    procedure stop();
    function IsRunning: boolean;

    function OnTarget: boolean; // true if the target from testFunc.objective is hit with tolerance testFunc.epsilon
    function OutCount: integer; // counter of particles went out search space and reinitrodused back

    function GetStatus: rOptimRslt; // record of optimization results

    property Variables: TVariableList read FVariables; // working variable
    property Particles: TParticleList read FParticles; // total swarm (create/destroy)
    property SubSw: TSubSw read FSubSw; // over-lapping or not sub-swarms (only ref to particles)

    property SwarmBestEverPos: TDoubleDynArray read FSwarmBestEverPos write FSwarmBestEverPos;
    property SwarmBestEverFitness: double read FSwarmBestEverFitness write FSwarmBestEverFitness;

    property ShouldStop: boolean read GetShouldStop; // stop request

    property ParticleCount: integer read FParticleCount;
    property Iterations: integer read GetIterations;
    property MaxIterations: integer read GetMaxIterations write SetMaxIterations;
    property Tolerance: double read fTolerance; // only for internal (default) use
    property Equidist: boolean read fEquidist; // equal particle distribution at start
    property User1: double read fUser1 write fUser1; // only for internal (testing) use
  end;
{$METHODINFO OFF}
{$TYPEINFO OFF}

implementation
uses MVC_U, frmExtConfigU;

constructor TPSO.Create(aOwner: TComponent; aitf: ITestFunc);
begin
  inherited Create(aOwner);
  FParticleCount := defaultSwarmSize;
  itf:= aitf; fEquidist:= false; fRunning:= false;
  FFitnessFunction := itf.fitnessFunction;
  FVariables := TVariableList.Create();
  FParticles := TParticleList.Create;
  FParticles.Adjust:= TAdjust.Create(IPSO(self));
  FSubSw:= TSubSw.Create;

  ObserverList := TObserverList.Create;
end;

destructor TPSO.Destroy();
var
  i: integer; prt: TParticle;
begin
  if (ParticleCount>0) and Assigned(FParticles) then
  begin
    for prt in FParticles do
      prt.Free;
    FreeAndNil(FParticles.Adjust);
  end;
  FreeAndNil(FParticles);

  if Assigned(FVariables) then
    for i := 0 to FVariables.Count-1 do
      FVariables[i].Free;
  FreeAndNil(FVariables);

  for i := 0 to FSubSw.Count-1 do
  begin
    if FSubSw.MultiSwarmKind = mskBiswarm then
      FreeAndNil(FSubSw[i].Adjust);
    FSubSw[i].Free;
  end;
  FreeAndNil(FSubSw);

  FreeAndNil(ObserverList);
  inherited Destroy;
end;

function TPSO.GetIterations: integer;
begin
  Result:= FIterations;
end;

function TPSO.GetMaxIterations: integer;
begin
  Result:= FMaxIterations;
end;

procedure TPSO.SetMaxIterations(mi: integer);
begin
  FMaxIterations:= mi;
end;

procedure TPSO.SetEquidist(ed: boolean);
begin
  fEquidist:= ed;
end;

function TPSO.GetTolerance: double;
begin
  Result:= Tolerance;
end;

function TPSO.GetParticle(index: integer): TParticle;
begin
  Result:= FParticles[index];
end;

function TPSO.GetItf: ITestFunc;
begin
  Result:= itf;
end;

function TPSO.CallExtFunc(cmd: string; prm: OleVariant): OleVariant;
begin
  if not Assigned(frmExtConfig) then exit;
  if not frmExtConfig.IsSimion then frmExtConfig.RunSimion('');
  if not Assigned(frmExtConfig.OnFireExtCmd) then exit;
  Result:= frmExtConfig.OnFireExtCmd('fly', prm);
end;

procedure TPSO.setParticleCount(NumberOfParticles: integer);
begin
  FParticleCount := NumberOfParticles;
end;

function TPSO.GetVaiablesCount: integer;
begin
  Result:= FVariables.Count;
end;
// ------- add---------
procedure TPSO.add(variable: PDouble);
begin
  FVariables.add(TVariable.Create(variable));
end;

procedure TPSO.add(variable: PDouble; min, max: double);
var v: TVariable;
begin
  v := TVariable.Create(variable);
  v.min := min;
  v.max := max;
  FVariables.add(v);
end;

// --------------------------------
// particle & variables init; once per optim, AFTER blocks init
procedure TPSO.Init(NumberOfParticles: integer = 0; ForceReset: boolean = false);
var
  i: integer; prt: TParticle; renewPart, reDim: boolean;
  dMin,dMax: double;
begin
  randomize();
  TermCond:= ''; fRunning:= false; FShouldStop:= false;

  FSwarmBestEverFitness := -Math.MaxDouble;
  if NumberOfParticles > 0 then
    FParticleCount := NumberOfParticles;
  if not InRange(FParticleCount,1,1000) then
    FParticleCount := 22;
  // variables clear & attach
  reDim:= (FVariables.Count <> itf.GetDim());
  for i := 0 to FVariables.Count-1 do
    FVariables[i].Free;
  Variables.Clear;
  for i := 0 to itf.GetDim-1 do
  begin
    itf.GetRange(i,dMin,dMax);
    add(itf.GetXaddr(i),dMin,dMax);
  end;

  renewPart:= (FParticleCount <> FParticles.Count) or reDim or ForceReset;
  if renewPart then
  begin
    if FParticles.Count > 0 then // erase particles
    begin
      for prt in FParticles do
        prt.Free;
      FParticles.Clear;
    end;
  end;

  for i := 0 to FParticleCount-1 do
  begin
    if renewPart then
    begin
      prt := TParticle.Create(FVariables, FMaxIterations, i,FParticleCount);
      FParticles.add(prt);
    end;
    FParticles[i].Init(Controller,fEquidist);

    FParticles[i].InertiaBlock:= Particles.InertiaBlock;
    FParticles[i].FactorBlock:= Particles.FactorBlock;
    FParticles[i].ClubsBlock:= Particles.ClubsBlock;
    FParticles[i].BiswarmBlock:= Particles.BiswarmBlock;
    FParticles[i].PosLimitBlock:= Particles.PosLimitBlock;
  end;

  if SubSw.Count > 0 then SubSw.Populate(FParticles,SubSw.NumbRatio);

  FSwarmBestEverPos:= FParticles[0].getPosition();
end;

function TPSO.evaluateParticle(particle: TParticle): double; // back fitness
var pos: TDoubleDynArray; fitness: double;
begin
  pos := particle.getPosition();
  FVariables.AssignFromDDA(pos);
  fitness := FFitnessFunction();
  particle.setFitness(fitness);

  Result := fitness;
end;

function TPSO.evaluatePartIdx(partIdx: integer): double;
begin
  Result:= NaN;
  if not InRange(partIdx,0,ParticleCount-1) then exit;
  Result:= evaluateParticle(FParticles[partIdx]);
end;

procedure TPSO.optimize(maximumIterations: integer=0; aTolerance: double = 0.0);
var
  swarmBest, prt: TParticle; ctrl: TController; iMdl: IblkModel;
  swarmBestFitness, fitness, a: double; i: integer;
begin
  fTolerance:= aTolerance;
  if maximumIterations>0 then
    FMaxIterations := maximumIterations;
  if FMaxIterations=0 then
    FMaxIterations := defaultIterations;
  ctrl:= TController(Controller);
  try
  if ShouldStop then exit;
  FIterations := 0; // utils init
  fRunning:= true;
  while (FIterations < FMaxIterations) and (not ShouldStop) do  // THE MAIN LOOP
  begin
    Inc(FIterations);
    ObserverList.VisualUpdate(self);  // update observers
    if ShouldStop then break;
    if Assigned(FOnBeforeIteration) then OnBeforeIteration(self); // before event
    if Assigned(TestFuncBlock) then TestFuncBlock.DoChange(-1); // empty for now

        // extract swarm params for particles speed calculations
    iMdl:= ctrl.modelByFork('precalc'); // precalc fork
    if Assigned(iMdl) then iMdl.DoChange(-1)
    else begin // default action {
      swarmBest:= FParticles.BestPrt(true); // recalc
      // update global EVER best
      if swarmBest.getFitness > FSwarmBestEverFitness then
      begin
        FSwarmBestEverFitness := swarmBest.getFitness;
        FSwarmBestEverPos:= swarmBest.getPosition();
      end;
    end;  // default action }
    if ShouldStop then break;

    // update all FParticles - MAIN speed adjustment
    for prt in FParticles do
      prt.update(FSwarmBestEverPos);  // all prt blocks are in here

    if ShouldStop then break;
    if Assigned(FOnAfterIteration) and not ShouldStop then OnAfterIteration(self); // after event
    if Assigned(TermCondBlock) then TermCondBlock.DoChange(-1)
    else begin // default action {
      // termination conditions
      if Tolerance>1.0E-100 then  // if 0 only iters number terminates
      begin
        if (FParticles.StdDevDistance(SwarmBestEverPos)<Tolerance) then TermCond:= 'small spot';
        if FParticles.Speed(spdMax)<Tolerance then TermCond:= 'immobil. ('+F2S(FParticles.Speed(spdMax))+')';
      end;
    end; // default action }

    if ShouldStop or (TermCond<>'') then break;
  end;  // end of MAIN loop
  finally
    if TermCond='' then
      if ShouldStop
        then TermCond:= 'User stop (iters='+IntToStr(Iterations)+')'
        else TermCond:= 'max iters ('+IntToStr(Iterations)+')';

    // finish with global best found in Variables
    if not ShouldStop then updateVariablesToBest();
    fRunning:= false;
  end;
end;

procedure TPSO.updateVariablesToBest();
begin
  FVariables.AssignFromDDA(FSwarmBestEverPos);
end;

function TPSO.getBestFitness(): double;
begin
  Result := FSwarmBestEverFitness;
end;

function TPSO.OnTarget: boolean;
var
  eps,obj: double; i: integer;
begin
  eps:= itf.GetProblem.epsilon;
  Result:= true;
  for i:= 0 to GetVaiablesCount-1 do  // one-dim objective here; multi-dim - later
  begin
    obj:= itf.GetProblem.objective[i];
    Result:= Result and InRange(SwarmBestEverPos[i], obj-eps,obj+eps);
  end;
end;

function TPSO.OutCount: integer;
begin
  Result:= Particles.outCount;
end;

function TPSO.GetStatus: rOptimRslt;
begin
// current
  Result.Vars:= SwarmBestEverPos;
  Result.BestFit:= getBestFitness;
  Result.SwarmSize:= Particles.StdDevDistance(SwarmBestEverPos);
  Result.AverSpeed:= Particles.Speed(spdAver);
  Result.IterCount:= Iterations;
  Result.OutCount:= OutCount;
// final
  Result.OnTarget:= OnTarget;
  Result.TermCond:= TermCond;
end;

procedure TPSO.stop();
begin
  FShouldStop := True;
end;

function TPSO.IsRunning: boolean;
begin
  Result:= fRunning;
end;

function TPSO.GetShouldStop: boolean;
begin
  Application.ProcessMessages;
  Result:= FShouldStop or Application.Terminated;
end;

procedure TPSO.GetPropNames(var PSO_PN, PartPN: string);
begin
  PSO_PN:= 'iter,best.fit,swarm.size,aver.speed,out.count,on.target,'+
  'best.pos.0,best.pos.1,best.part.idx,worst.part.idx,speed.inrt,speed.soc,'+
  'speed.cogn';
  PartPN:= 'index,pos.0,pos.1,speed.0,speed.1,val.of.speed,'+
  'pers.best.0,pers.best.1,out.count,last.inertia,last.social,last.cogn';
end;

function TPSO.GetProp(propName: string): double;
var
  pn: string; rOR: rOptimRslt; rSC: rSpeedComp;
begin
  pn:= LowerCase(propName);
  rOR:= GetStatus;
  if pn='iter' then Result:= Iterations;
  if pn='best.fit' then Result:= rOR.BestFit;
  if pn='swarm.size' then Result:= rOR.SwarmSize;
  if pn='aver.speed' then  Result:= rOR.AverSpeed;
  if pn='out.count' then  Result:= rOR.OutCount;
  if pn='on.target' then Result:= Integer(rOR.OnTarget);
  if (pn='best.pos.0') and (length(rOR.Vars)>0) then Result:= rOR.Vars[0];
  if (pn='best.pos.1') and (length(rOR.Vars)>1) then Result:= rOR.Vars[1];
  if pn='best.part.idx' then  Result:= Particles.BestPrt.Idx;
  if pn='worst.part.idx' then  Result:= Particles.WorstPrt.Idx;
  rSC:= Particles.SpeedComp(false);
  if pn='speed.inrt' then  Result:= rSC.scInertia;
  if pn='speed.soc'  then  Result:= rSC.scSocial;
  if pn='speed.cogn' then  Result:= rSC.scCogn;
end;

end.

