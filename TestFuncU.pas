(************************************************************************)
(*  Based on paspso by Filip Lundeholm 2010                             *)
(*  Developed by and copyright(c) Teodor Krastev 2015-2016              *)
(************************************************************************)

unit TestFuncU;

interface
uses System.Types, SysUtils, Math, Classes, VCL.Forms;
const lennard_jones: array[0..13] of double =
	(-1, -3, -6, -9.103852, -12.71, -16.505384,-19.821489,-24.113360,-28.422532,
		-32.77,-37.97,-44.33,-47.84,-52.32);
zero = 1.0e-30;
bts: array [0..18] of array [0..1] of double =
		((6, 9),(8, 7),(6, 5),(10, 5),(8, 3),(12, 2),(4, 7),(7, 3),(1, 6),(8, 2),
    (13, 12),(15, 7),(15, 11),(16, 6),(16, 8),(18, 9),(3, 7),(18, 2),(20, 17));

type
  TEvalFunc = function(): double of object;
  TEvaluateFunc = function(arrX: TDoubleDynArray): double of object;
  TQuantum = record
     d: integer;
     q: TDoubleDynArray;
  end;

  TSearchSpace = record
    d, fixD: integer;        // suggested (not actual); fixed dim (only one valid)
	  min, max: TDoubleDynArray;
	  q: TQuantum;         		// Quantisation step size. 0 => continuous problem

                            // TO BE DONE !
	  normalise: boolean ; 		//  recalibrate each vars so min[*]=-100 and max[*]=100

	  quantisation: integer;	// Flag. Set to 1 if quantisation needed
  end;

  TProblem = record
    name: string;
    enabled: boolean;
    epsilon: double; 					// Acceptable error
	  evalMax: integer; 				// Maximum number of fitness evaluations
	  //int function; 						 Function code
	  objective: TDoubleDynArray; 				// Objective value
	  //struct position solution;
	  ss: TSearchSpace;					// Search space
  end;

  ITestFunc = interface
    function Count: integer;
    function GetFuncIdx: integer;
    procedure SetFuncIdx(fi: integer);
    procedure SetRequestExtFunc(ef: boolean);
    function GetProblem: TProblem;
    procedure SetProblem(prob: TProblem);
    procedure SetNoiseLevel(nl: double);
    procedure SetNoiseLinear(nl: double);
    function GetDim: integer;
    procedure SetDim(dm: integer);
    function IsEnabled(d,fi: integer): boolean;
    function GetXaddr(idx: integer): PDouble;
    procedure GetRange(idx: integer; var dMin,dMax: double);
    function GetX(idx: integer): double;
    procedure SetX(idx: integer; value: double);
    function Eval(): double; // using X array (SetX/GetX)
    function Evaluate(arrX: TDoubleDynArray): double;
    function fitnessFunction: TEvalFunc;
  end;

  TTestFunc = class(TComponent, ITestFunc)
    private
      fFuncIdx: integer;
      fx: TDoubleDynArray;
      fOnChange: TNotifyEvent;
      fProblem: TProblem;
      fExtEvaluateFunc: TEvaluateFunc;
    protected
      function GetFuncIdx: integer;
      procedure SetFuncIdx(fi: integer);
      procedure SetDim(dm: integer);
      function GetProblem: TProblem;
      procedure SetProblem(prob: TProblem);
      function GetDefaultProblem: TProblem;
      function GetDim: integer;
      procedure GetRange(idx: integer; var dMin,dMax: double);
      function GetX(idx: integer): double;
      procedure SetX(idx: integer; value: double);
    public
      noiseLevel: double; // L ; default 0 (no noise)
      noiseLinear: double; // 0-100 range ; nL - 0-1
      // if noiseLinear = 0 -> purely additive noise;
      // if noiseLinear > 0 -> proportional to the signal noise [in %]
      RequestExtFunc: boolean;   // external unknown source
      constructor Create(AOwner: TComponent); override;
      function IsEnabled(d,fi: integer): boolean;
      procedure SetRequestExtFunc(ef: boolean);
      procedure SetNoiseLevel(nl: double);
      procedure SetNoiseLinear(nl: double);

