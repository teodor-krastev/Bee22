unit ScripterU;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, SynEdit, Vcl.Buttons,
  Vcl.StdCtrls, Vcl.ExtCtrls, PythonEngine, PythonGUIInputOutput,
  WrapDelphi;

type

  TfrmScripter = class(TForm)
    Panel1: TPanel;
    Splitter1: TSplitter;
    mmOut: TMemo;
    sbExecute: TSpeedButton;
    seIn: TSynEdit;
    py: TPythonEngine;
    PythonGUIInputOutput1: TPythonGUIInputOutput;
    PythonModule: TPythonModule;
    PyDelphiWrapper1: TPyDelphiWrapper;
    procedure sbExecuteClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmScripter: TfrmScripter;

implementation

{$R *.dfm}

//////////////////////////////////////////////////////////////////////////
// Using TPyDelphiObject you can wrap any Delphi object exposing published
// properties and methods.  Note that the conditional defines TYPEINFO and
// METHODINFO need to be on
//////////////////////////////////////////////////////////////////////////

{$TYPEINFO OFF}
{$IFNDEF FPC}{$METHODINFO OFF}{$ENDIF}
Type
TTestBase = class
  fdouble : double;
  function DoubleDValue : double;   // not visible in subclasses
published
  property DValue : Double read fdouble write fdouble;  // will be visible in subclasses
end;

function TTestBase.DoubleDValue : double;
begin
  Result := 2 * fdouble;
end;

type
{$TYPEINFO ON}
{$IFNDEF FPC}{$METHODINFO ON}{$ENDIF}
TTestClass = class(TTestBase, IFreeNotification, IInterface)
private
  fSValue : string;
  fIValue : integer;
  fSL : TStrings;
  fOnChange: TNotifyEvent;
  fFreeNotifImpl : IFreeNotification;
  // implementation of interface IUnknown
  function QueryInterface(const IID: TGUID; out Obj): HResult; stdcall;
  function _AddRef: Integer; stdcall;
  function _Release: Integer; stdcall;
protected
  property FreeNotifImpl : IFreeNotification read fFreeNotifImpl implements IFreeNotification;
public
  constructor Create;
  destructor Destroy; override;
  procedure SetMeUp(S: string; I : Integer);
  procedure TriggerChange;
published
  function DescribeMe(): string;
  property SL : TStrings read fSL;
  property SValue : string read fSValue write fSValue;
  property IValue : integer read fIValue write fIValue;
  property OnChange : TNotifyEvent read fOnChange write fOnChange;
end;
{$TYPEINFO OFF}
{$IFNDEF FPC}{$METHODINFO OFF}{$ENDIF}

constructor TTestClass.Create;
begin
  inherited;
  fFreeNotifImpl := TFreeNotificationImpl.Create(Self);
  fSL := TStringList.Create;
  //fSL.AddObject('Form1', Form1);
  //fSL.AddObject('Form1.Button1', Form1.Button1);
end;

destructor TTestClass.Destroy;
begin
  fSL.Free;
  inherited;
end;

procedure TTestClass.SetMeUp(S: string; I : Integer);
begin
  SValue := S;
  IValue := I;
end;

function TTestClass.Describeme() : string;
begin
  Result := fSValue + ' : ' + IntToStr(IValue);
end;

procedure TTestClass.TriggerChange;
begin
  if Assigned(fOnChange) then
    fOnChange(Self);
end;

function TTestClass._AddRef: Integer;
begin
  Result := -1; // we don't want reference counting
end;

function TTestClass._Release: Integer;
begin
  Result := -1; // we don't want reference counting
end;

function TTestClass.QueryInterface(const IID: TGUID; out Obj): HResult;
begin
  if GetInterface(IID, Obj) then
    Result := 0
  else
    Result := E_NOINTERFACE;
end;
//////////////////////////////////////////////////////////////////////////

procedure TfrmScripter.sbExecuteClick(Sender: TObject);
var   p : PPyObject;
begin
  //  Now wrap the an instance our TestClass
  //  This time we would like the object to be destroyed when the PyObject
  //  is destroyed, so we need to set its Owned property to True;
  p := PyDelphiWrapper1.Wrap(TTestClass.Create, soOwned);
  PythonModule.SetVar( 'DVar', p );
  Py.Py_DecRef(p);

  py.ExecStrings(seIn.Lines);
end;

end.
