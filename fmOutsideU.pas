(************************************************************************)
(*  Bee22 - Particle Swarm Optimization framework     http://bee22.com  *)
(*  developed by and copyright(c) Teodor Krastev 2015-2016              *)
(************************************************************************)
unit fmOutsideU;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, VCLTee.TeeComma, Math,
  VCLTee.TeeSurfa, VCLTee.TeePoin3, VCLTee.Series, VCLTee.ArrowCha, Types,
  VCLTee.TeEngine, Vcl.ExtCtrls, VCLTee.TeeProcs, VCLTee.Chart, Vcl.ComCtrls,
  MVC_U, TestFuncU, pso_algo, VCLTee.TeeEdit, UtilsU;

type
  TfmOutside = class(TFrame, InfObserver)
    PageControl1: TPageControl;
    tsOut2D: TTabSheet;
    Chart1: TChart;
    srsSS2: TLineSeries;
    srsS2: TArrowSeries;
    tsOut3D: TTabSheet;
    Chart2: TChart;
    srsSS3: TIsoSurfaceSeries;
    srsB3: TPoint3DSeries;
    srsS3: TVector3DSeries;
    TeeCommander1: TTeeCommander;
    srsB2: TPointSeries;
    ChartEditor1: TChartEditor;
    procedure Chart1DblClick(Sender: TObject);
  private
    { Private declarations }
    tfInf: ITestFunc;
    function GetDim: integer;
  public
    { Public declarations }
    Quiet: boolean;
    TraceFlag: boolean;
    procedure Init(itf: ITestFunc); // visual ini with Search Space line/surface
    function GetCollective: boolean;
    procedure VisualUpdate(Sender: TObject);

    property Dim: integer read GetDim;
  end;

implementation
{$R *.dfm}

procedure TfmOutside.Init(itf: ITestFunc);
var stx,sty,mi,ma,st,ev: double; i: integer; ss: string;
begin
  TeeCommander1.Enabled:= true;
  TeeCommander1.CreateControls([tcbNormal, tcbSeparator, tcbRotate, tcbMove, tcbZoom, tcbSeparator,
                                tcb3D, tcbDepth, tcbSeparator, tcbEdit]);
  TeeCommander1.DefaultButton := tcbRotate;
  Quiet:= false;
  tfInf:= itf;
  for i:= 0 to Chart1.AxesList.Count-1 do
    Chart1.AxesList.Items[i].Automatic:= true;
  ss:= '';
  if not tfInf.IsEnabled(Dim,tfInf.GetFuncIdx) then ss:= '-> NOT AVAILABLE for that func and this dim';
  if Dim=1 then
  begin
    PageControl1.ActivePageIndex:= 0;
    srsSS2.Clear; srsB2.Clear; srsS2.Clear;
    Chart1.Title.Text[0]:= 'test func: '+tfInf.GetProblem.name+ss;
    if ss<>'' then exit;
    mi:= tfInf.GetProblem.ss.min[0]; ma:= tfInf.GetProblem.ss.max[0];
    st:= (ma-mi)/100;
    tfInf.SetX(0,mi);
    repeat
      ev:= tfInf.Eval;
      assert(not IsNaN(ev));
      srsSS2.AddXY(tfInf.GetX(0),ev);
      tfInf.SetX(0, tfInf.GetX(0)+st);
    until (tfInf.GetX(0)>ma);
  end
  else begin
    PageControl1.ActivePageIndex:= 1;
    srsSS3.Clear; srsB3.Clear; srsS3.Clear;
    Chart2.Title.Text[0]:= 'test func: '+tfInf.GetProblem.name+ss;
    if ss<>'' then exit;
    stx:= abs(tfInf.GetProblem.ss.min[0]-tfInf.GetProblem.ss.max[0])/50;
    sty:= abs(tfInf.GetProblem.ss.min[1]-tfInf.GetProblem.ss.max[1])/50;
    tfInf.SetX(1, tfInf.GetProblem.ss.min[1]);
    repeat
      tfInf.SetX(0, tfInf.GetProblem.ss.min[0]);
      repeat
        srsSS3.AddXYZ(tfInf.GetX(0), tfInf.Eval,tfInf.GetX(1));
        tfInf.SetX(0, tfInf.GetX(0)+stx);
      until (tfInf.GetX(0) > tfInf.GetProblem.ss.max[0]);
      tfInf.SetX(1, tfInf.GetX(1)+sty);
    until (tfInf.GetX(1) > tfInf.GetProblem.ss.max[1]);
  end;
  TraceFlag:= false;
  Chart1.Refresh;
  Application.ProcessMessages;
  for i:= 0 to Chart1.AxesList.Count-1 do
    Chart1.AxesList.Items[i].Automatic:= false;
end;

function TfmOutside.GetCollective: boolean;
begin
  Result:= true;
end;

procedure TfmOutside.Chart1DblClick(Sender: TObject);
begin
  ChartEditor1.Execute;
end;

function TfmOutside.GetDim: integer;
begin
  Result:= tfInf.GetDim;
end;

procedure TfmOutside.VisualUpdate(Sender: TObject);
var i,j: integer; x,y,a,mi,ma,st: double; xx: TDoubleDynArray; pso: TPSO;
begin
  if Quiet or not Showing or not (Sender is TPSO) then exit;
  pso:= TPSO(Sender);
  if Dim=1 then // 2D chart
  begin
    SetLength(xx,1);
    if pso.ParticleCount<>srsB2.Count then
    begin
      srsB2.FillSampleValues(pso.ParticleCount);
      srsS2.FillSampleValues(pso.ParticleCount);
    end;

    for i := 0 to pso.ParticleCount-1 do
    begin
      x:= pso.Particle[i].getPosition[0]; xx[0]:= x;
      y:= tfInf.Evaluate(xx); assert(not IsNaN(y));
      with srsB2 do
      begin
         XValue[i]:= x; YValue[i]:= y;
         //XLabel[i]:= FloatToStrF(pso.Particle[i].Inertia,ffGeneral,6,3);
      end;
      //srsB.Marks.Item[0]:= FloatToStr(pso.Particle[i].Inertia);
      with srsS2 do
      begin
        StartXValues[i]:= x; StartYValues[i]:= y;
        EndXValues[i]:= x+pso.Particle[i].Speed[0]; EndYValues[i]:= y;
      end;
    end;
  end
  else begin // 3D chart
    if pso.ParticleCount<>srsB3.Count then
    begin
      srsB3.FillSampleValues(pso.ParticleCount);
      srsS3.FillSampleValues(pso.ParticleCount);
    end;

    for i := 0 to pso.ParticleCount-1 do
    begin
      // bees
      x:= pso.Particle[i].getPosition[0];
      y:= pso.Particle[i].getPosition[1];

      with srsB3 do
      begin
        XValue[i]:= x;
        if Chart2.View3D
        then begin
          a:= tfInf.Evaluate(pso.Particle[i].getPosition); assert(not IsNaN(a));
          YValue[i]:= a;
          ZValue[i]:= y;
        end
        else begin
          YValue[i]:= y;
          ZValue[i]:= 0;
        end;
        // speeds
      srsS3.Visible:= not Chart2.View3D;
      if srsS3.Visible then
      with srsS3 do
        begin
          XValue[i]:= srsB3.XValue[i];
          YValue[i]:= srsB3.YValue[i];
          ZValue[i]:= srsB3.ZValue[i];
          EndXValues[i]:= srsB3.XValue[i]+pso.Particle[i].Speed[0];
          EndYValues[i]:= srsB3.YValue[i]+pso.Particle[i].Speed[1];
          EndZValues[i]:= 0;
        end;
    end; // particles
  end; // 3D
end;

end;

end.
