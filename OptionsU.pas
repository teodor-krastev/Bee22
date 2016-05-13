(************************************************************************)
(*  Bee22 - Particle Swarm Optimization framework     http://bee22.com  *)
(*  developed by and copyright(c) Teodor Krastev 2015-2016              *)
(************************************************************************)
unit OptionsU;

interface

uses Winapi.Windows, System.SysUtils, System.Classes, Vcl.Graphics, Vcl.Forms,
  Vcl.Controls, Vcl.StdCtrls, Vcl.Buttons, Vcl.ComCtrls, Vcl.ExtCtrls, IOUtils,
  Vcl.Grids, Vcl.ValEdit, System.IniFiles, Math, Vcl.Samples.Spin, TrackerU;

type
  rState = record
    visible,enabled: boolean; height: integer; items: string;
  end;
  rBlock = record
    name, desc: string; place: integer;
    prop, chrt, src, log: rState;
  end;

  TfrmOptions = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    PageControl1: TPageControl;
    tsGeneral: TTabSheet;
    tsBlocks: TTabSheet;
    OKBtn: TButton;
    CancelBtn: TButton;
    HelpBtn: TButton;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    Panel8: TPanel;
    Panel9: TPanel;
    Panel10: TPanel;
    Panel11: TPanel;
    Panel12: TPanel;
    Panel13: TPanel;
    Panel14: TPanel;
    Panel15: TPanel;
    Panel16: TPanel;
    vleBlockLocation: TValueListEditor;
    Label1: TLabel;
    Panel17: TPanel;
    seStackWidth: TSpinEdit;
    Label2: TLabel;
    GroupBox1: TGroupBox;
    rbFactory: TRadioButton;
    rbDefaults: TRadioButton;
    rbCustom: TRadioButton;
    cbCustomSettings: TComboBox;
    chkSaveProps: TCheckBox;
    stRootPath: TStaticText;
    tsTracker: TTabSheet;
    fmTracker1: TfmTracker;
    procedure FormCreate(Sender: TObject);
    procedure vleBlockLocationSetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: string);
    procedure FormShow(Sender: TObject);
    procedure seStackWidthChange(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    panes: array[1..8] of TPanel;
    activeBlocks: string;
  public
    { Public declarations }
    RootDir: string;
    general: record
      OpenMode: byte;
      CustomProps: string;
      SaveOnClose: boolean;
    end;
    blocks: array of rBlock;
    pcHeights: array[0..8] of integer;
    StackWidth: integer;
    ini: TIniFile;
    procedure Opts2Vis;
    procedure Vis2Opts;
    procedure IniRead;
    procedure IniWrite;
    function IsActive(blk: string): boolean;

    function MainPath: string;
    function ConfigPath: string;
    function DataPath: string;
  end;

implementation
{$R *.dfm}
uses UtilsU;

procedure TfrmOptions.FormCreate(Sender: TObject);
begin
  // customisable root dir for different instances of CommandCenter/pso
  RootDir:= ''; // if empty application path is taken
  panes[1]:= panel16; panes[2]:= panel15;
  panes[3]:= panel10; panes[4]:= panel12; panes[5]:= panel11;
  panes[6]:= panel6; panes[7]:= panel8; panes[8]:= panel7;
end;

procedure TfrmOptions.FormDestroy(Sender: TObject);
begin
  FreeAndNil(Ini);
end;

procedure TfrmOptions.FormShow(Sender: TObject);
begin
  Opts2Vis;
end;

procedure TfrmOptions.IniRead; // after reg all the models
var
  i,j: integer; nm,ss: string;  // blocks sized and names from ctrl
begin
  assert(Assigned(Ini));
  general.OpenMode:= ini.ReadInteger('General','OpenMode',1);
  general.CustomProps:= ini.ReadString('General','CustomProps','');
  general.SaveOnClose:= ini.ReadBool('General','SaveOnClose',true);
  activeBlocks:= ','+ini.ReadString('General','Active','')+',';

  for i:= 0 to length(blocks)-1 do
  begin nm:= blocks[i].name;
    blocks[i].place:= ini.ReadInteger(nm,'place',0);
    vleBlockLocation.InsertRow(nm,IntToStr(blocks[i].place),true);
    blocks[i].prop.visible:= ini.ReadBool(nm,'propVis',true);
    blocks[i].prop.enabled:= ini.ReadBool(nm,'propEnb',true);
    blocks[i].prop.height:= ini.ReadInteger(nm,'propHigh',100);
    blocks[i].chrt.visible:= ini.ReadBool(nm,'chrtVis',true);
    blocks[i].chrt.enabled:= ini.ReadBool(nm,'chrtEnb',true);
    blocks[i].chrt.height:= ini.ReadInteger(nm,'chrtHigh',100);
    blocks[i].chrt.items:= ini.ReadString(nm,'chrtItems','');
    blocks[i].src.visible:= ini.ReadBool(nm,'srcVis',true);
    blocks[i].src.enabled:= ini.ReadBool(nm,'srcEnb',true);
    blocks[i].src.height:= ini.ReadInteger(nm,'srcHigh',100);
    blocks[i].log.visible:= ini.ReadBool(nm,'logVis',true);
    blocks[i].log.enabled:= ini.ReadBool(nm,'logEnb',true);
    blocks[i].log.items:= ini.ReadString(nm,'logItems','');
  end;
  for i:= 0 to 8 do
    pcHeights[i]:= ini.ReadInteger('pcHeights',IntToStr(i),150);
  StackWidth:= ini.ReadInteger('General','StackWidth',270);

  if not Assigned(fmTracker1.PSOprops) then fmTracker1.PSOprops:= TStringList.Create;
  fmTracker1.PSOprops.CommaText:= ini.ReadString('Tracker','PSOprops','');
  if not Assigned(fmTracker1.PartProps) then fmTracker1.PartProps:= TStringList.Create;
  fmTracker1.PartProps.CommaText:= ini.ReadString('Tracker','PartProps','');
end;

function TfrmOptions.IsActive(blk: string): boolean;
begin
  Result:= pos(','+blk+',',activeBlocks)>0;
end;

procedure TfrmOptions.IniWrite;
var i,j: integer; nm: string;
begin
  assert(Assigned(Ini));
  if SameText(Ini.FileName,ConfigPath+'_temp.ini') then
    raise Exception.Create('cannot save in temp file <_temp.ini>');

  Vis2Opts;

  ini.WriteInteger('General','OpenMode',general.OpenMode);
  ini.WriteString('General','CustomProps',general.CustomProps);
  ini.WriteBool('General','SaveOnClose',general.SaveOnClose);

  for i:= 0 to length(blocks)-1 do  // blocks sized and names from ctrl
  begin nm:= blocks[i].name;
    ini.WriteInteger(nm,'place',blocks[i].place);
    ini.WriteBool(nm,'propVis',blocks[i].prop.visible);
    ini.WriteBool(nm,'propEnb',blocks[i].prop.enabled);
    ini.WriteInteger(nm,'propHigh',blocks[i].prop.height);
    ini.WriteBool(nm,'chrtVis',blocks[i].chrt.visible);
    ini.WriteBool(nm,'chrtEnb',blocks[i].chrt.enabled);
    ini.WriteInteger(nm,'chrtHigh',blocks[i].chrt.height);
    ini.WriteString(nm,'chrtItems',blocks[i].chrt.items);
    ini.WriteBool(nm,'srcVis',blocks[i].src.visible);
    ini.WriteBool(nm,'srcEnb',blocks[i].src.enabled);
    ini.WriteInteger(nm,'srcHigh',blocks[i].src.height);
    ini.WriteBool(nm,'logVis',blocks[i].log.visible);
    ini.WriteBool(nm,'logEnb',blocks[i].log.enabled);
    ini.WriteString(nm,'logItems',blocks[i].log.items);
  end;
  for i:= 0 to 8 do
    ini.WriteInteger('pcHeights',IntToStr(i),pcHeights[i]);
  ini.WriteInteger('General','StackWidth',StackWidth);
  with fmTracker1 do
  begin
    PSOprops.Clear;
    for i:= 0 to chkPSO.Items.Count-1 do
      if chkPSO.Checked[i] then PSOprops.Add(chkPSO.Items[i]);
    ini.WriteString('Tracker','PSOprops',PSOprops.CommaText);
    PartProps.Clear;
    for i:= 0 to chkPart.Items.Count-1 do
      if chkPart.Checked[i] then PartProps.Add(chkPart.Items[i]);
    ini.WriteString('Tracker','PartProps',PartProps.CommaText);
  end;
end;

procedure TfrmOptions.Opts2Vis;
var i,j: integer; blk: rBlock; sp,sq: string;
begin
  case general.OpenMode of
   0: rbFactory.Checked:= true;
   1: rbDefaults.Checked:= true;
   2: rbCustom.Checked:= true;
  end;
  for sq in TDirectory.GetFiles(ConfigPath) do
  begin
    if not SameText(ExtractFileExt(sq),'.prop') then continue;
    sp:= ChangeFileExt(ExtractFileName(sq),'');
    if not SameText(sp,'defaults') then cbCustomSettings.Items.Add(sp);
  end;
  stRootPath.Caption:= 'Working directory: '+MainPath;
  cbCustomSettings.ItemIndex:= EnsureRange(cbCustomSettings.Items.IndexOf(general.CustomProps),0,100);
  chkSaveProps.Checked:= general.SaveOnClose;
  for i:= 1 to 8 do panes[i].Tag:= 0;
  for i:= 0 to length(blocks)-1 do
  begin
    blocks[i].place:= EnsureRange(blocks[i].place,0,8);
    j:= blocks[i].place;
    if not InRange(j,1,8) then continue;
    panes[j].Tag:= panes[j].Tag + 1;
  end;
  for i:= 1 to 8 do
    panes[i].Caption:= IntToStr(i)+' ('+IntToStr(panes[i].Tag)+')';
  seStackWidth.Value:= StackWidth;
end;

procedure TfrmOptions.Vis2Opts;
begin
  if rbFactory.Checked then general.OpenMode:= 0;
  if rbDefaults.Checked then general.OpenMode:= 1;
  if rbCustom.Checked then general.OpenMode:= 2;
  general.CustomProps:= cbCustomSettings.Items[cbCustomSettings.ItemIndex];
  general.SaveOnClose:= chkSaveProps.Checked;
end;

procedure TfrmOptions.seStackWidthChange(Sender: TObject);
begin
  StackWidth:= seStackWidth.Value;
end;

procedure TfrmOptions.vleBlockLocationSetEditText(Sender: TObject; ACol,
                      ARow: Integer; const Value: string);
var i,j: integer;
begin
  if not InRange(ARow,1,8) then exit;
  blocks[ARow-1].place:= EnsureRange(StrToIntDef(Value,0),0,8);
  Opts2Vis;
end;

function TfrmOptions.MainPath: string;
begin
  if DirectoryExists(RootDir) then Result:= RootDir
    else Result:= ExtractFilePath(Application.ExeName);
 Result:= IncludeTrailingBackslash(Result);
end;

function TfrmOptions.ConfigPath: string;
begin
  Result:= MainPath+'Config\'
end;

function TfrmOptions.DataPath: string;
begin
  Result:= MainPath+'Data\'
end;



end.

