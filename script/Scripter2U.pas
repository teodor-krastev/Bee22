unit Scripter2U;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Buttons, Vcl.ExtCtrls, SynEdit,
  Vcl.Graphics, Vcl.StdCtrls, Vcl.ComCtrls,
  PythonEngine, PythonGUIInputOutput, WrapDelphi, WrapDelphiClasses, Vcl.Grids,
  VCLTee.TeeInspector, W7Classes, W7Buttons, AdvMetroButton, AdvSmoothButton,
  AdvGlassButton, AeroButtons, AdvGlowButton;

type
  TfrmScripter = class(TForm)
    mmOut: TMemo;
    py: TPythonEngine;
    PythonGUIInputOutput1: TPythonGUIInputOutput;
    PyDelphiWrapper1: TPyDelphiWrapper;
    PythonModule: TPythonModule;
    seIn: TSynEdit;
    Splitter1: TSplitter;
    Panel1: TPanel;
    sbExecute: TSpeedButton;
    TeeInspector1: TTeeInspector;
    AdvGlassButton1: TAdvGlassButton;
    AdvGlowButton1: TAdvGlowButton;
    procedure sbExecuteClick(Sender: TObject);
    procedure PyDelphiWrapper1Initialization(Sender: TObject);
    procedure TeeInspector1Items0Change(Sender: TObject);
    procedure Panel1DblClick(Sender: TObject);
    procedure TeeInspector1Items0GetItems(Sender: TInspectorItem;
      Proc: TGetItemProc);
    procedure AdvGlassButton1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure AdvGlassButton1MouseLeave(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  {  Delphi class to be exported using WrapDelphi
     Note the METHODINFO directive for automatically
     exporting methods
  }
  {$METHODINFO ON}
  TPoint = class(TPersistent)
    private
      fx, fy : Integer;
      fName : String;
    public
      procedure OffsetBy( dx, dy : integer );
    published
      property x : integer read fx write fx;
      property y : integer read fy write fy;
      property Name : string read fName write fName;
  end;
  {$METHODINFO OFF}

  // TPyPoint is TPyObject decscendent, more specifically
  // a TPyDelphiPersistent (from WrapDelphi) descendent.
  // It overrides a few key methods Repr, Create and CreateWith
  TPyPoint = class(TPyDelphiPersistent)
    // Constructors & Destructors
    constructor Create( APythonType : TPythonType ); override;
    constructor CreateWith( PythonType : TPythonType; args : PPyObject ); override;
    // Basic services
    function  Repr : PPyObject; override;

    class function  DelphiObjectClass : TClass; override;
  end;

var
  frmScripter: TfrmScripter;

implementation
{$R *.dfm}
// First, we need to initialize the property PyObjectClass with
// the class of our Type object

{ TPoint }

procedure TPoint.OffsetBy(dx, dy: integer);
begin
  Inc(fx, dx);
  Inc(fy, dy);
end;

{ TPyPoint }

// We override the constructors

constructor TPyPoint.Create( APythonType : TPythonType );
begin
  inherited;
  // we need to set DelphiObject property
  DelphiObject := TPoint.Create;
  with TPoint(DelphiObject) do begin
    x := 1;
    y := 3;
  end;
  Owned := True; // We own the objects we create
end;

// Don't call the Create constructor of TPyPoint, because
// we call the inherited constructor CreateWith that calls
// the Create constructor first, and because the constructors
// are virtual, TPyPoint.Create will be automatically be called.

constructor TPyPoint.CreateWith( PythonType : TPythonType; args : PPyObject );
begin
  inherited;
  with GetPythonEngine, DelphiObject as TPoint do
    begin
      if PyArg_ParseTuple( args, 'ii:CreatePoint',@fx, @fy ) = 0 then
        Exit;
    end;
end;

// Then we override the needed services

class function TPyPoint.DelphiObjectClass: TClass;
begin
  Result := TPoint;
end;

function  TPyPoint.Repr : PPyObject;
begin
  with GetPythonEngine, DelphiObject as TPoint do
    Result := VariantAsPyObject(Format('(%d, %d)',[x, y]));
    // or Result := PyString_FromString( PAnsiChar(Format('(%d, %d)',[x, y])) );
end;
////////////////////////////////////////////////////////////////////////////

procedure TfrmScripter.PyDelphiWrapper1Initialization(Sender: TObject);
begin
  PyDelphiWrapper1.RegisterDelphiWrapper(TPyPoint);
end;

procedure TfrmScripter.sbExecuteClick(Sender: TObject);
var
  DelphiPoint : TPoint;
  p : PPyObject;
begin
  // Here's how you can create/read Python vars from Delphi with
  // Delphi/Python objects.
  DelphiPoint := TPoint.Create;

  DelphiPoint.x := 10;
  DelphiPoint.y := 20;

  // DelphiPoint will be owned and eventually destroyed by Python
  p := PyDelphiWrapper1.Wrap(DelphiPoint, soOwned);

  PythonModule.SetVar( 'myPoint', p );

  // Note, that you must not free the delphi point yourself.
  // Instead use the GetPythonEngine.Py_XDECREF(obj) method,
  // because the object may be used by another Python object.
  Py.Py_DecRef(p);

  // Excecute the script
  py.ExecStrings(seIn.Lines);
end;

procedure TfrmScripter.TeeInspector1Items0Change(Sender: TObject);
begin
  showmessage('hhh');
end;

 procedure TfrmScripter.TeeInspector1Items0GetItems(Sender: TInspectorItem;
  Proc: TGetItemProc);
begin
  proc('kkk');
end;

procedure TfrmScripter.AdvGlassButton1MouseLeave(Sender: TObject);
begin
  AdvGlassButton1.BackColor:= clGreen;
end;

procedure TfrmScripter.AdvGlassButton1MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  AdvGlassButton1.BackColor:= clBlue;
end;

procedure TfrmScripter.Panel1DblClick(Sender: TObject);
begin
  TeeInspector1.Items.Add(iiButton,'test',TeeInspector1Items0Change);
end;

end.
