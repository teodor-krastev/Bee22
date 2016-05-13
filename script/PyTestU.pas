unit PyTestU;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, PythonU,
  PythonEngine, PythonGUIInputOutput;

type
  TfrmPyTest = class(TForm)
    Splitter1: TSplitter;
    mmScript: TMemo;
    Panel2: TPanel;
    mmOut: TMemo;
    Panel1: TPanel;
    Button1: TButton;
    PythonGUIInputOutput1: TPythonGUIInputOutput;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    py: TPythonPlug;
  end;

var
  frmPyTest: TfrmPyTest;  Opaq: TOpaq;

implementation
{$R *.dfm}

procedure TfrmPyTest.FormCreate(Sender: TObject);
begin
  py:= TPythonPlug.Create(self,'tst');
  py.SetIO(PythonGUIInputOutput1);

  Opaq:= TOpaq.Create(self);
  py.Wrap(opaq,'opaq');
end;

procedure TfrmPyTest.Button1Click(Sender: TObject);
begin
  py.PyEngine.ExecStrings(mmScript.Lines);
end;

end.
