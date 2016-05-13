program ClientBee22;

uses
  Vcl.Forms,
  frmClientBee22U in 'frmClientBee22U.pas' {frmClientBee22},
  Bee22_TLB in 'Bee22_TLB.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmClientBee22, frmClientBee22);
  Application.Run;
end.
