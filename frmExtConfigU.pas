(************************************************************************)
(*  Bee22 - Particle Swarm Optimization framework     http://bee22.com  *)
(*  developed by and copyright(c) Teodor Krastev 2015-2016              *)
(************************************************************************)
unit frmExtConfigU;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls,
  Vcl.ExtCtrls, Vcl.Buttons, Vcl.Samples.Spin, VCLTee.TeeInspector, IniFiles,
  MVC_U, Math, UtilsU, pso_algo, blk_algo, Vcl.Menus, System.Types;

{
External function (object) to be optimized is charaterized by "features" (properties)
each feature is double value variable responsable for some parameter of the simulation,
in case of Simion - geometry or EM field. The point is to send fixed number of features
to the object and get back the fitness function value in order to do PSO on it.

The fitness value could be the direct output of Lua, but it could be some
statistical parameter: measured/simulated in Simion and statustically processed
in Lua or Bee22. In later case additional pages would parametrize and describe
the stats of the procedure.

The full set of features (enabled or not) is in the configuration file -
the names of the sections.
The disabled ones do not appear in the block selection comboboxes of x.1; x.2 ...
}

type
  TFireExtCmd = function (cmd: string; prm: OleVariant): OleVariant of object; // general
  TFeature = record
    Enabled: boolean; Name: string;
    Default, MinVal, MaxVal: double;
  end;

  TfrmExtConfig = class(TForm)
    Panel1: TPanel;
    sbLuaScript: TSpeedButton;
    sbSimion: TSpeedButton;
    sbSave: TSpeedButton;
    sbOpen: TSpeedButton;
    Shape1: TShape;
    StatusBar1: TStatusBar;
    chkNoGUI: TCheckBox;
    Panel2: TPanel;
    OKBtn: TButton;
    CancelBtn: TButton;
    HelpBtn: TButton;
    PageControl1: TPageControl;
    tsFeatures: TTabSheet;
    lbFeats: TListBox;
    Panel5: TPanel;
    leDftDbl: TLabeledEdit;
    leMinDbl: TLabeledEdit;
    leMaxDbl: TLabeledEdit;
    chkEnabled: TCheckBox;
    PopupMenu1: TPopupMenu;
    pmRunSimion: TMenuItem;
    pmPokeWithDatum: TMenuItem;
    pmCloseSimion: TMenuItem;
    OpenDialog1: TOpenDialog;
    procedure pmRunSimionClick(Sender: TObject);
    procedure pmPokeWithDatumClick(Sender: TObject);
    procedure pmCloseSimionClick(Sender: TObject);
    procedure sbSimionClick(Sender: TObject);
    procedure sbLuaScriptClick(Sender: TObject);
    procedure lbFeatsClick(Sender: TObject);
  private
    { Private declarations }
    mdl: TblkModel;
    pso: TPSO;
    lastAct: integer;
    fOnFireExtCmd: TFireExtCmd;
    procedure feat2vis(ft: TFeature);
    procedure vis2feat(var ft: TFeature);
  protected
    function OpenFile(fn: string): boolean;
    function SaveFile(fn: string): boolean;
  public
    { Public declarations }
    feats: array of TFeature;
    function featureByName(nm: string): TFeature;
    function Execute(aMdl: TblkModel; aPSO: TPSO): boolean;
    function Config(aMdl: TblkModel; aPSO: TPSO): boolean;
    function EnabledFeatures: string;
    function FeaturesCount: integer;

    function IsSimion(ping: boolean = false): boolean;
    function RunSimion(fts: string): boolean;
    function FireExtFunc(arrX: TDoubleDynArray): double; // epoch-specific
    procedure PrintRem(txt: string);
    property OnFireExtCmd: TFireExtCmd read fOnFireExtCmd write fOnFireExtCmd;
  end;

var
  frmExtConfig: TfrmExtConfig;

implementation
{$R *.dfm}
uses System.Win.ComServ;

procedure TfrmExtConfig.feat2vis(ft: TFeature);
begin
  leDftDbl.Text:= F2S(ft.Default);
  leMinDbl.Text:= F2S(ft.MinVal);
  leMaxDbl.Text:= F2S(ft.MaxVal);
  chkEnabled.Checked:= ft.Enabled;
end;

procedure TfrmExtConfig.vis2feat(var ft: TFeature);
begin
  ft.Default:= StrToFloatDef(leDftDbl.Text,ft.Default);
  ft.MinVal:= StrToFloatDef(leMinDbl.Text,ft.MinVal);
  ft.MaxVal:= StrToFloatDef(leMaxDbl.Text,ft.MaxVal);
  ft.Enabled:= chkEnabled.Checked;
end;

function TfrmExtConfig.OpenFile(fn: string): boolean;
var
  ini: TIniFile; i,j: integer; ps: TStrings;
begin
  Result:= false;
  if not FileExists(fn) then exit;
  ini:= TIniFile.Create(fn);
  sbSimion.Hint:= ini.ReadString('Simion','ExePath','');
  sbLuascript.Hint:= ini.ReadString('Simion','LuaPath','');
  chkNoGui.Checked:= ini.ReadBool('Simion','NoGui',true);
  ps:= TStringList.Create;
  ini.ReadSections(ps); SetLength(feats,ps.Count-1);
  j:= 0;
  for i:= 0 to ps.Count-1 do
  begin
    if SameText(ps[i],'Simion') then continue;
    feats[j].Name:= ps[i];
    feats[j].Enabled:= ini.ReadBool(ps[i],'Enabled',true);
    feats[j].Default:= ini.ReadFloat(ps[i],'Default',1);
    feats[j].MinVal:= ini.ReadFloat(ps[i],'Min',0);
    feats[j].MaxVal:= ini.ReadFloat(ps[i],'Max',1000);
    inc(j);
  end;
  ps.Free; ini.Free;
  Result:= true;
end;

function TfrmExtConfig.SaveFile(fn: string): boolean;
var
  ini: TIniFile; i: integer;
begin
  Result:= false;
  if not FileExists(fn) then exit;
  ini:= TIniFile.Create(fn);
  ini.WriteString('Simion','ExePath',sbSimion.Hint);
  ini.WriteString('Simion','LuaPath',sbLuaScript.Hint);
  ini.WriteBool('Simion','NoGui',chkNoGui.Checked);
  for i:= 0 to length(feats)-1 do
  begin
    ini.WriteBool(feats[i].Name,'Enabled',feats[i].Enabled);
    ini.WriteFloat(feats[i].Name,'Default',feats[i].Default);
    ini.WriteFloat(feats[i].Name,'Min',feats[i].MinVal);
    ini.WriteFloat(feats[i].Name,'Max',feats[i].MaxVal);
  end;
  ini.Free;
  Result:= true;
end;

procedure TfrmExtConfig.sbLuaScriptClick(Sender: TObject);
begin
  OpenDialog1.Title:= 'Lua script file';
  OpenDialog1.Filter:= 'Lua script(*.lua)|*.lua';
  if OpenDialog1.Execute then sbLuaScript.Hint:= OpenDialog1.FileName;
end;

procedure TfrmExtConfig.sbSimionClick(Sender: TObject);
begin
  OpenDialog1.Title:= 'Simion executable file';
  OpenDialog1.Filter:= 'Executable(*.exe)|*.exe';
  if OpenDialog1.Execute then sbSimion.Hint:= OpenDialog1.FileName;
end;

function TfrmExtConfig.featureByName(nm: string): TFeature;
var
  i: integer;
begin
  Result.Enabled:= false;
  for i:= 0 to length(feats)-1 do
    if SameText(nm,feats[i].Name) then
    begin
      Result:= feats[i];
      break;
    end;
end;

function TfrmExtConfig.Execute(aMdl: TblkModel; aPSO: TPSO): boolean;
var
  fn: string; i: integer;
begin
  Result:= false;
  mdl:= aMdl; pso:= aPSO;
  Config(aMdl,aPSO);
  lbFeats.Items.Clear;
  for i:=0 to length(feats)-1 do
      lbFeats.Items.Add(feats[i].Name);
  lbFeats.ItemIndex:= 0; lbFeatsClick(nil);
  if ShowModal = mrCancel then exit;
  vis2feat(feats[lastAct]);
  fn:= IncludeTrailingBackslash(TController(pso.Controller).frmOpts.ConfigPath)
      +'config.'+mdl.GetName;
  Result:= SaveFile(fn);
end;

function TfrmExtConfig.Config(aMdl: TblkModel; aPSO: TPSO): boolean;
var
  fn: string;
begin
  Result:= false;
  mdl:= aMdl; pso:= aPSO;
  fn:= IncludeTrailingBackslash(TController(pso.Controller).frmOpts.ConfigPath)
      +'config.'+mdl.GetName;
  Result:= OpenFile(fn);
end;

function TfrmExtConfig.EnabledFeatures: string;
var
  i: integer;
begin
  Result:= '';
  for i:=0 to length(feats)-1 do
    if feats[i].Enabled then
      Result:= Result+feats[i].Name+',';
  delete(Result,length(Result),1);
end;

function TfrmExtConfig.FeaturesCount: integer;
var
  i: integer;
begin
  Result:= 0;
  for i:=0 to length(feats)-1 do
    if feats[i].Enabled then inc(Result);
end;

procedure TfrmExtConfig.lbFeatsClick(Sender: TObject);
var
  i: integer;
begin
  i:= lbFeats.ItemIndex;
  if not InRange(i, 0,lbFeats.Items.Count-1) then exit;
  if Sender<>nil then vis2feat(feats[lastAct]); // save from the last active one before
  lastAct:= i;
  feat2vis(feats[lastAct]); // update vis with the new one
end;
//========== S I M I O N ==============================================

function TfrmExtConfig.FireExtFunc(arrX: TDoubleDynArray): double; // epoch-specific
var VarArray,vr: variant;  i: integer; d: double;
begin
  if not Assigned(OnFireExtCmd) then exit;
  DynArrayToVariant(VarArray,arrX, TypeInfo(TDoubleDynArray));
  Result:= double(OnFireExtCmd('fly', VarArray));
  Application.ProcessMessages;
end;

procedure TfrmExtConfig.PrintRem(txt: string);
begin
  if Assigned(OnFireExtCmd) then
    OnFireExtCmd('exec', OleVariant('print("! '+txt+'")'));
end;

procedure TfrmExtConfig.pmCloseSimionClick(Sender: TObject);
begin
  if Assigned(OnFireExtCmd) then OnFireExtCmd('exit',null);
end;

procedure TfrmExtConfig.pmPokeWithDatumClick(Sender: TObject);
var VarArray, vr: variant; arrX: TDoubleDynArray;
begin
  if not IsSimion() then RunSimion('');
  SetLength(arrX,2); arrX[0]:= 2; arrX[1]:= 3;
  DynArrayToVariant(VarArray,arrX, TypeInfo(TDoubleDynArray));
  if not Assigned(OnFireExtCmd) then exit;
  vr:= OnFireExtCmd('fly',VarArray);
  if VarIsArray(vr)
    then caption:= floattostr(double(vr[1]))+' | '+floattostr(double(vr[2]))
    else caption:= vartostr(vr);
end;

function TfrmExtConfig.IsSimion(ping: boolean = false): boolean;
var
  vr: variant; j: integer;
begin
  Result:= Assigned(OnFireExtCmd);

  if not Ping or not Result then exit;
  j:= random(1000);
  vr:= 'whw = '+IntToStr(j);
  vr:= OnFireExtCmd('exec',vr);
  vr:= 'whw';
  vr:= OnFireExtCmd('eval',vr);
  Result:= integer(vr)=j;
end;

procedure TfrmExtConfig.pmRunSimionClick(Sender: TObject);
begin
  RunSimion('');
end;

function TfrmExtConfig.RunSimion(fts: string): boolean;
var ss: string;
begin
  assert(FileExists(sbSimion.Hint),'Invalid Simion executable -> '+sbSimion.Hint);
  assert(FileExists(sbLuaScript.Hint),'Invalid Lua script -> '+sbLuaScript.Hint);
  ss:= '';
  if chkNoGUI.Checked then ss:= ss+'--nogui --noprompt '; //--quiet
  ss:= ss+'lua '+sbLuaScript.Hint;
  Result:= ShellExec(sbSimion.Hint,ss);
  if Assigned(OnFireExtCmd) and (fts<>'') then
    Result:= boolean(OnFireExtCmd('set',OleVariant(fts)));
  delay(2000);
end;

end.
