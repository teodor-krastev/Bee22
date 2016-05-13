(************************************************************************)
(*  Bee22 - Particle Swarm Optimization framework     http://bee22.com  *)
(*  developed by and copyright(c) Teodor Krastev 2015-2016              *)
(************************************************************************)
unit fmReportU;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Math,
  fmScanPropU, ReportDataU, VCLTee.Series, VCLTee.TeEngine, VCLTee.TeeProcs,
  VCLTee.Chart, Vcl.ValEdit, Vcl.StdCtrls, Vcl.Grids, Vcl.ToolWin, Vcl.ExtCtrls,
  Vcl.Samples.Spin, Types, UtilsU, VCLTee.TeeSurfa, VCLTee.TeeEdit,
  VCLTee.TeeComma, VCLTee.TeePoin3, Vcl.ImgList, VCLTee.TeeTriSurface,
  VCLTee.CandleCh, VCLTee.TeeTools, Clipbrd, Vcl.Buttons, VCLTee.TeeInspector;

type
  TfmReport = class(TFrame)
    PageControl1: TPageControl;
    tsOneProp: TTabSheet;
    tsTwoProps: TTabSheet;
    Panel1: TPanel;
    Panel2: TPanel;
    Splitter1: TSplitter;
    sgOne: TStringGrid;
    mmOne: TMemo;
    Splitter2: TSplitter;
    Panel3: TPanel;
    Splitter4: TSplitter;
    sgTwo: TStringGrid;
    Splitter5: TSplitter;
    Panel4: TPanel;
    gbPropSelect: TGroupBox;
    rbSp1: TRadioButton;
    rbSp2: TRadioButton;
    TrackBar1: TTrackBar;
    stFixedPropValue: TStaticText;
    sbFixedPropValue: TSpinButton;
    Splitter3: TSplitter;
    vleTwo: TValueListEditor;
    rgSelParam: TRadioGroup;
    ChartEditor1: TChartEditor;
    chartOne: TChart;
    srsUserDefLn: TLineSeries;
    srsOnTargetLn: TLineSeries;
    srsIterCountLn: TLineSeries;
    srsOutCountLn: TLineSeries;
    chartTwo: TChart;
    ChartEditor2: TChartEditor;
    TeeCommander1: TTeeCommander;
    chkPointSrs: TCheckBox;
    srsPoint: TPoint3DSeries;
    ImageList1: TImageList;
    srsVector: TVector3DSeries;
    ChartTool1: TColorLineTool;
    Panel5: TPanel;
    lbRetr: TLabel;
    srsOnTargetBr: TBarSeries;
    srsOutCountBr: TBarSeries;
    srsIterCountBr: TBarSeries;
    srsUserDefBr: TBarSeries;
    pnlProps: TPanel;
    lbProp1: TLabel;
    lbSeparator: TLabel;
    lbProp2: TLabel;
    lbUserDef: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    pnlBtns: TPanel;
    sbCopyTable: TSpeedButton;
    spCopyChart: TSpeedButton;
    pnlProgress: TPanel;
    lbStatCount: TLabel;
    tbProgress: TTrackBar;
    procedure sgTwoSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure rgSelParamClick(Sender: TObject);
    procedure rbSp1Click(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
    procedure sbFixedPropValueDownClick(Sender: TObject);
    procedure sbFixedPropValueUpClick(Sender: TObject);
    procedure Panel3Resize(Sender: TObject);
    procedure chartOneDblClick(Sender: TObject);
    procedure chartTwoDblClick(Sender: TObject);
    procedure sgOneSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure sbCopyTableClick(Sender: TObject);
    procedure spCopyChartClick(Sender: TObject);
    procedure mmOneEnter(Sender: TObject);
  private
    { Private declarations }
    fSignDigits: integer;
    fScanning: boolean;
    procedure SetScanning(vl: boolean);
    function PageOne: boolean;
    procedure Update4NProp;
    procedure CopyTwo2Series;
    function SelectedResult(ix,iy: integer): string;
    procedure UpdateTableIdx;
  public
    { Public declarations }
    rDt: TReportData;
    Caption: string;
    closing: boolean;
    procedure Config(aIn1,aIn2,aOut1: rScanProp; aDim: integer);
    procedure ConfigOne();
    procedure ConfigTwo();
    destructor Destroy; override;
    procedure Clear(what: integer=4); // 1,2, 3->both  4-> 3 + data

    procedure UpdateFromData;

    procedure AddRow2One(y: double; iy: integer; dt: rOptimRslt);
    procedure Add(x,y: double; dt: rOptimRslt);
    function IsRetrieved: boolean;
    property Scanning: boolean read fScanning write SetScanning;
    property SignDigits: integer read fSignDigits write fSignDigits;
  end;

implementation
{$R *.dfm}

procedure TfmReport.ConfigOne();
var i,j: integer;
begin
  Clear(1);
  sgOne.ColCount:= rDt.dim+9;
  sgOne.Cells[0,0]:= rDt.PropY.mdlName+':'+rDt.PropY.propName;
  sgOne.Cells[1,0]:= rDt.UserDef;
  sgOne.Cells[2,0]:= 'Best.Fit';
  sgOne.Cells[3,0]:= 'Swarm.Size';
  sgOne.Cells[4,0]:= 'Aver.Speed';
  sgOne.Cells[5,0]:= 'Iter.Count';
  sgOne.Cells[6,0]:= 'Out.Count';
  sgOne.Cells[7,0]:= 'On.Target';
  for i:= 0 to rDt.dim-1 do
    sgOne.Cells[i+8,0]:= 'var.'+IntToStr(i);
  sgOne.Cells[rDt.dim+8,0]:= 'Term.Cond';
  sgOne.ColWidths[rDt.dim+8]:= 140;
  rgSelParam.Items.Assign(sgOne.Rows[0]);
  rgSelParam.Items.Delete(0);
  rgSelParam.Items[0]:= 'User.Def';
  rgSelParam.Items.Delete(rgSelParam.Items.Count-1);
  lbProp1.Caption:= rDt.PropY.mdlName+':'+rDt.PropY.propName;

  if rDt.PropY.Style=iiSelection then
  begin
    ChartTool1.Active:= false;
    srsUserDefLn.ParentChart:= nil;   srsOnTargetLn.ParentChart:= nil;
    srsIterCountLn.ParentChart:= nil; srsOutCountLn.ParentChart:= nil;
    srsUserDefBr.ParentChart:= chartOne;   srsOnTargetBr.ParentChart:= chartOne;
    srsIterCountBr.ParentChart:= chartOne; srsOutCountBr.ParentChart:= chartOne;
    chartOne.BottomAxis.Grid.Visible:= false;
  end
  else begin
    ChartTool1.Active:= true;
    srsUserDefLn.ParentChart:= chartOne;   srsOnTargetLn.ParentChart:= chartOne;
    srsIterCountLn.ParentChart:= chartOne; srsOutCountLn.ParentChart:= chartOne;
    srsUserDefBr.ParentChart:= nil;   srsOnTargetBr.ParentChart:= nil;
    srsIterCountBr.ParentChart:= nil; srsOutCountBr.ParentChart:= nil;
    chartOne.BottomAxis.Grid.Visible:= true;
  end;
end;

procedure TfmReport.ConfigTwo();
begin
  rbSp1.Caption:= lbProp1.Caption;
  rbSp2.Caption:= rDt.PropX.mdlName+':'+rDt.PropX.propName;
  lbProp2.Caption:= rbSp2.Caption;
  rbSp2.Checked:= true;
  TeeCommander1.ButtonPrint.Visible:= False;
  TeeCommander1.ButtonSave.Visible:= False;
  TeeCommander1.DefaultButton := tcbRotate;
  fSignDigits:= 5; // default
end;

procedure TfmReport.Config(aIn1,aIn2,aOut1: rScanProp; aDim: integer);
var i,j: integer; d: double; bb: boolean;
begin
  Clear; closing:= false;
  if aIn2.mdlName=noModel then
    rDt:= TReportData.Create(aIn1)
  else
    rDt:= TReportData.Create(aIn2,aIn1);
  rDt.Dim:= aDim;
  rDt.UserDef:= aOut1.mdlName+':'+aOut1.propName; lbUserDef.Caption:= rDt.UserDef;

  Update4NProp;
  ConfigOne();
  if rDt.TwoProps then
    ConfigTwo();
end;

procedure TfmReport.Panel3Resize(Sender: TObject);
begin
  sgTwo.DefaultColWidth:= EnsureRange(floor((sgTwo.Width-3)/sgTwo.ColCount),40, 150);
end;

procedure TfmReport.rbSp1Click(Sender: TObject);
begin
  if scanning then
  begin
    rbSp2.Checked:= true; exit;
  end;
  if rbSp1.Checked then Trackbar1.Max:= rDt.yCount-1
  else Trackbar1.Max:= rDt.xCount-1;
  TrackBar1Change(Sender);
end;

procedure TfmReport.TrackBar1Change(Sender: TObject);
var
  aIn: rScanProp;
  i, ix, iy: Integer;
  idx: TDoubleDynArray;
begin
  if rbSp1.Checked then aIn := rDt.PropY
  else aIn := rDt.PropX;
  stFixedPropValue.Caption := F2S(TrackBar1.Position * aIn.sBy + aIn.sFrom);
  if scanning then exit;
  Clear(1);
  if rbSp1.Checked then
  begin
    for i := 0 to length(rDt.xIdx) - 1 do
      AddRow2One(rDt.xIdx[i], i, rDt[i, TrackBar1.Position]);
  end
  else begin
    for i := 0 to length(rDt.yIdx) - 1 do
      AddRow2One(rDt.yIdx[i], i, rDt[TrackBar1.Position, i]);
  end;
end;

procedure CopyStringGrid(sg: TStringGrid);
var i,j: integer; ss: string;
begin ss:= '';
  for i:= 0 to sg.RowCount-1 do
  begin
    for j:= 0 to sg.ColCount-1 do
        ss:= ss+sg.Cells[j,i]+#9;
    ss[length(ss)]:= #13;
  end;
  Clipboard.AsText:= ss;
end;

procedure TfmReport.sbCopyTableClick(Sender: TObject);
begin
  if PageOne then CopyStringGrid(sgOne)
  else CopyStringGrid(sgTwo);
end;

procedure TfmReport.spCopyChartClick(Sender: TObject);
begin
  if PageOne then ChartOne.CopyToClipboardMetafile(true)
  else ChartTwo.CopyToClipboardMetafile(true);
end;

procedure TfmReport.sbFixedPropValueDownClick(Sender: TObject);
begin
  if scanning then exit;
  TrackBar1.Position:= TrackBar1.Position - 1;
  TrackBar1Change(Sender);
end;

procedure TfmReport.sbFixedPropValueUpClick(Sender: TObject);
begin
  if scanning then exit;
  TrackBar1.Position:= TrackBar1.Position + 1;
  TrackBar1Change(Sender);
end;

procedure TfmReport.rgSelParamClick(Sender: TObject);
var ix,iy: integer;
begin
  if scanning then exit;
  for ix:= 0 to rDt.xCount-1 do
    for iy:= 0 to rDt.yCount-1 do
      sgTwo.Cells[ix+1, iy+1]:= SelectedResult(ix, iy);
  CopyTwo2Series;
end;

destructor TfmReport.Destroy;
begin
  Clear();
  inherited;
end;

procedure TfmReport.Clear(what: integer=4); // 1,2, 3->both tabs 4-> 3 + data
var i,j: integer;
begin
  assert(InRange(what,1,4));
  if Assigned(rDt) and (what=4) then rDt.Free;
  // ONE
  if (what=1) or (what>2) then
  begin
    sgOne.RowCount:= 2;
    for i := 0 to sgOne.ColCount-1 do
      sgOne.Cells[i,1]:= '';
    sgOne.Refresh;
    srsUserDefLn.Clear;   srsOnTargetLn.Clear;
    srsIterCountLn.Clear; srsOutCountLn.Clear;
    srsUserDefBr.Clear;   srsOnTargetBr.Clear;
    srsIterCountBr.Clear; srsOutCountBr.Clear;
  end;
  // TWO
  if what>1 then
  begin
    sgTwo.ColCount:= 2; sgTwo.RowCount:= 2;
    sgTwo.Cells[0,1]:= ''; sgTwo.Cells[1,0]:= ''; sgTwo.Cells[1,1]:= '';
    srsVector.Clear; srsPoint.Clear;
  end;
end;

procedure TfmReport.SetScanning(vl: boolean);
begin
  fScanning:= vl;
  pnlProgress.Visible:= vl;
  if vl then
  begin
    tbProgress.SelEnd:= 0;
  end;
end;

function TfmReport.PageOne: boolean;
begin
  Result:= PageControl1.ActivePageIndex=0;
end;

procedure TfmReport.Update4NProp;
begin
  gbPropSelect.Visible:= rDt.TwoProps;
  tsTwoProps.TabVisible:= rDt.TwoProps; // the order Two before One is important
  tsOneProp.TabVisible:= rDt.TwoProps;  // for some reason (bug maybe)
  if rDt.TwoProps then PageControl1.ActivePageIndex:= 1
  else PageControl1.ActivePageIndex:= 0;
  lbProp2.Visible:= rDt.TwoProps;
  lbSeparator.Visible:= rDt.TwoProps;
end;

procedure TfmReport.chartOneDblClick(Sender: TObject);
begin
  ChartEditor1.Execute;
end;

procedure TfmReport.chartTwoDblClick(Sender: TObject);
begin
  ChartEditor2.Execute;
end;

procedure TfmReport.sgOneSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
begin
   ChartTool1.Value:= StrToFloatDef(sgOne.Cells[0,ARow],0);
end;

procedure TfmReport.sgTwoSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
begin
  if Application.Terminated or closing then exit;
  OptimRslt2List(rDt[ACol-1, ARow-1],vleTwo.Strings);
end;

function TfmReport.SelectedResult(ix,iy: integer): string;
var ls: TStrings;
begin
  ls:= TStringList.Create;
  OptimRslt2List(rDt[ix,iy],ls);
  Result:= ls.ValueFromIndex[rgSelParam.ItemIndex];
  ls.Free;
end;

procedure TfmReport.UpdateTableIdx;
var i,j,ix,iy: integer;
begin
  with sgTwo do
  begin
    for i:= 0 to length(rDt.xIdx)-1 do
      Cells[i+1,0]:= F2S(rDt.xIdx[i]);
    for i:= 0 to length(rDt.yIdx)-1 do
      Cells[0,i+1]:= F2S(rDt.yIdx[i]);
  end;
end;

procedure TfmReport.AddRow2One(y: double; iy: integer; dt: rOptimRslt);
var i,j: integer; ls: TStrings; ys: string;
begin
  with sgOne do
  begin
    RowCount:= iy+2; j:= RowCount-1;
    Cells[1,j]:= F2S(dt.UserDef);
    Cells[2,j]:= F2S(dt.BestFit);
    Cells[3,j]:= F2S(dt.SwarmSize);
    Cells[4,j]:= F2S(dt.AverSpeed);
    Cells[5,j]:= F2S(dt.IterCount);
    Cells[6,j]:= F2S(dt.OutCount);
    Cells[7,j]:= IntToStr(dt.OnTargetStat);
    for i:= 0 to length(dt.Vars)-1 do
      Cells[i+8,j]:= F2S(dt.Vars[i]);
    Cells[rDt.dim+8,j]:= dt.TermCond;
  end;
  if rDt.PropY.Style=iiSelection then
  begin ys:= '';
    ls:= TStringList.Create;
    ls.CommaText:= rDt.PropY.SelItems;
    for i:= 0 to ls.Count-1 do
      if SameValue(y,StrToInt(ls.ValueFromIndex[i])) then
        ys:= ls.Names[i];
    assert(ys<>'');
    srsUserDefBr.Add(dt.UserDef,ys);     srsOnTargetBr.Add(dt.OnTargetStat,ys);
    srsIterCountBr.Add(dt.IterCount,ys); srsOutCountBr.Add(dt.OutCount,ys);
    ls.Free;
    sgOne.Cells[0,j]:= ys;
  end
  else begin
    sgOne.Cells[0,j]:= F2S(y);
    srsUserDefLn.AddXY(y,dt.UserDef);     srsOnTargetLn.AddXY(y,dt.OnTargetStat);
    srsIterCountLn.AddXY(y,dt.IterCount); srsOutCountLn.AddXY(y,dt.OutCount);
  end;
end;

procedure TfmReport.Add(x,y: double; dt: rOptimRslt);
var i,j,ix,iy: integer;
begin
  rDt.byFloat[x,y]:= dt;
  ix:= rDt.lastIdx.X; iy:= rDt.lastIdx.Y;

  AddRow2One(y, iy, rDt[ix,iy]);

  if rDt.TwoProps then
  begin
    TrackBar1.Position:= ix; TrackBar1Change(nil);
  end;
  with chartOne do
  begin

  end;
  with sgTwo do
  begin
    i:= ColCount; j:= RowCount;
    ColCount:= math.max(ColCount, ix+2);
    RowCount:= math.max(RowCount, iy+2);
    if (i <> ColCount) or (j <> RowCount) then UpdateTableIdx;
    Cells[ix+1, iy+1]:= SelectedResult(ix, iy);
  end;
end;

procedure TfmReport.UpdateFromData;
var i,j: integer; bb: boolean;
begin
  lbUserDef.Caption:= rDt.UserDef;
  Update4NProp;
  if not rDt.TwoProps then // ONE
  begin
    ConfigOne();
    for i:= 0 to rDt.yCount-1 do
      AddRow2One(rDt.yIdx[i],i,rDt[0,i]);
  end
  else begin // TWO
    ConfigOne();
    ConfigTwo();
    for i:= 0 to rDt.xCount-1 do
      for j:= 0 to rDt.yCount-1 do
        Add(rDt.xIdx[i],rDt.yIdx[j],rDt[i,j]);
    CopyTwo2Series;
    sgTwoSelectCell(nil,1,1,bb);
  end;
  if rDt.Comments<>'' then
  begin
    mmOne.Lines.Text:= rDt.Comments;
    mmOne.ParentFont:= true;
  end;
end;

procedure TfmReport.CopyTwo2Series;
var d: double; i,j,k: integer;
begin
  srsPoint.Clear; srsVector.Clear; srsVector.ColorEachPoint:= true;
  srsVector.Active:= not chkPointSrs.Checked;
  srsPoint.Active:= chkPointSrs.Checked;
  for i:= 0 to length(rDt.xIdx)-1 do
    for j:= 0 to length(rDt.yIdx)-1 do
    begin
      val(sgTwo.Cells[i+1,j+1], d,k);
      if k>0 then exit; // continue ?
      srsVector.AddVector(rDt.xIdx[i],0,rDt.yIdx[j],rDt.xIdx[i],d,rDt.yIdx[j],'');
      srsPoint.AddXYZ(rDt.xIdx[i],d,rDt.yIdx[j]);
    end;
end;

function TfmReport.IsRetrieved: boolean;
begin
  Result:= lbRetr.Caption<>'';
end;

procedure TfmReport.mmOneEnter(Sender: TObject);
begin
  if trim(mmOne.Lines.Text)='Comment here' then
  begin
    mmOne.Lines.Clear;
    mmOne.ParentFont:= true;
  end;
end;

end.
