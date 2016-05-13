(************************************************************************)
(*  Bee22 - Particle Swarm Optimization framework     http://bee22.com  *)
(*  developed by and copyright(c) Teodor Krastev 2015-2016              *)
(************************************************************************)
unit TrackerU;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, UtilsU, Vcl.StdCtrls,
  Vcl.CheckLst, Vcl.ExtCtrls, TestFuncU, Vcl.Samples.Spin, Vcl.Oleauto;

type
  TfmTracker = class(TFrame, InfObserver)
    Panel1: TPanel;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    chkPSO: TCheckListBox;
    chkPart: TCheckListBox;
    chkTrackNext: TCheckBox;
    seNumbIters: TSpinEdit;
    Label1: TLabel;
  private
    { Private declarations }
    oXL, oWB, oSheet: Variant;
  public
    { Public declarations }
    PSOprops, PartProps: TStrings;
    Quiet: boolean;
    procedure ChargeItems(psoI: IInterface);
    procedure Init(itf: ITestFunc);
    procedure Clear;
    procedure Close;
    function GetCollective: boolean;
    procedure VisualUpdate(Sender: TObject);
  end;

implementation
{$R *.dfm}
uses pso_algo, pso_particle;

procedure TfmTracker.ChargeItems(psoI: IInterface); // once at Scan.init
var
  i,j: integer; s,t: string; pso: IPSO;
begin
  pso:= IPSO(psoI);
  pso.GetPropNames(s,t);
  chkPSO.Items.CommaText:= s; //chkPSO.CheckAll(cbChecked);
  chkPart.Items.CommaText:= t; //chkPart.CheckAll(cbChecked);
  if not Assigned(PSOprops) then PSOprops:= TStringList.Create;
  for i:= 0 to chkPSO.Items.Count-1 do
    chkPSO.Checked[i]:= PSOprops.IndexOf(chkPSO.Items[i]) > -1;
  if not Assigned(PartProps) then PartProps:= TStringList.Create;
  for i:= 0 to chkPart.Items.Count-1 do
    chkPart.Checked[i]:= PartProps.IndexOf(chkPart.Items[i]) > -1;
end;

procedure TfmTracker.Init(itf: ITestFunc);
var
  i,j: integer;
begin
  if not chkTrackNext.Checked then exit;
  PSOprops.Clear;
  for i:= 0 to chkPSO.Items.Count-1 do
    if chkPSO.Checked[i] then PSOprops.Add(chkPSO.Items[i]);
  PartProps.Clear;
  for i:= 0 to chkPart.Items.Count-1 do
    if chkPart.Checked[i] then PartProps.Add(chkPart.Items[i]);

  // Start Excel and get Application Object
  oXL := CreateOleObject('Excel.Application');
  oXL.Visible := True;

  // Get a new workbook
  oWB := oXL.Workbooks.Add;
end;

procedure TfmTracker.VisualUpdate(Sender: TObject);
var
  i,j: integer; d,f: double; pso: TPSO;
begin
  if not chkTrackNext.Checked or not (Sender is TPSO) then exit;
  pso:= TPSO(Sender);
  chkTrackNext.Checked:= pso.Iterations < seNumbIters.Value;

  if pso.Iterations = 1 then oSheet := oWB.ActiveSheet
                        else oSheet:= oWB.Sheets.Add;
  for i:= 0 to PSOprops.Count-1 do // [row,col]
  begin
    oSheet.Cells[1,i+1]:= PSOprops[i];
    oSheet.Cells[2,i+1]:= F2S(pso.GetProp(PSOprops[i]));
  end;

  for i:= 0 to PartProps.Count-1 do
    oSheet.Cells[4,i+1]:= PartProps[i];
  for j:= 0 to pso.ParticleCount-1 do
  with pso.Particle[j] do
    for i:= 0 to PartProps.Count-1 do // [row,col]
      oSheet.Cells[5+j,i+1]:= F2S(GetProp(PartProps[i]));

end;

function TfmTracker.GetCollective: boolean;
begin
  Result:= false;
end;

procedure TfmTracker.Clear;
begin
  oXL:= Null; oWB:= Null; oSheet:= Null;
end;

procedure TfmTracker.Close;
begin
  Clear;
  PSOprops.Free; PartProps.Free;
end;

end.
