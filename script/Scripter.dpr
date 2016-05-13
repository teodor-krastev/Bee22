program Scripter;

uses
  Vcl.Forms,
  ScripterU in 'ScripterU.pas' {frmScripter};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmScripter, frmScripter);
  Application.Run;
end.
