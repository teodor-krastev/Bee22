unit Unit4;

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
 {$METHODINFO ON}
  TOpaq = class(TComponent)
  published
    procedure doSt(txt: string);
  end;
 {$METHODINFO OFF}

  TForm1 = class(TForm)
    Splitter1: TSplitter;
    Memo1: TMemo;
    Panel1: TPanel;
    Button1: TButton;
    PythonGUIInputOutput1: TPythonGUIInputOutput;
    Memo2: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
  public
    PyEngine: TPythonEngine;
    PythonModule: TPythonModule;
    PyDelphiWrapper : TPyDelphiWrapper;
    Opaq: TOpaq;
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
  Variants, VarPyth, WrapDelphiClasses;

{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
var
  p : PPyObject;
begin
  Opaq:= TOpaq.Create(self);
  // Wrap the Form itself.
  p := PyDelphiWrapper.Wrap(Opaq);
  PythonModule.SetVar( 'MainForm', p );
  PyEngine.Py_DecRef(p);

  // Excecute the script
  PyEngine.ExecStrings( memo1.Lines );
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  if PythonOK then PyEngine:= GetPythonEngine  // support more than one ctrlCenter
    else begin
      PyEngine:= TPythonEngine.Create(self);
      PyEngine.AutoFinalize:= true;
      PyEngine.LoadDll;
    end;

  PythonModule:= TPythonModule.Create(PyEngine);
  PythonModule.Engine:= PyEngine;
  PythonModule.ModuleName:= 'spam';
  PythonModule.Initialize;

  PyDelphiWrapper := TPyDelphiWrapper.Create(Self);  // no need to destroy
  PyDelphiWrapper.Engine := PyEngine;
  PyDelphiWrapper.Module := PythonModule;
  PyDelphiWrapper.Initialize;  // Should only be called if PyDelphiWrapper is created at run time
end;

procedure TOpaq.doSt(txt: string);
begin
  ShowMessage('hey it works '+txt);
end;

end.
