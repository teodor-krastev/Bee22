(************************************************************************)
(*  Bee22 - Particle Swarm Optimization framework     http://bee22.com  *)
(*  developed by and copyright(c) Teodor Krastev 2015-2016              *)
(************************************************************************)
unit Bee22U;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,  Vcl.Graphics,
  Vcl.Menus, ctrlCenterU, fmInsideU, fmOutsideU, Vcl.ComCtrls, Types, System.IniFiles,
  fmScanU, Vcl.AppEvnts, AboutBoxU;

type
  TfrmBee22 = class(TForm)
    Panel2: TPanel;
    Panel1: TPanel;
    Memo1: TMemo;
    Panel3: TPanel;
    StatusBar1: TStatusBar;
    procedure Panel1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    ini: TIniFile;
    procedure log(txt: string);
  public
    { Public declarations }
    fmScanPSO1: TfmScanPSO;
    procedure Position;
  end;

var frmBee22: TfrmBee22; remoteAccess: boolean = false;

implementation
{$R *.dfm}
uses UtilsU;

procedure TfrmBee22.log(txt: string);
begin
  Memo1.Lines.Add(txt);
end;

procedure TfrmBee22.Position;
begin
  // retrieve form size/pos
  if ini.ReadBool('General','Maxim',false) then
    WindowState:=wsMaximized
  else begin
    Width:= ini.ReadInteger('General','Width',Width);
    Height:= ini.ReadInteger('General','Height',Height);
    Top:= ini.ReadInteger('General','Top',Top);
    Left:= ini.ReadInteger('General','Left',Left);
  end;
end;

procedure TfrmBee22.FormActivate(Sender: TObject);
begin
  if Tag=1 then exit; // to be called once
  Tag:= 1;
  Caption:= Caption+Sto_GetFmtFileVersion(Application.ExeName)+' (Teodor Krastev)';
  frmAboutBox.Show; Application.ProcessMessages;
  ini:= TIniFile.Create(ChangeFileExt(Application.ExeName,'.ini'));
  Position;
  fmScanPSO1:= TfmScanPSO.Create(self); fmScanPSO1.Name:= 'fmScanPSO1';
  fmScanPSO1.Parent:= Panel3;
  fmScanPSO1.Init(3,ParamStr(1));
  frmAboutBox.Hide;
  if remoteaccess then Application.BringToFront;
end;

procedure TfrmBee22.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if fmScanPSO1.cc.psoInf.IsRunning then
  begin
    Vcl.Dialogs.ShowMessage('PSO is still running.  Stop the it first.');
    Action:= caNone;
  end;
  if Action = caNone then exit;
  // save form size/pos
  if WindowState=wsMaximized then
    ini.WriteBool('General','Maxim',true)
  else
  begin
    ini.WriteBool('General','Maxim',false);
    ini.WriteInteger('General','Width',Width);
    ini.WriteInteger('General','Height',Height);
    ini.WriteInteger('General','Top',Top);
    ini.WriteInteger('General','Left',Left);
  end;
  ini.Free;
  fmScanPSO1.Finish;
end;

procedure TfrmBee22.Panel1Click(Sender: TObject);
var i: integer; rslt: TDoubleDynArray;
begin
  for i := 1 to 10 do
  begin
    rslt:= fmScanPSO1.cc.RunPSO(30,true).vars;
    log(FloatToStr(rslt[0]));
  end;
end;

end.
