(************************************************************************)
(*  Bee22 - Particle Swarm Optimization framework     http://bee22.com  *)
(*  developed by and copyright(c) Teodor Krastev 2015-2016              *)
(************************************************************************)
unit UtilsU;

interface
uses SysUtils, System.Math, Classes, Windows, VCL.Forms, VCLTee.TeeInspector,
  Vcl.ComCtrls, Vcl.Graphics, StrUtils, Winapi.Messages, ShellAPI,
  TestFuncU, Types, IOUtils;

const
  smallDouble= 1.0E-100; Epsilon3 = 1E-6;
type
  // OBSERVERS
  InfObserver = interface
    procedure Init(itf: ITestFunc);
    function GetCollective: boolean;
    procedure VisualUpdate(Sender: TObject);
  end;

  TObserverList = class(TInterfaceList)
  private
    fMute: boolean;
    procedure SetMute(mt: boolean);
  public
    procedure Init(itf: ITestFunc);
    procedure VisualUpdate(Sender: TObject);

    property Mute: boolean read fMute write SetMute;
  end;

  TPropVal = class
  private
    fSel: byte;
    fInt: integer;
    fDbl: double;
    fOnChange: TNotifyEvent;
  protected
    procedure SetInt(vl: integer);
    procedure SetDbl(vl: double);
    procedure SetSel(vl: byte);
  public
    ReadOnly: boolean; // if true - mutable only from within the model (or desc), not GUI
    Hint: string;
    Style: TInspectorItemStyle; // iiBoolean, iiInteger, iiDouble, iiString, iiSelection
    bool: boolean;
    intMin,intMax: integer;
    dblMin,dblMax: double;
    str: string;
    selItems: string; // items of selection in comma list
    constructor Create(aStyle: TInspectorItemStyle = iiDouble; aReadOnly: boolean = false);
    procedure Assign(pv: TPropVal);
    function AsVar: variant;
    function AsDouble: double;
    function AsInt: integer;
    function AsString: string;
    procedure SetDouble(d: double);

    function selCount: integer;
    function rangeAsString: string; // allowed range of prop
    property int: integer read fInt write SetInt;
    property dbl: double read fDbl write SetDbl;
    property sel: byte read fSel write SetSel;
    property OnChange: TNotifyEvent read fOnChange write fOnChange;
  end;

  IPSO = interface
    procedure SetParticleCount(NumberOfParticles: integer);
    procedure SetEquidist(ed: boolean);
    function GetItf: ITestFunc;
    function GetIterations: integer;
    function GetMaxIterations: integer;
    procedure SetMaxIterations(mi: integer);
    function GetVaiablesCount: integer;
    function evaluatePartIdx(partIdx: integer): double;
    function getBestFitness(): double;
    function GetTolerance: double;
    function OutCount: integer;
    procedure Stop;
    function IsRunning: boolean;
    procedure GetPropNames(var PSO_PN, PartPN: string);
  end;

  TOnLogEvent = procedure (txt: string) of object;

  function Style2Str(Style: TInspectorItemStyle): string;
  function Str2Style(Style: string): TInspectorItemStyle;

  function F2S(d: double; prec: integer = 5): string;
  procedure AddTxt2RichEdit(reView: TRichEdit; txt: string; clr: TColor = clNone);

  function Sto_GetFmtFileVersion(const FileName: String = '';
                                 const Fmt: String = '%d.%d.%d.%d'): String;
  procedure Delay(DTime : LongInt);
  procedure FillArrayWith(arr: TDoubleDynArray; elem: double);
  procedure DeleteFolder(DirName: string);

  function HyperlinkExe(Hyperlink: string): boolean;
  function ShellExec(App,Prms: string): boolean;

var DecPlacesInProps: integer;

implementation

procedure TObserverList.Init(itf: ITestFunc);
var
  i: integer;
begin
  for i:= 0 to Count-1 do
  begin
    InfObserver(Items[i]).Init(itf);
  end;
end;

procedure TObserverList.VisualUpdate(Sender: TObject);
var i: integer;
begin
  for i:= 0 to Count-1 do
  begin
    if Mute and InfObserver(Items[i]).GetCollective then continue;
    InfObserver(Items[i]).VisualUpdate(Sender);
  end;
end;

procedure TObserverList.SetMute(mt: boolean);
begin
  fMute:= mt;
end;
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

constructor TPropVal.Create(aStyle: TInspectorItemStyle = iiDouble; aReadOnly: boolean = false);
begin
  inherited Create;
  Style:= aStyle; ReadOnly:= aReadOnly;
  intMin:= Low(Integer); // -2147483648
  intMax := High(Integer); // 2147483647
  dblMin:= -Infinite;
  dblMax:= Infinite;
end;

procedure TPropVal.SetInt(vl: integer);
begin
  fInt:= EnsureRange(vl, intMin,intMax);
  if Assigned(OnChange) then OnChange(self);
end;

procedure TPropVal.SetDbl(vl: double);
var d: double;
begin
  d:= vl;
  if not IsInfinite(dblMin) then
    if d<dblMin then d:= dblMin;
  if not IsInfinite(dblMax) then
    if d>dblMax then d:= dblMax;
  fDbl:= d;
  if Assigned(OnChange) then OnChange(self);
end;

function TPropVal.selCount: integer;
var ts: TStrings;
begin
  ts:= TStringList.Create;
  ts.CommaText:= selItems;
  Result:= ts.Count;
  ts.Free;
end;

function TPropVal.rangeAsString: string;
var ts: TStrings;
begin
  case Style of
    iiBoolean: Result:= 'True..False';
    iiInteger: Result:= IntToStr(intMin)+'..'+IntToStr(intMax);
    iiDouble:  Result:= F2S(dblMin)+'..'+F2S(dblMax);
    iiString:  Result:= 'string type';
    iiSelection:begin
                  ts:= TStringList.Create;
                  ts.CommaText:= selItems;
                  Result:= '"'+ts[0]+'".."'+ts[ts.Count-1]+'"';
                  ts.Free;
                end;
  end;
end;

procedure TPropVal.SetSel(vl: byte);
begin
  if selCount=0 then exit;
  fSel:= EnsureRange(vl, 0,selCount-1);
  if Assigned(OnChange) then OnChange(self);
end;

procedure TPropVal.Assign(pv: TPropVal);
begin
  ReadOnly:= pv.ReadOnly;
  Style:= pv.Style;
  case pv.Style of
    iiBoolean: bool:= pv.bool;
    iiInteger: begin
                 intMin:= pv.intMin; intMax:= pv.intMax;
                 int:= pv.int;
               end;
    iiDouble:  begin
                 dblMin:= pv.dblMin; dblMax:= pv.dblMax;
                 dbl:= pv.dbl;
               end;
    iiString:  str:= pv.str;
    iiSelection:begin
                  sel:= pv.sel;
                  selItems:= pv.selItems;
                end;
  end;
end;

function TPropVal.AsVar: variant;
begin
  case Style of
    iiBoolean: Result:= variant(bool);
    iiInteger: Result:= variant(int);
    iiDouble: Result:= variant(SimpleRoundTo(dbl,-DecPlacesInProps));
    iiString: Result:= variant(str);
    iiSelection: Result:= variant(sel);
  end;
end;

function TPropVal.AsDouble: double;
begin
  case Style of
    iiBoolean,
    iiSelection,
    iiInteger: Result:= AsInt;
    iiDouble: Result:= dbl;
  end;
end;

function TPropVal.AsInt: integer;
begin
  case Style of
    iiBoolean: if bool then Result:= 1
                       else Result:= 0;
    iiInteger: Result:= int;
    iiDouble: Result:= Round(dbl);
    iiSelection: Result:= sel;
  end;
end;

function TPropVal.AsString: string;
var ts: TStrings;
begin Result:= '';
  case Style of
    iiBoolean: Result:= BoolToStr(bool);
    iiInteger: Result:= IntToStr(int);
    iiDouble:  Result:= F2S(dbl);
    iiString:  Result:= str;
    iiSelection:
      begin
        ts:= TStringList.Create;
        ts.CommaText:= selItems;
        if InRange(sel,0,ts.Count-1) then
          Result:= ts[sel];
        ts.Free;
      end;
  end;
end;

procedure TPropVal.SetDouble(d: double);
var ts: TStrings; sl: integer;
begin
  case Style of
    iiBoolean: bool:= not IsZero(d,Epsilon2);
    iiInteger: int:= round(d);
    iiDouble:  dbl:= d;
    iiString:  str:= F2S(d);
    iiSelection:
      begin
        ts:= TStringList.Create;
        ts.CommaText:= selItems;
        sl:= round(d);
        if InRange(sl,0,ts.Count-1) then
          sel:= sl;
        ts.Free;
      end;
  end;
end;

function Style2Str(Style: TInspectorItemStyle): string;
begin
  case Style of
    iiBoolean: Result:= 'bool';
    iiInteger: Result:= 'int';
    iiDouble:  Result:= 'dbl';
    iiString:  Result:= 'str';
    iiSelection: Result:= 'sel';
  end;
end;

function Str2Style(Style: string): TInspectorItemStyle;
begin
  if SameText(Style, 'bool') then Result:= iiBoolean;
  if SameText(Style, 'int')  then Result:= iiInteger;
  if SameText(Style, 'dbl')  then Result:=iiDouble;
  if SameText(Style, 'str')  then Result:= iiString;
  if SameText(Style, 'sel')  then Result:= iiSelection;
end;
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

function F2S(d: double; prec: integer  = 5): string;
begin
  Result:= FloatToStrF(d,ffGeneral,prec,3);
end;

procedure AddTxt2RichEdit(reView: TRichEdit; txt: string; clr: TColor = clNone);
begin
  while reView.Lines.Count>1500 // lines number limit
    do reView.Lines.Delete(0);
  reView.SelAttributes.Style := []; // default style
  if clr=clNone then
  begin
    reView.SelAttributes.Color := clBlack; // default color
    if (leftStr(txt,1)='!') or (leftStr(txt,1)='#') then
      reView.SelAttributes.Color := clMaroon;
    if (leftStr(txt,2)='=>') or (leftStr(txt,3)='...')  then
    begin
      reView.SelAttributes.Color := clNavy;
      reView.SelAttributes.Style := [fsBold];
    end;
    if leftStr(txt,3)='Err' then
      reView.SelAttributes.Color := $000000D2;
    if leftStr(txt,3)='War' then
    begin
      reView.SelAttributes.Color := $000054A8; // orange
      reView.SelAttributes.Style := [fsBold];
    end;
    if leftStr(txt,1)='>' then
      reView.SelAttributes.Color := clNavy;
  end
  else reView.SelAttributes.Color := clr;
  reView.SelText:= txt+chr(10);
  if reView.CanFocus and reView.Showing then
  begin
    reView.SetFocus;
    reView.SelStart := reView.GetTextLen;
    reView.Perform(EM_SCROLLCARET, 0, 0);
  end;
end;

/// <summary>
///   This function reads the file resource of "FileName" and returns
///   the version number as formatted text.</summary>
/// <example>
///   Sto_GetFmtFileVersion() = '4.13.128.0'
///   Sto_GetFmtFileVersion('', '%.2d-%.2d-%.2d') = '04-13-128'
/// </example>
/// <remarks>If "Fmt" is invalid, the function may raise an
///   EConvertError exception.</remarks>
/// <param name="FileName">Full path to exe or dll. If an empty
///   string is passed, the function uses the filename of the
///   running exe or dll.</param>
/// <param name="Fmt">Format string, you can use at most four integer
///   values.</param>
/// <returns>Formatted version number of file, '' if no version
///   resource found.</returns>
function Sto_GetFmtFileVersion(const FileName: String = '';
  const Fmt: String = '%d.%d.%d.%d'): String;
var
  sFileName: String;
  iBufferSize: DWORD;
  iDummy: DWORD;
  pBuffer: Pointer;
  pFileInfo: Pointer;
  iVer: array[1..4] of Word;
begin
  // set default value
  Result := '';
  // get filename of exe/dll if no filename is specified
  sFileName := FileName;
  if (sFileName = '') then
  begin
    // prepare buffer for path and terminating #0
    SetLength(sFileName, MAX_PATH + 1);
    SetLength(sFileName,
      GetModuleFileName(hInstance, PChar(sFileName), MAX_PATH + 1));
  end;
  // get size of version info (0 if no version info exists)
  iBufferSize := GetFileVersionInfoSize(PChar(sFileName), iDummy);
  if (iBufferSize > 0) then
  begin
    GetMem(pBuffer, iBufferSize);
    try
    // get fixed file info (language independent)
    GetFileVersionInfo(PChar(sFileName), 0, iBufferSize, pBuffer);
    VerQueryValue(pBuffer, '\', pFileInfo, iDummy);
    // read version blocks
    iVer[1] := HiWord(PVSFixedFileInfo(pFileInfo)^.dwFileVersionMS);
    iVer[2] := LoWord(PVSFixedFileInfo(pFileInfo)^.dwFileVersionMS);
    iVer[3] := HiWord(PVSFixedFileInfo(pFileInfo)^.dwFileVersionLS);
    iVer[4] := LoWord(PVSFixedFileInfo(pFileInfo)^.dwFileVersionLS);
    finally
      FreeMem(pBuffer);
    end;
    // format result string
    Result := Format(Fmt, [iVer[1], iVer[2], iVer[3], iVer[4]]);
  end;
end;

procedure Delay(DTime : LongInt); { delay DTime miliseconds; negative - no proc-msg }
var L, DT : LongInt;
begin L := GetTickCount; DT:= abs(DTime);
  While (Abs(L-GetTickCount) < DT) do
        if DTime>0 then Application.ProcessMessages;
end; { Delay }

procedure FillArrayWith(arr: TDoubleDynArray; elem: double);
var
  i: integer;
begin
  for i:= 0 to length(arr)-1 do
    arr[i]:= elem;
end;

procedure DeleteFolder(DirName: string);
var
  Str: String;
begin
  for Str in TDirectory.GetFiles(DirName) do
    TFile.Delete(Str);
  RemoveDir(DirName);
end;

function ShellExec(App,Prms: string): boolean;
begin
  Result:= ShellExecute(GetDesktopWindow(), PWideChar('open'), PWideChar(App), PWideChar(Prms), nil,
                        SW_SHOWNORMAL)>32;
end;

function HyperlinkExe(Hyperlink: string): boolean;
begin
  Result:= ShellExecute(GetDesktopWindow(), PWideChar('open'), PWideChar(Hyperlink), nil, nil,
                        SW_SHOWNORMAL)>32;
end;

end.
