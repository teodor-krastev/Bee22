(************************************************************************)
(*  Bee22 - Particle Swarm Optimization framework     http://bee22.com  *)
(*  developed by and copyright(c) Teodor Krastev 2015-2016              *)
(************************************************************************)
unit blkPilesU;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.ComCtrls,
  Vcl.ExtCtrls, fmConsoleU, Math, BlockU, Vcl.Buttons, OptionsU, IniFiles,
  pso_algo, pso_particle, TestFuncU, UtilsU, MVC_U, Vcl.Imaging.GIFImg;

type
  TOnRunEvent = procedure (NumberOfParticles: integer; ForceReset: boolean) of object;

  TfmBlkPiles = class(TFrame)
    ScrollBox1: TScrollBox;
    ScrollBox3: TScrollBox;
    ScrollBox2: TScrollBox;
    fmConsole1: TfmConsole;
    Splitter0: TSplitter;
    PageControl1: TPageControl;
    Splitter1: TSplitter;
    PageControl2: TPageControl;
    Splitter2: TSplitter;
    PageControl3: TPageControl;
    Splitter3: TSplitter;
    PageControl4: TPageControl;
    Splitter5: TSplitter;
    PageControl6: TPageControl;
    Splitter6: TSplitter;
    PageControl5: TPageControl;
    Splitter4: TSplitter;
    PageControl7: TPageControl;
    Splitter7: TSplitter;
    PageControl8: TPageControl;
    Splitter8: TSplitter;
    Panel1: TPanel;
    Panel2: TPanel;
    sbRun: TSpeedButton;
    sbPause: TSpeedButton;
    sbPreview: TSpeedButton;
    sbPopupMenu: TSpeedButton;
    PopupMenu1: TPopupMenu;
    mOptions: TMenuItem;
    N1: TMenuItem;
    mOpenProp: TMenuItem;
    mSaveProp: TMenuItem;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    mSavePropAs: TMenuItem;
    Image1: TImage;
    N2: TMenuItem;
    mMute: TMenuItem;
    N3: TMenuItem;
    mHelp: TMenuItem;
    procedure sbPopupMenuMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure mOptionsClick(Sender: TObject);
    procedure sbRunClick(Sender: TObject);
    procedure mOpenPropClick(Sender: TObject);
    procedure mSavePropClick(Sender: TObject);
    procedure sbPauseClick(Sender: TObject);
    procedure mMuteClick(Sender: TObject);
    procedure mHelpClick(Sender: TObject);
  private
    { Private declarations }
    frmOptions: TfrmOptions;
    fOnRunEvent: TOnRunEvent;
    function GetMute(): boolean;
    procedure SetMute(vl: boolean);
  public
    { Public declarations }
    trace: integer;
    pc: array[1..8] of TPageControl;
    spl: array[0..8] of TSplitter;
    blks: array of TfmBlock;
    psoRef: TPSO;      // Ref means that the object is owned by another class
    ctrlPortRef: TctrlPort;

    procedure Init(AfrmOptions: TfrmOptions);
    destructor Destroy; override;
    function BlkByName(nm: string): TfmBlock;
    procedure UpdateVis(conOnly: boolean = false);
    procedure UpdateIni;

    procedure OnIteraction(Sender: TObject);
    procedure ShowRunning(running: boolean);
    property OnRun: TOnRunEvent read fOnRunEvent write fOnRunEvent;
    property Mute: boolean read GetMute write SetMute;
  end;

implementation
{$R *.dfm}

procedure TfmBlkPiles.sbPauseClick(Sender: TObject);
begin
  if sbPause.Down then sbPreview.Caption:= 'Next'
  else sbPreview.Caption:= 'Preview';
end;

procedure TfmBlkPiles.sbPopupMenuMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var p: TPoint; btn: TSpeedButton;
begin
  btn:= TSpeedButton(Sender);
  p.X:= btn.Left; p.Y:= btn.Top+btn.Height;
  p:= ClientToScreen(p);
  btn.PopupMenu.Popup(p.X,p.Y);
end;

procedure TfmBlkPiles.OnIteraction(Sender: TObject);
begin
  while (sbPause.Down) and (trace < psoRef.Iterations)
    and not Application.Terminated do Application.ProcessMessages;
end;

procedure TfmBlkPiles.ShowRunning(running: boolean);
begin
  Image1.Visible:= running;
  sbPopupMenu.Visible:= not running;
  (Image1.Picture.Graphic as TGIFImage).Animate:= running; // gets it goin'
  (Image1.Picture.Graphic as TGIFImage).AnimationSpeed:= 120; // adjust your speed
end;

procedure TfmBlkPiles.sbRunClick(Sender: TObject);
begin
  if sbRun.Down then
  begin
    ShowRunning(true); trace:= -1;
    if Assigned(OnRun) then OnRun(0, false);
    fmConsole1.Log('Done: '+psoRef.TermCond);
    fmConsole1.Log(psoRef.SwarmBestEverPos);
    sbRun.Down:= false; ShowRunning(false);
  end
  else begin
    psoRef.Stop; ShowRunning(false);
  end;
end;

//oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
procedure TfmBlkPiles.Init(AfrmOptions: TfrmOptions);
var i: byte;
begin
  pc[1]:= PageControl1; pc[2]:= PageControl2;
  pc[3]:= PageControl3; pc[4]:= PageControl4; pc[5]:= PageControl5;
  pc[6]:= PageControl6; pc[7]:= PageControl7; pc[8]:= PageControl8;
  for i:= 1 to 8 do
  begin
    pc[i].Font.Name:= 'Lucida Console';
    pc[i].Font.Size:= 9;
  end;
  spl[0]:= Splitter0; spl[1]:= Splitter1; spl[2]:= Splitter2;
  spl[3]:= Splitter3; spl[4]:= Splitter4; spl[5]:= Splitter5;
  spl[6]:= Splitter6; spl[7]:= Splitter7; spl[8]:= Splitter8;
  sbPause.Left:= sbPreview.Left+sbPreview.Width+5;

  frmOptions:= AfrmOptions;
  psoRef.OnBeforeIteration:= OnIteraction;
end;

destructor TfmBlkPiles.Destroy;
begin
  if Assigned(psoRef) then psoRef.Stop; Application.ProcessMessages;
  inherited Destroy;
end;

procedure TfmBlkPiles.mOptionsClick(Sender: TObject);
begin
  if frmOptions.ShowModal=mrOK then frmOptions.iniWrite;
end;

procedure TfmBlkPiles.mHelpClick(Sender: TObject);
begin
  HyperlinkExe('http://bee22.com/?pg=manual/pso.htm');
end;

procedure TfmBlkPiles.mMuteClick(Sender: TObject);
begin
  Mute:= mMute.Checked;
end;

procedure TfmBlkPiles.mOpenPropClick(Sender: TObject);
begin
  OpenDialog1.InitialDir:= frmOptions.ConfigPath;
  if OpenDialog1.Execute then
    ctrlPortRef.IniLoad(OpenDialog1.Filename);
end;

procedure TfmBlkPiles.mSavePropClick(Sender: TObject);
begin
  if (Sender=mSaveProp) then ctrlPortRef.IniSave('');
  begin
    SaveDialog1.InitialDir:= frmOptions.ConfigPath;
    if SaveDialog1.Execute then
      ctrlPortRef.IniSave(SaveDialog1.Filename);
  end;
end;

function TfmBlkPiles.BlkByName(nm: string): TfmBlock;
var i: integer;
begin
  Result:= nil;
  for i:= 0 to length(blks)-1 do
    if SameText(blks[i].Caption,nm) then
    begin
      Result:= blks[i]; exit;
    end;
end;

procedure TfmBlkPiles.UpdateVis(conOnly: boolean = false); // from Options
var ts: TTabSheet; i,j,k: integer;
begin
  if not conOnly then
    for i := 0 to length(frmOptions.blocks)-1 do
    begin
      j:= frmOptions.blocks[i].place;
      //if not InRange(j,1,8) then continue;
      j:= EnsureRange(j,1,8);
      ts:= TTabSheet.Create(self); ts.Name:= 'tsBlk'+IntToStr(i);
      ts.PageControl:= pc[j]; ts.Caption:= frmOptions.blocks[i].name;
      ts.Font.Size:= 9;
      k:= length(blks); SetLength(blks,k+1);
      blks[k]:= TfmBlock.Create(self); blks[k].Name:='fmBlk'+IntToStr(i);
      blks[k].Parent:= ts; blks[k].Init(frmOptions.blocks[i].name,IPSO(psoRef));
      with frmOptions.blocks[i] do
      begin
        blks[k].vPane[vptProp]:= prop.visible; blks[k].ePane[vptProp]:= prop.Enabled;
        blks[k].pnls[vptProp].Height:= prop.height;
        blks[k].vPane[vptChart]:= chrt.visible; blks[k].ePane[vptChart]:= chrt.Enabled;
        blks[k].pnls[vptChart].Height:= chrt.height;
        blks[k].vPane[vptSrc]:= src.visible; blks[k].ePane[vptSrc]:= src.Enabled;
        blks[k].pnls[vptSrc].Height:= src.height;
        blks[k].vPane[vptLog]:= log.visible; blks[k].ePane[vptLog]:= log.Enabled;
        blks[k].TemplList:= log.items;
      end;
      blks[k].UpdateVis;
    end;
  // piles
  Panel1.Height:= frmOptions.pcHeights[0];
  for i:= 1 to 8 do
  begin
    pc[i].Visible:= pc[i].PageCount>0; spl[i].Visible:= pc[i].Visible;
    if pc[i].Visible then pc[i].Height:= frmOptions.pcHeights[i];
  end;
  // ScrollBox1
  if pc[2].Visible then pc[2].Align:= alClient
    else if pc[1].Visible then pc[1].Align:= alClient
           else begin Panel1.Align:= alClient; spl[0].Visible:= false;
           end;
  ScrollBox1.Width:= frmOptions.StackWidth;
  // ScrollBox2
  if pc[5].Visible then pc[5].Align:= alClient
    else if pc[4].Visible then pc[4].Align:= alClient
           else pc[3].Align:= alClient;
  ScrollBox2.Visible:= pc[3].Visible or pc[4].Visible or pc[5].Visible;
  if ScrollBox2.Visible then ScrollBox2.Width:= frmOptions.StackWidth;
  // ScrollBox3
  if pc[8].Visible then pc[8].Align:= alClient
    else if pc[7].Visible then pc[7].Align:= alClient
           else pc[6].Align:= alClient;
  ScrollBox3.Visible:= pc[6].Visible or pc[7].Visible or pc[8].Visible;
  if ScrollBox3.Visible then ScrollBox3.Width:= frmOptions.StackWidth;

  for i:= 1 to 8 do
    spl[i].Visible:= spl[i].Visible and (pc[i].Align<>alClient);
end;

procedure TfmBlkPiles.UpdateIni;
var i,j: integer;
begin
  frmOptions.pcHeights[0]:= Panel1.Height;
  for i:= 1 to 8 do
    if pc[i].Visible then frmOptions.pcHeights[i]:= pc[i].Height;

  for i := 0 to length(frmOptions.blocks)-1 do
  with frmOptions.blocks[i] do
  begin
    prop.visible:= blks[i].vPane[vptProp]; prop.Enabled:= blks[i].ePane[vptProp];
    prop.height:= blks[i].pnls[vptProp].Height;
    chrt.visible:= blks[i].vPane[vptChart]; chrt.Enabled:= blks[i].ePane[vptChart];
    chrt.height:= blks[i].pnls[vptChart].Height; chrt.items:= blks[i].SrsList;
    src.visible:= blks[i].vPane[vptSrc]; src.Enabled:= blks[i].ePane[vptSrc];
    src.height:= blks[i].pnls[vptSrc].Height;
    log.visible:= blks[i].vPane[vptLog]; log.Enabled:= blks[i].ePane[vptLog];
    log.items:= blks[i].TemplList;
  end;
end;

function TfmBlkPiles.GetMute(): boolean;
begin
  Result:= mMute.Checked;
end;

procedure TfmBlkPiles.SetMute(vl: boolean);
var blk: TfmBlock;
begin
  mMute.Checked:= vl;
  for blk in blks do
    blk.Mute:= vl;
end;

end.
