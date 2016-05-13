(************************************************************************)
(*  Bee22 - Particle Swarm Optimization framework     http://bee22.com  *)
(*  developed by and copyright(c) Teodor Krastev 2015-2016              *)
(************************************************************************)
unit BlockU;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, VCLTee.Series, StrUtils,
  VCLTee.TeEngine, VCLTee.TeeProcs, VCLTee.Chart, Vcl.Grids, Generics.Collections,
  VCLTee.TeeInspector, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.CheckLst, Vcl.Buttons,
  Vcl.ComCtrls, SynEditHighlighter, SynHighlighterPas, SynEdit, Vcl.Menus,
  MVC_U, UtilsU, Vcl.Samples.Spin, pso_algo, VCLTee.TeeEdit, Vcl.ToolWin,
  Vcl.ExtDlgs, Math, fmSourceU;

type
  vPaneType = (vptProp, vptChart, vptSrc, vptLog);

  TfmBlock = class(TFrame, IView)
    Panel1: TPanel;
    pnlProp: TPanel;
    Splitter1: TSplitter;
    pnlLog: TPanel;
    pnlSrc: TPanel;
    Splitter2: TSplitter;
    pnlChart: TPanel;
    Splitter3: TSplitter;
    TeeInspector1: TTeeInspector;
    Chart1: TChart;
    reLog: TRichEdit;
    sbPopupMenu: TSpeedButton;
    PopupMenu1: TPopupMenu;
    pmStepsOver: TMenuItem;
    N1: TMenuItem;
    pnlMenu: TPanel;
    PopupMenu2: TPopupMenu;
    mPropVisible: TMenuItem;
    mPropEnabled: TMenuItem;
    PopupMenu3: TPopupMenu;
    mChartVisible: TMenuItem;
    mChartEnabled: TMenuItem;
    PopupMenu4: TPopupMenu;
    mSrcVisible: TMenuItem;
    mSrcEnabled: TMenuItem;
    PopupMenu5: TPopupMenu;
    mLogVisible: TMenuItem;
    mLogEnabled: TMenuItem;
    lbLog: TLabel;
    lbSrc: TLabel;
    lbChart: TLabel;
    lbProp: TLabel;
    N2: TMenuItem;
    pmConciseLog: TMenuItem;
    N3: TMenuItem;
    mChartConfig: TMenuItem;
    clbSeries: TCheckListBox;
    Panel7: TPanel;
    GroupBox1: TGroupBox;
    rbIters: TRadioButton;
    mClearLog: TMenuItem;
    mConfigLog: TMenuItem;
    mmLogTemplate: TMemo;
    pm1: TMenuItem;
    pm5: TMenuItem;
    pm20: TMenuItem;
    pm100: TMenuItem;
    pm500: TMenuItem;
    pm1000: TMenuItem;
    ChartEditor1: TChartEditor;
    mEditChart: TMenuItem;
    chkClearChartAtStart: TCheckBox;
    btnChartDone: TButton;
    ToolBarLog: TToolBar;
    tbSave: TToolButton;
    tbErase: TToolButton;
    chkClearLogAtStart: TCheckBox;
    tbLogDone: TToolButton;
    ToolButton1: TToolButton;
    SaveTextFileDialog1: TSaveTextFileDialog;
    mMute: TMenuItem;
    fmSource1: TfmSource;
    N4: TMenuItem;
    mHelp: TMenuItem;
    mConfigure: TMenuItem;
    procedure lbPropMouseEnter(Sender: TObject);
    procedure lbPropMouseLeave(Sender: TObject);
    procedure lbPropMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure sbPopupMenuMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure mPropVisibleClick(Sender: TObject);
    procedure mChartConfigClick(Sender: TObject);
    procedure mClearLogClick(Sender: TObject);
    procedure mConfigLogClick(Sender: TObject);
    procedure pm1Click(Sender: TObject);
    procedure mEditChartClick(Sender: TObject);
    procedure btnChartDoneClick(Sender: TObject);
    procedure tbLogDoneClick(Sender: TObject);
    procedure tbEraseClick(Sender: TObject);
    procedure tbSaveClick(Sender: TObject);
    procedure reLogDblClick(Sender: TObject);
    procedure mtest2Click(Sender: TObject);
    procedure pnlPropExit(Sender: TObject);
    procedure mMuteClick(Sender: TObject);
    procedure TeeInspector1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure TeeInspector1KeyPress(Sender: TObject; var Key: Char);
    procedure mHelpClick(Sender: TObject);
  private
    { Private declarations }

    fOnChange: TNotifyEvent;
    fCaption: string;
    ItemsProc, wls: TStrings;

    function GetVPane(idx: vPaneType): boolean;
    procedure SetVPane(idx: vPaneType; vl: boolean);

    function GetEPane(idx: vPaneType): boolean;
    procedure SetEPane(idx: vPaneType; vl: boolean);
    function GetMute(): boolean;
    procedure SetMute(vl: boolean);

    procedure GetComboItems(Sender:TInspectorItem; Proc:TGetItemProc);
    function GetSrsList: string;

    procedure SetSrsList(sl: string);
    function GetTemplList: string;
    procedure SetTemplList(tl: string);
  public
    { Public declarations }
    psoInf: IPSO;
    modelInf: IblkModel;

    menus: array[vptProp..vptLog] of TLabel;
    pnls: array[vptProp..vptLog] of TPanel;
    spls: array[vptProp..vptSrc] of TSplitter;

    procedure Init(capt: string; apsoInf: IPSO);
    destructor Destroy; override;
    procedure UpdateVis;
    procedure Log(txt: string);

    procedure UpdateChartSeries; // recreate series
    procedure UpdateView(PropName: string = ''; PropVal: TPropVal = nil); // important
             // the only way to set prop in view usualy from model
             // if '' and nil - repopulate items
    procedure AddProp(PropNm: string; pv: TPropVal);
    procedure RecreateProps;

    property Caption: string read fCaption;
    property vPane[idx: vPaneType]: boolean read GetvPane write SetVPane;
    property ePane[idx: vPaneType]: boolean read GetePane write SetEPane;
    property Mute: boolean read GetMute write SetMute;

    property SrsList: string read GetSrsList write SetSrsList;
    property TemplList: string read GetTemplList write SetTemplList;

    procedure SetOnChangeEvent(event: TNotifyEvent);
    property OnChange: TNotifyEvent read fOnChange write fOnChange;
  end;

implementation
{$R *.dfm}
uses PythonEngine;

procedure TfmBlock.Init(capt: string; apsoInf: IPSO);
begin
  clbSeries.Items.Clear;
  mmLogTemplate.Lines.Clear;
  reLog.Lines.Clear;
  if Assigned(psoInf) then exit; // only once
  pnls[vptProp]:= pnlProp; spls[vptProp]:= Splitter1; menus[vptProp]:= lbProp;
  pnls[vptChart]:= pnlChart; spls[vptChart]:= Splitter2; menus[vptChart]:= lbChart;
  pnls[vptSrc]:= pnlSrc; spls[vptSrc]:= Splitter3; menus[vptSrc]:= lbSrc;
  pnls[vptLog]:= pnlLog; menus[vptLog]:= lbLog;
  fCaption:= capt; psoInf:= apsoInf;
  ItemsProc:= TStringList.Create; wls:= TStringList.Create;
end;

procedure TfmBlock.btnChartDoneClick(Sender: TObject);
begin
  mChartConfig.Checked:= false;
  mChartConfigClick(nil);
end;

destructor TfmBlock.Destroy;
begin
  FreeAndNil(wls);
  FreeAndNil(ItemsProc);
  inherited;
end;

function TfmBlock.GetvPane(idx: vPaneType): boolean;
begin
  case idx of
    vptProp: Result:= mPropVisible.Checked;
    vptChart: Result:= mChartVisible.Checked;
    vptSrc: Result:= mSrcVisible.Checked;
    vptLog: Result:= mLogVisible.Checked;
  end;
end;

procedure TfmBlock.lbPropMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var p: TPoint; lb: TLabel;
begin
  lb:= TLabel(Sender);
  p.X:= lb.Left; p.Y:= lb.Top+lb.Height;
  p:= ClientToScreen(p);
  lb.PopupMenu.Popup(p.X,p.Y);
end;

procedure TfmBlock.lbPropMouseEnter(Sender: TObject);
begin
  (Sender as TLabel).Font.Color:= clBlue;
end;

procedure TfmBlock.lbPropMouseLeave(Sender: TObject);
var pt: vPaneType;
begin
  if Sender=mSrcEnabled then
    if mSrcEnabled.Checked and not PythonOK then
      mSrcEnabled.Checked:= false;
  for pt:= vptProp to vptLog do
    if ord(pt)=(Sender as TComponent).Tag then
    begin
      if ePane[pt] then Menus[pt].Font.Color:= clBlack
      else Menus[pt].Font.Color:= clGray;
      if pt = vptSrc then
      begin
        if Assigned(modelInf) then
          modelInf.GetSource.enabled := ePane[pt];
        if ePane[pt] then fmSource1.pnlSwitch.Color:= clWhite
        else fmSource1.pnlSwitch.Color:= clSilver;
      end;
    end;
end;

procedure TfmBlock.mChartConfigClick(Sender: TObject);
begin
  vPane[vptChart]:= true;
  Chart1.Visible:= not mChartConfig.Checked;
  Panel7.Visible:= mChartConfig.Checked;
  if not mChartConfig.Checked then UpdateChartSeries;
end;

procedure TfmBlock.mClearLogClick(Sender: TObject);
begin
   reLog.Lines.Clear;
end;

procedure TfmBlock.mConfigLogClick(Sender: TObject);
begin
  vPane[vptLog]:= true;
  reLog.Visible:= not mConfigLog.Checked;
  mmLogTemplate.Visible:= mConfigLog.Checked;
  ToolBarLog.Visible:= mConfigLog.Checked;
end;

procedure TfmBlock.mEditChartClick(Sender: TObject);
begin
  ChartEditor1.Execute;
end;

procedure TfmBlock.mHelpClick(Sender: TObject);
begin
  HyperlinkExe('http://bee22.com/?pg=manual/blocks.htm');
end;

procedure TfmBlock.mMuteClick(Sender: TObject);
begin
  Mute:= mMute.Checked;
end;

procedure TfmBlock.mPropVisibleClick(Sender: TObject);
begin
  UpdateVis;
end;

procedure TfmBlock.mtest2Click(Sender: TObject);
begin
  TeeInspector1.Options:= TeeInspector1.Options+[goEditing,goAlwaysShowEditor];
end;

procedure TfmBlock.pm1Click(Sender: TObject);
begin
  pmStepsOver.Tag:= (Sender as TMenuItem).Tag;
  pmStepsOver.Caption:= 'Steps Over ('+IntToStr(pmStepsOver.Tag)+')';
  (Sender as TMenuItem).Checked:= true;
end;

procedure TfmBlock.pnlPropExit(Sender: TObject);
begin
  RecreateProps;
end;

procedure TfmBlock.reLogDblClick(Sender: TObject);
begin
  mConfigLog.Checked:= true;
  mConfigLogClick(nil);
end;

procedure TfmBlock.sbPopupMenuMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var p: TPoint; btn: TSpeedButton;
begin
  btn:= TSpeedButton(Sender);
  p.X:= btn.Left; p.Y:= btn.Top+btn.Height;
  p:= ClientToScreen(p);
  mConfigure.Visible:= Assigned(modelInf.getOnConfigure);
  if mConfigure.Visible then mConfigure.OnClick:= modelInf.getOnConfigure;
  btn.PopupMenu.Popup(p.X,p.Y);
end;

procedure TfmBlock.UpdateVis;
var pt: vPaneType; k: integer;
begin
  for pt:= vptProp to vptSrc do // reset vis
  begin
    pnls[pt].Visible:= false;
    spls[pt].Visible:= false;
  end;
  pnls[vptLog].Visible:= false;

  k:= Panel1.Height;
  for pt:= vptSrc downto vptProp do
  begin
    spls[pt].Visible:= vPane[pt];
    pnls[pt].Visible:= vPane[pt];
    Application.ProcessMessages;
  end;
  pnls[vptLog].Visible:= vPane[vptLog];
end;

procedure TfmBlock.GetComboItems(Sender:TInspectorItem; Proc:TGetItemProc);
var ss: string; i: integer;
begin
  wls.CommaText:= ItemsProc.Values[Sender.Caption];
  for ss in wls do
    Proc(ss);
end;

function TfmBlock.GetSrsList;
var
  i,j: integer;
begin
  Result:= '';
  for i:= 0 to clbSeries.Items.Count-1 do
  begin
    if not clbSeries.Checked[i] then continue;
    Result:= Result+clbSeries.Items[i]+'|';
  end;
  if Chart1.SeriesCount=0 then exit;
  Result:= LeftStr(Result,length(Result)-1);
end;

procedure TfmBlock.UpdateChartSeries; // recreate series
var
  i,j: integer; MyAxis : TChartAxis; sr: TChartSeries;
begin
  Chart1.SeriesList.Clear; Chart1.CustomAxes.Clear;
  for i:= 0 to clbSeries.Items.Count-1 do
  begin
    if not clbSeries.Checked[i] then continue;
    MyAxis := TChartAxis.Create( Chart1 );
    sr:= Chart1.AddSeries(TFastLineSeries);
    sr.CustomVertAxis := MyAxis;
    sr.Title:= clbSeries.Items[i];
  end;
  if Chart1.CustomAxes.Count>1 then
  begin
    for sr in Chart1.SeriesList do
      sr.CustomVertAxis.Labels:= false;
  end;
end;

procedure TfmBlock.SetSrsList(sl: string);
var i,j: integer;
begin
  for i:= 0 to clbSeries.Items.Count-1 do
    clbSeries.Checked[i]:= pos('|'+LowerCase(clbSeries.Items[i])+'|','|'+LowerCase(sl)+'|')>0;
end;

function TfmBlock.GetTemplList: string;
begin
  mmLogTemplate.Lines.Delimiter:= '|';
  mmLogTemplate.Lines.StrictDelimiter:= true;
  Result:= mmLogTemplate.Lines.DelimitedText;
end;

procedure TfmBlock.SetTemplList(tl: string);
begin
  mmLogTemplate.Lines.Delimiter:= '|';
  mmLogTemplate.Lines.StrictDelimiter:= true;
  mmLogTemplate.Lines.DelimitedText:= tl;
end;

procedure TfmBlock.Log(txt: string);
begin
  if reLog.Lines.Count>1100 then
    while reLog.Lines.Count>1000 do reLog.Lines.Delete(0);
  reLog.Lines.Add(txt);
  if reLog.CanFocus then
  begin
    try
     reLog.SetFocus;
    except
      on EInvalidOperation do exit;
    end;
    reLog.SelStart := reLog.GetTextLen;
    reLog.Perform(EM_SCROLLCARET, 0, 0);
  end;
end;

procedure TfmBlock.UpdateView(PropName: string = ''; PropVal: TPropVal = nil);
var i,iters: integer; ii: TInspectorItem; sr: TChartSeries; ss,st,sq: string;
begin
  if (PropName='') and (PropVal=nil) then
  begin
    RecreateProps; exit;
  end;
  if Mute then exit;
  iters:= psoInf.GetIterations;
  if iters=1 then
  begin
    if chkClearChartAtStart.Checked then
      for sr in Chart1.SeriesList do
        sr.Clear;
    if chkClearLogAtStart.Checked then
      reLog.Lines.Clear;
  end;
  if (iters mod pmStepsOver.Tag)<>0 then exit; // steps over
  if vPane[vptProp] and ePane[vptProp] then  // properties
  begin
    for i:= 0 to TeeInspector1.Items.Count-1 do
      if SameText(PropName,TeeInspector1.Items[i].Caption) then
      begin
        TeeInspector1.Items[i].Enabled:= not PropVal.ReadOnly;
        if PropVal.Style=iiSelection
          then TeeInspector1.Items[i].Value:= variant(PropVal.AsString)
          else TeeInspector1.Items[i].Value:= PropVal.AsVar;
        break;
      end;
  end;
  if vPane[vptChart] and ePane[vptChart] and (Chart1.SeriesCount>0) then // chart
  begin
    for sr in Chart1.SeriesList do
      if SameText(sr.Title,PropName) then
        sr.AddXY(psoInf.GetIterations,PropVal.AsDouble);
  end;
  if vPane[vptLog] and ePane[vptLog] then // log
  begin
    if (PropName='@log') then  // free style loging
    begin
      if (PropVal.Style=iiString) then
        Log(PropVal.str)
      else Log(PropVal.str+PropVal.AsString);
    end;
    if (mmLogTemplate.Lines.Count>0) then
    begin
      st:= '$'+LowerCase(PropName)+'$';
      for ss in mmLogTemplate.Lines do
        if pos(st,LowerCase(ss))>0 then
        begin
          sq:= ReplaceStr(ss,st,PropVal.AsString); // => $best.fitness$ ~~~
          st:= '$i$';
          if pos(st,LowerCase(sq))>0 then // iteractions
            sq:= ReplaceStr(sq,st,'#'+IntToStr(iters));
          Log(sq);
        end;
    end;
  end;
end;

procedure TfmBlock.AddProp(PropNm: string; pv: TPropVal);
var ii: TInspectorItem;
begin
  ii:= TeeInspector1.Items.Add(pv.Style,PropNm,OnChange);
  if pv.Style=iiSelection
    then begin
      ItemsProc.Add(PropNm+'='+pv.selItems);
      wls.CommaText:= pv.selItems;
      ii.OnGetItems:= GetComboItems;
      ii.Value:= wls[pv.sel];
    end
    else begin
      ii.Value:= pv.AsVar;
    end;
  ii.Enabled:= not pv.ReadOnly;
  if (pv.Style=iiDouble) or (pv.Style=iiInteger) then
    clbSeries.Items.Add(PropNm);
end;

procedure TfmBlock.RecreateProps; // fixing a bug in teeInspector
var i: integer; ss,st: string;
begin
  if modelInf=nil then exit;
  TeeInspector1.Clear; Application.ProcessMessages;
  TeeInspector1.Header.Update; ItemsProc.Clear;
  st:= SrsList; clbSeries.Items.Clear;
  i:= 0; ss:= modelInf.GetPropName(i);
  while ss<>'' do
  begin
    AddProp(ss,modelInf.GetProp(ss));
    inc(i); ss:= modelInf.GetPropName(i);
  end;
  SrsList:= st;
end;

procedure TfmBlock.SetOnChangeEvent(event: TNotifyEvent);
begin
  FOnChange:= event;
end;

procedure TfmBlock.SetVPane(idx: vPaneType; vl: boolean);
begin
  case idx of
    vptProp: mPropVisible.Checked:= vl;
    vptChart: mChartVisible.Checked:= vl;
    vptSrc: mSrcVisible.Checked:= vl;
    vptLog: mLogVisible.Checked:= vl;
  end;
  UpdateVis;
end;

procedure TfmBlock.tbSaveClick(Sender: TObject);
begin
  if SaveTextFileDialog1.Execute then
    reLog.Lines.SaveToFile(SaveTextFileDialog1.FileName);
end;

procedure TfmBlock.TeeInspector1KeyPress(Sender: TObject; var Key: Char);
begin
  if Key=#13 then Key:= #0;  
end;

procedure TfmBlock.TeeInspector1MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var Col,Row: integer; pv: TPropVal; ss,st: string;
begin
  TeeInspector1.MouseToCell(X,Y, Col,Row); Dec(Row);
  if not InRange(Row, 0,TeeInspector1.Items.Count-1) then exit;
  pv:= modelInf.GetProp(TeeInspector1.Items[Row].Caption);
  if not Assigned(pv) then exit;
  ss:= pv.Hint;
  if trim(ss)='' then ss:= TeeInspector1.Items[Row].Caption;
  if pv.ReadOnly then st:= '(READ ONLY)'
                 else st:= '['+pv.rangeAsString+']';
  TeeInspector1.Hint:= '  '+ss+'  '+st;
end;

procedure TfmBlock.tbEraseClick(Sender: TObject);
begin
  reLog.Lines.Clear;
end;

procedure TfmBlock.tbLogDoneClick(Sender: TObject);
begin
  mConfigLog.Checked:= false;
  mConfigLogClick(nil);
end;

function TfmBlock.GetEPane(idx: vPaneType): boolean;
begin
  case idx of
    vptProp: Result:= mPropEnabled.Checked;
    vptChart: Result:= mChartEnabled.Checked;
    vptSrc: Result:= mSrcEnabled.Checked and PythonOK;
    vptLog: Result:= mLogEnabled.Checked;
  end;
end;

procedure TfmBlock.SetEPane(idx: vPaneType; vl: boolean);
begin
  case idx of
    vptProp: mPropEnabled.Checked:= vl;
    vptChart: mChartEnabled.Checked:= vl;
    vptSrc: mSrcEnabled.Checked:= vl and PythonOK;
    vptLog: mLogEnabled.Checked:= vl;
  end;
  lbPropMouseLeave(menus[idx]);
end;

function TfmBlock.GetMute(): boolean;
begin
  Result:= mMute.Checked;
end;

procedure TfmBlock.SetMute(vl: boolean);
var pnl: TPanel;
begin
  mMute.Checked:= vl;
  if vl then pnlMenu.Color:= clBtnFace
        else pnlMenu.Color:= clWhite;
  if vl then Panel1.BorderStyle:= bsSingle
        else Panel1.BorderStyle:= bsNone;
  pnlMenu.Enabled:= not vl;
  for pnl in pnls do
    pnl.Enabled:= pnlMenu.Enabled;
end;

end.