{Maurice's test set (Ice Cone)

	0 Parabola (Sphere)
	1 Griewank
	2 Rosenbrock (Banana)
	3 Rastrigin
	4 Tripod (dimension 2)
	5 Ackley
	6 Schwefel
	7 Schwefel 1.2
	8 Schwefel 2.22
	9 Neumaier 3
	10 G3
	11 Network optimisation (Warning: see problemDef() and also perf() for
		problem elements (number of BTS and BSC)
	12 Schwefel
	13 2D Goldstein-Price
	14 Schaffer f6
	15 Step
	16 Schwefel 2.21
	17 Lennard-Jones
	18 Gear train
	19 Sine_sine function
	20 Perm function
	21 Compression Spring
 }
      function Evaluate(arrX: TDoubleDynArray): double;
      function Eval(): double;
      function fitnessFunction: TEvalFunc;
      procedure PbAsList(ls: TStrings);
      function GetXaddr(idx: integer): PDouble;

      function Count: integer;
      property FuncIdx: integer read GetFuncIdx write SetFuncIdx;
      property Problem: TProblem read GetProblem write SetProblem; // default one, set with FuncIdx
      property dim: integer read GetDim write SetDim;  // the actual one
      property ExtEvaluateFunc: TEvaluateFunc read fExtEvaluateFunc write fExtEvaluateFunc;
      property x [idx: integer]: double read GetX write SetX;
      property OnChange: TNotifyEvent read fOnChange write fOnChange;
  end;

  function AssignProblem(src: TProblem): TProblem;

implementation
uses Variants, UtilsU;

constructor TTestFunc.Create(AOwner: TComponent);
begin
  inherited;
  RequestExtFunc:= false;             // defaults
  fProblem.enabled:= true;
  FuncIdx:= 1;
  Dim:= 1;
  noiseLevel:= 0;
  noiseLinear:= 0;
end;

function TTestFunc.Count: integer;
begin
  Result:= 23; //0..22
end;

function TTestFunc.GetFuncIdx: integer;
begin
  Result:= fFuncIdx;
end;

procedure TTestFunc.SetFuncIdx(fi: integer);
begin
  fFuncIdx:= fi;
  fProblem:= AssignProblem(GetDefaultProblem); // default problem setting
end;

function TTestFunc.GetDim: integer;
begin
  result:= length(fx);
end;

procedure TTestFunc.SetDim(dm: integer);
begin
  if not InRange(dm,1,100) then raise Exception.Create('Error: wrong dim value');
  SetLength(fx,dm);
  with fProblem do
  begin
    SetLength(objective,dm);
    SetLength(ss.min,dm); SetLength(ss.max,dm);
    SetLength(ss.q.q,dm);
    ss.q.d:= dm;
  end;
end;

function TTestFunc.IsEnabled(d,fi: integer): boolean;
var pm: TProblem; d0,fi0: integer;
begin
  Result:= false;
  if not InRange(d,1,31) then exit;
  if RequestExtFunc then
  begin
    Result:= true; exit;
  end;
  if not InRange(fi,0,Count-1) then exit;
  d0:= dim; fi0:= FuncIdx; // backup
  FuncIdx:= fi; dim:= d;   // set
  pm:= AssignProblem(GetProblem);
  dim:= d0; FuncIdx:= fi0;           // retreave
  Result:= pm.enabled and ((pm.SS.fixD=-1) or (pm.ss.fixD=d));
end;

procedure TTestFunc.SetRequestExtFunc(ef: boolean);
begin
  RequestExtFunc:= ef;
end;

procedure TTestFunc.SetNoiseLevel(nl: double);
begin
  noiseLevel:= nl;
end;

procedure TTestFunc.SetNoiseLinear(nl: double);
begin
  noiseLinear:= EnsureRange(nl,0,1000);
end;

procedure TTestFunc.PbAsList(ls: TStrings);
var pm: TProblem;
begin
  if ls=nil then exit;
  dim:= 1; pm:= AssignProblem(GetProblem); ls.Clear;
  with ls,pm do
  begin
    Add('epsilon*='+FloatToStr(epsilon));
    Add('evalMax*='+IntToStr(evalMax));
    Add('objective='+FloatToStr(objective[0]));
    Add('ss.d='+IntToStr(ss.d));
    Add('ss.min='+FloatToStr(ss.min[0]));
    Add('ss.max='+FloatToStr(ss.max[0]));
  end;
end;

function TTestFunc.GetProblem: TProblem;
begin
  Result:= AssignProblem(fProblem);
end;

procedure TTestFunc.SetProblem(prob: TProblem);
begin
  fProblem:= AssignProblem(prob);
end;

function TTestFunc.GetDefaultProblem: TProblem;
var d, btsNb,bcsNb, nAtoms: integer;
begin
with fProblem do
begin
	// Default values, can be modified below for each function
  enabled:= true;
	epsilon := 0.0;    	  // Acceptable error (default). May be modified below
	FillArrayWith(objective, 0);  // Objective value (default). May be modified below
  evalMax := 1000;      // Max number of evaluations for each run
  SS.fixD := -1;
	SS.quantisation := 0;	// No quantisation needed (all variables are continuous
	SS.normalise := false;    // No normalisation needed (same range for all variables)
  if RequestExtFunc then
  begin
    name:= 'External';
    SS.d:= 5;
    for d:= 0 to dim-1 do
      begin
			  SS.q.q[d] := 0;	// Relative quantisation, in [0,1].
        ss.min[d]:= -100;
        ss.max[d]:= 100;
      end;
  end
  else
  case FuncIdx of
  -1:begin
       name:= 'orig. psopas';
       SS.d := 1;
       SS.fixD := 1;
    	 SS.min[0] := -1000; // -100
			 SS.max[0] := 1000;	// 100
			 SS.q.q[0] := 0;	// Relative quantisation, in [0,1].
       evalMax := 10000;
       epsilon := 0.001;
     end;
  0:begin
      name:= 'Parabola';
      SS.d:= 1;
      SS.fixD:= -1;
    	for d:= 0 to dim-1 do
      begin
    		SS.min[d] := -100; // -100
			  SS.max[d] := 100;	// 100
			  SS.q.q[d] := 0;	// Relative quantisation, in [0,1].
      end;
      evalMax := 1000;
      epsilon := 0.00003;
    end;
  1:begin
      name:= 'Griewank';
      SS.d:= 2; //30;
      for d:= 0 to dim-1 do  // Boundaries
      begin
        SS.min[d] := -600;
			  SS.max[d] := 600;
			  SS.q.q[d] := 0;
      end;
      evalMax := 2000;
      epsilon := 0.001;
    end;
  2:begin
      name:= 'Rosenbrock';
      SS.d:= 2; // 30
      for d:= 0 to dim-1 do  // Boundaries
      begin
			  SS.min[d] := -100; // -30;
			  SS.max[d] := 100; // 30;
			  SS.q.q[d] := 0;
      end;
		evalMax := 4000; //2.e6;  // 40000
		epsilon := 0.001;
    end;
  3:begin
      name:= 'Rastrigin';
      SS.d:= 2; // 10;
      for d:= 0 to dim-1 do  // Boundaries
      begin
			  SS.min[d] := -5.12; // -30;
			  SS.max[d] := 5.12; // 30;
			  SS.q.q[d] := 0;
      end;
		  evalMax := 2000;
  		epsilon := 0.00001;
    end;
  4:begin  //  2-dim
      name:= 'Tripod';
      SS.fixD:= 2;
      SS.d:= 2; // 10;
      for d:= 0 to dim-1 do  // Boundaries
      begin
			  SS.min[d] := -100;
			  SS.max[d] := 100;
			  SS.q.q[d] := 0;
      end;
      if dim>1 then objective[1] := -50;
		  evalMax := 1000;
		  epsilon := 0.01;
    end;
  5:begin //  2-dim
      name:= 'Ackley';
      SS.D:= 2;
      SS.fixD:= 2;
      for d:= 0 to dim-1 do  // Boundaries
      begin
			  SS.min[d] := -32;
			  SS.max[d] := 32;
			  SS.q.q[d] := 0;
      end;
		  epsilon := 0.0001;
		  evalMax := 1000;
    end;
  6:begin // . Min on (A=420.8687, ..., A)  30-dim
      name:= 'Schwefel 7';
      SS.d:= 30;
      for d:= 0 to dim-1 do  // Boundaries
      begin
        objective[d] := 420.97;
			  SS.min[d] := -500;
			  SS.max[d] := 500;
			  SS.q.q[d] := 0;
      end;
		   //-12569.5;?
		  epsilon:= 0.05; //2569.5; ?
 		  evalMax:= 300;
    end;
   7:begin
      name:= 'Schwefel 1.2';
      SS.d:= 40;
      for d:= 0 to dim-1 do  // Boundaries
      begin
			  SS.min[d] := -100;
			  SS.max[d] := 100;
			  SS.q.q[d] := 0;
      end;
		  epsilon := 0.001;
		  evalMax := 400;
    end;
   8:begin
      name:= 'Schwefel 2.22';
      SS.D:= 30;
      for d:= 0 to dim-1 do  // Boundaries
      begin
			  SS.min[d] := -10;
			  SS.max[d] := 10;
			  SS.q.q[d] := 0;
      end;
		  epsilon := 0.0001;
		  evalMax:= 1000;
    end;
   9:begin
      name:= 'Neumaier 3';
      SS.d:= 40;
      for d:= 0 to dim-1 do  // Boundaries
      begin
        objective[d] := 0.66667;
			  SS.min[d] := -dim*dim;
			  SS.max[d] := -SS.min[d];
			  SS.q.q[d] := 0;
      end;
		  epsilon := 3.e-4;
		  evalMax := 400;
    end;
  10:begin
       name:= 'G3 (constrained)';
       SS.d:= 10;
       for d:= 0 to dim-1 do  // Boundaries
       begin
         objective[d] := 0.7227;
			   SS.min[d] := 0;
			   SS.max[d] := 1;
			   SS.q.q[d] := 0;
       end;
       if dim>1 then objective[1] := 0.6911;
		   evalMax:= 400;
       epsilon:= 0.02;
       SS.quantisation:= 1;
      end;
   11:begin enabled:= false;
        name:= 'Network';
		    btsNb:= 19; bcsNb:= 2;
		    SS.d:= bcsNb*btsNb+2*bcsNb;
{        for d:= 0 to bcsNb*btsNb-1 do  //Binary representation. 1 means: there is a link
        begin
			    SS.min[d] := 0;
			    SS.max[d] := 1;
			    SS.q.q[d] := 1;
        end;
        SS.quantisation:= 1;
        for d:= bcsNb*btsNb to dim-1 do  // 2D space for the BSC positions
        begin
			    SS.min[d] := 0;
			    SS.max[d] := 25;
			    SS.q.q[d] := 0;
        end;
        SS.normalise:= 1;}
		    epsilon := 0.0001;
		    evalMax := 5000;
      end;
   12:begin
        Enabled:= false; // duplicates s.7
        name:= 'Schwefel';
        SS.d:= 30;
        for d:= 0 to dim-1 do  // Boundaries
        begin
          objective[d] := 420.97;
			    SS.min[d] := -500;
			    SS.max[d] := 500;
			    SS.q.q[d] := 0;
        end;
		    epsilon := 0.001;
		    evalMax := 600;
      end;
   13:begin // 2D Goldstein-Price function (f_min=3, on (0,-1))
        name:= 'Goldstein-Price';
        SS.D:= 2;
        SS.fixD:= 2;
        if dim>1 then objective[1] := -1;
        for d:= 0 to dim-1 do  // Boundaries
        begin
			    SS.min[d] := -100;
			    SS.max[d] := 100;
			    SS.q.q[d] := 0;
        end;
		    epsilon := 0.003;
		    evalMax := 1000;
      end;
   14:begin
        name:= 'Schwefel f6';
        SS.D:= 2;
        SS.fixD:= 2;
        for d:= 0 to dim-1 do  // Boundaries
        begin
			    SS.min[d] := -100;
			    SS.max[d] := 100;
			    SS.q.q[d] := 0;
        end;
		    epsilon := 0.002;
  		  evalMax := 300;
      end;
   15:begin
        name:= 'Step';
        SS.d:= 10;
        for d:= 0 to dim-1 do  // Boundaries
        begin
			    SS.min[d] := -100;
			    SS.max[d] := 100;
			    SS.q.q[d] := 0;
        end;
		    epsilon := 0.6;
		    evalMax := 500;
      end;
   16:begin
        name:= 'Schwefel 2.21';
        SS.d:= 30;
        for d:= 0 to dim-1 do  // Boundaries
        begin
			    SS.min[d] := -100;
			    SS.max[d] := 100;
			    SS.q.q[d] := 0;
        end;
		    epsilon := 0.001;
		    evalMax := 1000;
      end;
   17:begin enabled:= false;
        name:= 'Lennard-Jones';
			  nAtoms:= 6; // in {2, ..., 15}
		    SS.d:= 3*nAtoms;
        for d:= 0 to dim-1 do  // Boundaries
        begin
		      objective[d] := lennard_jones[nAtoms-2];
			    SS.min[d] := -2;
			    SS.max[d] := 2;
			    SS.q.q[d] := 0;
        end;
		    epsilon:= 1e-3;
		    evalMax:= 5000+3000*nAtoms*(nAtoms-1) ; // Empirical rule
      end;
   18:begin
        name:= 'Gear train';
			  // solution (16,19,43,49) and equivalent ones (like (19,16,49,43)
			  // Success rate 9% is reasonable
        SS.d:= 4;
        SS.fixD:= 4;
        for d:= 0 to dim-1 do  // Boundaries
        begin
		      objective[d] := 2.7e-12;
			    SS.min[d] := 12;
			    SS.max[d] := 60;
			    SS.q.q[d] := 1;
        end;
		    SS.quantisation:= 1;
		    epsilon:= 1.e-13;
		    evalMax := 2000;
      end;
   19:begin
        name:= 'Sine-sine';
        SS.d:= 2;
        for d:= 0 to dim-1 do  // Boundaries
          begin
		        objective[d] := 2.2029;
			      SS.min[d] := 0;
			      SS.max[d] := pi;
			      SS.q.q[d] := 0;
          end;
        if dim=2 then objective[1] := 1.5708;
		    epsilon := 0.01;
		    evalMax := 600;
      end;
   20:begin
        //enabled:= false;
        name:= 'Perm';
        SS.d:= 5;
        objective[0]:= 1.17;
        if dim>1 then objective[1]:= 1.68;
        for d:= 0 to dim-1 do  // Boundaries
        begin
			    SS.min[d] := -dim;
			    SS.max[d] := dim;
			    SS.q.q[d] := 0;
        end;
        SS.quantisation :=1;
		    epsilon := 0.2;
		    evalMax := 1000;
      end;
   21:begin // Coil compression spring  (penalty method)
			      // Ref New Optim. Tech. in Eng. p 644
        enabled:= false;
        name:= 'Coil compression spring';
        SS.d:= 3;
        SS.fixD:= 3;
        SetLength(SS.min,3); SetLength(SS.max,3);
        SetLength(SS.q.q,3);
		    SS.min[0]:= 1; SS.max[0]:= 70; SS.q.q[0]:= 1;
		    SS.min[1]:= 0.6; SS.max[1]:= 3; SS.q.q[1]:= 0;
        SS.min[2]:= 0.207; SS.max[2]:= 0.5; SS.q.q[2]:= 0.001;
		    SS.quantisation:= 1;
		    //SS.normalise:= 1; ?
		    evalMax:= 2000 ;
		    epsilon:= 1.e-3;		    FillArrayWith(objective, 2.6254214578);
      end;
   22:begin
        name:= 'sine Peak';
        SS.D:= 1;
        SS.fixD:= 1;
        for d:= 0 to dim-1 do  // Boundaries
        begin
          objective[d] := 0.052448;
			    SS.min[d] := -2;
			    SS.max[d] := 2;
			    SS.q.q[d] := 0;
        end;
		    epsilon := 0.001;
  		  evalMax := 300;
      end;
  end;
end;
  result:= AssignProblem(fProblem);
end; // GetProblem
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

procedure TTestFunc.GetRange(idx: integer; var dMin,dMax: double);
begin
  if not InRange(idx, 0, dim-1) then raise Exception.Create('Error in index');
  dMin:= Problem.ss.min[idx]; dMax:= Problem.ss.max[idx];
end;

function TTestFunc.GetX(idx: integer): double;
begin
  if not InRange(idx, 0, dim-1) then raise Exception.Create('Error in index');
  Result:= fx[idx];
end;

procedure TTestFunc.SetX(idx: integer; value: double);
begin
  if not InRange(idx, 0, dim-1) then raise Exception.Create('Error in index');
  fx[idx]:= value;
  if Assigned(fOnChange) then OnChange(self);
end;

function TTestFunc.GetXaddr(idx: integer): PDouble;
begin
  if not InRange(idx, 0, dim-1) then raise Exception.Create('Error in index');
  Result:= @fx[idx];
end;

function TTestFunc.Evaluate(arrX: TDoubleDynArray): double;
var i: integer;
begin
  if length(fx)<>length(arrX) then raise Exception.Create('Evaluate: Wrong array size');
  for i:= 0 to dim-1 do fx[i]:= arrX[i];
  Result:= Eval;
end;

function TTestFunc.Eval(): double;
var
  i,j,d,k,btsNb,bcsNb,n: integer; a,p,f,xd,min,t0,t1,tt, sum1,sum2: double;
  x0,x1,x2,x3,c,s11,s12,s21,s22, btsPenalty,z1,z2, beta, nl, t2,t3: double;
  VarArray: variant;
begin
btsPenalty:= 100;
if RequestExtFunc then
  begin
    if Assigned(ExtEvaluateFunc) then Result:= -ExtEvaluateFunc(fx)
                                 else Result:= NaN;
    exit;
  end
  else
  case FuncIdx of
 -1:begin
     f:= 42 * power(x[0],4) - 33 * power(x[0],3) - 157 * power(x[0],2) + 22 * x[0] + 60;
    end;
  0:begin // Parabola (Sphere) - for multiobjective test
	    f:= 0;
	    for d:= 0 to dim-1 do
        f:= f+x[d]*x[d];
    end;
  1:begin // Griewank
	    f:= 0;
	    p:= 1; // shift
	    for d:= 0 to dim-1 do
	    begin
		    xd:= x[d];
		    f:= f+xd*xd;
		    p:= p*cos(xd/sqrt(d+1));
      end;
	    f:= f/4000 - p + 1;
    end;
  2:begin // Rosenbrock
  	  f:= 0;
      t0:= x[0]  + 1;	// Solution on (0,...0) when
			// offset=0
	    for d:= 0 to dim-1 do
      begin
			  t1 := x[d]  + 1;
			  tt := 1 - t0;
			  f := f + tt * tt;
			  tt := t1 - t0 * t0;
			  f := f+ 100 * tt * tt;
			  t0 := t1;
      end;
    end;
  3:begin  // Rastrigin
	  	k := 10;
      f := 0;
	    for d:= 0 to dim-1 do
      begin
        xd := x[d];
        f := f+ xd * xd - k * cos (2 * pi * xd);
      end;
		  f := f+ dim * k;
    end;
  4:begin // 2D Tripod function
				// Note that there is a big discontinuity right on the solution
				// point.
      x1:= x[0] ;
			x2:= x[1];
			s11:= (1.0 - sign (x1)) / 2;
			s12:= (1.0 + sign (x1)) / 2;
			s21:= (1.0 - sign (x2)) / 2;
			s22:= (1.0 + sign (x2)) / 2;

			//f = s21 * (fabs (x1) - x2); // Solution on (0,0)
			f:= s21 * (abs (x1) +abs(x2+50)); // Solution on (0,-50)
			f:= f + s22 * (s11 * (1 + abs (x1 + 50) +
          abs (x2 - 50)) + s12 * (2 +
			    abs (x1 - 50) + abs (x2 - 50)));
    end;
  5:begin // Ackley
      sum1:= 0;
			sum2:= 0;

	    for d:= 0 to dim-1 do
      begin
			  xd:= x[d];
			  sum1:= sum1+xd*xd;
        sum2:= sum2+cos(2*pi*xd);
      end;
			f:= -20*exp(-0.2*sqrt(sum1/dim))-exp(sum2/dim)+20+exp(1);
    end;
  6:begin // Schwefel 7
      f:= 0;
	    for d:= 0 to dim-1 do
      begin
        xd := x[d];
        f:= f-xd*sin(sqrt(abs(xd)));
      end;
    end;
  7:begin // Schwefel 1.2
      f:= 0;
	    for d:= 0 to dim-1 do
      begin
       	xd := x[d];
			  sum1:= 0;
			  for k:=0 to d do sum1:= sum1+xd;
			  f:= f+sum1*sum1;
      end;
    end;
  8:begin // Schwefel 2.22
      sum1:= 0; sum2:= 1;
	    for d:= 0 to dim-1 do
      begin
        xd:= abs(x[d]);
			  sum1:= sum1+xd;
			  sum2:= sum2*xd;
      end;
      f:= sum1+sum2;
    end;
  9:begin // Neumaier 3
      sum1:= 0; sum2:= 1;
	    for d:= 0 to dim-1 do
      begin
        xd:= x[d]-1;
			  sum1:= sum1+xd*xd;
      end;
      for d:= 1 to dim-1 do
        sum2:= sum2+ x[d]* x[d-1];
      f:= sum1+sum2;
    end;
 10:begin // G3 (constrained)
      sum1:= 0; f:= 1;
	    for d:= 0 to dim-1 do
      begin
        xd:= x[d];
			  f:= f*xd;
			  sum1:= sum1+xd*xd;
      end;
      f:= abs(1-power(dim,dim/2)*f) + dim*abs(sum1-1);
    end;
 11:begin // Network  btsNb BTS, bcdNb BSC
			f:= 0;
			// Constraint: each BTS has one link to one BSC
	    for d:= 0 to bcsNb-1 do
      begin
			  sum1:= 0;
        for k:=0 to bcsNb-1 do
          sum1:= sum1+x[d+k*btsNb];
			  if (sum1<1-zero) or (sum1>1+zero) then
          f:= f+btsPenalty;
      end;
			// Distances
	    for d:= 0 to bcsNb-1 do //For each BCS d
			  for k:=0 to bcsNb-1 do // For each BTS k
          begin
 				    if(x[k+d*btsNb]<1) then continue;
				    // There is a link between BTS k and BCS d
				    n:= bcsNb*btsNb+2*d;
				    z1:= bts[k][0]-x[n];
				    z2:= bts[k][1]-x[n+1];
				    f:= f+sqrt(z1*z1+z2*z2);
          end;
    end;
 12:begin // Schwefel
      f:= 0;
	    for d:= 0 to dim-1 do
      begin
        xd:= x[d];
			  f:= f-xd*sin(sqrt(abs(xd)));
   //   f:= f-xd*sin(sqrt(abs(xd)));   Schwefel.7
      end;
    end;
 13:begin // 2D Goldstein-Price function
			x1:= x[0]; x2:= x[1];
      f:= (1 + power(x1 + x2 + 1, 2) *
          (19-14 *x1 + 3*x1*x1-14* x2 + 6* x1* x2 + 3*x2*x2 ))
				* (30 + power(2* x1 - 3*x2 ,2)*
				  (18 -32 *x1 + 12 *x1*x1 + 48* x2 - 36* x1 *x2 + 27* x2*x2 ));
    end;
 14:begin  //Schaffer F6
      x1:= x[0]; x2:= x[1];
			f:= 0.5 + (power(sin(sqrt(x1*x1 + x2*x2)),2) - 0.5)/
                 power(1.0 + 0.001*(x1*x1 + x2*x2),2);
    end;
 15:begin //Step
   		f:= 0;
	    for d:= 0 to dim-1 do
      begin
			  xd:= round(x[d]+0.5);
			  f:= f+xd*xd;
      end;
    end;
  16:begin // Schwefel 2.21
 			 f:= 0;
	     for d:= 0 to dim-1 do
       begin
  		   xd:= abs(x[d]);
	  		 if(xd>f) then f:= xd;
       end;
     end;
  //17:f=lennard_jones(x);
  18:begin //Gear train
       if IsZero(x[2]*x[3],epsilon3) then raise Exception.Create('Division to zero.');
		   f:= power(1./6.931 -x[0]*x[1]/(x[2]*x[3]),2);
     end;

  19:begin //Sine-sine function
		   f:= 0;
       for d:= 0 to dim-1 do
       begin
	  	   xd:= x[d];
         p:= power(sin((d+1)*xd*xd/pi),20);
			   f:= f-sin(xd)*p;
       end;
     end;
  20:begin // Perm function
       beta:= 10;
	     f:= 0;
       for k:= 1 to dim do
	     begin
         sum1:= 0;
         for d:= 0 to dim-1 do
         begin
           xd:= x[d];
           sum1:= sum1 + (power(d+1,k)+beta) * (power(xd/(d+1),k)-1);
         end;
		   sum1:= sum1*sum1;
	     f:= f+sum1;
       end;
     end;
  21:begin  // Coil compression spring  (penalty method)
		      	// Ref New Optim. Tech. in Eng. p 644
       x1:= x[0]; // {1,2, ... 70}
		   x2:= x[1];//[0.6, 3]
		   x3:= x[2];// relaxed form [0.207,0.5]  dx=0.001
		   // In the original problem, it is a list of
		   // acceptable values
		   // {0.207,0.225,0.244,0.263,0.283,0.307,0.331,0.362,0.394,0.4375,0.5}
		   f:= pi*pi*x2*x3*x3*(x1+2)*0.25;
		   // Constraints
		   (*ff:= constraint(xs,function,0);

			 if (ff.f[1]>0) then
       begin
         c:= 1+ff.f[1]; f:= f*c*c*c;
       end;
			 if (ff.f[2]>0) then
       begin
         c:= 1+ff.f[1]; f:= f*c*c*c;
       end;
			 if (ff.f[3]>0) then
       begin
         c:= 1+ff.f[3]; f:= f*c*c*c;
       end;
			 if (ff.f[4]>0) then
       begin
         c:= 1+power(10,10)*ff.f[4]; f:= f*c*c*c;
       end;
			 if (ff.f[5]>0) then
       begin
         c:= 1+power(10,10)*ff.f[5]; f:= f*c*c*c;
       end; *)
     end;
  22:begin // sine.Peak
       a:= 1.5;
       f:= -(sin(100/(abs(x[0])+a))/(abs(x[0])+a)+0.1*x[0]);
     end;
end;
  if isZero(noiseLevel,epsilon3) then a:= 0
   else a:= randG(0,noiseLevel);
  if isZero(noiseLinear,epsilon3) then p:= 0
   else p:= (-f) * randG(0,noiseLinear/100);
  Result:= (-f) + a + p;
  // noiseLevel = 0 -> no additive noise
  // if noiseLinear = 0 -> purely additive noise;
  // if noiseLinear > 0 -> proportional to the signal noise [in %]
end; // function definitions
//####################################################################

function TTestFunc.fitnessFunction: TEvalFunc;
begin
  Result:= Eval;
end;

function AssignProblem(src: TProblem): TProblem;
begin
  with Result do
  begin
    name:= src.name;
    enabled:= src.enabled;
    epsilon:= src.epsilon;
    evalMax:= src.evalMax;
    objective:= src.objective;
    ss.d:= src.ss.d;
    ss.fixD:= src.ss.fixD;
    ss.min:= src.ss.min;
    ss.max:= src.ss.max;
    ss.normalise:= src.ss.normalise;
    ss.quantisation:= src.ss.quantisation;
    ss.q.d:= src.ss.q.d;
    ss.q.q:= src.ss.q.q;
  end;
end;

end.
