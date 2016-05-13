(************************************************************************)
(*  Bee22 - Particle Swarm Optimization framework     http://bee22.com  *)
(*  developed by and copyright(c) Teodor Krastev 2015-2016              *)
(************************************************************************)
unit fmInsideU;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, VCLTee.Series,
  VCLTee.TeEngine, Vcl.ExtCtrls, VCLTee.TeeProcs, VCLTee.Chart, UtilsU,
  MVC_U, TestFuncU,  VCLTee.TeeEdit;

type
  TfmInside = class(TFrame, InfObserver)
    Chart1: TChart;
    srsSize: TFastLineSeries;
    srsOuters: TFastLineSeries;
    Splitter1: TSplitter;
    Chart2: TChart;
    srsTop: TFastLineSeries;
    srsAver: TFastLineSeries;
    ChartEditor1: TChartEditor;
    Splitter2: TSplitter;
    Chart3: TChart;
    srsScInertia: TFastLineSeries;
    srsUser1: TFastLineSeries;
    srsScSocial: TFastLineSeries;
    srsScCogn: TFastLineSeries;
    procedure Chart1DblClick(Sender: TObject);
    procedure FrameResize(Sender: TObject);
  private
    { Private declarations }
    lastout: integer;
    procedure VisualUpdate(Sender: TObject);
  public
    { Public declarations }
    Quiet: boolean;
    procedure Init(itf: ITestFunc);
    function GetCollective: boolean;
  end;

implementation
{$R *.dfm}
uses pso_algo, pso_particle;

procedure TfmInside.Chart1DblClick(Sender: TObject);
begin
  ChartEditor1.Chart:= Sender as TChart;
  ChartEditor1.Execute;
end;

procedure TfmInside.FrameResize(Sender: TObject);
begin
  Chart1.Height:= round(Height/3);
  Chart2.Height:= round(Height/3);
  Chart3.Height:= round(Height/3);
end;

procedure TfmInside.Init(itf: ITestFunc);
begin
  lastout:= 0; Quiet:= false;
  srsSize.Clear; srsOuters.Clear;
  srsAver.Clear; srsTop.Clear;
  srsScInertia.Clear; srsScSocial.Clear; srsScCogn.Clear;
  srsUser1.Clear;
end;

function TfmInside.GetCollective: boolean;
begin
  Result:= true;
end;

procedure TfmInside.VisualUpdate(Sender: TObject);
var i,j: integer; d,f: double; pso: TPSO; spd: rSpeedComp;
begin
  if Quiet or not (Sender is TPSO) then exit;
  pso:= TPSO(Sender);
  if pso.Iterations=1 then // late init
  begin
    Chart1.BottomAxis.Maximum:= pso.MaxIterations;
    Chart2.BottomAxis.Maximum:= pso.MaxIterations;
    Chart3.BottomAxis.Maximum:= pso.MaxIterations;
  end;
  j:= pso.Iterations;
  srsSize.AddXY(j,pso.Particles.StdDevDistance(pso.SwarmBestEverPos));
  srsOuters.AddXY(j,pso.Particles.outCount); // pso.OutCount--lastout
  lastout:= pso.Particles.OutCount;

  srsTop.addXY(j,pso.Particles.Speed(spdTop));
  srsAver.addXY(j,pso.Particles.Speed(spdAver));

  spd:= pso.Particles.SpeedComp(false);
  srsScInertia.addXY(j,spd.scInertia);
  srsScSocial.addXY(j,spd.scSocial);
  srsScCogn.addXY(j,spd.scCogn);
//  srsUser1.addXY(j,pso.User1);
end;

end.
