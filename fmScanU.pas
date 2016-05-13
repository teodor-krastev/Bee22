(************************************************************************)
(*  Bee22 - Particle Swarm Optimization framework     http://bee22.com  *)
(*  developed by and copyright(c) Teodor Krastev 2015-2016              *)
(************************************************************************)
unit fmScanU;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, fmInsideU, fmOutsideU,
  Vcl.ComCtrls, ctrlCenterU, fmConsoleU, Vcl.ExtCtrls, fmScanPropU, Vcl.Buttons,
  IniFiles, Vcl.StdCtrls, Vcl.Samples.Spin, Types, Math, IOUtils, Vcl.ImgList,
  Generics.Collections, Vcl.ExtDlgs, TrackerU, AboutBoxU,
  fmReportU, ReportDataU, UtilsU, Vcl.Menus, fmSubswarmsU, Vcl.AppEvnts;

type
  TfmScanPSO = class(TFrame)
    PageControl1: TPageControl;
    tsOutside: TTabSheet;
    tsInside: TTabSheet;
    tsMuteObservers: TTabSheet;
    pnlLeft: TPanel;
    consoleScan: TfmConsole;
    Splitter1: TSplitter;
    pcMain: TPageControl;
    tsPSO: TTabSheet;
    fmOutside1: TfmOutside;
    fmInside1: TfmInside;
    pcScan: TPageControl;
    tsScan: TTabSheet;
    tsOptions: TTabSheet;
    fmScanProp1: TfmScanProp;
    fmScanProp2: TfmScanProp;
    fmScanProp3: TfmScanProp;
    pnlScanBtns: TPanel;
    sbScanOne: TSpeedButton;
    sbScanAll: TSpeedButton;
    chkMuteBlocks: TCheckBox;
    Panel2: TPanel;
    sbOpen: TSpeedButton;
    sbSave: TSpeedButton;
    cbScanFlies: TComboBox;
    rbStartupScan: TRadioGroup;
    ImageList1: TImageList;
    OpenDialog1: TOpenDialog;
    GroupBox1: TGroupBox;
    seStats: TSpinEdit;
    Label1: TLabel;
    GroupBox2: TGroupBox;
    Label2: TLabel;
    seSignDigits: TSpinEdit;
    Label3: TLabel;
    seDecPlaces: TSpinEdit;
    GroupBox3: TGroupBox;
    Panel3: TPanel;
    sbOpenGroup: TSpeedButton;
    sbSaveGroup: TSpeedButton;
    sbDeleteAllReports: TSpeedButton;
    Panel4: TPanel;
    sbOpenReport: TSpeedButton;
    sbSaveReport: TSpeedButton;
    sbDeleteReport: TSpeedButton;
    OpenDialog2: TOpenDialog;
    FileOpenDialog1: TFileOpenDialog;
    sbMenu: TSpeedButton;
    PopupMenu1: TPopupMenu;
    mHelp: TMenuItem;
    N1: TMenuItem;
    mAbout: TMenuItem;
    ImageListScan: TImageList;
    TabSheet1: TTabSheet;
    fmSubswarms1: TfmSubswarms;
    ApplicationEvents1: TApplicationEvents;
    SaveDialog2: TSaveDialog;
    SaveDialog1: TSaveDialog;
    procedure PageControl1Change(Sender: TObject);
    procedure sbScanOneClick(Sender: TObject);
    procedure sbScanAllClick(Sender: TObject);
    procedure sbSaveClick(Sender: TObject);
    procedure sbOpenReportClick(Sender: TObject);
    procedure sbSaveGroupClick(Sender: TObject);
    procedure sbDeleteAllReportsClick(Sender: TObject);
    procedure seDecPlacesChange(Sender: TObject);
    procedure sbOpenGroupClick(Sender: TObject);
    procedure sbSaveReportClick(Sender: TObject);
    procedure sbDeleteReportClick(Sender: TObject);
    procedure sbOpenMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure sbMenuMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure mAboutClick(Sender: TObject);
    procedure mHelpClick(Sender: TObject);
    procedure ApplicationEvents1ShortCut(var Msg: TWMKey; var Handled: Boolean);
  private
    { Private declarations }
    scanIni: TIniFile;
    LastScanFile: string;
    fScanning, fStopRequest: boolean;
    rpt: TList<TfmReport>;
    ReportUnderConstr: TfmReport;

    procedure DeleteReport(rp: TfmReport);
    procedure UpdateScanFiles;
    function GetStopRequest: boolean;
    function GetScanning: boolean;
    function MetaIteration(In1,In2: double): rOptimRslt;
    procedure NewReportPlace(cpt: string; var rp: TfmReport);

    procedure UpdateVis(Sender: TObject);
  public
    { Public declarations }
    cc: TctrlCenter;
    procedure Init(level: integer; wd: string= '');
    procedure Finish;

    function ActiveReport: TfmReport;

    function ScanOneFunc(funcIdx: integer): TfmReport;  // -1 - current test.func

    procedure LoadScan(fn: string = '');
    procedure SaveScan(fn: string = '');
    property StopRequest: boolean read GetStopRequest;
    property Scanning: boolean read GetScanning;
  end;

implementation
{$R *.dfm}
uses frmExtConfigU;
const default_scan= 'default.scan';

procedure TfmScanPSO.Init(level: integer; wd: string = '');
var
  ss: string;
begin
  DecPlacesInProps:= 5; pcScan.ActivePageIndex:= 0; Align:= alClient; ss:= '';
  if  wd<>'' then ss:= ExtractFilePath(Application.ExeName)+wd+'\';
  if (wd='') or not DirectoryExists(ss) then
    ss:= ExtractFilePath(Application.ExeName)+'ext\'; // Scans default one
  cc:= TctrlCenter.Create(self, level, '', ss, tsPSO, PageControl1);
  // TctrlCenter.Create(Owner, level, NameSpace, WorkingPath, Parent, ExtContainer);
  // level=1 invisible (no UI); level=2 console only; level=3 full visuals
  cc.AddObserver(fmOutside1);
  cc.AddObserver(fmInside1);
  cc.AddObserver(fmSubswarms1);
  cc.AddObserver(cc.frmOptions.fmTracker1); cc.frmOptions.fmTracker1.ChargeItems(cc.psoInf);
  consoleScan.log('! Hello to PSO at level '+IntToStr(cc.Level));
  fmScanProp1.Init(cc.cp,true, 'First scanning property');
  fmScanProp2.Init(cc.cp,true, 'Second scanning property');
  fmScanProp2.cbModel.Items.Insert(0,noModel);
  fmScanProp3.Init(cc.cp,false, 'Result (user.def) property');
  Splitter1.Height:= 3;
  fmScanProp2.Top:= fmScanProp1.Top+fmScanProp1.Height;
  scanIni:= TIniFile.Create(cc.frmOptions.ConfigPath+'Scan.ini');
  chkMuteBlocks.Checked:= scanIni.ReadBool('General','MuteBlocks',true);
  rbStartupScan.ItemIndex:= scanIni.ReadInteger('General','StartupScan',0);
  seStats.Value:= scanIni.ReadInteger('General','Stats',1);
  seSignDigits.Value:= scanIni.ReadInteger('General','SignDigits',5);
  seDecPlaces.Value:= scanIni.ReadInteger('General','DecPlaces',4);
  if rbStartupScan.ItemIndex = 0 then
    LastScanFile:= cc.frmOptions.ConfigPath+default_scan
  else
    LastScanFile:= cc.frmOptions.ConfigPath+scanIni.ReadString('General','LastScan','');
  LoadScan(LastScanFile);
  UpdateScanFiles;
  ss:= ChangeFileExt(ExtractFileName(LastScanFile),'');
  cbScanFlies.ItemIndex:= cbScanFlies.Items.IndexOf(ss);
  fmScanProp1.OnResize:= UpdateVis; fmScanProp2.OnResize:= UpdateVis;
  fmScanProp3.OnResize:= UpdateVis; UpdateVis(nil);
  rpt:= TList<TfmReport>.Create();
  PageControl1Change(nil);
end;

procedure TfmScanPSO.PageControl1Change(Sender: TObject);
begin
  if pcMain.ActivePage=tsPSO
    then cc.MuteObservers(PageControl1.ActivePage=tsMuteObservers)
    else cc.MuteObservers(true);
end;

procedure TfmScanPSO.Finish;
var ifn: string; i,j: integer;
begin
  cc.psoInf.Stop;
  fStopRequest:= true;
  for i:= 0 to rpt.Count-1 do
    rpt[i].closing:= true;
  j:= 0;
  while (j<100) and scanning do
  begin
    Delay(10); inc(j);
  end;
  if rbStartupScan.ItemIndex = 0 then
    LastScanFile:= cc.frmOptions.ConfigPath+default_scan;

  SaveScan(LastScanFile);
  scanIni.WriteBool('General','MuteBlocks',chkMuteBlocks.Checked);
  scanIni.WriteBool('General','StartupScan',rbStartupScan.ItemIndex=1);
  scanIni.WriteString('General','LastScan',ExtractFileName(LastScanFile));
  scanIni.WriteInteger('General','Stats',seStats.Value);
  scanIni.WriteInteger('General','SignDigits',seSignDigits.Value);
  scanIni.WriteInteger('General','DecPlaces',seDecPlaces.Value);

  scanIni.Free;
  cc.Free;
  for i:= rpt.Count-1 downto 0 do rpt[i].Free;
  rpt.Clear; rpt.Free;
end;

procedure TfmScanPSO.LoadScan(fn: string = '');
var
  ss: string; ini: TIniFile;
begin
  if fn='' then ss:= cc.frmOptions.ConfigPath+default_scan
  else ss:= fn;
  ss:= ChangeFileExt(ss,'.scan');
  ini:= TIniFile.Create(ss);
  fmScanProp1.ReadIniSection(ini,'CtrlProp1');
  fmScanProp2.ReadIniSection(ini,'CtrlProp2');
  fmScanProp3.ReadIniSection(ini,'RsltProp');
  ini.Free;
end;

procedure TfmScanPSO.mAboutClick(Sender: TObject);
begin
  frmAboutBox.ShowModal;
end;

procedure TfmScanPSO.SaveScan(fn: string = '');
var
  ss: string; ini: TIniFile;
begin
  if fn='' then ss:= cc.frmOptions.ConfigPath+default_scan
           else ss:= fn;
  ss:= ChangeFileExt(ss,'.scan');
  ini:= TIniFile.Create(ss);
  fmScanProp1.WriteIniSection(ini,'CtrlProp1');
  fmScanProp2.WriteIniSection(ini,'CtrlProp2');
  fmScanProp3.WriteIniSection(ini,'RsltProp');
  ini.Free;
end;

function TfmScanPSO.GetStopRequest: boolean;
begin
  Result:= fStopRequest or Application.Terminated;
end;

function TfmScanPSO.GetScanning: boolean;
var rp: TfmReport;
begin
  Result:= false;
  for rp in rpt do
    Result:= Result or rp.scanning;
end;

procedure TfmScanPSO.sbSaveGroupClick(Sender: TObject);
var
  ss,sq: string; i: integer;
begin
  if scanning or (pcMain.PageCount = 1) then exit;
  ss:= InputBox('Save group of reports','Directory name:','');
  sq:= IncludeTrailingBackslash(cc.frmOptions.MainPath+ss);
  if DirectoryExists(sq) then
    if MessageDlg('Directory <'+sq+'> already exists. Overwrite it?',
                  mtConfirmation, [mbYes, mbNo], 0, mbYes) = mrYes then
      DeleteFolder(sq)
      else exit;
  TDirectory.CreateDirectory(sq);
  for i:= 1 to pcMain.PageCount-1 do
  begin
    pcMain.ActivePageIndex:= i;
    ss:= trim(ActiveReport.mmOne.Lines.Text);
    if (ss<>'Comment here') and (ss<>'') then
      ActiveReport.rDt.Comments:= ss;
    ss:= StringReplace(ActiveReport.Caption,'.','_',[rfReplaceAll]);
    ss:= StringReplace(ss,' (R)','',[rfReplaceAll]);
    ActiveReport.rDt.SaveReport(ChangeFileExt(sq+ss,'.brt'));
  end;
  cc.cp.IniSave(sq+'_pso.prop');
  SaveScan(sq+'_working.scan');
end;

procedure TfmScanPSO.sbSaveReportClick(Sender: TObject);
var ss: string;
begin
  SaveDialog2.InitialDir:= cc.frmOptions.MainPath;
  if ActiveReport=nil then raise Exception.Create('No report to be saved');
  ss:= trim(ActiveReport.mmOne.Lines.Text);
  if (ss<>'Comment here') and (ss<>'') then
    ActiveReport.rDt.Comments:= ss;
  if SaveDialog2.Execute then
  begin
    ss:= SaveDialog2.FileName;
    if FileExists(ss) then
      DeleteFile(ss);
    ActiveReport.rDt.SaveReport(ss);
  end;
end;

function TfmScanPSO.MetaIteration(In1,In2: double): rOptimRslt;
var
  pv: TPropVal; sp1,sp2,sp3: rScanProp; rpa: array of rOptimRslt;
  i: integer; rp: rOptimRslt;
begin
  if (fmScanProp1.Status = spsInvalid) or (fmScanProp2.Status = spsInvalid) or
    (fmScanProp3.Status = spsInvalid) then exit;
  sp1:= fmScanProp1.ScanProp; sp2:= fmScanProp2.ScanProp;
  sp3:= fmScanProp3.ScanProp;
  cc.cp.GetProp(sp1.mdlName, sp1.propName).SetDouble(In1);
  if not IsNaN(In2) then
    cc.cp.GetProp(sp2.mdlName, sp2.propName).SetDouble(In2);

  SetLength(rpa,seStats.Value);
  for i:= 0 to seStats.Value-1 do
  begin
    rpa[i]:= cc.RunPSO(); // the whole point
    rpa[i].UserDef:= cc.cp.GetProp(sp3.mdlName, sp3.propName).AsDouble;
    if Assigned(ReportUnderConstr) then
      ReportUnderConstr.lbStatCount.Caption:=
      '('+IntToStr(i)+'/'+IntToStr(seStats.Value)+')  @ '+timetostr(now);
    if StopRequest then break;
  end;
  if not StopRequest then
    OptimRsltStats(rpa, Result,rp);
end;

procedure TfmScanPSO.mHelpClick(Sender: TObject);
begin
  HyperlinkExe('http://bee22.com/?pg=manual');
  //frmExtConfig.RunSimion('');
end;

procedure TfmScanPSO.UpdateVis(Sender: TObject);
begin
  pcScan.Height:= pcScan.TabHeight + pnlScanBtns.Top+pnlScanBtns.Height+15;
end;

procedure TfmScanPSO.ApplicationEvents1ShortCut(var Msg: TWMKey;
  var Handled: Boolean);
begin
  if VK_F1=Msg.CharCode then
  begin
    mHelpClick(nil);
    Msg.CharCode:= 0;
  end;
end;

procedure TfmScanPSO.DeleteReport(rp: TfmReport);
var TabSheet: TTabSheet; i: integer;
begin
  if ReportUnderConstr=rp then exit;
  TabSheet:= TTabSheet(rp.Parent);
  i:= rpt.IndexOf(rp);
  rp.Free; rpt.Delete(i);
  TabSheet.Free;
end;

procedure TfmScanPSO.sbDeleteAllReportsClick(Sender: TObject);
var
  i: integer;
begin
  if MessageDlg('Delete all reports?', mtConfirmation,
                [mbYes, mbNo], 0, mbYes) = mrNo then exit;
  while pcMain.PageCount > 1 do
  begin
    pcMain.ActivePageIndex:= 1;
    DeleteReport(ActiveReport);
  end;
end;

procedure TfmScanPSO.sbDeleteReportClick(Sender: TObject);
begin
  DeleteReport(ActiveReport);
end;

procedure TfmScanPSO.sbOpenGroupClick(Sender: TObject);
var
  ss,sq: string; i: integer;
  dt: TReportData; rp: TfmReport;
begin
  FileOpenDialog1.DefaultFolder:= cc.frmOptions.MainPath;
  if not FileOpenDialog1.Execute then exit;
  assert(DirectoryExists(FileOpenDialog1.Filename));
  for sq in TDirectory.GetFiles(FileOpenDialog1.Filename) do
  begin
    if not SameText(ExtractFileExt(sq),'.brt') then continue;
    dt:= TReportData.Create(sq);
    NewReportPlace(dt.TestFunc+' (R)', rp);
    rp.rDt:= dt;
    rp.lbRetr.Caption:= 'Retrieved from '+sq;
    rp.UpdateFromData;
  end;
end;

procedure TfmScanPSO.sbOpenMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  ss: string;
begin
  if Button<>mbLeft then exit;
  if ssCtrl in Shift then
  begin
    OpenDialog2.InitialDir:= cc.frmOptions.DataPath;
    if OpenDialog2.Execute then
      LoadScan(OpenDialog2.FileName);
  end
  else begin
    ss:= cc.frmOptions.ConfigPath+cbScanFlies.Text;
    ss:= ChangeFileExt(ss,'.scan');
    assert(FileExists(ss));
    LastScanFile:= ss;
    LoadScan(ss);
  end;
end;

procedure TfmScanPSO.sbOpenReportClick(Sender: TObject);
var
  dt: TReportData; rp: TfmReport;
begin
  OpenDialog1.InitialDir:= cc.frmOptions.MainPath;
  if not OpenDialog1.Execute then exit;
  dt:= TReportData.Create(OpenDialog1.FileName);
  NewReportPlace(dt.TestFunc+' (R)', rp);
  rp.rDt:= dt;
  rp.lbRetr.Caption:= 'Retrieved from '+OpenDialog1.FileName;
  rp.UpdateFromData;
end;

procedure TfmScanPSO.UpdateScanFiles;
var sp,sq: string;
begin
  cbScanFlies.Items.Clear;
  for sq in TDirectory.GetFiles(cc.frmOptions.ConfigPath) do
  begin
    if not SameText(ExtractFileExt(sq),'.scan') then continue;
    sp:= ChangeFileExt(ExtractFileName(sq),'');
    cbScanFlies.Items.Add(sp);
  end;
  if (cbScanFlies.ItemIndex=-1) and (cbScanFlies.Items.Count>0) then
    cbScanFlies.ItemIndex:= 0;
end;

procedure TfmScanPSO.sbSaveClick(Sender: TObject);
var fn: string;
begin
  SaveDialog1.InitialDir:= cc.frmOptions.ConfigPath;
  if SaveDialog1.Execute then
  begin
    fn:= SaveDialog1.FileName;
    SaveScan(fn);
    UpdateScanFiles;
    fn:= ChangeFileExt(ExtractFileName(fn),'');
    cbScanFlies.ItemIndex:= cbScanFlies.Items.IndexOf(fn);
  end;
end;

procedure TfmScanPSO.sbScanOneClick(Sender: TObject);
var i,j,dim: integer;
begin
  try
    if not sbScanOne.Down then
    begin
      fStopRequest:= true;
      consoleScan.log('! User cancel');
      exit;
    end;
    fStopRequest:= false;
    consoleScan.LogTime;
    if (fmScanProp1.Status = spsInvalid) or (fmScanProp2.Status = spsInvalid) or
      (fmScanProp3.Status = spsInvalid) then
      begin
        consoleScan.log('Error: invalid scanning params');
        exit;
      end;
    if cc.cp.propCount('extfn')>0 then
      if not frmExtConfig.IsSimion() then frmExtConfig.RunSimion('');
    if cc.isExtFunc
      then consoleScan.log('doing <external.Simion> PSO scan')
      else consoleScan.log('doing <'+cc.cp.GetProp('func','test.func').AsString+'>  func');
    ScanOneFunc(-1);
    consoleScan.LogTime(true); // frmExtConfig.PrintRem('~~~~~~ End of Scan ~~~~~~~~~~~~~~~');
  finally
    sbScanOne.Down:= false;
  end;
end;

procedure TfmScanPSO.sbScanAllClick(Sender: TObject);
var i,j,dim: integer;
begin
  if cc.isExtFunc then
  begin
    ShowMessage('Valid only for internal test functions');
    sbScanAll.Down:= false; exit;
  end;
  try
    if not sbScanAll.Down then
    begin
      fStopRequest:= true;
      consoleScan.log('! User cancel');
      exit;
    end;
    fStopRequest:= false; consoleScan.LogTime;
    if (fmScanProp1.Status = spsInvalid) or (fmScanProp2.Status = spsInvalid) or
      (fmScanProp3.Status = spsInvalid) then
      begin
        consoleScan.log('Error: invalid scanning params');
        exit;
      end;
    dim:= cc.cp.GetProp('func','dim').AsInt;
    j:= cc.cp.GetProp('func','test.func').AsInt;
    for i:= 0 to cc.psoInf.GetItf.Count-1 do
      if cc.psoInf.GetItf.IsEnabled(dim,i) then
      begin
        cc.cp.GetProp('func','test.func').SetDouble(i);
        cc.cp.Notify('func','test.func');
        consoleScan.log('doing  <'+cc.cp.GetProp('func','test.func').AsString+'>  func');
        ScanOneFunc(i);
        if StopRequest then break;
      end;
    consoleScan.LogTime(true);
    consoleScan.log('======== done doing ==========');
  finally
    cc.cp.GetProp('func','test.func').SetDouble(j);
    cc.cp.Notify('func','test.func');
    sbScanAll.Down:= false;
  end;
end;

procedure TfmScanPSO.NewReportPlace(cpt: string; var rp: TfmReport);
  function isReport(nm: string): boolean;
  var
    i: integer;
  begin
    for i:= 0 to rpt.Count-1 do
    begin
      Result:= SameText(nm,rpt[i].Name);
      if Result then break;
    end;
  end;
var i,j: integer; TabSheet: TTabSheet;
begin
  for i:= 1 to pcMain.PageCount-1 do
     if SameText(cpt,pcMain.Pages[i].Caption) then  // find existing tab
     begin
       pcMain.ActivePageIndex:= i;
       DeleteReport(ActiveReport);
       break;
     end;
  TabSheet := TTabSheet.Create(pcMain); // new tab
  TabSheet.Caption := cpt;
  TabSheet.PageControl := pcMain;
  if (pcMain.ActivePageIndex>0) or (pcMain.PageCount=2) then pcMain.ActivePage:= TabSheet;
  PageControl1Change(nil);
  i:= rpt.Add(TfmReport.Create(pcMain)); rp:= rpt[i];
  while isReport('fmReport'+IntToStr(i)) do inc(i);
  rp.Name:= 'fmReport'+IntToStr(i); TabSheet.ImageIndex:= -1;
  rp.Parent:= TabSheet; rp.Caption := cpt; rp.SignDigits:= seSignDigits.Value;
end;

function TfmScanPSO.ActiveReport: TfmReport;
var
  i,j: integer; rp: TfmReport;
begin
  Result:= nil;
  for rp in rpt do
    if rp.Parent=pcMain.ActivePage then
    begin
      Result:= rp;
      break;
    end;
end;

function TfmScanPSO.ScanOneFunc(funcIdx: integer): TfmReport;  // -1 - current test.func
var rp: TfmReport; sp1,sp2,sp3: rScanProp; fi,dim,i,j, total,current: integer; bb: boolean;
  a,b: double; dt: rOptimRslt; pv: TPropVal; cpt,sdm: string;
begin
  if scanning or StopRequest then exit;
  try

  if (funcIdx>-1) and not cc.isExtFunc then
  begin
    if cc.cp.GetProp('func','test.func').AsInt<>funcIdx then
      cc.cp.GetProp('func','test.func').SetDouble(funcIdx);
  end;
  if cc.isExtFunc then cpt:= 'external.Simion'
                  else cpt:= cc.cp.GetProp('func','test.func').AsString;
  NewReportPlace(cpt, rp); ReportUnderConstr:= rp;

  sp1:= fmScanProp1.ScanProp; sp2:= fmScanProp2.ScanProp;
  sp3:= fmScanProp3.ScanProp;
  if cc.isExtFunc then sdm:= 'extfn'
                  else sdm:= 'func';
  dim:= cc.cp.GetProp(sdm,'dim').AsInt;
  rp.Config(sp1, sp2, sp3, dim); // create data obj (rDt)
  rp.rDt.TestFunc:= cpt;
  rp.Scanning:= true; total:= rp.rDt.xCount*rp.rDt.yCount; current:= 1;
  if chkMuteBlocks.Checked then cc.Mute:= true;

  if rp.rDt.TwoProps then // TWO
  begin
    fmScanProp2.Start;
    repeat
      b:= fmScanProp2.CurrentValue;
      fmScanProp1.Start; rp.Clear(1);
      repeat
        a:= fmScanProp1.CurrentValue;
        dt:= MetaIteration(a,b); // the actual PSO action
        if StopRequest then break;
        rp.Add(b,a,dt); // report it
        rp.tbProgress.SelEnd:= round(100*current/total); inc(current);
        if SameValue(a,sp1.sFrom,Epsilon3) then
          rp.Panel3Resize(nil); // resize col width
      until not fmScanProp1.Next or StopRequest;
    until not fmScanProp2.Next or StopRequest;
    cc.Mute:= false;
    fmScanProp1.Reinstate; fmScanProp2.Reinstate;
  end
  else begin  // ONE
    fmScanProp1.Start;
    repeat
      a:= fmScanProp1.CurrentValue;
      dt:= MetaIteration(a,NaN); // the actual PSO action
      if StopRequest then break;
      rp.Add(NaN,a,dt);  // report it
      rp.tbProgress.SelEnd:= round(100*current/total); inc(current);
    until not fmScanProp1.Next or StopRequest;
    cc.Mute:= false;
    fmScanProp1.Reinstate;
  end;
  finally
    rp.Scanning:= false; ReportUnderConstr:= nil; rp.lbStatCount.Caption:= '';
    if rp.rDt.TwoProps then rp.rgSelParamClick(nil);
    Result:= rp;
  end;
end;

procedure TfmScanPSO.seDecPlacesChange(Sender: TObject);
begin
  DecPlacesInProps:= seDecPLaces.Value;
end;

procedure TfmScanPSO.sbMenuMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var p: TPoint; btn: TSpeedButton;
begin
  btn:= TSpeedButton(Sender);
  p.X:= btn.Left; p.Y:= btn.Top+btn.Height;
  p:= ClientToScreen(p);
  btn.PopupMenu.Popup(p.X,p.Y);
end;

end.
