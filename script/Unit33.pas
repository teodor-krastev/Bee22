unit Unit33;

{$I Definition.Inc}

interface

uses
  SysUtils, Classes,
{$IFDEF MSWINDOWS}
  Windows, Messages, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls,
{$ENDIF}
{$IFDEF LINUX}
  QForms, QStdCtrls, QControls, QExtCtrls,
{$ENDIF}
  PythonEngine, PythonGUIInputOutput, WrapDelphi;

type
  TForm1 = class(TForm)
    Splitter1: TSplitter;
    Memo1: TMemo;
    PyEngine: TPythonEngine;
    PythonModule: TPythonModule;
    Panel1: TPanel;
    Button1: TButton;
    PythonGUIInputOutput1: TPythonGUIInputOutput;
    Memo2: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
  public
    PyDelphiWrapper : TPyDelphiWrapper;
  end;

var
  Form1: TForm1;

implementation
{$R *.dfm}

Uses
  TypInfo,
{$IFNDEF FPC}
  ObjAuto,
{$ENDIF}
  Variants, VarPyth, WrapDelphiVCL;

{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
var
  p : PPyObject;
begin
  // Wrap the Form itself.
  p := PyDelphiWrapper.Wrap(Self);
  PythonModule.SetVar( 'MainForm', p );
  PyEngine.Py_DecRef(p);

  // Excecute the script
  PyEngine.ExecStrings( memo1.Lines );
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  PyDelphiWrapper := TPyDelphiWrapper.Create(Self);  // no need to destroy
  PyDelphiWrapper.Engine := PyEngine;
  PyDelphiWrapper.Module := PythonModule;
  PyDelphiWrapper.Initialize;  // Should only be called if PyDelphiWrapper is created at run time
end;

end.
