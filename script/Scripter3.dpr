program Scripter3;

{$I Definition.Inc}

uses
  Forms,
  Unit33 in 'Unit33.pas' {Form1};

{$R *.res}

begin
  ReportMemoryLeaksOnShutDown := DebugHook <> 0;

  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
