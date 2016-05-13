unit frmClientBee22U;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Oleauto,  Vcl.Controls, Vcl.Forms,
  Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, System.Win.ComObj, Bee22_TLB;

type
  TfrmClientBee22 = class(TForm)
    Panel1: TPanel;
    mmIn: TMemo;
    Panel2: TPanel;
    Splitter1: TSplitter;
    mmOut: TMemo;
    btnConfog: TButton;
    cbExpr: TComboBox;
    btnEval: TButton;
    btnExec: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnConfogClick(Sender: TObject);
    procedure btnEvalClick(Sender: TObject);
    procedure btnExecClick(Sender: TObject);
  private
    { Private declarations }
    Bee22srv: ICoBee22;
  public
    { Public declarations }
  end;

var frmClientBee22: TfrmClientBee22;

implementation
{$R *.dfm}

procedure TfrmClientBee22.FormCreate(Sender: TObject);
var gd: TGUID;
begin
  Bee22srv:= CoCoBee22.Create;
end;

procedure TfrmClientBee22.btnConfogClick(Sender: TObject);
begin
  Bee22srv.Config(3,'');
end;

procedure TfrmClientBee22.btnEvalClick(Sender: TObject);
begin
  mmOut.Lines.Add('> '+cbExpr.Text);
  mmOut.Lines.Add(string(Bee22srv.Eval(String(cbExpr.Text))));
  cbExpr.Items.Insert(0,cbExpr.Text);
  cbExpr.Text:= '';
end;

procedure TfrmClientBee22.btnExecClick(Sender: TObject);
begin
  if Bee22srv.Exec(String(mmIn.Lines.Text))
    then mmOut.Lines.Add('> OK')
    else mmOut.Lines.Add('> problem');
end;

end.
