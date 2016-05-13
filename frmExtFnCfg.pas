unit frmExtFnCfg;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics,  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, MVC_U, Vcl.StdCtrls,
  Vcl.ExtCtrls;

type
  TfrmExtFnConfig = class(TForm)
    Panel2: TPanel;
    OKBtn: TButton;
    CancelBtn: TButton;
    HelpBtn: TButton;
  private
    { Private declarations }
  public
    { Public declarations }
    function Execute(mdl: TblkModel; psoObj: TObject): boolean;
  end;

var frmExtFnConfig: TfrmExtFnConfig;

implementation
{$R *.dfm}
uses pso_algo;

function TfrmExtFnConfig.Execute(mdl: TblkModel; psoObj: TObject): boolean;
var pso: TPSO;
begin
  Result:= false;
  pso:= TPSO(psoObj);
  if ShowModal = mrCancel then exit;
  Result:= true;
end;

end.
