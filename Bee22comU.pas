(************************************************************************)
(*  Bee22 - Particle Swarm Optimization framework     http://bee22.com  *)
(*  developed by and copyright(c) Teodor Krastev 2015-2016              *)
(************************************************************************)
unit Bee22comU;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  System.SysUtils, System.Types, ComObj, ActiveX, AxCtrls, Classes, StdVcl, Bee22_TLB;

type
  TCoBee22 = class(TAutoObject, IConnectionPointContainer, ICoBee22)
  private
    { Private declarations }
    FConnectionPoints: TConnectionPoints;
    FConnectionPoint: TConnectionPoint;
    FEvents: ICoBee22Events;
    { note: FEvents maintains a *single* event sink. For access to more
      than one event sink, use FConnectionPoint.SinkList, and iterate
      through the list of sinks. }

  public
    procedure Initialize; override;
    function FireExtFunc(arrX: TDoubleDynArray): double;
    function FireExtCmd(cmd: string; prm: OleVariant): OleVariant;

  protected
    procedure Config; safecall;  // recreates fmScanPSO (almost everything)
    procedure CloseConnection(Sender: TObject);

    function Eval(const expr: WideString): OleVariant; safecall;
    function Exec(const code: WideString): WordBool; safecall;
    procedure Reset; safecall;
    { Protected declarations }
    property ConnectionPoints: TConnectionPoints read FConnectionPoints
      implements IConnectionPointContainer;
    procedure EventSinkChanged(const EventSink: IUnknown); override;
  end;

implementation
uses Forms, Dialogs, ComServ, System.Variants, PythonEngine, Bee22U, fmScanU,
  UtilsU, frmExtConfigU;

function TCoBee22.FireExtFunc(arrX: TDoubleDynArray): double; // epoch-specific
var VarArray,vr: variant;  i: integer; d: double;
begin
{  d:= 0;
  for i:= 0 to length(arrX)-1 do
    d:= d+arrX[i]*arrX[i];
  Result:= d; exit;  }
  DynArrayToVariant(VarArray,arrX, TypeInfo(TDoubleDynArray));
  vr:= FireExtCmd('fly', VarArray);
  if vr.isArray() then
  begin
    Result:= double(vr[0])+double(vr[1]);
  end
  else Result:= double(vr);
  Application.ProcessMessages;
end;

function TCoBee22.FireExtCmd(cmd: string; prm: OleVariant): OleVariant;  // general
begin
  Result:= FEvents.OnEpoch(cmd,prm); 
end;

procedure TCoBee22.EventSinkChanged(const EventSink: IUnknown);
begin
  FEvents := EventSink as ICoBee22Events;  // if bee22 is a master
  // event is fired when pso.particle needs fitness func calculated from x array
end;

procedure TCoBee22.Initialize;
begin
  inherited Initialize;
  FConnectionPoints := TConnectionPoints.Create(Self);
  if AutoFactory.EventTypeInfo <> nil then
    FConnectionPoint := FConnectionPoints.CreateConnectionPoint(
      AutoFactory.EventIID, ckSingle, EventConnect)
  else FConnectionPoint := nil;
  Bee22U.remoteAccess:= true;
end;

procedure TCoBee22.Reset;
begin
  // recreates fmScanPSO (almost everything)
  frmBee22.fmScanPSO1.Finish;
  frmBee22.fmScanPSO1.Free;
  frmBee22.fmScanPSO1:= TfmScanPSO.Create(frmBee22);
  frmBee22.fmScanPSO1.Name:= 'fmScanPSO1';
  frmBee22.fmScanPSO1.Parent:= frmBee22.Panel3;
  frmBee22.fmScanPSO1.Init(3,'ext');
end;

procedure TCoBee22.Config;
begin
  // default event hooks
  assert(Assigned(frmBee22)); assert(Assigned(frmBee22.fmScanPSO1));
  assert(Assigned(frmBee22.fmScanPSO1.cc)); assert(Assigned(frmExtConfig));
  frmBee22.fmScanPSO1.cc.SetExtFunc(nil);
  frmExtConfig.OnFireExtCmd:= FireExtCmd;
  frmBee22.fmScanPSO1.cc.OnCloseCC:= CloseConnection;
end;

procedure TCoBee22.CloseConnection(Sender: TObject);
var rslt: OleVariant;
begin
  FEvents.OnEpoch('exit',null);
  frmExtConfig.OnFireExtCmd:= nil;         // general
  FConnectionPoint.Free; FConnectionPoints.Free; // EnumConnectionPoints.
  //TEnumConnectionPoints.
end;

function TCoBee22.Eval(const expr: WideString): OleVariant;
var gpy: TPythonEngine;
begin
  if PythonOK then
  begin
    gpy:= GetPythonEngine;
    Result:= OleVariant(gpy.PyObjectAsVariant(gpy.EvalString(AnsiString(expr))));
  end;
end;

function TCoBee22.Exec(const code: WideString): WordBool;
var gpy: TPythonEngine;
begin
  Result:= WordBool(false);
  if PythonOK then
  begin
    gpy:= GetPythonEngine;
    gpy.ExecString(AnsiString(code)); // code format from TStrings.text
    Result:= WordBool(true);
  end;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TCoBee22, Class_CoBee22,
    ciMultiInstance, tmApartment);
end.
