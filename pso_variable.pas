(************************************************************************)
(*  Based on paspso by Filip Lundeholm 2010                             *)
(*  Developed by and copyright(c) Teodor Krastev 2015-2016              *)
(************************************************************************)
unit pso_variable;

interface
uses Generics.Collections, math, System.Types, SysUtils;
const TRUNCPLUSONE = 1.0; StackDepth = 100;

type
  TWhen2End = class(TList<double>)
    minmax: boolean;
    eps: double;
    sd: integer;
    procedure Init(aminmax: boolean; epsilon: double = 0.00001; StackDepth :integer = 20);
    function Append(d: double): double;
  end;

  TSetValue = procedure(value: double) of object;

  TVariable = class
  private
    FValue: pointer;
    FMin,FMax,FAdjustedMin,FAdjustedMax: double;
    FIsTrunced: boolean;
    fsetValue: TSetValue;

    procedure SetValueDouble(value: double);
    procedure setMin(value: double);
    procedure setMax(value: double);
  public
    property Min:double read FMin write setMin;
    property Max:double read FMax write setMax;
    property AdjustedMin: double read FAdjustedMin;
    property AdjustedMax: double read FAdjustedMax;

    constructor create(var value: PDouble);
    function GetValueDouble: double;

    property setValue : TSetValue read fsetValue write fsetValue;
  end;

  TVariableList =  class(TList<TVariable>)
    procedure AssignFromDDA(src: TDoubleDynArray);
    function AsDoubleDynArray: TDoubleDynArray;
  end;

TWhen2EndList = TList<TWhen2End>;

implementation

constructor TVariable.create(var value: PDouble);
begin
  FValue := value;
  setValue := SetValueDouble;
  Min := -10000;
  Max := 10000;
  FIsTrunced := false;
end;

procedure TVariable.setMin(value: double);
begin
  FMin := value;
  FAdjustedMin := value;
end;

procedure TVariable.setMax(value: double);
begin
  FMax := value;
  FAdjustedMax := value;
  if FIsTrunced then
  FAdjustedMax := value + TRUNCPLUSONE;
end;

function TVariable.GetValueDouble: double;
begin
  Result:= double(FValue^);
end;

procedure TVariable.SetValueDouble(value: double);
begin
  double(FValue^) := value;
end;

procedure TVariableList.AssignFromDDA(src: TDoubleDynArray);
var
  i: integer;
begin
  if Count<>length(src) then //raise Exception.Create('Error: wrong size array');
  begin
    exit;
  end;
  for i:=0 to Count-1 do
    Items[i].SetValue(src[i]);
end;

function TVariableList.AsDoubleDynArray: TDoubleDynArray;
var
  v: TVariable; i: integer;
begin
  SetLength(Result, Count);
  for i:=0 to Count-1 do
    Result[i]:= Items[i].GetValueDouble;
end;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
procedure TWhen2End.Init(aminmax: boolean; epsilon: double; StackDepth: integer);
begin
  minmax:= aminmax;
  eps:= epsilon;
  sd:= StackDepth;
  Clear;
end;

function TWhen2End.Append(d: double): double;
var
  d1,d2: double; i: integer; da: TDoubleDynArray;
begin
  Result:= 1000;
  Add(d);
  if Count<SD then exit;
  while (Count>SD) do Delete(0); // size down

  if minmax then
  begin
    d1:= Math.MaxDouble; d2:= -Math.MaxDouble;
    for i:= 0 to Count-1 do
    begin
      d1:= min(d1,Items[i]);
      d2:= max(d2,Items[i]);
    end;
    Result:= (d2-d1);
  end
  else begin
    SetLength(da,Count);
    for i:= 0 to Count-1 do
      da[i]:= Items[i];
    Result:= Math.StdDev(da);
  end;
end;

end.

