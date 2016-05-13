(************************************************************************)
(*  Bee22 - Particle Swarm Optimization framework     http://bee22.com  *)
(*  developed by and copyright(c) Teodor Krastev 2015-2016              *)
(************************************************************************)
unit AdjustU;

interface

uses Classes, SysUtils, Math, pso_variable, System.Types, Generics.Collections,
  UtilsU;

type
  rRand = record
    mode: byte; // 0 - no random; 1 - unified (-disp:disp) random; 2 - gauss (0,disp)
    disp: double;
  end;

  TAdjust = class // behaviour setting
  protected
    z: double;
    function GetCurInertia: double;
    function GetSocialFactor: double;
  public
    psoInf: IPSO;
    rand: rRand;
    InertiaMode: integer;
    defInertia, maxInertia, minInertia, scaleInertia: double;
    factorBalance, minSocial, maxSocial: double;
    constructor Create(ApsoInf: IPSO);
    procedure CopyFrom(adj: TAdjust);
    function MyRandom(): double;
    function cognitiveFactor(socFactor: double): double;
    property curInertia: double read GetCurInertia;
    property socialFactor: double read GetSocialFactor;
  end;

  TAdjustList = class(TList<TAdjust>) // sub-swarms with dif.behaviour
  private
    psoInf: IPSO;
    // particle specific models (owned by PSO)
    //BigPicBlock: TBigPicBlock;     // mostly inertia modeling
    //PosLimitBlock: TPosLimitBlock; // reflect outliers back
  public
    constructor Create(aipso: IPSO); overload;
    destructor Destroy; override;

    function Add(Adjust: TAdjust): integer; overload;
    function NewAdjust: integer;
  end;

implementation

constructor TAdjust.Create(ApsoInf: IPSO);
begin
  psoInf:= ApsoInf;
  rand.mode:= 2; rand.disp:= 0.1;
  defInertia:= 0.4; InertiaMode:= 0;
  maxInertia:= 1.1; minInertia:= 0.1;
  factorBalance:= 0.6; minSocial:= 0; maxSocial:= 2;
  z:= random();
end;

function TAdjust.GetCurInertia: double;
var
  i,j,md, iters,maxIters,scMaxIters: integer;
  a,d,iMax,iMin,iDefault,iScale,iCur, gen,u,k,d1,d2: double;
begin
  iDefault:= defInertia; iScale:= scaleInertia;
  iMin:= minInertia; iMax:= maxInertia;
  assert(iMax>iMin);

  iters:= psoInf.GetIterations;
  maxIters:= psoInf.GetMaxIterations;

  if IsZero(iScale,epsilon3) then scMaxIters:= maxIters
  else scMaxIters:= round(maxIters*100/iScale);

  case InertiaMode of  // mostly  Bansal 2011
   {-1:begin iCur:= 0;
        for i:= 0 to length(cf)-1 do
            iCur:= iCur+cf[i]*power((pso.MaxIterations-pso.Iterations)/pso.MaxIterations,i);
        iCur:= (iMax-iMin)*iCur+iMin;
            //iCur:= iCur+cf[i]*power(pso.Iterations/pso.MaxIterations,i)
      end;  }
    0:iCur:= iDefault;
    1:iCur:= iMin + (iMax-iMin)*random();
    2:iCur:= iMax-(iMax-iMin)*iters/scMaxIters;
    3:iCur:= RandG(iDefault, (iMax-iMin)/2);
    4:begin //Chaotic.linear
        z:= 4*z*(1-z);
        iCur:= (iMax-iMin)*(maxIters-iters)/scMaxIters+z*iMin;
      end;
    5:begin // Pure.chaotic
        z:= 4*z*(1-z);
        iCur:= random()/2+z/2;
      end;
    6:// Nonlinear.decr
      iCur:= (iMax-iMin)*math.power(abs(maxIters-iters)/scMaxIters,1.2)+iMin;
    7,8:begin // Sigmoid.decr,Sigmoid.incr - Malik 2007
         if md=7 then j:= 1
                 else j:= -1;
         gen:= 3; k:= 1;
         u:= math.Power(10,math.Log10(gen)-2);
         iCur:= (iMax-iMin)/(1+exp(j*u*(iters-scMaxIters*gen/7)))+iMin;
       end;
     9:// Simulated.Annealing
       iCur:= iMin+(iMax-iMin)*math.Power(0.985,iters);
     10:// Exponential.e1 - Al-Hasan 2007
        iCur:= iMin+(iMax-iMin)*exp(-iters/(scMaxIters/10));
     11:// Exponential.e2
        iCur:= iMin+(iMax-iMin)*exp(-sqr(iters/(scMaxIters/4)));
     12:begin // Exponent Decreasing - H.R.Li 2009
          d1:= 0.4; d2:= 7;
          iCur:= (iMax-iMin-d1)*exp(1/(1+(d2*iters)/scMaxIters))-iMin;
        end;
      else raise Exception.Create('Error: Unknown inertia mode');
  end;
  Result:= EnsureRange(iCur,iMin,iMax);
end;

function TAdjust.cognitiveFactor(socFactor: double): double;
begin
  Result:= (maxSocial-minSocial) - socFactor;
end;

function TAdjust.GetSocialFactor: double;
begin
  Result:=  psoInf.GetIterations * 2*(1 - factorBalance)
          / psoInf.GetMaxIterations + factorBalance;
  Result:= EnsureRange(Result,minSocial,maxSocial);
end;

procedure TAdjust.CopyFrom(adj: TAdjust);
begin
  psoInf:= adj.psoInf;
  rand:= adj.rand;
  InertiaMode:= adj.InertiaMode;
  defInertia:= adj.defInertia; scaleInertia:= adj.scaleInertia;
  minInertia:= adj.minInertia; maxInertia:= adj.maxInertia;
  factorBalance:= adj.factorBalance;
  minSocial:= adj.minSocial; maxSocial:= adj.maxSocial;
end;

function TAdjust.MyRandom(): double;
begin
  case Rand.mode of
    0: Result:= 1;
    1: Result:=  (random()-0.5) * 2*rand.disp + 1;
    else
      Result:= RandG(1, rand.disp/2);
  end;
  Result:= EnsureRange(Result,0,2); // or maybe not
end;

//^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

constructor TAdjustList.Create(aipso: IPSO);
begin
  inherited Create;
  psoInf:= aipso;
end;

destructor TAdjustList.Destroy;
begin
  inherited;
end;

function TAdjustList.Add(Adjust: TAdjust): integer;
begin
  Result:= inherited Add(Adjust);
end;

function TAdjustList.NewAdjust: integer;
begin
  Result:= Add(TAdjust.Create(psoInf));
end;

end.
