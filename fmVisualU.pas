unit fmVisualU;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  VCLTee.Series, VCLTee.TeEngine, Vcl.ExtCtrls, VCLTee.TeeProcs, VCLTee.Chart,
  pso_algo, TestFuncU, Vcl.Buttons, Vcl.Samples.Spin, Vcl.ComCtrls, IniFiles,
  VCLTee.ArrowCha, VCLTee.BubbleCh, VCLTee.TeeComma, VCLTee.TeeSurfa, UtilsU,
  VCLTee.TeePoin3, Vcl.Grids, AdvObj, BaseGrid, AdvGrid,  fmOutsideU, fmInsideU,
  fmConsoleU, Vcl.ValEdit;

type
  TfmVisual = class(TFrame, IObserver)
    Panel1: TPanel;
    Panel2: TPanel;
    Splitter1: TSplitter;
    GroupBox1: TGroupBox;
    chkChart: TCheckBox;
    chkOutside: TCheckBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    sbPause: TSpeedButton;
    chkTrace: TCheckBox;
    btnStep: TButton;
    seEvery: TSpinEdit;
    Label1: TLabel;
    PageControl1: TPageControl;
    tsOutside: TTabSheet;
    tsInside: TTabSheet;
    chkInside: TCheckBox;
    chkIters: TCheckBox;
    fmLog: TfmConsole;
    vleIters: TValueListEditor;
    procedure btnStepClick(Sender: TObject);
    procedure chkChartClick(Sender: TObject);
  private
    { Private declarations }
    TraceFlag: boolean;
    FQuiet: boolean;
    lastout: integer;
    tf: TTestFunc;
    fmOutside: TfmOutside;
    fmInside: TfmInside;
    ini: TIniFile;
    procedure SetQuiet(q: boolean);
    procedure VisualUpdate(Sender: TObject);
  public
    { Public declarations }
    pso: TPSO;
    constructor Create(Home: TWinControl; apso: TPSO; atf: TTestFunc); overload;
    procedure Init;

    property Quiet: boolean read FQuiet write SetQuiet;
  end;

implementation
{$R *.dfm}

procedure TfmVisual.chkChartClick(Sender: TObject);
begin
  fmOutside.Quiet:= not chkChart.Checked or not chkOutside.Checked
                    or (PageControl1.ActivePage=tsInside);
  fmInside.Quiet:= not chkChart.Checked or not chkInside.Checked;
end;

constructor TfmVisual.Create(Home: TWinControl; apso: TPSO; atf: TTestFunc);
begin
  inherited Create(home);
  parent:= Home;
  pso:= apso;
  tf:= atf;
  pso.ObserverList.Add(IObserver(self));
  fmOutside:= TfmOutside.Create(tsOutside,pso,tf);
  fmInside:= TfmInside.Create(tsInside,pso,tf);
  Quiet:= false;
  TraceFlag:= false;
  with vleIters do
  begin
     Cells[0,0]:= 'Iteration'; Cells[1,0]:= '';
     Cells[0,1]:= 'dSwarm (StrDev)'; Cells[1,1]:= '';
     Cells[0,2]:= 'Aver.speed'; Cells[1,2]:= '';
  end;
  ini:= TIniFile.Create(ConfigPath+'Visual.ini');
end;

procedure TfmVisual.Init;
var i,j: integer; mi,ma,st: double;
begin
  TraceFlag:= false;
  sbPause.Down:= false;
  fmLog.Clear;
  fmOutside.Init;
  fmInside.Init;
  chkChart.Checked:= ini.ReadBool('gen','chart',true);
  chkOutside.Checked:= ini.ReadBool('gen','chart-out',true);
  chkInside.Checked:= ini.ReadBool('gen','chart-in',true);
  chkIters.Checked:= ini.ReadBool('gen','iterations',true);
  fmLog.chkShow.Checked:= ini.ReadBool('gen','log',false);
end;

procedure TfmVisual.SetQuiet(q: boolean);
begin
  fQuiet:= q;
  pso.ObserverList.SetQuiet(q); // central lock
end;

procedure TfmVisual.btnStepClick(Sender: TObject);
begin
  TraceFlag:= true;
end;

procedure TfmVisual.VisualUpdate(Sender: TObject);
var i,j: integer; x,y,d: double;
begin
  Application.ProcessMessages;
  // control
  while sbPause.Down and not pso.ShouldStop do Application.ProcessMessages;
  while chkTrace.Checked and not pso.ShouldStop do
  begin
    if TraceFlag then break;
    Application.ProcessMessages;
  end;
  TraceFlag:= false;

  if Quiet or ((pso.Iterations mod seEvery.Value)=0) then exit;
  if chkIters.Checked then
  begin
    vleIters.Values['Iteration']:=  IntToStr(pso.Iterations);
    vleIters.Values['dSwarm (StrDev)']:= F2S(pso.StdDevDistance(pso.SwarmBestEverPos));
    vleIters.Values['Aver.speed']:= F2S(pso.AverSpeed());
  end;
  // log
end;

end.
