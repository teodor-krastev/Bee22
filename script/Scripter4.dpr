program Scripter4;

uses
  Forms,
  Unit4 in 'Unit4.pas' {Form1};

{$R *.res}

begin
  ReportMemoryLeaksOnShutDown := DebugHook <> 0;

  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
