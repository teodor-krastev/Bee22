program Bee22;

uses
  Vcl.Forms,
  Bee22U in 'Bee22U.pas' {frmBee22},
  pso_algo in 'pso_algo.pas',
  pso_particle in 'pso_particle.pas',
  pso_variable in 'pso_variable.pas',
  TestFuncU in 'TestFuncU.pas',
  UtilsU in 'UtilsU.pas',
  MVC_U in 'MVC_U.pas',
  fmConsoleU in 'fmConsoleU.pas' {fmConsole: TFrame},
  BlockU in 'BlockU.pas' {fmBlock: TFrame},
  OptionsU in 'OptionsU.pas' {frmOptions},
  ctrlCenterU in 'ctrlCenterU.pas',
  fmInsideU in 'fmInsideU.pas' {fmInside: TFrame},
  fmOutsideU in 'fmOutsideU.pas' {fmOutside: TFrame},
  blk_algo in 'blk_algo.pas',
  blk_particle in 'blk_particle.pas',
  fmScanU in 'fmScanU.pas' {fmScanPSO: TFrame},
  fmScanPropU in 'fmScanPropU.pas' {fmScanProp: TFrame},
  ReportDataU in 'ReportDataU.pas',
  fmReportU in 'fmReportU.pas' {fmReport: TFrame},
  fmSourceU in 'fmSourceU.pas' {fmSource: TFrame},
  fmSrcPaneU in 'fmSrcPaneU.pas' {fmSrcPane: TFrame},
  blkPilesU in 'blkPilesU.pas' {fmBlkPiles: TFrame},
  AdjustU in 'AdjustU.pas',
  blk_subSw in 'blk_subSw.pas',
  fmSubswarmsU in 'fmSubswarmsU.pas' {fmSubswarms: TFrame},
  TrackerU in 'TrackerU.pas' {fmTracker: TFrame},
  PythonU in 'PythonU.pas',
  AboutBoxU in 'AboutBoxU.pas' {frmAboutBox},
  Bee22_TLB in 'Bee22_TLB.pas',
  Bee22comU in 'Bee22comU.pas',
  frmGenConfigU in 'frmGenConfigU.pas' {frmGenConfig},
  Vcl.Themes,
  Vcl.Styles,
  frmExtConfigU in 'frmExtConfigU.pas' {frmExtConfig};

{$R *.TLB}

{$R *.res}

begin
  ReportMemoryLeaksOnShutDown := DebugHook <> 0;

  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'Bee22';
  Application.CreateForm(TfrmBee22, frmBee22);
  Application.CreateForm(TfrmAboutBox, frmAboutBox);
  Application.CreateForm(TfrmGenConfig, frmGenConfig);
  Application.CreateForm(TfrmExtConfig, frmExtConfig);
  Application.Run;
end.
