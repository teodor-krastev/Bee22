(************************************************************************)
(*  Bee22 - Particle Swarm Optimization framework     http://bee22.com  *)
(*  developed by and copyright(c) Teodor Krastev 2015-2016              *)
(************************************************************************)
unit fmSrcPaneU;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, SynEdit, Vcl.StdCtrls,
  Vcl.Buttons, Vcl.ExtCtrls, SynEditHighlighter, SynHighlighterPython,
  MVC_U, Vcl.Samples.Spin;

type
  TfmSrcPane = class(TFrame)
    pnlHeader: TPanel;
    sbGoLeft: TSpeedButton;
    chkEnabled: TCheckBox;
    seCode: TSynEdit;
    SynPythonSyn1: TSynPythonSyn;
  private
    { Private declarations }
    fFunc: rFunc;
    updating: boolean;
    function getFunc: rFunc;
    procedure setFunc(fn: rFunc);
  public
    { Public declarations }
    property Func: rFunc read getFunc write setFunc;
  end;

implementation
{$R *.dfm}

function TfmSrcPane.getFunc: rFunc;
begin
  if updating then exit;
  Result:= fFunc;
  Result.enabled:= chkEnabled.Checked;
  Result.code:= seCode.Lines.Text;
end;

procedure TfmSrcPane.setFunc(fn: rFunc);
begin
  updating:= true;
  fFunc:= fn;
  pnlHeader.Caption:= ' def '+fn.nm+'('+fn.prms+'):';
  chkEnabled.Checked:= fn.enabled;
  seCode.Lines.Text:= fn.code;
  updating:= false;
end;

end.
