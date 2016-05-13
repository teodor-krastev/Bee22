unit OptimRsltU;

interface

uses Types, Math, UtilsU;

const
  Epsilon = 1E-6;

type
  rOptimRslt = record
    Vars: TDoubleDynArray;
    BestFit, SwarmSize, IterCount, IterDisp: double;
    TimePass: integer;
    TermCond: string;
  end;

  TOptimRslt = class
  private
    fxCount, fyCount: integer; // x- slow; y- fast; one-dim xCount=1
    fData: array of array of rOptimRslt;
    function IndexOf(a: double; iArr: TDoubleDynArray): integer;

    function GetData(iX, iY: integer): rOptimRslt;
    procedure SetData(iX, iY: integer; oRslt: rOptimRslt);
    function GetByFloat(iX, iY: double): rOptimRslt;
    procedure SetByFloat(iX, iY: double; oRslt: rOptimRslt);
  public
    xIdx, yIdx: TDoubleDynArray;
    constructor Create(iX, iY: integer); overload;
    // set xIdx, yIdx values afterwards
    constructor Create(xFrom, xTo, xBy, yFrom, yTo, yBy: double); overload;
    constructor Create(yFrom, yTo, yBy: double); overload;

    property xCount: integer read fxCount; // 1 if one-dim case
    property yCount: integer read fyCount;
    property Data[iX, iY: integer]: rOptimRslt read GetData
      write SetData; default;
    property byFloat[iX, iY: double]: rOptimRslt read GetByFloat
      write SetByFloat;
  end;

implementation

constructor TOptimRslt.Create(iX, iY: integer); // set xIdx, yIdx afterwards
begin
  inherited Create;
  fxCount := iX;
  fyCount := iY;
  SetLength(xIdx, xCount);
  SetLength(yIdx, yCount);
  SetLength(fData, xCount, yCount);
end;

constructor TOptimRslt.Create(xFrom, xTo, xBy, yFrom, yTo, yBy: double);
var
  x, y: double; iX, iY: integer;
begin
  inherited Create;

  x := xFrom;
  iX := 0;
  while x <= (xTo + Epsilon) do
  begin
    inc(iX);
    SetLength(xIdx, iX);
    xIdx[iX - 1] := x;
    x := +xBy;
  end;
  fxCount := iX;

  y := yFrom;
  iY := 0;
  while y <= (yTo + Epsilon) do
  begin
    inc(iY);
    SetLength(yIdx, iY);
    yIdx[iY - 1] := y;
    y := y + yBy;
  end;
  fyCount := iY;

  SetLength(fData, xCount, yCount);
end;

constructor TOptimRslt.Create(yFrom, yTo, yBy: double);
var
  y: double; iY: integer;
begin
  inherited Create;

  SetLength(fData, 1);
  fxCount := 1; SetLength(xIdx, 0);
  y := yFrom; iY := 0;
  while y <= (yTo + smallDouble) do
  begin
    inc(iY);
    SetLength(yIdx, iY);
    yIdx[iY - 1] := y;
    y := y + yBy;
  end;
  fyCount := iY;
  SetLength(fData[0], fyCount);
end;

function TOptimRslt.IndexOf(a: double; iArr: TDoubleDynArray): integer;
var
  i: integer; d: double;
begin
  Result := -1;
  for d in iArr do
    if SameValue(d, a, Epsilon) then break
    else inc(Result);
end;

function TOptimRslt.GetData(iX, iY: integer): rOptimRslt;
begin
  Result := fData[iX, iY];
end;

procedure TOptimRslt.SetData(iX, iY: integer; oRslt: rOptimRslt);
begin
  fData[iX, iY] := oRslt;
end;

function TOptimRslt.GetByFloat(iX, iY: double): rOptimRslt;
var
  i, j: integer;
begin
  if xCount = 1 then i := 0
  else i := IndexOf(iX, xIdx);
  j := IndexOf(iY, yIdx);
  if (i = -1) or (j = -1) then exit;
  Result := fData[i, j];
end;

procedure TOptimRslt.SetByFloat(iX, iY: double; oRslt: rOptimRslt);
var
  i, j: integer;
begin
  if xCount = 1 then i := 0
  else i := IndexOf(iX, xIdx);
  j := IndexOf(iY, yIdx);
  if (i = -1) or (j = -1) then
    exit;
  fData[i, j] := oRslt;
end;

end.
