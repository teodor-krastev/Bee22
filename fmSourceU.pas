(************************************************************************)
(*  Bee22 - Particle Swarm Optimization framework     http://bee22.com  *)
(*  developed by and copyright(c) Teodor Krastev 2015-2016              *)
(************************************************************************)
unit fmSourceU;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.ComCtrls,
  SynEditHighlighter, SynHighlighterPython, SynEdit, Vcl.StdCtrls, Vcl.Buttons,
  MVC_U, fmSrcPaneU, Vcl.Samples.Spin;

type
  TfmSource = class(TFrame)
    pnlLeft: TPanel;
    pnlSwitch: TPanel;
    cbFuncs: TComboBox;
    sbExpand: TSpeedButton;
    chkEnabled: TCheckBox;
    fmSrcPane1: TfmSrcPane;
    spCommon: TfmSrcPane;
    Splitter1: TSplitter;
    pnlRight: TScrollBox;
    procedure sbExpandClick(Sender: TObject);
    procedure spCommonsbGoLeftClick(Sender: TObject);
    procedure cbFuncsChange(Sender: TObject);
    procedure fmSrcPane1seCodeChange(Sender: TObject);
    procedure spCommonseCodeChange(Sender: TObject);
  private
    { Private declarations }
    fExpanded: boolean;
    leftContainer: TPanel;
    rightContainer: TPageControl;
    rcTab: TTabSheet;
    updating: boolean;
    SrcPanes: array of TfmSrcPane;
    SrcSplit: array of TSplitter;
    procedure SetExpanded(vl: boolean);
  public
    { Public declarations }
    src: TSource; // data

    procedure Init(source: TSource; leftCont: TPanel; rightCont: TPageControl);
    procedure UpdateLeftFromSrc;
    procedure UpdateRightFromSrc;
    procedure UpdateSrcFromLeft;
    procedure UpdateSrcFromRight;

    property Expanded: boolean read fExpanded write SetExpanded;
  end;

implementation
{$R *.dfm}

procedure TfmSource.Init(source: TSource; leftCont: TPanel; rightCont: TPageControl);
var i,j,n: integer; sp: TfmSrcPane; ss: TSplitter;
begin
  leftContainer:= leftCont; rightContainer:= rightCont;
  updating:= false;
  src:= source;
  // left
  cbFuncs.Items.Add('Common code');
  for i:= 0 to src.Count-1 do
    cbFuncs.Items.Add(src.Funcs[i].nm);
  cbFuncs.ItemIndex:= 0;
  fExpanded:= false; Expanded:= false;
  // right
  SetLength(SrcPanes,src.Count); SetLength(SrcSplit,src.Count);
  if src.Count=0 then exit;
  for i:= 0 to src.Count-1 do
  begin
    sp:= TfmSrcPane.Create(self); ss:= TSplitter.Create(self);
    sp.Align:= alTop; ss.Align:= alTop; ss.Color:= clSilver;
    sp.Parent:= pnlRight; ss.Parent:= pnlRight;
    sp.Name:= 'SrcPane'+IntToStr(i); ss.Name:= 'SrcSplit'+IntToStr(i);
    sp.sbGoLeft.OnClick:= spCommon.sbGoLeft.OnClick;
    sp.chkEnabled.OnClick:= spCommonseCodeChange;
    sp.seCode.OnChange:= spCommonseCodeChange;
    SrcPanes[i]:= sp; SrcSplit[i]:= ss;
  end;
  updating:= false;
end;

procedure TfmSource.sbExpandClick(Sender: TObject);
begin
  Expanded:= true;
end;

procedure TfmSource.SetExpanded(vl: boolean);
var bb: boolean; i,j,n: integer;
begin
  bb:= (fExpanded <> vl); // it has been a change
  fExpanded:= vl;
  pnlLeft.Visible:= not vl; pnlRight.Visible:= vl;
  Parent:= nil;
  FreeAndNil(rcTab);
  if vl then // right
  begin
    rcTab:= TTabSheet.Create(rightContainer);
    rcTab.Caption:= 'Source: '+src.blkName;
    rcTab.PageControl:= rightContainer;
    Parent:= rcTab;
    rightContainer.ActivePage:= rcTab; Application.ProcessMessages;
    j:= round(pnlRight.Height/(src.Count+1)-Splitter1.Height-2);
    for i:= 0 to src.Count-1 do
    begin
      SrcPanes[i].Height:= j;
      SrcPanes[i].Align:= alNone; SrcSplit[i].Align:= alNone;
      SrcPanes[i].Top:= 900; SrcSplit[i].Top:= 900;
    end;
    Application.ProcessMessages;
    spCommon.Top:= 0; spCommon.Height:= j;
    for i:= 0 to src.Count-1 do
    begin
      SrcPanes[i].Align:= alTop; SrcSplit[i].Align:= alTop;
    end;
    UpdateRightFromSrc;
  end
  else begin // left
    if bb then UpdateSrcFromRight;
    Parent:= leftContainer;
    UpdateLeftFromSrc;
  end;
end;

procedure TfmSource.cbFuncsChange(Sender: TObject);
begin
  UpdateLeftFromSrc;
end;

procedure TfmSource.spCommonsbGoLeftClick(Sender: TObject);
begin
  Expanded:= false;
end;

procedure TfmSource.fmSrcPane1seCodeChange(Sender: TObject);
begin
  if not updating then
    UpdateSrcFromLeft;
end;

procedure TfmSource.spCommonseCodeChange(Sender: TObject);
begin
  if not updating then
    UpdateSrcFromRight;
end;

procedure TfmSource.UpdateLeftFromSrc;
var fn: rFunc; idx: integer;
begin
  updating:= true;
  if cbFuncs.Text='Common code'  then
  begin
    fmSrcPane1.pnlHeader.Caption:= ' # common section';
    fmSrcPane1.seCode.Lines.Text:= src.commonCode;
    chkEnabled.Visible:= false;
    exit;
  end;
  chkEnabled.Visible:= true;
  idx:= cbFuncs.ItemIndex-1;
  if idx<0 then exit;
  fmSrcPane1.Func:= src.Funcs[idx];
  chkEnabled.Checked:= src.Funcs[idx].enabled;
  updating:= false;
end;

procedure TfmSource.UpdateRightFromSrc;
var i: integer; cp: TCategoryPanel;
begin
  updating:= true;
  spCommon.seCode.Lines.Text:= src.commonCode;
  for i:= 0 to src.Count-1 do
    SrcPanes[i].Func:= src.Funcs[i];
  updating:= false;
end;

procedure TfmSource.UpdateSrcFromLeft;
var fn: rFunc; idx: integer;
begin
  if cbFuncs.ItemIndex=0 then
  begin
    src.commonCode:= fmSrcPane1.seCode.Lines.Text;
    exit;
  end;
  idx:= cbFuncs.ItemIndex-1;
  if idx<0 then exit;
  src.Funcs[idx]:= fmSrcPane1.Func;
  src.Funcs[idx].enabled:= chkEnabled.Checked;
end;

procedure TfmSource.UpdateSrcFromRight;
var i: integer;
begin
  src.commonCode:= spCommon.seCode.Lines.Text;
  for i:= 0 to src.Count-1 do
    src.Funcs[i]:= SrcPanes[i].Func;
end;

end.
