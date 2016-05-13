(************************************************************************)
(*  Bee22 - Particle Swarm Optimization framework     http://bee22.com  *)
(*  developed by and copyright(c) Teodor Krastev 2015-2016              *)
(************************************************************************)

unit blk_algo;

interface

uses
  System.Types, Classes, SysUtils, pso_variable, Generics.Collections,
  Math, Forms, Dialogs, VCLTee.TeeInspector,
  TestFuncU, UtilsU, MVC_U, AdjustU;

type
  TTestFuncBlock = class(TblkModel)
  protected
    problem: TProblem;
    procedure ConfigureDialog(Sender: TObject);
  public
    procedure Config(); override;
    procedure Synchro(PropName: string); override;
    procedure Init(idx: integer); override;
    procedure DoChange(idx: integer); override;
  end;

  TExtFuncBlock = class(TblkModel)
  protected
    problem: TProblem;
    procedure ConfigureDialog(Sender: TObject);
    function feat2prop(xIdx: integer): TPropVal;
  public
    procedure Config(); override;
    procedure Synchro(PropName: string); override;
    procedure Init(idx: integer); override;
    procedure DoChange(idx: integer); override;
  end;

  TPreCalcBlock = class(TblkModel)
  protected
  public
    procedure Config(); override;
    procedure Synchro(PropName: string); override;
    procedure Init(idx: integer); override;
    procedure DoChange(idx: integer); override;
  end;

  TTermCondBlock = class(TblkModel)
  protected
    When2EndList: TWhen2EndList;
    speedMode: integer; speedBottom: double;
    sizeMode, sizeDirection: integer; sizeBottom: double;
  public
    procedure Config(); override;
    procedure Init(idx: integer); override;
    procedure DoChange(idx: integer); override;
    destructor Destroy; override;
  end;

implementation
uses pso_algo, pso_particle, frmGenConfigU,frmExtConfigU;
//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
// FUNC block
procedure TTestFuncBlock.ConfigureDialog(Sender: TObject);
begin
  if frmGenConfig.Execute(self, TPSO(psoObj)) then
  begin
    //Clear;
    //if frmGenConfig.Config(self, TPSO(psoObj)) then
    UpdateAllViews('',nil);
  end;
end;

procedure TTestFuncBlock.Config();  // initial configuration of props - name, type and default value
var
  ls: TStrings; pso: TPSO;
begin
  OnConfigure:= ConfigureDialog; // that makes it all good
  pso:= TPSO(psoObj);
  if frmGenConfig.Config(self, pso) then
  begin
    NotifyAll();
    exit;
  end;
  // func/problem
  problem:= pso.GetItf.GetProblem;
  wpv:= TPropVal.Create(iiSelection); ls:= TStringList.Create;
  ls.Add('Parabola.Sphere');
	ls.Add('Griewank');
	ls.Add('Rosenbrock.Banana');
	ls.Add('Rastrigin');
	ls.Add('Tripod.dim.2');
	ls.Add('Ackley');
	ls.Add('Schwefel.7');
	ls.Add('Schwefel.1.2');
	ls.Add('Schwefel.2.22');
	ls.Add('Neumaier.3');
	ls.Add('G3');
	ls.Add('Network.optim');
	ls.Add('Schwefel');
	ls.Add('2D.Goldstein-Price ');
	ls.Add('Schaffer.f6');
	ls.Add('Step');
	ls.Add('Schwefel.2.21');
	ls.Add('Lennard-Jones');
	ls.Add('Gear.train ');
	ls.Add('Sine_sine.func');
	ls.Add('Perm.function');
	ls.Add('Compression.Spring');
	ls.Add('sine.Peak');
  wpv.selItems:= ls.CommaText;
  wpv.sel:= pso.GetItf.GetFuncIdx;
  wpv.Hint:= 'Test function, covering variety of situations';
  SetProp('test.func',wpv);
  ls.Free;

  wpv:= TPropVal.Create(iiInteger,problem.ss.fixD>0); wpv.int:= problem.ss.d;
  wpv.intMin:= 1; wpv.intMax:= 22;
  wpv.Hint:= 'The actual current dimensionality';
  SetProp('dim',wpv);
  wpv:= TPropVal.Create(iiInteger,true); wpv.int:= problem.ss.fixD;
  wpv.intMin:= -1; wpv.intMax:= 22;
  wpv.Hint:= 'In case the test function requires some particular (fixed) dimensionality';
  SetProp('fix.dim',wpv);
  wpv:= TPropVal.Create(); wpv.dbl:= 0; wpv.dblMin:= 0;
  wpv.Hint:= 'Noise level, as additive component. The effect depends on the test function.';
  SetProp('noise.level',wpv);
  wpv:= TPropVal.Create(); wpv.dbl:= 0; wpv.dblMin:= 0;
  wpv.Hint:= 'Proportional to the function value noise level, for very specific purposes.';
  SetProp('noise.linear',wpv);
  wpv:= TPropVal.Create(); wpv.dbl:= problem.objective[0];
  wpv.Hint:= 'First value of objective (solution) vector';
  SetProp('objective.0',wpv);
  wpv:= TPropVal.Create(); wpv.dbl:= problem.ss.min[0];
  wpv.Hint:= 'Minimum of search space - common (for now) to all dims';
  SetProp('ss.min',wpv);
  wpv:= TPropVal.Create(); wpv.dbl:= problem.ss.max[0];
  wpv.Hint:= 'Maximum of search space - common (for now) to all dims';
  SetProp('ss.max',wpv);

  wpv:= TPropVal.Create(iiInteger,true);
  wpv.int:= problem.evalMax; wpv.intMin:= 1; wpv.intMax:= 10000;
  wpv.Hint:= 'Recommended max iterations number - specific to a test function';
  SetProp('sug.max.iters',wpv);

  wpv:= TPropVal.Create(iiDouble); wpv.dbl:= problem.epsilon; wpv.dblMin:= 0;
  wpv.Hint:= 'Tolerance for hiiting the target (objective) vector - on.target prop';
  SetProp('sug.epsilon',wpv);
end;

procedure TTestFuncBlock.Synchro(PropName: string);
var
   pso: TPSO; d,idx: integer;
begin
  pso:= TPSO(psoObj);
  if not SameText(PropName,'test.func') then exit; // only when change func index
  idx:= GetProp('test.func').sel;
  pso.GetItf.SetFuncIdx(idx);
  problem:= pso.GetItf.GetProblem;
  // notifications
  wpv:= GetProp('dim'); d:= wpv.int; wpv.ReadOnly:= problem.ss.fixD>0;
  if wpv.ReadOnly then
  begin
    wpv.int:= problem.ss.fixD;
    problem.ss.d:= problem.ss.fixD;
    pso.GetItf.SetDim(problem.ss.d);
  end;
  Notify('dim',wpv);
  Notify('fix.dim',problem.ss.fixD);
  wpv:= GetProp('objective.0');
  wpv.ReadOnly:= not pso.GetItf.IsEnabled(d,idx);
  wpv.dbl:= problem.objective[0];
  Notify('objective.0',wpv);
  Notify('ss.min',problem.ss.min[0]);
  Notify('ss.max',problem.ss.max[0]);
  Notify('sug.max.iters',problem.evalMax);
  Notify('sug.epsilon',problem.epsilon);
end;

procedure TTestFuncBlock.Init(idx: integer); // this Init() is before preview (test func)
var
  i,dm: integer; pso: TPSO;
begin
  pso:= TPSO(psoObj);
  pso.GetItf.SetFuncIdx(GetProp('test.func').sel); // new default problem
  dm:= GetProp('dim').int;
  pso.GetItf.SetDim(dm);
  pso.GetItf.SetNoiseLevel(GetProp('noise.level').dbl);
  pso.GetItf.SetNoiseLinear(GetProp('noise.linear').dbl);

  problem:= pso.GetItf.GetProblem(); // get default
  problem.evalMax:= GetProp('sug.max.iters').int;
  problem.ss.d:= dm;
  for i:= 0 to dm-1 do
  begin
    problem.ss.min[i]:= GetProp('ss.min').dbl;
    problem.ss.max[i]:= GetProp('ss.max').dbl;
  end;
  problem.epsilon:= GetProp('sug.epsilon').dbl;
  pso.GetItf.SetProblem(problem);
end;

procedure TTestFuncBlock.DoChange(idx: integer);
begin
end;

//-=-==-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// ExtFn block
procedure TExtFuncBlock.ConfigureDialog(Sender: TObject);
var i: integer;
begin
  if frmExtConfig.Execute(self, TPSO(psoObj)) then
  begin
    Synchro('dim');
    UpdateAllViews(); UpdateAllViews(); //unclear why twice
  end;
end;

function TExtFuncBlock.feat2prop(xIdx: integer): TPropVal;
begin
  Result:= GetProp('x.'+IntToStr(xIdx));
  if not Assigned(Result) then exit;
  Result.selItems:= frmExtConfig.EnabledFeatures;
end;

procedure TExtFuncBlock.Config();
var pso: TPSO;
begin
  OnConfigure:= ConfigureDialog; // that makes it all good
  pso:= TPSO(psoObj);
  frmExtConfig.Config(self, TPSO(psoObj));
  pso.itf.SetRequestExtFunc(true);

  wpv:= TPropVal.Create(iiInteger); wpv.int:= 2;
  wpv.intMin:= 1; wpv.intMax:= 22;
  wpv.Hint:= 'The actual current dimensionality';
  SetProp('dim',wpv);

  wpv:= TPropVal.Create(iiInteger,true);
  wpv.int:= problem.evalMax; wpv.intMin:= 1; wpv.intMax:= 10000;
  wpv.Hint:= 'Recommended max iterations number - specific to a test function';
  SetProp('sug.max.iters',wpv);
  wpv:= TPropVal.Create(iiDouble); wpv.dbl:= problem.epsilon; wpv.dblMin:= 0;
  wpv.Hint:= 'Tolerance for hiiting the target (objective) vector - on.target prop';
  SetProp('sug.epsilon',wpv);

  wpv:= TPropVal.Create(iiSelection); wpv.selItems:= frmExtConfig.EnabledFeatures;
  wpv.Hint:= 'First element of Variable array.';
  SetProp('x.1',wpv);
  wpv:= TPropVal.Create(iiSelection);wpv.selItems:= frmExtConfig.EnabledFeatures;
  wpv.Hint:= 'Second element of Variable array.';
  SetProp('x.2',wpv);
  {wpv:= TPropVal.Create(iiSelection); wpv.selItems:= frmExtConfig.EnabledFeatures;
  wpv.Hint:= 'Third element of Variable array.';
  SetProp('x.3',wpv);}
end;

procedure TExtFuncBlock.Synchro(PropName: string);
var pso: TPSO; i,dm: integer; ss: string;
begin
  pso:= TPSO(psoObj);
  if PropName<>'dim' then exit;
  dm:= GetProp('dim').int;
  for i:= 1 to dm do
  begin
    ss:= 'x.'+IntToStr(i);
    wpv:= GetProp(ss);
    if not Assigned(wpv) then wpv:= TPropVal.Create(iiSelection);
    wpv.selItems:= frmExtConfig.EnabledFeatures;
    wpv.Hint:= 'Element['+IntToStr(i)+'] of Variable array.';
    SetProp(ss,wpv);
  end;
  for i:= dm+1 to 22 do
  begin
    ss:= 'x.'+IntToStr(i);
    wpv:= GetProp(ss);
    if not Assigned(wpv) then break;
    Remove(ss);
  end;
  NotifyAll;
end;

procedure TExtFuncBlock.Init(idx: integer);
var
  i,dm: integer; pso: TPSO; ss,st: string; ft: TFeature;
begin
  pso:= TPSO(psoObj);
  pso.GetItf.SetFuncIdx(-1); // new default problem
  pso.GetItf.SetNoiseLevel(0);
  pso.GetItf.SetNoiseLinear(0);

  problem:= pso.GetItf.GetProblem(); // get default
  problem.evalMax:= GetProp('sug.max.iters').int;
  problem.epsilon:= GetProp('sug.epsilon').dbl;

  dm:= GetProp('dim').int;
  pso.GetItf.SetDim(dm);
  problem.ss.d:= dm;
  for i:= 1 to dm do
  begin
    ss:= 'x.'+IntToStr(i);
    wpv:= GetProp(ss);
    if not Assigned(wpv) then continue;
    st:= wpv.AsString;
    ft:= frmExtConfig.featureByName(st);
    if not ft.Enabled then continue;
    problem.ss.min[i-1]:= ft.MinVal;
    problem.ss.max[i-1]:= ft.MaxVal;
  end;
  pso.GetItf.SetProblem(problem);
  if not frmExtConfig.IsSimion() then frmExtConfig.RunSimion('');
end;

procedure TExtFuncBlock.DoChange(idx: integer);
begin

end;
//*************************************************************************
// PreCalc block

procedure TPreCalcBlock.Config();
begin
  wpv:= TPropVal.Create(iiInteger);
  wpv.int:= 30; wpv.intMin:= 1; wpv.intMax:= 1000;
  wpv.Hint:= 'Number of particles';
  SetProp('numb.part',wpv);

  wpv:= TPropVal.Create(iiBoolean); wpv.bool:= false;
  wpv.Hint:= 'Equidistant initial position, to remove initial randomness';
  SetProp('equidist.ini',wpv);

  wpv:= TPropVal.Create(iiDouble,true); wpv.dbl:= 0;
  wpv.Hint:= 'First component of the solution vector';
  SetProp('Var.0',wpv);
  wpv:= TPropVal.Create(iiBoolean,true); wpv.bool:= false;
  wpv.Hint:= 'If the target/objective is hit (within sug.epsilon precision)';
  SetProp('on.target',wpv);
  wpv:= TPropVal.Create(iiDouble,true); wpv.dbl:= 0;
  wpv.Hint:= 'Best fitness value';
  SetProp('Best.Fitness',wpv);
  wpv:= TPropVal.Create(iiDouble,true); wpv.dbl:= 0;
  wpv.Hint:= 'Best ever fitness value so far';
  SetProp('Best.Ever.Fitness',wpv);

  wpv:= TPropVal.Create(iiInteger); wpv.int:= 0; wpv.intMin:= 0; wpv.intMax:= 10000;
  wpv.Hint:= 'Artificial delay [ms] for better visualization of the process';
  SetProp('artif.delay',wpv);
end;

procedure TPreCalcBlock.Synchro(PropName: string);
begin
end;

procedure TPreCalcBlock.Init(idx: integer);
var pso: TPSO;
begin
  pso:= TPSO(psoObj);
  pso.SetParticleCount(GetProp('numb.part').int);
  pso.SetEquidist(GetProp('equidist.ini').bool);
end;

procedure TPreCalcBlock.DoChange(idx: integer);
var pso: TPSO;
  swarmBest: TParticle; i: integer;
begin
  if idx>0 then exit; // pso block

  pso:= TPSO(psoObj);
  // go rogue or go with the crowd

  swarmBest:= pso.Particles.BestPrt(true); // recalc

  // update global best
  if swarmBest.getFitness > pso.SwarmBestEverFitness then
  begin
    pso.SwarmBestEverFitness := swarmBest.getFitness;
    pso.SwarmBestEverPos:= swarmBest.getPosition();
  end;
  // notifications
  if length(pso.SwarmBestEverPos)>0 then
    Notify('Var.0',pso.SwarmBestEverPos[0]);
  Notify('on.target',pso.OnTarget);
  Notify('Best.Fitness',swarmBest.getFitness);
  Notify('Best.Ever.Fitness',pso.SwarmBestEverFitness);
  delay(GetProp('artif.delay').int);
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// TERM block

procedure TTermCondBlock.Config();
var When2End: TWhen2End; i: integer; d: double;
begin
  wpv:= TPropVal.Create(iiInteger,true);
  wpv.int:= 0; wpv.Hint:= 'The number of iterations so far';
  SetProp('iterations',wpv);

  wpv:= TPropVal.Create(iiInteger);
  wpv.int:= 10; wpv.intMin:= 1; wpv.intMax:= 10000;
  wpv.Hint:= 'The upper limit of number of iterations';
  SetProp('max.iters',wpv);

  wpv:= TPropVal.Create(iiDouble,true);
  wpv.dbl:= 0; wpv.Hint:= 'Size, the value is min-max or sigma of a normal distribution';
  SetProp('size',wpv);
  wpv:= TPropVal.Create(iiSelection);
  wpv.selItems:= 'off,min-max,sigma'; wpv.sel:= 2;
  wpv.Hint:= 'Size mode: min-max or sigma of a normal distribution';
  SetProp('size.mode',wpv);
  wpv:= TPropVal.Create(iiSelection);
  wpv.selItems:= 'swarm,in.time'; wpv.sel:= 0;
  wpv.Hint:= 'Size direction: in space (swarm) or in history (in.time)';
  SetProp('size.direction',wpv);

  wpv:= TPropVal.Create(); wpv.dbl:= 0; wpv.dblMin:= 0;
  wpv.Hint:= 'Value limit of terminal condition upon the size';
  SetProp('size.bottom',wpv);

  wpv:= TPropVal.Create(iiDouble,true);
  wpv.dbl:= 0; wpv.Hint:= 'Maximum particle speed';
  SetProp('max.speed',wpv);
  wpv:= TPropVal.Create(iiDouble,true);
  wpv.dbl:= 0; wpv.Hint:= 'Average particle speed';
  SetProp('aver.speed',wpv);
  wpv:= TPropVal.Create(iiDouble,true);
  wpv.dbl:= 0; wpv.Hint:= 'Top particle speed - top 10% (min.5) of best fitness particles average speed';
  SetProp('top.speed',wpv);

  wpv:= TPropVal.Create(iiSelection);
  wpv.selItems:= 'off,maximum,average,top';
  wpv.sel:= 2; wpv.Hint:= 'Type of speed terminal condition: maximum, average or top';
  SetProp('speed.mode',wpv);
  wpv:= TPropVal.Create(); wpv.dbl:= 0; wpv.dblMin:= 0;
  wpv.Hint:= 'Value  limit of terminal condition upon the speed';
  SetProp('speed.bottom',wpv);

  wpv:= TPropVal.Create(); wpv.dbl:= 0;
  wpv.Hint:= 'Variable to be used by the script for buffering or chart viewing';
  SetProp('user.1',wpv);
  // script
  source.Count:= 2;
  source.Funcs[0].nm:= 'ft1'; source.Funcs[0].prms:= 'p1,p2,p3';
  source.Funcs[1].nm:= 'ft2'; source.Funcs[1].prms:= 'q1,q2';
end;

procedure TTermCondBlock.Init(idx: integer);
var
  When2End: TWhen2End; i: integer; pso: TPSO;
begin
  inherited; // in case of src
  pso:= TPSO(psoObj);
  pso.MaxIterations:= GetProp('max.iters').int;
  // speed limit
  speedMode:= GetProp('speed.mode').sel;
  speedBottom:= GetProp('speed.bottom').dbl;
  // size limit
  sizeMode:= GetProp('size.mode').sel;
  sizeDirection:= GetProp('size.direction').sel;
  sizeBottom:= GetProp('size.bottom').dbl;

  if not Assigned(When2EndList) then When2EndList := TWhen2EndList.Create()
  else begin
    for When2End in When2EndList do  // erase When2End
      When2End.Free;
    When2EndList.Clear;
  end;
  for i := 0 to pso.GetVaiablesCount-1 do  // recreate
    When2EndList.add(TWhen2End.Create());
  for i := 0 to When2EndList.Count-1 do
    When2EndList[i].Init(sizeMode=1, sizeBottom); //, round(psoInf.GetMaxIterations/20));
end;

procedure TTermCondBlock.DoChange(idx: integer);
var pso: TPSO; i: integer; aver: double;
begin
  pso:= TPSO(psoObj); pso.TermCond:= '';
  // termination conditions
  aver:= 0;
  case GetProp('size.direction').sel of
    0:begin
        case sizeMode of
         1:aver:= pso.Particles.MinMaxSize();
         2:aver:= pso.Particles.StdDevDistance(pso.SwarmBestEverPos);
        end;
      end;
    1:begin
        for i := 0 to When2EndList.Count-1 do  // numb vars
          aver:= aver + When2EndList[i].Append(pso.SwarmBestEverPos[i]);
        if When2EndList.Count>0 then
          aver:= aver/When2EndList.Count;
      end;
  end;
  if (aver > smallDouble) and (aver < sizeBottom) and (sizeMode > 0) then
    pso.TermCond:= 'small spot ('+F2S(aver)+')';

  case SpeedMode of
    1: if pso.Particles.Speed(spdMax)<speedBottom then pso.TermCond:= 'low speed ('+F2S(pso.Particles.Speed(spdMax))+')';
    2: if pso.Particles.Speed(spdAver)<speedBottom then pso.TermCond:= 'low speed ('+F2S(pso.Particles.Speed(spdAver))+')';
    3: if pso.Particles.Speed(spdTop)<speedBottom then pso.TermCond:= 'low speed ('+F2S(pso.Particles.Speed(spdTop))+')';
  end;

  if source.enabled and source.Funcs[0].enabled then
  begin
    source.Exec('ft1(2,3,1)');
    pso.User1:= GetProp('user.1').dbl;
  end;
  // notifications
  Notify('iterations',pso.Iterations);
  Notify('size',aver);
  Notify('aver.speed',pso.Particles.Speed(spdAver));
  Notify('max.speed',pso.Particles.Speed(spdMax));
  Notify('top.speed',pso.Particles.Speed(spdTop));
  if pso.TermCond<>'' then
  begin
    wpv:= TPropVal.Create(iiString); wpv.str:= pso.TermCond;
    Notify('@log',wpv);
    wpv.Free;
  end;
end;

destructor TTermCondBlock.Destroy;
var i: integer; When2End: TWhen2End;
begin
  if Assigned(When2EndList) then
    for When2End in When2EndList do
      When2End.Free;
  FreeAndNil(When2EndList);
  inherited;
end;

end.
