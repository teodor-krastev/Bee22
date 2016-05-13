(************************************************************************)
(*  Bee22 - Particle Swarm Optimization framework     http://bee22.com  *)
(*  developed by and copyright(c) Teodor Krastev 2015-2016              *)
(************************************************************************)
unit fmSubswarmsU;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, Math,
  UtilsU, TestFuncU, Vcl.ExtCtrls;

type
  TfmSubswarms = class(TFrame, InfObserver)
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Splitter1: TSplitter;
    StringGrid0: TStringGrid;
    StringGrid1: TStringGrid;
    StringGrid2: TStringGrid;
    StringGrid3: TStringGrid;
    StringGrid4: TStringGrid;
    procedure FrameResize(Sender: TObject);
  private
    { Private declarations }
    sg: array[0..4] of TStringGrid;
    procedure VisualUpdate(Sender: TObject);
  public
    { Public declarations }
    Quiet: boolean;
    procedure Init(itf: ITestFunc);
    function GetCollective: boolean;
  end;

implementation
{$R *.dfm}
uses pso_algo,pso_particle;

procedure TfmSubswarms.FrameResize(Sender: TObject);
var
  i: integer;
begin
  if not Assigned(sg[0]) then Init(nil);
  for i:= 0 to 4 do
   sg[i].Width:= ceil(width/5);
end;

procedure TfmSubswarms.Init(itf: ITestFunc);
var
  i: integer;
begin
  sg[0]:= StringGrid0; sg[1]:= StringGrid1; sg[2]:= StringGrid2;
  sg[3]:= StringGrid3; sg[4]:= StringGrid4;
  for i:= 0 to 4 do
  begin
    sg[i].Cols[0].Clear; sg[i].ColWidths[0]:= 40;
    sg[i].Cols[1].Clear; sg[i].ColWidths[1]:= 75;
    sg[i].Cols[2].Clear; sg[i].ColWidths[2]:= 50;
    sg[i].Cells[0,0]:= 'Best'; sg[i].Cells[0,1]:= 'Worst';
    sg[i].Cells[0,2]:= 'P.Idx'; sg[i].Cells[1,2]:= 'Fitness'; sg[i].Cells[2,2]:= 'Memb';
    sg[i].FixedRows:= 3;
  end;
end;

function TfmSubswarms.GetCollective: boolean;
begin
  Result:= true;
end;

procedure TfmSubswarms.VisualUpdate(Sender: TObject);
var
  i,j,n,k,m: integer; d,f: double; pso: TPSO; prt: TParticle;
begin
  if Quiet or not Showing or not (Sender is TPSO) then exit;
  pso:= TPSO(Sender);
  if pso.SubSw.Count=0 then exit;
  n:= min(pso.SubSw.Count,5);
  k:= 3;
  for i:= 0 to n-1 do // sg's/sub-swarms
  begin
    if sg[i].RowCount<>pso.ParticleCount then sg[i].RowCount:= pso.ParticleCount;

    prt:= pso.SubSw[i].BestPrt;
    if Assigned(prt) then
      sg[i].Cells[1,0]:= IntToStr(prt.Idx)+'/'+FloatToStrF(prt.getFitness,ffGeneral,3,2)
      else sg[i].Cells[1,0]:= '';
    prt:= pso.SubSw[i].WorstPrt;
    if Assigned(prt) then
      sg[i].Cells[1,1]:= IntToStr(prt.Idx)+'/'+FloatToStrF(prt.getFitness,ffGeneral,3,2)
      else sg[i].Cells[1,1]:= '';

    for j:= 0 to pso.SubSw[i].Count-1 do // parts
    begin
      prt:= pso.SubSw[i].Items[j];
      if not Assigned(prt) then continue;
      sg[i].Cells[0,j+k]:= ' '+IntToStr(prt.Idx);
      sg[i].Cells[1,j+k]:= FloatToStrF(prt.getFitness,ffGeneral,3,2);
      sg[i].Cells[2,j+k]:= ' '+IntToStr(pso.SubSw.PartMemLevel(prt));
    end;
    m:= pso.SubSw[i].Count+k;
    for j:= m to sg[i].RowCount-1 do // parts
      sg[i].Rows[j].Clear;
  end;
end;


end.
