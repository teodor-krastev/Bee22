(************************************************************************)
(*  Bee22 - Particle Swarm Optimization framework     http://bee22.com  *)
(*  developed by and copyright(c) Teodor Krastev 2015-2016              *)
(************************************************************************)
unit blk_particle;

interface
uses Classes, SysUtils, Math, pso_variable, System.Types, Generics.Collections,
  VCLTee.TeeInspector, UtilsU, MVC_U, TestFuncU, AdjustU;

type

 TFactorBlock = class(TblkModel)
  protected
    factorBalance: double;
  public
    procedure Config(); override;
    procedure Synchro(PropName: string); override;
    procedure Init(idx: integer); override;
    procedure DoChange(idx: integer); override;
  end;

  TInertiaBlock = class(TblkModel)
  private
    lastIter: integer;
    z: double; // chaotic param
    function GetICur: double;
    procedure SetICur(dbl: double);
  public
    procedure Config(); override;
    procedure Init(idx: integer); override;
    procedure DoChange(idx: integer); override;

    property iCur: double read GetICur write SetICur;
  end;

  TPosLimitBlock = class(TblkModel)
  private
    maxSpeedScale: double;
  public
    procedure Config(); override;
    procedure Init(idx: integer); override;
    procedure DoChange(idx: integer); override;
  end;

implementation
uses pso_particle, pso_algo;

//***************************************************************************
// PREP block

procedure TFactorBlock.Config();
begin
  OncePerIter:= true;
  // random params
  wpv:= TPropVal.Create(iiSelection);
  wpv.selItems:= 'none,uniform(-rd:rd),gauss(0;rd)';
  wpv.sel:= 1;
  wpv.Hint:= 'Random generator mode (rd - random.disp) - none; uniform from -rd to rd; gauss with sigma=rd';
  SetProp('random.Mode',wpv);
  wpv:= TPropVal.Create;
  wpv.dbl:= 0.1; wpv.dblMin:= 0; wpv.dblMax:= 1;
  wpv.Hint:= 'Parameter (rd) for random generator (see Random.Mode)';
  SetProp('random.Disp',wpv);

  // factor setting
  wpv:= TPropVal.Create;
  wpv.dbl:= 1; wpv.dblMin:= 0; wpv.dblMax:= 2;
  wpv.Hint:= 'The slope of social factor linear trend. The value is the intial position of social factor going to negative of that value';
  SetProp('factor.balance',wpv);
  // factor results
  wpv:= TPropVal.Create(iiDouble,true);
  wpv.dbl:= 1; wpv.dblMin:= 0; wpv.dblMax:= 2;
  wpv.Hint:= 'Social factor - follows the colective movement and its best';
  SetProp('social.Factor',wpv);
  wpv:= TPropVal.Create(iiDouble,true);
  wpv.dbl:= 1; wpv.dblMin:= 0; wpv.dblMax:= 2;
  wpv.Hint:= 'Cognitive factor - follows the particle individual experince (its best)';
  SetProp('cogn.Factor',wpv);
end;

procedure TFactorBlock.Synchro(PropName: string);
begin
end;

procedure TFactorBlock.Init(idx: integer);
var pso: TPSO;
begin
  pso:= TPSO(psoObj); // defaults if sub-sw
  pso.Particles.Adjust.rand.mode:= GetProp('random.Mode').sel;
  pso.Particles.Adjust.rand.disp:= GetProp('random.Disp').dbl;
  pso.Particles.Adjust.factorBalance:= GetProp('factor.balance').dbl;
  pso.Particles.Adjust.rand.mode:= GetProp('random.Mode').sel;
  pso.Particles.Adjust.rand.disp:= GetProp('random.Disp').dbl;
end;

procedure TFactorBlock.DoChange(idx: integer);
var pso: TPSO;
  prt: TParticle; i: integer; mn: double;
  socFactor: double;
begin
  if OncePerIter and (idx>0) then exit;
  pso:= TPSO(psoObj); prt:= pso.Particle[Idx];

  // notifications
  socFactor:= prt.Adjust.socialFactor;
  Notify('social.Factor', socFactor * prt.Adjust.MyRandom);
  Notify('cogn.Factor', prt.Adjust.cognitiveFactor(socFactor) * prt.Adjust.MyRandom);
end;

//£££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££
// Inertia Block

function TInertiaBlock.GetICur: double;
begin
  Result:= GetProp('cur.Inertia').dbl;
end;

procedure TInertiaBlock.SetICur(dbl: double);
begin
  wpv:= GetProp('cur.Inertia');
  if wpv=nil then wpv:= TPropVal.Create;
  wpv.dbl:= dbl;
  SetProp('cur.Inertia',wpv);
end;

procedure TInertiaBlock.Config();
begin
  OncePerIter:= true;

  wpv:= TPropVal.Create(iiDouble,true); wpv.dbl:= 0.7;
  wpv.Hint:= 'Current magnitude of inertia';
  SetProp('cur.Inertia',wpv);

  wpv:= TPropVal.Create(iiSelection);
  wpv.selItems:= 'Constant,Random,Linear.decr,Gauss,Chaotic.linear,Pure.chaotic';
  wpv.selItems:= wpv.selItems+',Nonlinear.decr,Sigmoid.decr,Sigmoid.incr,Simulated.Annealing';
  wpv.selItems:= wpv.selItems+',Exponential.e1,Exponential.e2,Exponent.decr';
  wpv.Hint:= 'Inertia modes: different ways to calculate inertia as function of iter.#, default, min and max inertia';
  wpv.sel:= 1;
  SetProp('mode.Inertia',wpv);

  wpv:= TPropVal.Create; wpv.dbl:= 100;
  wpv.Hint:= 'Change the original curve scale of 0..maxIters (100%)';
  SetProp('scale.Inertia',wpv);
  wpv:= TPropVal.Create; wpv.dbl:= 0.7;
  wpv.Hint:= 'Used in Constant and Gauss modes only';
  SetProp('def.Inertia',wpv);
  wpv:= TPropVal.Create; wpv.dbl:= 0.1;
  wpv.Hint:= 'Lower inertia limit and use in most modes';
  SetProp('min.Inertia',wpv);
  wpv:= TPropVal.Create; wpv.dbl:= 1;
  wpv.Hint:= 'Upper inertia limit and use in most modes';
  SetProp('max.Inertia',wpv);
end;

procedure TInertiaBlock.Init(idx: integer);
var
  pso: TPSO; prt: TParticle;
begin
  z:= random(); lastIter:= 0;

  pso:= TPSO(psoObj); // defaults for multi-swarm
  pso.Particles.Adjust.scaleInertia:= GetProp('scale.Inertia').dbl;
  pso.Particles.Adjust.defInertia:= GetProp('def.Inertia').dbl;
  pso.Particles.Adjust.InertiaMode:= GetProp('mode.Inertia').sel;
  pso.Particles.Adjust.minInertia:= GetProp('min.Inertia').dbl;
  pso.Particles.Adjust.maxInertia:= GetProp('max.Inertia').dbl;
end;

procedure TInertiaBlock.DoChange(idx: integer);
var
  v: TVariable; prt: TParticle; i,j,md, iters,maxIters,scMaxIters: integer;
  a,d,iMax,iMin,iDefault,iScale, gen,u,k,d1,d2: double; pso: TPSO;
begin
  if OncePerIter and (idx>0) then exit;

  pso:= TPSO(psoObj); prt:= pso.Particle[idx];
  // notifications
  Notify('cur.Inertia',prt.Adjust.curInertia);
end;
//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
// PosLimit Block

procedure TPosLimitBlock.Config();
begin
  OncePerIter:= false; // !!!

  wpv:= TPropVal.Create(iiInteger,true); wpv.int:= 0;
  wpv.Hint:= 'Outlier count: too small number questions the exploratory phase; too bigger - the convergience effectiveness';
  SetProp('outCount',wpv);
  wpv:= TPropVal.Create(iiInteger); wpv.int:= 100; wpv.intMin:= 1; wpv.intMax:= 300;
  wpv.Hint:= 'Maximum speed limits the speed of particales, scale add coeff (in %) to that limit';
  SetProp('max.speed.scale',wpv);
end;

procedure TPosLimitBlock.Init(idx: integer);
begin
  GetProp('outCount').int:= 0;
  maxSpeedScale:= GetProp('max.speed.scale').int / 100;
end;

procedure TPosLimitBlock.DoChange(idx: integer);
var
  i: integer; v: TVariable; prt: TParticle; pso: TPSO; r: double;
begin
  if OncePerIter and (idx>0) then exit;

  pso:= TPSO(psoObj); prt:= TParticle(pso.Particle[idx]);
  for i := 0 to prt.FVariables.Count - 1 do
  begin
    //limit FPos by randomizing trespassers
    v := TVariable(prt.FVariables[i]);
    prt.mxSpeed[i]:=  maxSpeedScale * (v.AdjustedMax - v.AdjustedMin) / 2 ;
    if not InRange(prt.FPos[i], v.AdjustedMin, v.AdjustedMax) then
    begin
      if pso.Equidist then r:= 0.5
                      else r:= Random();
      prt.FPos[i]:=  r * prt.mxSpeed[i] + v.AdjustedMin;
      prt.OutCount:= prt.OutCount + 1;
    end;
  end;
  // notifications
  if idx=pso.ParticleCount-1 then // at the end of iter
    Notify('outCount',pso.OutCount);
end;

end.

