(************************************************************************)
(*  Bee22 - Particle Swarm Optimization framework     http://bee22.com  *)
(*  developed by and copyright(c) Teodor Krastev 2015-2016              *)
(************************************************************************)
unit blk_subSw;

interface
uses Classes, SysUtils, Math, pso_variable, System.Types, Generics.Collections,
  VCLTee.TeeInspector, UtilsU, MVC_U, TestFuncU;

type
  TClubsBlock = class(TblkModel)
  private
    fSubCount: integer;
  public
    procedure Config(); override;
    procedure Init(idx: integer); override;
    procedure DoChange(idx: integer); override;
  end;

  TBiswarmBlock = class(TblkModel)
  private
  public
    procedure Config(); override;
    procedure Init(idx: integer); override;
    procedure DoChange(idx: integer); override;
  end;

implementation
uses pso_particle, pso_algo, AdjustU;
//£££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££
// Clubs Block

procedure TClubsBlock.Config();
begin
  OncePerIter:= false;

  wpv:= TPropVal.Create(iiInteger); wpv.int:= 20;
  wpv.intMin:= 1; wpv.intMax:= 100;
  wpv.Hint:= 'Number of clubs';
  SetProp('numb.clubs',wpv);

  wpv:= TPropVal.Create(iiInteger); wpv.int:= 10;
  wpv.intMin:= 1; wpv.intMax:= 22;
  wpv.Hint:= 'Default membership level';
  SetProp('def.ml',wpv);

  wpv:= TPropVal.Create(iiInteger); wpv.int:= 2;
  wpv.intMin:= 1; wpv.intMax:= 22;
  wpv.Hint:= 'Min membership level';
  SetProp('min.ml',wpv);

  wpv:= TPropVal.Create(iiInteger); wpv.int:= 20;
  wpv.intMin:= 1; wpv.intMax:= 22;
  wpv.Hint:= 'Max membership level';
  SetProp('max.ml',wpv);

  wpv:= TPropVal.Create(iiInteger); wpv.int:= 5;
  wpv.intMin:= 0; wpv.intMax:= 50;
  wpv.Hint:= 'Redistribution rate; 0 - off';
  SetProp('redist.rate',wpv);

  wpv:= TPropVal.Create(iiBoolean); wpv.bool:= false;
  wpv.Hint:= 'Redistribute particles in clubs: best/worst and default membership level (ML)';
  SetProp('redistribute',wpv);

  wpv:= TPropVal.Create(iiInteger,true); wpv.int:= 0;
  wpv.Hint:= 'Redistribution counter';
  SetProp('redist.cnt',wpv);

  wpv:= TPropVal.Create(iiDouble,true); wpv.dbl:= 0;
  wpv.Hint:= 'Multi-swarm effect: influence flow';
  SetProp('influ.flow',wpv);
end;

procedure TClubsBlock.Init(idx: integer);
var
  i,j,k, nc: integer; pso: TPSO; prtL: TParticleList;
begin
  pso:= TPSO(psoObj);
  if pso.SubSw.Count > 0 then
    for prtL in pso.SubSw do
      prtL.Clear;
  nc:= GetProp('numb.clubs').int;
  if nc<>pso.SubSw.Count then  // recreate
  begin
    for i:= 0 to pso.SubSw.Count-1 do
      pso.SubSw[i].Free;
    pso.SubSw.Clear;
    pso.SubSw.MultiSwarmKind:= mskClubs;
    for i:= 0 to nc-1 do
      pso.SubSw.Add(TParticleList.Create);
  end;
  pso.SubSw.defML:= GetProp('def.ml').int;
  pso.SubSw.minML:= GetProp('min.ml').int;
  pso.SubSw.maxML:= GetProp('max.ml').int;
  pso.SubSw.rr:= GetProp('redist.rate').int;
  wpv:= GetProp('redist.cnt'); wpv.int:= 0;
  Notify('redist.cnt',wpv);
  wpv:= GetProp('influ.flow'); wpv.dbl:= 0;
  Notify('influ.flow',wpv);
end;

procedure TClubsBlock.DoChange(idx: integer);
var pso: TPSO;
  prt,wprt, best,worst, LocalBest: TParticle; i,j: integer;
  fitness, LocalBestFitness,lastCogn,lastSocial,socFactor: double;
  LocalBestPos: TDoubleDynArray; prtList,wPrtList: TParticleList;
begin
  if OncePerIter and (idx>0) then exit;

  pso:= TPSO(psoObj); prt:= pso.Particle[Idx];
  SetLength(LocalBestPos,prt.FVariables.Count);

  prtList:= TParticleList.Create;
  pso.SubSw.Locality(prt,prtList); // all the subs prt is member of

  best:= prtList.BestPrt();

  FreeAndNil(prtList);

  for i := 0 to prt.FVariables.Count - 1 do
  with prt do
  begin
    // update FSpeed
    socFactor:= Adjust.socialFactor;
    lastSocial := socFactor * Adjust.MyRandom * (best.FPos[i] - FPos[i]);
    lastCogn := Adjust.cognitiveFactor(socFactor) * Adjust.MyRandom * (FPersonalBest[i] - FPos[i]);
    lastInertia:= FSpeed[i] * Adjust.curInertia;
    FSpeed[i] := lastInertia + lastCogn + lastSocial;
  end;

  // redistribution
  if (idx=pso.ParticleCount-1) and   // once per iter (at the end)
     GetProp('redistribute').bool then  // redistribute switch
  begin
    wPrtList:= TParticleList.Create;
    for prtList in pso.SubSw do
    begin
      wPrtList.Clear; wPrtList.AddRange(prtList);
      best:= prtList.WorstPrt;
      pso.SubSw.JoinUpPart(best);
      if prtList.Count = 0 then continue;
      worst:= prtList.BestPrt;
      pso.SubSw.LeaveDownPart(worst);
      if pso.SubSw.rr = 0 then continue;
      if ((pso.Iterations mod pso.SubSw.rr) > 0) or (prtList.Count = 0) then continue;
      j:= 0;
      while j < wPrtList.Count do
      begin
        prt:= wPrtList[j];
        if (pso.SubSw.PartMemLevel(prt) > pso.SubSw.defML) and
          not (prt=best) or not (prt=worst) then
          pso.SubSw.LeaveDownPart(prt);
        inc(j);
      end;
      j:= 0;
      while j < wPrtList.Count do
      begin
        prt:= wPrtList[j];
        if (pso.SubSw.PartMemLevel(prt) < pso.SubSw.defML) and
          not (prt=best) or not (prt=worst) then
          pso.SubSw.JoinUpPart(prt);
        inc(j);
      end;
      wpv:= GetProp('redist.cnt');
      wpv.int:= wpv.int + 1;
      Notify('redist.cnt',wpv);
    end;
    FreeAndNil(wPrtList);
    wpv:= GetProp('influ.flow');
    wpv.dbl:= wpv.dbl + pso.SubSw.AverGenPrtDist;
    Notify('influ.flow',wpv);
  end;
end;
//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
// Biswarm Block

procedure TBiswarmBlock.Config();
var
  i,j,k, nc: integer; pso: TPSO; si: string;
begin
  OncePerIter:= false;

  wpv:= TPropVal.Create(iiInteger);
  wpv.dbl:= 50; wpv.dblMin:= 0; wpv.dblMax:= 100;
  wpv.Hint:= 'Number of particles ratio in %';
  SetProp('numb.part.rt',wpv);

  for i:= 0 to 1 do
  begin
    si:= IntToStr(i);
    wpv:= TPropVal.Create;
    wpv.dbl:= 0.1; wpv.dblMin:= 0; wpv.dblMax:= 1;
    wpv.Hint:= 'Parameter (rd) for random generator (see Random.Mode)';
    SetProp('random.Disp.'+si,wpv);

    // Adjust
    wpv:= TPropVal.Create;
    wpv.dbl:= 1; wpv.dblMin:= 0; wpv.dblMax:= 2;
    wpv.Hint:= 'The slope of social factor linear trend. The value is the intial position of social factor going to negative of that value';
    SetProp('factor.balance.'+si,wpv);

    wpv:= TPropVal.Create(iiDouble,true);
    wpv.dbl:= 1; wpv.dblMin:= 0; wpv.dblMax:= 2;
    wpv.Hint:= 'Cognitive factor - follows the particle individual experince (its best)';
    SetProp('cogn.Factor.'+si,wpv);
    wpv:= TPropVal.Create(iiDouble,true);
    wpv.dbl:= 1; wpv.dblMin:= 0; wpv.dblMax:= 2;
    wpv.Hint:= 'Social factor - follows the colective movement and its best';
    SetProp('social.Factor.'+si,wpv);

    wpv:= TPropVal.Create(iiSelection);
    wpv.selItems:= 'Constant,Random,Linear.decr,Gauss,Chaotic.linear,Pure.chaotic';
    wpv.selItems:= wpv.selItems+',Nonlinear.decr,Sigmoid.decr,Sigmoid.incr,Simulated.Annealing';
    wpv.selItems:= wpv.selItems+',Exponential.e1,Exponential.e2,Exponent.decr';
    wpv.Hint:= 'Inertia modes: different ways to calculate inertia as function of iter.#, default, min and max inertia';
    wpv.sel:= 1;
    SetProp('mode.Inertia.'+si,wpv);

    wpv:= TPropVal.Create(iiDouble); wpv.dblMin:= 0.3; wpv.dblMax:= 3;
    wpv.Hint:= 'Maximum inertia'; wpv.dbl:= 1.1;
    SetProp('max.Inertia.'+si,wpv);
  end;
end;

procedure TBiswarmBlock.Init(idx: integer);
var
  i,j,k, nc: integer; pso: TPSO; prtL: TParticleList; si: string;
begin
  pso:= TPSO(psoObj);
  pso.SubSw.MultiSwarmKind:= mskBiswarm;
  if pso.SubSw.Count=0 then
    for i:= 0 to 1 do
    begin
      pso.SubSw.Add(TParticleList.Create);
      pso.SubSw[i].Adjust:= TAdjust.Create(pso);
    end;
  pso.SubSw.NumbRatio:= GetProp('numb.part.rt').int;
  for i:= 0 to 1 do
  begin
    si:= IntToStr(i);
    // set defaults from PrepUpdateBlock (factors) and InertiaBlock
    pso.SubSw[i].Adjust.CopyFrom(pso.Particles.Adjust);

    pso.SubSw[i].Adjust.rand.disp:= GetProp('random.Disp.'+si).dbl;
    pso.SubSw[i].Adjust.factorBalance:= GetProp('factor.balance.'+si).dbl;
    pso.SubSw[i].Adjust.InertiaMode:= GetProp('mode.Inertia.'+si).int;
    pso.SubSw[i].Adjust.maxInertia:= GetProp('max.Inertia.'+si).dbl;
  end;
end;

procedure TBiswarmBlock.DoChange(idx: integer);
var pso: TPSO;
  prt,wprt, best,worst, LocalBest: TParticle; i,j: integer; si: string;
  socFactor: double;
begin
  if OncePerIter and (idx>0) then exit;
  pso:= TPSO(psoObj); prt:= pso.Particle[Idx];

  if (idx = 0) or (idx = pso.SubSw[0].Count) then // once per sub-swarm
  begin
    if idx < pso.SubSw[0].Count then si:= '0'
                                else si:= '1';
    // notifications
    socFactor:= prt.Adjust.socialFactor;
    Notify('social.Factor.'+si, socFactor * prt.Adjust.MyRandom);
    Notify('cogn.Factor.'+si, prt.Adjust.cognitiveFactor(socFactor) * prt.Adjust.MyRandom);
  end;

  // evaluate particles speed/pos
  for i:= 0 to prt.FVariables.Count - 1 do
  with prt do
  begin
    // update FSpeed
    socFactor:= Adjust.socialFactor;
    lastSocial:= socFactor * Adjust.MyRandom * (pso.SwarmBestEverPos[i] - FPos[i]);
    lastCogn:= Adjust.cognitiveFactor(socFactor) * Adjust.MyRandom * (FPersonalBest[i] - FPos[i]);
    lastInertia:= FSpeed[i] * Adjust.curInertia;
    FSpeed[i]:= lastInertia + lastCogn + lastSocial;
  end;
end;

end.
