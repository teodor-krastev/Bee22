program Scripter2;

uses
  Vcl.Forms,
  Scripter2U in 'Scripter2U.pas' {frmScripter};

{$R *.res}

begin
  ReportMemoryLeaksOnShutDown := DebugHook <> 0;

  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmScripter, frmScripter);
  Application.Run;
end.
