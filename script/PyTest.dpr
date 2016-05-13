program PyTest;

uses
  Vcl.Forms,
  PyTestU in 'PyTestU.pas' {frmPyTest},
  PythonU in '..\PythonU.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutDown := DebugHook <> 0;

  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmPyTest, frmPyTest);
  Application.Run;
end.
