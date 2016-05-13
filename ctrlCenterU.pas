(************************************************************************)
(*  Bee22 - Particle Swarm Optimization framework     http://bee22.com  *)
(*  developed by and copyright(c) Teodor Krastev 2015-2016              *)
(************************************************************************)
unit ctrlCenterU;

interface
uses System.SysUtils, System.Variants, System.Classes, Vcl.Controls, Math,
 pso_algo, pso_particle, pso_variable, TestFuncU, MVC_U, IniFiles, Types,
 UtilsU, BlkPilesU, BlockU, OptionsU, Vcl.Buttons, Forms, Dialogs, Vcl.ComCtrls,
 ReportDataU, System.Contnrs, PythonU, PythonEngine, WrapDelphi,
  WrapDelphiTypes, WrapDelphiClasses;

type
  TctrlCenter = class(TComponent)
  private
    fLevel: integer;
    fNameSpace: string;
    fOnCloseCC: TNotifyEvent;

  protected
    tf: TTestFunc;
    pso: TPSO; // the only REAL one
    ctrl: TController;

    fmBlkPiles: TfmBlkPiles;
    function GetMute: boolean;
    procedure SetMute(vl: boolean);
    procedure ConfigMVC;
    procedure ReleaseMVC;
    procedure OnRunPSO(NumberOfParticles: integer; ForceReset: boolean);
    procedure OnObserverPreview(Sender: TObject);
  public
    { Public declarations }
    frmOptions: TfrmOptions;
    cp: TctrlPort; // public access (get/set) to props
    constructor Create(aOwner: TComponent; aLevel: integer = 3; NameSpace: string = '';
      WorkingPath: string = ''; aParent: TWinControl = nil; ExtContainer: TPageControl = nil);
    destructor Destroy; override;
    function AddObserver(Observer: InfObserver): integer; // returns observers count
    procedure MuteObservers(mute: boolean);

    function psoInf: IPSO;
    function LoadProps(fn: string): boolean; overload; // for one or more models
    function LoadProps(ls: TStrings): boolean; overload; // same format as INI file section
    procedure SetExtFunc(ef: TEvaluateFunc);
    function isExtFunc: boolean;

    function RunPSO(NumberOfParticles: integer = 0; ForceReset: boolean = false): rOptimRslt;

    property Level: integer read fLevel;
    property Mute: boolean read GetMute write SetMute;

    property OnCloseCC: TNotifyEvent read fOnCloseCC write fOnCloseCC;
  end;

implementation
uses blk_algo, blk_particle, blk_subSw, ComServ, frmExtConfigU;

constructor TctrlCenter.Create(aOwner: TComponent; aLevel: integer = 3; NameSpace: string = '';
  WorkingPath: string = ''; aParent: TWinControl = nil; ExtContainer: TPageControl = nil);
var
  i,j: integer; ss,st: string; pv: TPropVal; blk: TfmBlock; p: PPyObject; mdl: IblkModel;
begin
  inherited Create(aOwner);
  assert(InRange(aLevel,1,3));
  fLevel:= aLevel;
  if not PythonOK then py:= TPythonPlug.Create(self); // comment that line to disable python script
  py.CreateModule(NameSpace); fNameSpace:= NameSpace;
  tf:= TTestFunc.Create(self);
  tf.dim:= 1; tf.FuncIdx:= 6;
  pso:= TPSO.Create(self, ITestFunc(tf)); pso.Caption:= 'main';  // the heart of it all

  ctrl:= TController.Create(self); // one CTRL per PSO
  cp:= TctrlPort.Create(ctrl);

  if PythonOK then py.Wrap(NameSpace,pso,'pso'); // pso in Py

  frmOptions:= TfrmOptions.Create(self); ctrl.frmOpts:= frmOptions;
  if DirectoryExists(WorkingPath) then frmOptions.RootDir:= WorkingPath
    else ShowMessage('WorkingPath <'+WorkingPath+'> is not valid,'#10'application path is assumed.');
  frmOptions.ini:= TIniFile.Create(frmOptions.ConfigPath+'Blocks.ini');
  frmOptions.IniRead;
  ConfigMVC; // bloc reg
  if PythonOK then py.Init;            // pso and mdl's declarations in python
  case frmOptions.general.OpenMode of
    1: ctrl.IniLoad(frmOptions.ConfigPath+'defaults.prop');
    2: ctrl.IniLoad(frmOptions.ConfigPath+ChangeFileExt(frmOptions.general.CustomProps,'.prop'));
  end;
  if (Level=1) or (aParent=nil) then exit; // Level ONE - out

  assert(Assigned(frmOptions));
  fmBlkPiles:= TfmBlkPiles.Create(self); fmBlkPiles.Parent:= aParent;
  fmBlkPiles.psoRef:= pso; fmBlkPiles.ctrlPortRef:= cp;
  fmBlkPiles.Init(frmOptions);
  fmBlkPiles.OnRun:= OnRunPSO; fmBlkPiles.sbPreview.Onclick:= OnObserverPreview;
  SetLength(frmOptions.blocks,ctrl.modelCount);
  for i:= 0 to ctrl.modelCount-1 do // the block names are taken from models
    frmOptions.blocks[i].name:= ctrl.ModelByIdx(i).GetName;
  frmOptions.iniRead;
  fmBlkPiles.fmConsole1.SaveTextFileDialog1.InitialDir:= frmOptions.DataPath;
  fmBlkPiles.UpdateVis(Level=2);
  if PythonOK then py.SetOut(fmBlkPiles.fmConsole1.reLog);  // the default one
  if Level=2 then exit;     // Level TWO - out

  for i:= 0 to ctrl.modelCount-1 do // the block names are taken from models
  begin
    mdl:= ctrl.ModelByIdx(i);
    blk:= fmBlkPiles.BlkByName(mdl.GetName);
    if not Assigned(blk) then continue;
    blk.modelInf:= mdl;
    mdl.RegView(IView(blk));
  end;

  for i:= 0 to ctrl.modelCount-1 do
  begin
    mdl:= ctrl.ModelByIdx(i);
    ss:= mdl.GetName;
    blk:= fmBlkPiles.BlkByName(ss);
    j:= 0; st:= cp.GetPropName(ss,j);
    while (st <> '') do
    begin
      pv:= mdl.GetProp(st);
      if blk<>nil then
      begin
        blk.AddProp(st,pv);
        blk.SrsList:= frmOptions.blocks[i].chrt.items; // exception  :-(
      end;
      inc(j); st:= cp.GetPropName(ss,j);
    end;
    mdl.NotifyAll;
    blk.fmSource1.Init(mdl.GetSource, blk.pnlSrc, ExtContainer);
    blk.UpdateChartSeries;
  end;
  Mute:= false;
end;

destructor TctrlCenter.Destroy;
var
  j: integer;
begin
  if frmOptions.general.SaveOnClose then
    case frmOptions.general.OpenMode of
      1: ctrl.IniSave(frmOptions.ConfigPath+'defaults.prop');
      2: ctrl.IniSave(frmOptions.ConfigPath+ChangeFileExt(frmOptions.general.CustomProps,'.prop'));
    end;
  if level=3 then
  begin
    ctrl.LockedUI:= true;
    fmBlkPiles.UpdateIni;
    frmOptions.iniWrite;
  end;
  frmOptions.fmTracker1.Close;
  ReleaseMVC;
  FreeAndNil(cp); FreeAndNil(ctrl);
  FreeAndNil(fmBlkPiles);
  if Assigned(OnCloseCC) then OnCloseCC(self);
  inherited Destroy;
end;

function TctrlCenter.GetMute: boolean;
begin
  Result:= fmBlkPiles.Mute;
end;

procedure TctrlCenter.SetMute(vl: boolean);
begin
  fmBlkPiles.Mute:= vl;
end;

function TctrlCenter.AddObserver(Observer: InfObserver): integer;
begin
  Result:= pso.ObserverList.Add(Observer);
end;

procedure TctrlCenter.MuteObservers(mute: boolean);
begin
  pso.ObserverList.Mute:= mute;
end;

function TctrlCenter.psoInf: IPSO;
begin
  Result:= IPSO(pso);
end;

function TctrlCenter.LoadProps(fn: string): boolean;
begin
  Result:= FileExists(fn);
  if not Result then exit;
  ctrl.IniLoad(fn);
end;

function TctrlCenter.LoadProps(ls: TStrings): boolean;
var fn: string;
begin
  assert(Assigned(ls));
  fn:= frmOptions.ConfigPath+'_temp.ini';
  ls.SaveToFile(fn);
  Result:= LoadProps(fn);
end;

procedure TctrlCenter.SetExtFunc(ef: TEvaluateFunc);
begin
  if Assigned(ef) then tf.ExtEvaluateFunc:= ef
                  else tf.ExtEvaluateFunc:= frmExtConfig.FireExtFunc;
end;

function TctrlCenter.isExtFunc: boolean;
begin
  Result:= Assigned(tf.ExtEvaluateFunc) and Assigned(OnCloseCC);
end;

function TctrlCenter.RunPSO(NumberOfParticles: integer = 0; ForceReset: boolean = false): rOptimRslt;
begin
  try
    fmBlkPiles.ShowRunning(true);
    ctrl.LockedUI:= true;
    OnObserverPreview(nil); // custom & preview
    pso.Init(NumberOfParticles, ForceReset);
    pso.optimize();
    if pso.ShouldStop then exit;
    Result:= AssignOptimRslt(pso.GetStatus);
    ctrl.LockedUI:= false;
    fmBlkPiles.ShowRunning(false);
  finally
  end;
end;

procedure TctrlCenter.OnRunPSO(NumberOfParticles: integer; ForceReset: boolean);
begin
  RunPSO(NumberOfParticles, ForceReset);
end;

procedure TctrlCenter.OnObserverPreview(Sender: TObject);
var
  i: integer; preview: boolean; cap: string;
begin
  preview:= not (Sender is TSpeedButton);
  if not preview then
  begin
    cap:= (Sender as TSpeedButton).Caption;
    preview:= SameText(cap,'Preview');
  end;
  if preview then
  begin
    for i:= 0 to ctrl.modelCount-1 do // take user customization
      ctrl.modelByIdx(i).Init(-1);
    pso.ObserverList.Init(ITestFunc(tf));     // preview
  end
  else begin
    fmBlkPiles.trace:= pso.Iterations;
  end;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// customizable part / configuration
procedure TctrlCenter.ConfigMVC; // the place to on/off blocks
  procedure RegModel(mdl: TblkModel; nm: string; fork: string = '');
  var
    frk: string;
  begin
    if not Assigned(mdl) or (nm='') then exit;
    if fork='' then frk:= nm
               else frk:= fork;
    ctrl.RegModel(mdl, frk);
    if PythonOK then py.Wrap(fNameSpace,mdl,nm);
  end;
begin
  pso.Controller:= self.ctrl;
  // blk_algo unit
  if frmOptions.IsActive('func') then
    pso.TestFuncBlock:= TTestFuncBlock.Create(self, pso, 'func');
  RegModel(pso.TestFuncBlock, 'func', 'fn');

  if frmOptions.IsActive('extfn') then
    pso.ExtFuncBlock:= TExtFuncBlock.Create(self, pso, 'extfn');
  RegModel(pso.ExtFuncBlock, 'extfn', 'fn');

  if frmOptions.IsActive('precalc') then
    pso.PreCalcBlock:= TPreCalcBlock.Create(self, pso, 'precalc');
  RegModel(pso.PreCalcBlock, 'precalc');

  if frmOptions.IsActive('term') then
    pso.TermCondBlock:= TTermCondBlock.Create(self, pso, 'term');
  RegModel(pso.TermCondBlock, 'term');

  // blk_paricle unit
  if frmOptions.IsActive('fact') then
    pso.Particles.FactorBlock:= TFactorBlock.Create(self, pso, 'fact');
  RegModel(pso.Particles.FactorBlock, 'fact');

  if frmOptions.IsActive('inrt') then
    pso.Particles.InertiaBlock:= TInertiaBlock.Create(self, pso, 'inrt');
  RegModel(pso.Particles.InertiaBlock, 'inrt');

  if frmOptions.IsActive('limt') then
    pso.Particles.PosLimitBlock:= TPosLimitBlock.Create(self, pso, 'limt');
  RegModel(pso.Particles.PosLimitBlock, 'limt');

  // blk_subSw unit
  if frmOptions.IsActive('clubs') then
    pso.Particles.ClubsBlock:= TClubsBlock.Create(self, pso, 'clubs');
  RegModel(pso.Particles.ClubsBlock, 'clubs', 'sub-swarms');

  if frmOptions.IsActive('bi-swarms') then
    pso.Particles.BiswarmBlock:= TBiswarmBlock.Create(self, pso, 'bi-swarms');
  RegModel(pso.Particles.BiswarmBlock, 'bi-swarms', 'sub-swarms');
end;

procedure TctrlCenter.ReleaseMVC;
begin
  // algo
  ctrl.UnregModel(pso.TestFuncBlock);
  if Assigned(pso.TestFuncBlock) then pso.TestFuncBlock.FreeOnRelease;
  ctrl.UnregModel(pso.ExtFuncBlock);
  if Assigned(pso.ExtFuncBlock) then pso.ExtFuncBlock.FreeOnRelease;

  ctrl.UnregModel(pso.PreCalcBlock);
  if Assigned(pso.PreCalcBlock) then pso.PreCalcBlock.FreeOnRelease;

  ctrl.UnregModel(pso.TermCondBlock);
  if Assigned(pso.TermCondBlock) then pso.TermCondBlock.FreeOnRelease;

  // paricle
  ctrl.UnregModel(pso.Particles.FactorBlock);
  if Assigned(pso.Particles.FactorBlock) then pso.Particles.FactorBlock.FreeOnRelease;
  ctrl.UnregModel(pso.Particles.InertiaBlock);
  if Assigned(pso.Particles.InertiaBlock) then pso.Particles.InertiaBlock.FreeOnRelease;

  ctrl.UnregModel(pso.Particles.ClubsBlock);
  if Assigned(pso.Particles.ClubsBlock) then pso.Particles.ClubsBlock.FreeOnRelease;
  ctrl.UnregModel(pso.Particles.BiswarmBlock);
  if Assigned(pso.Particles.BiswarmBlock) then pso.Particles.BiswarmBlock.FreeOnRelease;

  ctrl.UnregModel(pso.Particles.PosLimitBlock);
  if Assigned(pso.Particles.PosLimitBlock) then pso.Particles.PosLimitBlock.FreeOnRelease;
end;

end.
