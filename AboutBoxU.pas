(************************************************************************)
(*  Bee22 - Particle Swarm Optimization framework     http://bee22.com  *)
(*  developed by and copyright(c) Teodor Krastev 2015-2016              *)
(************************************************************************)
unit AboutBoxU;

interface

uses WinApi.Windows, System.SysUtils, System.Classes, Vcl.Graphics,
  Vcl.Forms, Vcl.Controls, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls,
  Vcl.Imaging.jpeg, Vcl.Imaging.GIFImg, UtilsU;

type
  TfrmAboutBox = class(TForm)
    imgBg: TImage;
    lbProduct: TLabel;
    lbVersion: TLabel;
    Copyright: TLabel;
    OKButton: TButton;
    imgBee22: TImage;
    LinkLabel1: TLinkLabel;
    procedure LinkLabel1LinkClick(Sender: TObject; const Link: string;
      LinkType: TSysLinkType);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var frmAboutBox: TfrmAboutBox;

implementation
{$R *.dfm}


procedure TfrmAboutBox.FormCreate(Sender: TObject);
begin
  lbVersion.Caption:= 'v '+Sto_GetFmtFileVersion(Application.ExeName);
end;

procedure TfrmAboutBox.LinkLabel1LinkClick(Sender: TObject; const Link: string;
  LinkType: TSysLinkType);
begin
  if LinkType=sltURL then
    HyperlinkExe(Link);
end;

end.

