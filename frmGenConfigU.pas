(************************************************************************)
(*  Bee22 - Particle Swarm Optimization framework     http://bee22.com  *)
(*  developed by and copyright(c) Teodor Krastev 2015-2016              *)
(************************************************************************)
unit frmGenConfigU;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics,  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, MVC_U, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.Buttons, Vcl.Samples.Spin, IniFiles, Math,
  VCLTee.TeeInspector, UtilsU, pso_algo, blk_algo;

type
  TfrmGenConfig = class(TForm)
    Panel2: TPanel;
    OKBtn: TButton;
    CancelBtn: TButton;
    HelpBtn: TButton;
    Panel1: TPanel;
    Panel3: TPanel;
    sbRemove: TSpeedButton;
    sbNewProp: TSpeedButton;
    sbSave: TSpeedButton;
    sbOpen: TSpeedButton;
    Shape1: TShape;
    Panel4: TPanel;
    lbProps: TListBox;
    Panel5: TPanel;
    sbRename: TSpeedButton;
    SpinButton1: TSpinButton;
    Panel6: TPanel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    leDftInt: TLabeledEdit;
    leMinInt: TLabeledEdit;
    leMaxInt: TLabeledEdit;
    TabSheet2: TTabSheet;
    leDftDbl: TLabeledEdit;
    leMinDbl: TLabeledEdit;
    leMaxDbl: TLabeledEdit;
    TabSheet3: TTabSheet;
    chkDftBool: TCheckBox;
    TabSheet4: TTabSheet;
    mmSelect: TMemo;
    TabSheet5: TTabSheet;
    leDftStr: TLabeledEdit;
    Panel7: TPanel;
    eHint: TEdit;
    Label1: TLabel;
    chkReadOnly: TCheckBox;
    Panel8: TPanel;
    leDftSel: TLabeledEdit;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    procedure lbPropsClick(Sender: TObject);
    procedure sbOpenClick(Sender: TObject);
    procedure sbSaveClick(Sender: TObject);
    procedure SpinButton1DownClick(Sender: TObject);
    procedure SpinButton1UpClick(Sender: TObject);
    procedure sbRenameClick(Sender: TObject);
    procedure sbNewPropClick(Sender: TObject);
    procedure sbRemoveClick(Sender: TObject);
  private
    { Private declarations }
    mdl: TblkModel;
    pso: TPSO;
    lastAct: TPropVal;
    procedure prop2vis(pv: TPropVal);
    procedure vis2prop(var pv: TPropVal);
    function OpenFile(fn: string; ps: TStrings): boolean;
    function SaveFile(fn: string; ps: TStrings): boolean;
  public
    { Public declarations }
    function Execute(aMdl: TblkModel; aPSO: TPSO): boolean;
    function Config(aMdl: TblkModel; aPSO: TPSO): boolean;
  end;

var frmGenConfig: TfrmGenConfig;

implementation
{$R *.dfm}
uses OptionsU;

function TfrmGenConfig.Execute(aMdl: TblkModel; aPSO: TPSO): boolean;
begin
  Result:= false;
  mdl:= aMdl; pso:= aPSO;
  lbProps.Items.Assign(mdl.props);
  lbProps.ItemIndex:= 0; lastAct:= nil; lbPropsClick(nil);
  if ShowModal = mrCancel then exit;
  mdl.props.Clear;
  mdl.props.Assign(lbProps.Items);
  Result:= true;
end;

function TfrmGenConfig.Config(aMdl: TblkModel; aPSO: TPSO): boolean;
var
  fn: string;
begin
  Result:= false;
  mdl:= aMdl; pso:= aPSO;
  fn:= IncludeTrailingBackslash(TController(pso.Controller).frmOpts.ConfigPath)
      +'config.'+mdl.GetName;
  if not FileExists(fn) then exit;
  OpenFile(fn,mdl.props);
  Result:= true;
end;

function TfrmGenConfig.OpenFile(fn: string; ps: TStrings): boolean;
var
  ini: TIniFile; i: integer; ss: string; pv: TPropVal;
begin
  Result:= false;
  if not FileExists(fn) then exit;
  if not Assigned(ps) then ps:= TStringList.Create;
  ini:= TIniFile.Create(fn);
  ini.ReadSections(ps);
  for i:= 0 to ps.Count-1 do
  begin
    if Assigned(ps.Objects[i]) then pv:= TPropVal(ps.Objects[i])
      else begin
        pv:= TPropVal.Create();
        ps.Objects[i]:= pv;
      end;
    pv.Style:= Str2Style(ini.ReadString(ps[i],'Style','dbl'));
    case pv.Style of
      iiBoolean: pv.bool:= ini.ReadBool(ps[i],'Default',false);
      iiInteger: begin
        pv.int:= ini.ReadInteger(ps[i],'Default',0);
        pv.intMin:= ini.ReadInteger(ps[i],'Min',Low(Integer));
        pv.intMax:= ini.ReadInteger(ps[i],'Max',High(Integer));
      end;
      iiDouble: begin
        pv.dbl:= ini.ReadFloat(ps[i],'Default',0);
        pv.dblMin:= ini.ReadFloat(ps[i],'Min',-Infinite);
        pv.dblMax:= ini.ReadFloat(ps[i],'Max',Infinite);
      end;
      iiString: pv.str:= ini.ReadString(ps[i],'Default','');
      iiSelection: begin
        pv.sel:= ini.ReadInteger(ps[i],'Default',0);
        pv.selItems:= ini.ReadString(ps[i],'List','');
      end;
    end;
    pv.ReadOnly:= ini.ReadBool(ps[i],'ReadOnly',false);
    pv.Hint:= ini.ReadString(ps[i],'Hint','');
  end;
  ini.Free;
  Result:= true;
end;

function TfrmGenConfig.SaveFile(fn: string; ps: TStrings): boolean;
var
  ini: TIniFile; i: integer; ss: string; pv: TPropVal;
begin
  Result:= false;
  if not Assigned(ps) then exit;
  if FileExists(fn) then DeleteFile(fn); // to avoid deleted sections
  if ps.Count=0 then exit;
  ini:= TIniFile.Create(fn);
  for i:= 0 to ps.Count-1 do
  begin
    pv:= TPropVal(ps.Objects[i]);
    ini.WriteString(ps[i],'Style',Style2Str(pv.Style));
    case pv.Style of
      iiBoolean: ini.WriteBool(ps[i],'Default',pv.bool);
      iiInteger: begin
        ini.WriteInteger(ps[i],'Default',pv.int);
        ini.WriteInteger(ps[i],'Min',pv.intMin);
        ini.WriteInteger(ps[i],'Max',pv.intMax);
      end;
      iiDouble: begin
        ini.WriteFloat(ps[i],'Default',pv.dbl);
        ini.WriteFloat(ps[i],'Min',pv.dblMin);
        ini.WriteFloat(ps[i],'Max',pv.dblMax);
      end;
      iiString: ini.WriteString(ps[i],'Default',pv.str);
      iiSelection: begin
        ini.WriteInteger(ps[i],'Default',pv.sel);
        ini.WriteString(ps[i],'List',pv.selItems);
      end;
    end;
    ini.WriteBool(ps[i],'ReadOnly',pv.ReadOnly);
    ini.WriteString(ps[i],'Hint',pv.Hint);
  end;
  ini.Free;
  Result:= true;
end;

procedure TfrmGenConfig.sbOpenClick(Sender: TObject);
var
  i: integer;
begin
  with OpenDialog1 do
  begin
    InitialDir:= TController(pso.Controller).frmOpts.ConfigPath;
    DefaultExt:= mdl.GetName;
    Title:= 'Open configuration file for '+UpperCase(mdl.GetName)+' block As';
    Filter:= 'Configuration file (*.'+mdl.GetName+')|*.'+mdl.GetName;
    FileName:= IncludeTrailingBackslash(InitialDir)+'config.'+mdl.GetName;
    for i:= 0 to lbProps.Items.Count-1 do
      TPropVal(lbProps.Items.Objects[i]).Free;
    lbProps.Items.Clear;
    if not Execute then exit;
    OpenFile(FileName, lbProps.Items);
  end;
  lbProps.ItemIndex:= 0; lastAct:= nil; lbPropsClick(nil);
end;

procedure TfrmGenConfig.sbSaveClick(Sender: TObject);
begin
  with SaveDialog1 do
  begin
    InitialDir:= TController(pso.Controller).frmOpts.ConfigPath;
    DefaultExt:= mdl.GetName;
    Title:= 'Save configuration file for '+UpperCase(mdl.GetName)+' block As';
    Filter:= 'Configuration file (*.'+mdl.GetName+')|*.'+mdl.GetName;
    FileName:= IncludeTrailingBackslash(InitialDir)+'config.'+mdl.GetName;
    if Execute then SaveFile(FileName, lbProps.Items);
  end;
end;

procedure TfrmGenConfig.sbNewPropClick(Sender: TObject);
var
  i: integer; pv: TPropVal;
begin
  i:= lbProps.ItemIndex;
  if not InRange(i, 0,lbProps.Items.Count-1) then exit;
  pv:= TPropVal.Create();
  lbProps.Items.InsertObject(i, InputBox('Create Property', 'Name:',''),pv);
  lbProps.ItemIndex:= i; lbPropsClick(nil);
end;

procedure TfrmGenConfig.sbRemoveClick(Sender: TObject);
var
  i: integer; pv: TPropVal;
begin
  i:= lbProps.ItemIndex;
  if not InRange(i, 0,lbProps.Items.Count-1) then exit;
  TPropVal(lbProps.Items.Objects[i]).Free;
  lbProps.Items.Delete(i);
  i:= EnsureRange(i, 0,lbProps.Items.Count-1);
  lbProps.ItemIndex:= i; lastAct:= nil; lbPropsClick(nil);
end;

procedure TfrmGenConfig.sbRenameClick(Sender: TObject);
var
  i: integer;
begin
  i:= lbProps.ItemIndex;
  if not InRange(i, 0,lbProps.Items.Count-1) then exit;
  lbProps.Items[i]:= InputBox('Property Rename', 'New Name:',lbProps.Items[i]);
end;

procedure TfrmGenConfig.SpinButton1DownClick(Sender: TObject);
var
  i: integer;
begin
  if (lbProps.ItemIndex = -1) or (lbProps.ItemIndex = lbProps.Items.Count-1) then exit;
  i:= lbProps.ItemIndex;
  lbProps.Items.Move(i, i+1);
  lbProps.ItemIndex:= i+1; lbPropsClick(nil);
end;

procedure TfrmGenConfig.SpinButton1UpClick(Sender: TObject);
var
  i: integer;
begin
  if lbProps.ItemIndex < 1 then exit;
  i:= lbProps.ItemIndex;
  lbProps.Items.Move(i, i-1);
  lbProps.ItemIndex:= i-1; lbPropsClick(nil);
end;

procedure TfrmGenConfig.lbPropsClick(Sender: TObject); // update vis controls
var
  i: integer;
begin
  i:= lbProps.ItemIndex;
  if not InRange(i, 0,lbProps.Items.Count-1) then exit;
  vis2prop(lastAct); // save from the last active one before
  lastAct:= TPropVal(lbProps.Items.Objects[i]);
  prop2vis(lastAct); // update vis with the new one
end;

procedure TfrmGenConfig.prop2vis(pv: TPropVal);
var
  i: integer;
begin
  case pv.Style of
    iiBoolean: i:= 2;
    iiInteger: i:= 0;
    iiDouble: i:= 1;
    iiString: i:= 4;
    iiSelection: i:= 3;
  end;
  PageControl1.ActivePageIndex:= i;

  leDftInt.Text:= IntToStr(pv.int);
  leMinInt.Text:= IntToStr(pv.intMin);
  leMaxInt.Text:= IntToStr(pv.intMax);
  leDftDbl.Text:= F2S(pv.dbl);
  leMinDbl.Text:= F2S(pv.dblMin);
  leMaxDbl.Text:= F2S(pv.dblMax);
  chkDftBool.Checked:= pv.bool;
  leDftSel.Text:= IntToStr(pv.sel);
  mmSelect.Lines.CommaText:= pv.selItems;
  leDftStr.Text:= pv.str;
  chkReadOnly.Checked:= pv.ReadOnly;
  eHint.Text:= pv.Hint;
end;

procedure TfrmGenConfig.vis2prop(var pv: TPropVal);
var
  i: integer;
begin
  if not Assigned(pv) then exit;
  case PageControl1.ActivePageIndex of
    0: pv.Style:= iiInteger;
    1: pv.Style:= iiDouble;
    2: pv.Style:= iiBoolean;
    3: pv.Style:= iiSelection;
    4: pv.Style:= iiString;
  end;
  pv.int:= StrToIntDef(leDftInt.Text,pv.int);
  pv.intMin:= StrToIntDef(leMinInt.Text,pv.intMin);
  pv.intMax:= StrToIntDef(leMaxInt.Text,pv.intMax);
  pv.dbl:= StrToFloatDef(leDftDbl.Text,pv.dbl);
  pv.dblMin:= StrToFloatDef(leMinDbl.Text,pv.dblMin);
  pv.dblMax:= StrToFloatDef(leMaxDbl.Text,pv.dblMax);
  pv.bool:= chkDftBool.Checked;
  pv.selItems:= mmSelect.Lines.CommaText;
  i:= StrToIntDef(leDftSel.Text,-1);
  if InRange(i,0,mmSelect.Lines.Count-1) then pv.sel:= i
  else begin
    i:= mmSelect.Lines.IndexOf(leDftSel.Text);
    if InRange(i,0,mmSelect.Lines.Count-1) then pv.sel:= i;
  end;
  pv.str:= leDftStr.Text;
  pv.ReadOnly:= chkReadOnly.Checked;
  pv.Hint:= eHint.Text;
end;

end.
