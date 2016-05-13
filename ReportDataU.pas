(************************************************************************)
(*  Bee22 - Particle Swarm Optimization framework     http://bee22.com  *)
(*  developed by and copyright(c) Teodor Krastev 2015-2016              *)
(************************************************************************)
unit ReportDataU;

interface

uses System.SysUtils, System.Classes, Types, Math, IniFiles, VCLTee.TeeInspector,
  UtilsU, fmScanPropU;

type
  rOptimRslt = record
    UserDef: double;
    BestFit, SwarmSize, AverSpeed, IterCount: double;
    // TimePass: integer; later maybe
    OutCount: double;
    OnTarget: boolean;     // from a single measurement
    OnTargetStat: integer; // in percent [%]
    TermCond: string;
    Vars: TDoubleDynArray; // var0; var1; var2; etc.
  end;

  TOptimRslt = class // frills DP
  private
    fData: rOptimRslt;
  public
    ls: TStrings;
    constructor Create(rOR: rOptimRslt);
    destructor Destroy; override;
    property data: rOptimRslt read fData;
  end;

  TReportData = class
  private
    fPropX, fPropY: rScanProp;
    fTwoProps: boolean;
    fxCount, fyCount: integer; // x- slow; y- fast; one-dim xCount=1
    fData: array of array of rOptimRslt;
    function IndexOf(a: double; iArr: TDoubleDynArray): integer;

    function GetData(iX, iY: integer): rOptimRslt;
    procedure SetData(iX, iY: integer; oRslt: rOptimRslt);
    function GetByFloat(iX, iY: double): rOptimRslt;
    procedure SetByFloat(iX, iY: double; oRslt: rOptimRslt);
  public
    xIdx, yIdx: TDoubleDynArray;
    Dim: integer;
    lastIdx: TPoint;
    UserDef, TestFunc, Comments: string;

    constructor Create(iX, iY: integer); overload; // set xIdx, yIdx values afterwards
    constructor Create(xProp, yProp: rScanProp); overload;
    constructor Create(yProp: rScanProp); overload;
    constructor Create(fn: string); overload;

    procedure SaveReport(fn: string);

    property xCount: integer read fxCount; // 1 if one-dim case
    property yCount: integer read fyCount;
    property Data[iX, iY: integer]: rOptimRslt read GetData
      write SetData; default;
    property byFloat[iX, iY: double]: rOptimRslt read GetByFloat
      write SetByFloat;
    property PropX: rScanProp read fPropX;
    property PropY: rScanProp read fPropY;
    property TwoProps: boolean read fTwoProps;
  end;

  function AssignOptimRslt(optR: rOptimRslt): rOptimRslt;
  procedure OptimRslt2List(rOR: rOptimRslt; ls: TStrings);
  procedure OptimRsltStats(aor: array of rOptimRslt; var aver, disp: rOptimRslt);

implementation

procedure OptimRslt2List(rOR: rOptimRslt; ls: TStrings);
var i: integer;
begin
  if ls=nil then ls:= TStringList.Create;
  ls.Clear;
  ls.Add('User.Def='+F2S(rOR.UserDef));
  ls.Add('Best.Fit='+F2S(rOR.BestFit));
  ls.Add('Swarm.Size='+F2S(rOR.SwarmSize));
  ls.Add('Aver.Speed='+F2S(rOR.AverSpeed));
  ls.Add('Iter.Count='+F2S(rOR.IterCount));
  ls.Add('Out.Count='+F2S(rOR.OutCount));
  ls.Add('On.Target='+IntToStr(rOR.OnTargetStat));
  for i:= 0 to length(rOR.Vars)-1 do    // var.0; var.1; var.2; etc.
    ls.Add('var.'+IntToStr(i)+'='+F2S(rOR.Vars[i]));
  ls.Add('Term.Cond='+rOR.TermCond);
end;

procedure OptimRsltStats(aor: array of rOptimRslt; var aver, disp: rOptimRslt);
var
  da: TDoubleDynArray; i,j,k,m, itr,sst,lsp: integer;
begin
  j:= length(aor); if j=0 then exit;
  SetLength(da,j);
  for i:= 0 to j-1 do da[i]:= aor[i].UserDef;
  Math.MeanAndStdDev(da, aver.UserDef, disp.UserDef);
  for i:= 0 to j-1 do da[i]:= aor[i].BestFit;
  Math.MeanAndStdDev(da, aver.BestFit, disp.BestFit);
  for i:= 0 to j-1 do da[i]:= aor[i].SwarmSize;
  Math.MeanAndStdDev(da, aver.SwarmSize, disp.SwarmSize);
  for i:= 0 to j-1 do da[i]:= aor[i].AverSpeed;
  Math.MeanAndStdDev(da, aver.AverSpeed, disp.AverSpeed);
  for i:= 0 to j-1 do da[i]:= aor[i].IterCount;
  Math.MeanAndStdDev(da, aver.IterCount, disp.IterCount);
  for i:= 0 to j-1 do da[i]:= aor[i].OutCount;
  Math.MeanAndStdDev(da, aver.OutCount, disp.OutCount);
  k:= 0;
  for i:= 0 to j-1 do
    if aor[i].OnTarget then inc(k);
  aver.OnTargetStat:= round(100*k/j);
  k:= length(aor[0].vars); SetLength(aver.Vars,k); SetLength(disp.Vars,k);
  for m:=0 to k-1 do
  begin
    for i:= 0 to j-1 do da[i]:= aor[i].Vars[m];
    Math.MeanAndStdDev(da, aver.Vars[m], disp.Vars[m]);
  end;
  if j=1 then
    aver.TermCond:= aor[0].TermCond
  else begin
    itr:= 0; sst:= 0; lsp:= 0;
    for i:= 0 to j-1 do
    begin
      if pos('max iters', aor[i].TermCond)>0 then inc(itr);
      if pos('small spot', aor[i].TermCond)>0 then inc(sst);
      if pos('low speed', aor[i].TermCond)>0 then inc(lsp);
    end;
    aver.TermCond:= 'itr('+IntToStr(round(100*itr/j))+
                 '); sst('+IntToStr(round(100*sst/j))+
                 '); lsp('+IntToStr(round(100*lsp/j))+')';
  end;
end;

constructor TOptimRslt.Create(rOR: rOptimRslt);
var i: integer;
begin
  inherited Create;
  fData:= AssignOptimRslt(rOR);
  OptimRslt2List(rOR, ls);
end;

destructor TOptimRslt.Destroy;
begin
  ls.Free; SetLength(fData.Vars,0);
  inherited Destroy;
end;

//###########################################################################
constructor TReportData.Create(iX, iY: integer); // set xIdx, yIdx afterwards
begin
  inherited Create;
  fxCount := iX;
  fyCount := iY;
  SetLength(xIdx, xCount);
  SetLength(yIdx, yCount);
  SetLength(fData, xCount, yCount);
end;

constructor TReportData.Create(xProp, yProp: rScanProp);
var
  x, y: double; iX, iY: integer;
begin
  inherited Create; fTwoProps:= true;
  fPropX:= xProp; fPropY:= yProp;

  x := xProp.sFrom;
  iX := 0;
  while x <= (xProp.sTo + Epsilon3) do
  begin
    inc(iX);
    SetLength(xIdx, iX);
    xIdx[iX - 1] := x;
    x := x + xProp.sBy;
  end;
  fxCount := iX;

  y := yProp.sFrom;
  iY := 0;
  while y <= (yProp.sTo + Epsilon3) do
  begin
    inc(iY);
    SetLength(yIdx, iY);
    yIdx[iY - 1] := y;
    y := y + yProp.sBy;
  end;
  fyCount := iY;

  SetLength(fData, xCount, yCount);
end;

constructor TReportData.Create(yProp: rScanProp);
var
  y: double; iY: integer; ls: TStrings;
begin
  inherited Create; fTwoProps:= false;
  fPropY:= yProp;
  SetLength(fData, 1);
  fxCount := 1; SetLength(xIdx, 0);
  if yProp.Style=iiSelection then
  begin
    ls:= TStringList.Create;
    ls.CommaText:= yProp.SelItems;
    fyCount:= ls.Count;
    SetLength(yIdx, fyCount);
    for iY:= 0 to fyCount-1 do
       yIdx[iY]:= StrToInt(ls.ValueFromIndex[iY]);
    ls.Free;
  end
  else begin
    y := yProp.sFrom; iY := 0;
    while y <= (yProp.sTo + Epsilon2) do
    begin
      inc(iY);
      SetLength(yIdx, iY);
      yIdx[iY - 1] := y;
      y := y + yProp.sBy;
    end;
    fyCount := iY;
  end;
  SetLength(fData[0], fyCount);
end;

function ReadProp(ini: TIniFile; section: string): rScanProp;
begin
  Result.mdlName:= ini.ReadString(section,'block','');
  Result.propName:= ini.ReadString(section,'prop','');
  Result.style:= Str2Style(ini.ReadString(section,'style',''));
  if Result.Style=iiSelection then
    Result.selItems:= ini.ReadString(section,'selItems','')
  else begin
    Result.sFrom:= ini.ReadFloat(section,'From',0);
    Result.sTo:= ini.ReadFloat(section,'To',10);
    Result.sBy:= ini.ReadFloat(section,'By',1);
  end;
end;

procedure WriteProp(ini: TIniFile; section: string; dt: rScanProp);
begin
  ini.WriteString(section,'block',dt.mdlName);
  ini.WriteString(section,'prop',dt.propName);
  ini.WriteString(section,'style',Style2Str(dt.style));
  if dt.Style=iiSelection then
    ini.WriteString(section,'selItems',dt.selItems)
  else begin
    ini.WriteFloat(section,'From',dt.sFrom);
    ini.WriteFloat(section,'To',dt.sTo);
    ini.WriteFloat(section,'By',dt.sBy);
  end;
end;

procedure ReadOptimRslt(ini: TIniFile; section: string;
         var x,y: double; var dt: rOptimRslt); // dt.vars setLength before calling
var i: integer;
begin
  x:= ini.ReadFloat(section,'X',0);
  y:= ini.ReadFloat(section,'Y',0);
  dt.UserDef:= ini.ReadFloat(section,'User.Def',0);
  dt.BestFit:= ini.ReadFloat(section,'Best.Fit',0);
  dt.SwarmSize:= ini.ReadFloat(section,'Swarm.Size',0);
  dt.AverSpeed:= ini.ReadFloat(section,'Aver.Speed',0);
  dt.IterCount:= ini.ReadFloat(section,'Iter.Count',0);
  dt.OutCount:= ini.ReadFloat(section,'Out.Count',0);
  dt.OnTargetStat:= ini.ReadInteger(section,'On.Target',0);
  dt.TermCond:= ini.ReadString(section,'Term.Cond','');
  for i:= 0 to length(dt.vars)-1 do
    dt.Vars[i]:= ini.ReadFloat(section,'var.'+IntToStr(i),0);
end;

procedure WriteOptimRslt(ini: TIniFile; section: string;
          x,y: double; dt: rOptimRslt); // dt.vars setLength before calling
var i: integer;
begin
  if not isNaN(x) then
    ini.WriteFloat(section,'X',x);
  ini.WriteFloat(section,'Y',y);
  ini.WriteFloat(section,'User.Def',dt.UserDef);
  ini.WriteFloat(section,'Best.Fit',dt.BestFit);
  ini.WriteFloat(section,'Swarm.Size',dt.SwarmSize);
  ini.WriteFloat(section,'Aver.Speed',dt.AverSpeed);
  ini.WriteFloat(section,'Iter.Count',dt.IterCount);
  ini.WriteFloat(section,'Out.Count',dt.OutCount);
  ini.WriteInteger(section,'On.Target',dt.OnTargetStat);
  ini.WriteString(section,'Term.Cond',dt.TermCond);
  for i:= 0 to length(dt.vars)-1 do
    ini.WriteFloat(section,'var.'+IntToStr(i),dt.Vars[i]);
end;

constructor TReportData.Create(fn: string);
var ini: TIniFile; i,j: integer; dt: rOptimRslt; x,y: double; ls: TStrings;
begin
  ini:= TIniFile.Create(fn);
  fTwoProps:= ini.ReadBool('General','TwoProps',false);
  dim:= ini.ReadInteger('General','dim',0);
  UserDef:= ini.ReadString('General','UserDef','');
  TestFunc:= ini.ReadString('General','TestFunc','');
  SetLength(dt.vars,dim);

  if not TwoProps then // ONE
  begin
    fPropY:= ReadProp(ini,'PropY');
    Create(PropY);
    for i:= 0 to yCount-1 do
    begin
      ReadOptimRslt(ini,IntToStr(i), x,y, dt);
      SetByFloat(x,y,dt);
    end;
  end
  else begin // TWO
    fPropX:= ReadProp(ini,'PropX');
    fPropY:= ReadProp(ini,'PropY');
    Create(PropX, PropY);
    for i:= 0 to xCount-1 do // col
      for j:= 0 to yCount-1 do // row
      begin                    //  [col,row]
        ReadOptimRslt(ini,IntToStr(i)+','+IntToStr(j), x,y,dt);
        SetByFloat(x,y,dt);
        assert((lastIdx.X=i) and (lastIdx.Y=j), 'index issue');
      end;
  end;
  ini.Free;
  try
    Comments:= '';
    ls:= TStringList.Create;
    ls.LoadFromFile(fn);
    j:= ls.IndexOf('[Comments]');
    if j=-1 then exit;
    for i:= 0 to j do ls.Delete(0);
    if ls.Count=0 then exit;
    Comments:= ls.Text;
  finally
    ls.Free;
  end;
end;

procedure TReportData.SaveReport(fn: string);
var ini: TIniFile; i,j: integer; dt: rOptimRslt; x,y: double; ls,lt: TStrings;
begin
  ini:= TIniFile.Create(fn);
  ini.WriteBool('General','TwoProps',fTwoProps);
  ini.WriteInteger('General','dim',dim);
  ini.WriteString('General','UserDef',UserDef);
  ini.WriteString('General','TestFunc',TestFunc);

  if not TwoProps then // ONE
  begin
    WriteProp(ini,'PropY',PropY);
    for i:= 0 to yCount-1 do
    begin
      WriteOptimRslt(ini,IntToStr(i), NaN,yIdx[i], Data[0,i]);
    end;
  end
  else begin // TWO
    WriteProp(ini,'PropX',fPropX);
    WriteProp(ini,'PropY',fPropY);
    for i:= 0 to xCount-1 do // col
      for j:= 0 to yCount-1 do // row
      begin                    //  [col,row]
        WriteOptimRslt(ini,IntToStr(i)+','+IntToStr(j), xIdx[i],yIdx[j],Data[i,j]);
      end;
  end;
  ini.EraseSection('Comments');
  ini.Free;
  if Comments<>'' then
  begin
    ls:= TStringList.Create;  lt:= TStringList.Create;
    ls.LoadFromFile(fn);
    lt.Text:= Comments;
    ls.Add('[Comments]');
    ls.AddStrings(lt);
    ls.SaveToFile(fn);
    ls.Free; lt.Free;
  end;
end;

function TReportData.IndexOf(a: double; iArr: TDoubleDynArray): integer;
var
  i: integer; d: double;
begin
  Result := -1; i:= 0;
  for d in iArr do
    if SameValue(d, a, Epsilon3) then
    begin
      Result:= i;
      break;
    end
    else inc(i);
end;

function TReportData.GetData(iX, iY: integer): rOptimRslt;
begin
  if not InRange(iX,0,xCount-1) or not InRange(iY,0,yCount-1) then
    raise Exception.Create('index problem '+IntToStr(ix)+' / '+IntToStr(iy));
  Result := AssignOptimRslt(fData[iX, iY]);
end;

procedure TReportData.SetData(iX, iY: integer; oRslt: rOptimRslt);
begin
  if not InRange(iX,0,xCount-1) or not InRange(iY,0,yCount-1) then
    raise Exception.Create('index problem '+IntToStr(ix)+' / '+IntToStr(iy));
  fData[iX, iY] := AssignOptimRslt(oRslt);
  lastIdx.X:= iX;  lastIdx.Y:= iY;
end;

function TReportData.GetByFloat(iX, iY: double): rOptimRslt;
var
  i, j: integer;
begin
  if xCount = 1 then i := 0
  else i := IndexOf(iX, xIdx);
  j := IndexOf(iY, yIdx);
  if (i = -1) or (j = -1) then exit;
  Result := Data[i, j];
end;

procedure TReportData.SetByFloat(iX, iY: double; oRslt: rOptimRslt);
var
  i, j: integer;
begin
  if xCount = 1 then i := 0
  else i := IndexOf(iX, xIdx);
  j := IndexOf(iY, yIdx);
  if (i = -1) or (j = -1) then
    exit;
  Data[i, j] := oRslt;
end;

function AssignOptimRslt(optR: rOptimRslt): rOptimRslt;
begin
  Result:= optR;
  Result.Vars:= optR.Vars;
end;

end.
