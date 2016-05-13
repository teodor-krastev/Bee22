(************************************************************************)
(*  Bee22 - Particle Swarm Optimization framework     http://bee22.com  *)
(*  developed by and copyright(c) Teodor Krastev 2015-2016              *)
(************************************************************************)
unit fmScanPropU;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,  Vcl.StdCtrls, Types,
  Vcl.Grids, Vcl.ExtCtrls, IniFiles, VCLTee.TeeInspector, Math,
  MVC_U, UtilsU, Vcl.CheckLst;

const noModel = '<none>';

type
  TScanPropStatus = (spsNone, spsInvalid, spsValid);
  rScanProp = record
    mdlName, propName: string;
    Style: TInspectorItemStyle;
    SelItems: string; // commatext pairs name=index (SelList)
    sFrom, sTo, sBy: double; // mask int or sel types
  end;

  TfmScanProp = class(TFrame)
    Panel1: TPanel;
    sgProp: TStringGrid;
    cbModel: TComboBox;
    cbProp: TComboBox;
    stCaption: TStaticText;
    lbStyle: TLabel;
    chkSelect: TCheckListBox;
    procedure cbModelChange(Sender: TObject);
    procedure cbPropChange(Sender: TObject);
    procedure chkSelectClickCheck(Sender: TObject);
  private
    { Private declarations }
    cp: TCtrlPort;
    fCurrentValue, StartValue: double;
    SelList: TStrings;

    EnabledOnly, fSelSel: boolean; // true (IN, control) or false (OUT, result) props
    function GetScanVar: TPropVal;
    procedure SetScanVar(pv: TPropVal);

    function GetScanProp: rScanProp;
    procedure SetScanProp(sp: rScanProp);
    procedure SetSelSel(bl: boolean);
    procedure SetCV(cv: double);
  public
    { Public declarations }
    procedure Init(acp: TCtrlPort; aEnabledOnly: boolean; Caption: string);
    destructor Destroy; override;
    procedure ReadIniSection(ini: TIniFile; SecName: string);
    procedure WriteIniSection(ini: TIniFile; SecName: string);
    function Status: TScanPropStatus;

    function Start: TPropVal;
    function Next: boolean;
    procedure Reinstate;

    property ScanProp: rScanProp read GetScanProp write SetScanProp;
    property SelSel: boolean read fSelSel write SetSelSel;
    property CurrentValue: double read fCurrentValue write SetCV;
  end;

implementation
{$R *.dfm}

function TfmScanProp.GetScanVar: TPropVal;
begin
  Result:= nil;
  if Status()=spsValid then
    Result:= cp.GetProp(cbModel.Text, cbProp.Text);
end;

procedure TfmScanProp.SetScanVar(pv: TPropVal);
begin
  assert(Assigned(pv)); //  not (Status()=spsNone) and
  cp.SetProp(cbModel.Text,cbProp.Text, pv);
  cp.Notify(cbModel.Text,cbProp.Text);
end;

function TfmScanProp.GetScanProp: rScanProp;
var
  pv: TPropVal;
begin
  Result.mdlName:= cbModel.Text; Result.propName:= cbProp.Text;
  pv:= GetScanVar; if not Assigned(pv) then exit;
  if cbModel.Text <> NoModel  then Result.Style:= pv.Style;
  if Result.Style=iiSelection then
  begin
    chkSelectClickCheck(nil); // update SelList
    Result.SelItems:= SelList.CommaText;
  end;
  if (Result.Style=iiDouble) or (Result.Style=iiInteger) then
  begin
    Result.sFrom:= StrToFloatDef(sgProp.Cells[1,1],0);
    Result.sTo:=  StrToFloatDef(sgProp.Cells[2,1],100);
    Result.sBy:= StrToFloatDef(sgProp.Cells[3,1],1);
  end;
end;

procedure TfmScanProp.SetScanProp(sp: rScanProp);
var i: integer;
begin
  sgProp.Cells[1,1]:= ''; sgProp.Cells[2,1]:= ''; sgProp.Cells[3,1]:= '';

  i:= cbModel.Items.IndexOf(sp.mdlName);
  cbModel.ItemIndex:= EnsureRange(i,0,cbModel.Items.Count-1); cbModelChange(nil);
  if SameText(noModel,sp.mdlName) then exit;

  i:= cbProp.Items.IndexOf(sp.propName);
  if i=-1 then exit; // unknown prop name
  cbProp.ItemIndex:= i; cbPropChange(nil);

  sgProp.Cells[1,1]:= F2S(sp.sFrom);
  sgProp.Cells[2,1]:= F2S(sp.sTo);
  sgProp.Cells[3,1]:= F2S(sp.sBy);

  if sp.Style<>iiSelection then exit;
  SelList.CommaText:= sp.selItems;
  for i:= 0 to chkSelect.Items.Count-1 do
    chkSelect.Checked[i]:= SelList.IndexOfName(chkSelect.Items[i])>-1;
end;

procedure TfmScanProp.cbModelChange(Sender: TObject);
var mn,pn: string; i: integer; pv: TPropVal;
begin
  cbProp.Items.Clear;
  mn:= cbModel.Text;
  if SameText(noModel,mn) then
  begin
    sgProp.Cells[1,1]:= ''; sgProp.Cells[2,1]:= ''; sgProp.Cells[3,1]:= '';
    chkSelect.Items.Clear; chkSelect.Height:= 40;
    exit;
  end;
  for i:= 0 to cp.propCount(mn)-1 do
  begin
    pn:= cp.GetPropName(mn,i);
    pv:= cp.GetProp(mn, pn);
    if EnabledOnly and pv.ReadOnly then continue;
    if (pv.Style=iiDouble) or (pv.Style=iiInteger) or
       ((pv.Style=iiSelection) and EnabledOnly) then
      cbProp.Items.Add(pn);
  end;
end;

procedure TfmScanProp.cbPropChange(Sender: TObject);
var
  pv: TPropVal; i: byte;
begin
  pv:= cp.GetProp(cbModel.Text, cbProp.Text);
  if Assigned(pv) then lbStyle.Caption:= 'of '+Style2Str(pv.Style);
  SetSelSel(pv.Style=iiSelection);
  if not SelSel then exit;
  chkSelect.Items.CommaText:= pv.selItems;
  chkSelect.CheckAll(cbChecked);
  chkSelect.Height:= ceil(chkSelect.Items.Count/2)*chkSelect.ItemHeight+23;
end;

procedure TfmScanProp.chkSelectClickCheck(Sender: TObject);
var
  i: integer;
begin
  SelList.Clear;
  for i:= 0 to chkSelect.Items.Count-1 do
    if chkSelect.Checked[i] then
      SelList.Add(chkSelect.Items[i]+'='+IntToStr(i));
end;

procedure TfmScanProp.SetSelSel(bl: boolean);
begin
  chkSelect.Visible:= bl;
  sgProp.Visible:= not bl and EnabledOnly;
  fSelSel:= bl;
end;

procedure TfmScanProp.SetCV(cv: double);
var
  d: double; i: integer;
begin
  case GetScanVar.Style of
    iiDouble: begin
      d:= cv; sgProp.Cells[0,1]:= F2S(d);
    end;
    iiInteger: begin
      d:= round(cv); sgProp.Cells[0,1]:= F2S(d);
    end;
    iiSelection: begin
      d:= round(cv); //

      //sgProp.Cells[0,1]:= SelList.In ValueFromIndex[round(d)]; show the current somewhere
    end;
  end;
  fCurrentValue:= d;
end;

procedure TfmScanProp.Init(acp: TCtrlPort; aEnabledOnly: boolean; Caption: string);
var i: integer; ss: string;
begin
  cp:= acp; EnabledOnly:= aEnabledOnly; stCaption.Caption:= Caption;
  cbModel.Items.Clear; SelList:= TStringList.Create;
  for i:= 0 to cp.modelCount-1 do
    cbModel.Items.Add(cp.modelNameByIdx(i));
  cbModel.ItemIndex:= 0; cbModelChange(nil);

  sgProp.Visible:= EnabledOnly;
  if not EnabledOnly then
  begin
    stCaption.Font.Color:= clNavy; stCaption.Color:= $00AA6C55;
    exit;
  end;
  sgProp.Cells[0,0]:= 'Current'; sgProp.Cells[1,0]:= ' From';
  sgProp.Cells[2,0]:= '  To'; sgProp.Cells[3,0]:= '  By';
end;

destructor TfmScanProp.Destroy;
begin
  SelList.Free;
  inherited;
end;

procedure TfmScanProp.ReadIniSection(ini: TIniFile; SecName: string);
var
  pv: TPropVal; sp: rScanProp;
begin
  sp.mdlName:= ini.ReadString(SecName,'modelName','');
  sp.propName:= ini.ReadString(SecName,'propName','');
  pv:= cp.GetProp(sp.mdlName, sp.propName);
  if Assigned(pv) then sp.Style:= pv.Style
  else sp.Style:= iiDouble;
  if sp.Style=iiSelection then
    sp.SelItems:= ini.ReadString(SecName,'SelItems','')
  else begin
    sp.sFrom:= ini.ReadFloat(SecName,'From',0);
    sp.sTo:= ini.ReadFloat(SecName,'To',100);
    sp.sBy:= ini.ReadFloat(SecName,'By',1);
  end;
  ScanProp:= sp;
end;

procedure TfmScanProp.WriteIniSection(ini: TIniFile; SecName: string);
var
  sp: rScanProp;
begin
  sp:= ScanProp;
  ini.WriteString(SecName,'modelName',sp.mdlName);
  ini.WriteString(SecName,'propName',sp.propName);
  if sp.Style=iiSelection then
    ini.WriteString(SecName,'SelItems',sp.SelItems)
  else begin
    ini.WriteFloat(SecName,'From',sp.sFrom);
    ini.WriteFloat(SecName,'To',sp.sTo);
    ini.WriteFloat(SecName,'By',sp.sBy);
  end;
end;

function TfmScanProp.Status: TScanPropStatus;
var
  pv: TPropVal; sp: rScanProp;
begin
  Result:= spsInvalid;
  if cbModel.Text = NoModel then
  begin
    Result:= spsNone; exit;
  end;
  if (cbModel.Text = '') or (cbProp.Text = '') then exit;
  pv:= cp.GetProp(cbModel.Text, cbProp.Text);
  if not Assigned(pv) then exit;
  if not((pv.Style=iiDouble) or (pv.Style=iiInteger) or (pv.Style=iiSelection))
    then exit;
  if pv.Style=iiSelection then
  begin
    chkSelectClickCheck(nil); // update SelList
    if SelList.CommaText='' then
      raise Exception.Create('Error: Some item(s) must be checked');
  end;
  if (pv.Style=iiDouble) or (pv.Style=iiInteger) then
  begin
    sp.sFrom:= StrToFloatDef(sgProp.Cells[1,1],0);
    sp.sTo:=  StrToFloatDef(sgProp.Cells[2,1],100);
    sp.sBy:= StrToFloatDef(sgProp.Cells[3,1],1);

    if sp.sFrom >= sp.sTo then exit; //('Error: "From" value must be smaller than "To" value');
    if IsZero(sp.sBy, epsilon3) then exit; //('Error: "By" value must be positive');
  end;
  Result:= spsValid;
end;
//¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬

function TfmScanProp.Start: TPropVal;
var
  i: integer;
begin
  chkSelectClickCheck(nil);
  Result:= GetScanVar;
  StartValue:= Result.AsDouble;
  if Result.Style=iiSelection then
  begin
    i:= StrToIntDef(SelList.ValueFromIndex[0],0);
    Result.SetDouble(i); CurrentValue:= i;
  end
  else begin
    Result.SetDouble(ScanProp.sFrom); CurrentValue:= ScanProp.sFrom;
  end;
  SetScanVar(Result);
  Enabled:= false;
end;

function TfmScanProp.Next: boolean; // returns validity
var
  pv: TPropVal; d: double; i: integer; found: boolean;
begin
  pv:= GetScanVar; found:= true;
  case pv.Style of
    iiDouble: d:= CurrentValue + ScanProp.sBy;
    iiInteger: d:= round(CurrentValue + ScanProp.sBy);
    iiSelection: begin
      found:= false;
      for i:= 0 to SelList.Count-1 do
        if SameValue(StrToInt(SelList.ValueFromIndex[i]),CurrentValue,Epsilon3) then
        begin
          found:= i < (SelList.Count-1);
          if found then
            d:= StrToInt(SelList.ValueFromIndex[i+1]);
          break;
        end;
    end;
  end;
  pv.SetDouble(d);
  CurrentValue:= d;
  SetScanVar(pv);
  if pv.Style=iiSelection then Result:= found
  else Result:= d < (ScanProp.sTo + Epsilon3);
end;

procedure TfmScanProp.Reinstate;
var
  pv: TPropVal;
begin
  pv:= GetScanVar;
  pv.SetDouble(StartValue); CurrentValue:= StartValue;
  SetScanVar(pv);
  Enabled:= true;
end;

end.
