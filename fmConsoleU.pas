(************************************************************************)
(*  Bee22 - Particle Swarm Optimization framework     http://bee22.com  *)
(*  developed by and copyright(c) Teodor Krastev 2015-2016              *)
(************************************************************************)
unit fmConsoleU;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, UtilsU, Math,
  Vcl.StdCtrls, Vcl.ToolWin, Vcl.ExtDlgs, TestFuncU, Vcl.Buttons, Vcl.ExtCtrls,
  Types, System.StrUtils, PythonEngine, PythonU, Vcl.Menus;

type
  TfmConsole = class(TFrame)
    SaveTextFileDialog1: TSaveTextFileDialog;
    Splitter1: TSplitter;
    PageControl1: TPageControl;
    tsEval: TTabSheet;
    tsExec: TTabSheet;
    cbCmd: TComboBox;
    StaticText1: TStaticText;
    bbRollCmd: TBitBtn;
    mmScript2Run: TMemo;
    reLog: TRichEdit;
    pnlTools: TPanel;
    sbEraseLog: TSpeedButton;
    sbSaveLog: TSpeedButton;
    chkShow: TCheckBox;
    Panel1: TPanel;
    bbRun: TBitBtn;
    sbSavePy: TSpeedButton;
    sbOpenPy: TSpeedButton;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    PopupMenu1: TPopupMenu;
    pmExpanded: TMenuItem;
    N1: TMenuItem;
    pmSave: TMenuItem;
    pmErase: TMenuItem;
    N2: TMenuItem;
    pmLog: TMenuItem;
    procedure bbRollCmdClick(Sender: TObject);
    procedure cbCmdKeyPress(Sender: TObject; var Key: Char);
    procedure PageControl1Change(Sender: TObject);
    procedure bbRunClick(Sender: TObject);
    procedure sbEraseLogClick(Sender: TObject);
    procedure sbSaveLogClick(Sender: TObject);
    procedure sbOpenPyClick(Sender: TObject);
    procedure sbSavePyClick(Sender: TObject);
    procedure reLogDblClick(Sender: TObject);
    procedure pmLogClick(Sender: TObject);
    procedure pmExpandedClick(Sender: TObject);
  private
    { Private declarations }
    lastTime: TDateTime;
    function GetExpanded: boolean;
    procedure SetExpanded(value: boolean);
  public
    { Public declarations }
    AlwaysShowWarnings: boolean;
    procedure Log(msg: string); overload;
    procedure Log(dd: TDoubleDynArray); overload;
    procedure LogTime(lapse: boolean = false);

    procedure Warning(msg: string);
    procedure Error(msg: string);
    procedure Clear;

    procedure Init(scripter: boolean = false);
    property Expanded: boolean read GetExpanded write SetExpanded;
  end;

implementation
{$R *.dfm}
uses MVC_U, OptionsU;

function TfmConsole.GetExpanded: boolean;
begin
  Result:= pmExpanded.Checked;
end;

procedure TfmConsole.SetExpanded(value: boolean);
begin
  pmExpanded.Checked:= value;
  PageControl1.Visible:= Expanded;
  Splitter1.Visible:= Expanded;
  Splitter1.Height:= 3;
  pnlTools.Visible:= Expanded;
end;

procedure TfmConsole.Log(msg: string);
begin
  if not chkShow.Checked then exit;
  AddTxt2RichEdit(reLog,msg);
end;

procedure TfmConsole.Log(dd: TDoubleDynArray);
var i: integer; ss: string; d: double;
begin
  ss:= '';
  for d in dd do
    ss:= ss + F2S(d)+ ', ';
  log('=> '+leftStr(ss,length(ss)-2));
end;

procedure TfmConsole.LogTime(lapse: boolean = false);
begin
  if lapse then
  begin
    Log('time lapse: '+TimeToStr(Time-lastTime)+' ~~~~~~~');
  end
  else begin
    Log('the time is '+TimeToStr(Time));
    lastTime:= Time;
  end;
end;

procedure TfmConsole.PageControl1Change(Sender: TObject);
begin
  if not PageControl1.Visible then exit;
  if PageControl1.ActivePageIndex=0
    then PageControl1.Height:= max(cbCmd.Height+PageControl1.TabHeight+8,61)
    else PageControl1.Height:= 200;
end;

procedure TfmConsole.pmExpandedClick(Sender: TObject);
begin
  Expanded:= pmExpanded.Checked;
end;

procedure TfmConsole.pmLogClick(Sender: TObject);
begin
  if Sender=chkShow then pmLog.Checked:= chkShow.Checked;
  if Sender=pmLog then chkShow.Checked:= pmLog.Checked;
end;

procedure TfmConsole.reLogDblClick(Sender: TObject);
begin
  Expanded:= not Expanded;
  reLog.SelLength:= 0;
end;

procedure TfmConsole.sbEraseLogClick(Sender: TObject);
begin
  reLog.Lines.Clear;
end;

procedure TfmConsole.sbOpenPyClick(Sender: TObject);
begin
  with OpenDialog1 do
    begin
      if Execute then
        mmScript2Run.Lines.LoadFromFile( FileName );
    end;
end;

procedure TfmConsole.sbSavePyClick(Sender: TObject);
begin
  with SaveDialog1 do
    begin
      if Execute then
        mmScript2Run.Lines.SaveToFile( FileName );
    end;
end;

procedure TfmConsole.sbSaveLogClick(Sender: TObject);
begin
  if SaveTextFileDialog1.Execute then
     reLog.Lines.SaveToFile(SaveTextFileDialog1.FileName);
end;

procedure TfmConsole.Warning(msg: string);
begin
  if AlwaysShowWarnings then
     reLog.Lines.Add('Warning: '+msg)
  else Log('Warning: '+msg);
end;

procedure TfmConsole.Error(msg: string);
begin
  reLog.Lines.Add('Error: '+msg);  // unconditional
end;

procedure TfmConsole.bbRollCmdClick(Sender: TObject);
var gpy: TPythonEngine; ss: string;
begin
  if not PythonOK then exit;
  gpy:= GetPythonEngine;
  ss:= gpy.EvalStringAsStr(cbCmd.Text);
  AddTxt2RichEdit(reLog,'> '+cbCmd.Text+' = '+ss);
  cbCmd.Items.Insert(0,cbCmd.Text);
  cbCmd.Text:= ''; cbCmd.SetFocus;
end;

procedure TfmConsole.bbRunClick(Sender: TObject);
var gpy: TPythonEngine;
begin
  if not PythonOK then exit;
  py.SetOut(reLog);
  py.PyEngine.ExecStrings(mmScript2Run.Lines);
end;

procedure TfmConsole.cbCmdKeyPress(Sender: TObject; var Key: Char);
begin
  if Key=#13 then
  begin
    bbRollCmdClick(nil);
    Key:= #0;
  end;
end;

procedure TfmConsole.Clear;
begin
  reLog.Lines.Clear;
end;

procedure TfmConsole.Init(scripter: boolean = false);
begin
  PageControl1.Visible:= scripter;
  Splitter1.Visible:= scripter;
end;

end.
