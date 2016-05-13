(************************************************************************)
(*  Bee22 - Particle Swarm Optimization framework     http://bee22.com  *)
(*  developed by and copyright(c) Teodor Krastev 2015-2016              *)
(************************************************************************)
unit MVC_U;

interface
uses System.SysUtils, System.Variants, System.Classes, Generics.Collections,
  VCLTee.TeeInspector, System.Math, System.IniFiles,
  uPSCompiler, uPSRuntime, uPSUtils, TestFuncU, UtilsU, OptionsU,
  PythonEngine;

type
  // source
  rFunc = record
    nm, prms: string; // prms - comma-list of prm names; defined in block
    code: string; // after the header
    enabled: boolean; // in header line
  end;

  TSource = class(TComponent)  // script part of a block
  private
    function GetCount: integer;
    procedure SetCount(cnt: integer);
  public
    commonCode, blkName: string;
    enabled: boolean;
    Funcs: array of rFunc; // the skeleton is created in model config
    { syntax
    #[common
    ...common code
    #]common
    #[funcName Enabled=0/1
    def funcName(prm1,prm2...) - the header is defined in the delphi code nm(prms) -
    ... the func code
    #]funcName
    }
    function IdxByName(nm: string): integer;
    function FuncByName(nm: string): rFunc;
    procedure Exec(cmd: string);
    function Open(IniFN,BlockName: string): boolean; // fill-in the existing in file funcs
    procedure Save(IniFN,BlockName: string); // save the non-empty funcs
    property Count: integer read GetCount write SetCount;
  end;

  // View interface
  IView = interface
    procedure UpdateView(PropName: string; PropVal: TPropVal);
    procedure SetOnChangeEvent(event: TNotifyEvent);
  end;

  IblkModel = interface
    procedure Config; // called once created or after Configure
    procedure Clear;
    function GetOnConfigure: TNotifyEvent; // hook for Configure
    procedure Init(idx: integer);  // before optimization cycle (run)
    procedure DoChange(idx: integer); // at each iteration at pso block and
              // for each particle at each iteration for particle (idx) block
    function LoadSrc(iniFN: string): boolean;
    procedure SaveSrc(iniFN: string);
    function GetSource: TSource;

    procedure RegView(view: IView); // register view
    procedure SetLocked(lck: boolean);
    procedure Notify(PropName: string; PropVal: TPropVal);
              // if PropVal real assign to model (SetProp) and update the view
              // if nil does not update model, but takes stored value for views
    procedure SynchroUp(PropName: string);
    procedure NotifyAll;

    function GetName: string;
    function GetDesc: string;
    function propCount: integer;
    function GetPropName(idx: integer): string; // from 0 till gets back empty
    function GetPropVar(PropName: string): variant;
    procedure SetPropVar(PropName: string; PropVal: variant);
    function GetProp(PropName: string): TPropVal;
    procedure SetProp(PropName: string; PropVal: TPropVal);
  end;
{$TYPEINFO ON}
{$METHODINFO ON}
  TblkModel = class(TComponent, IblkModel)
  private
    blkName: string;
    iViews: TInterfaceList;
    fCurrentPropName: string;
    SynLocked: boolean; // locks out the view OnChange events
    fOnConfigure: TNotifyEvent;
  protected
    Desc: string;
    OncePerIter: boolean; // for particle specific: in DoChange idx>-1
    psoObj: TObject;
    Locked: boolean; // locks out the view OnChange events
    source: TSource;
    wpv: TPropVal; // working PropVal

      // on change of prop change other interdependent props
    procedure Synchro(PropName: string); virtual; abstract;
  public
    props: TStrings; // name, pv in object

    constructor Create(aOwner: TComponent; ThePSO: TObject; aBlkName: string);

       // create props in the model from instance; once in the pso lifetime
    procedure Config; virtual; abstract;
    procedure Remove(PropName: string);
    procedure Clear;
    function GetOnConfigure: TNotifyEvent;

      // synchro props in case there are internal dependancies;
      // before each optim run, just before PSO.Init(...)
    procedure Init(idx: integer); virtual;
    procedure DoChange(idx: integer); virtual; abstract;

    function LoadSrc(iniFN: string): boolean;
    procedure SaveSrc(iniFN: string);
    function GetSource: TSource;

    destructor Destroy; override;
    procedure RegView(View: IView);
    procedure SetLocked(lck: boolean);

    procedure OnChangeView(Sender: TObject);
    procedure UpdateAllViews(PropName: string = ''; PropVal: TPropVal = nil);
    procedure Notify(PropName: string; PropVal: TPropVal = nil); overload;
              // if nil does not update model but takes stored value for views
    procedure SynchroUp(PropName: string);

    procedure Notify(PropName: string; PropVal: double); overload;
    procedure Notify(PropName: string; PropVal: integer); overload;
    procedure Notify(PropName: string; PropVal: byte); overload;
    procedure Notify(PropName: string; PropVal: boolean); overload;
    procedure NotifyAll; // updates views for all props

    function GetName: string;
    function GetDesc: string;

    function GetProp(PropName: string): TPropVal;
    procedure SetProp(PropName: string; PropVal: TPropVal); overload;
    procedure SetProp(PropName: string; PropVal: double); overload;
    procedure SetProp(PropName: string; PropVal: integer); overload;
    procedure SetProp(PropName: string; PropVal: byte); overload;
    procedure SetProp(PropName: string; PropVal: boolean); overload;
    function GetPropVar(PropName: string): variant;
    procedure SetPropVar(PropName: string; PropVal: variant);
    // creates one if no there; if creates, the type/style is taken from PropVal
    // if exists, preserves the style

    property CurrentPropName: string read fCurrentPropName write fCurrentPropName;
    property OnConfigure: TNotifyEvent read fOnConfigure write fOnConfigure;

  published
    function propCount: integer;
    function getPropName(idx: integer): string; // from 0 till gets back empty
    function getP(PropName: string): variant;
    procedure setP(PropName: string; PropVal: variant);
    procedure setFuncCode(func, code: string); // sets func.enabled to true
    // code:= '' EQUIV code:='  pass' EQUIV enabled:= false
  end;
{$METHODINFO OFF}
{$TYPEINFO OFF}

///////////////////////////////////////////////////////////////////////////

  TController = class(TComponent)
  private
    fLockedUI: boolean;
    iModels: TInterfaceList;
    forks: TStrings;
    IniFile: TIniFile;
    fOnLog: TOnLogEvent;
    function GetModels(mdlName: string): IblkModel;
  protected
    procedure SetLockedUI(locked: boolean);
  public
    rslt: variant;
    frmOpts: TfrmOptions; // only reference

    constructor Create(aOwner: TComponent); override;
    destructor Destroy; override;

    function RegModel(mdl: TblkModel; fork: string): integer;
    procedure UnregModel(mdl: TblkModel);

    // for all sections that does not exist models are kept unchanged
    procedure IniLoad(fn: string); // after reg all the models
    procedure IniSave(fn: string);

    function Eval(cmd: string): variant;
    procedure Exec(script: string);

    function modelCount: integer;
    function modelByIdx(idx: integer): IblkModel;
    function modelByFork(fork: string): IblkModel;
    property Models[mdlName: string]: IblkModel read GetModels;
    property OnLog: TOnLogEvent read fOnLog  write fOnLog;
    property LockedUI: boolean read fLockedUI write SetLockedUI;
  end;

  TctrlPort = class
  protected
    ctrl: TController;
  public
    constructor Create(aCtrl: TController); overload;
    procedure IniLoad(fn: string); // after reg all the models
    procedure IniSave(fn: string);
    function SetRslt(vr: variant): boolean;

    function modelCount: integer;
    function modelNameByIdx(idx: integer): string; // from 0 till gets back empty
    function propCount(mdlNm: string): integer;
    function GetPropName(mdlNm: string; idx: integer): string; // from 0 till gets back empty
    function GetPropByIdx(mdlIdx, propIdx: integer): TPropVal;
    function GetProp(mdlNm, propNm: string): TPropVal;
    function SetProp(mdlNm, propNm: string; pv: TPropVal): boolean;
    procedure Notify(mdlNm, propNm: string);


  end;

  function ImplementsAbstractMethod(AObj: TblkModel): Boolean;

implementation
uses uPSC_std, uPSR_std, ctrlCenterU, pso_algo;

function TSource.GetCount: integer;
begin
  Result:= length(Funcs);
end;

procedure TSource.SetCount(cnt: integer);
begin
  SetLength(Funcs,cnt);
end;

function TSource.IdxByName(nm: string): integer;
var
  i: integer;
begin
  Result:= -1;
  for i:= 0 to Count-1 do
    if SameText(Funcs[i].nm,nm) then
    begin
      Result:= i; break;
    end;
end;

function TSource.FuncByName(nm: string): rFunc;
begin
  Result:= Funcs[IdxByName(nm)];
end;

procedure TSource.Exec(cmd: string);
begin
  if not PythonOK or (trim(cmd)='') then exit;
  GetPythonEngine.ExecString(cmd);
end;

function ProduceFN(IniFN,BlockName: string): string;
begin
  Result:= ChangeFileExt(ChangeFileExt(IniFN,'')+'_'+BlockName,'.py');
end;

function TSource.Open(IniFN,BlockName: string): boolean;
var
  ss,st: string; ls,lt: TStrings; i,j,k,m,n: integer;
begin
  Result:= true;
  blkName:= BlockName;
  if Count = 0 then exit;

  Result:= false;
  ls:= TStringList.Create; lt:= TStringList.Create;
  ls.LoadFromFile(ProduceFN(IniFN,BlockName));
  for j:= 0 to ls.Count-1 do
  begin
    if pos('#[common',ls[j])=0 then continue;
    k:= j; st:= ls[j]; break;
  end;
  for j:= k+1 to ls.Count-1 do
  begin
    if pos('#]common',ls[j])>0 then break;
    lt.Add(ls[j]);
  end;
  commonCode:= lt.Text;
  for i:= 0 to Count-1 do
  begin
    if Funcs[i].nm='' then continue;
    ss:= '#['+Funcs[i].nm+' ';
    for j:= 0 to ls.Count-1 do
    begin
      if pos(ss,ls[j])=0 then continue;
      Funcs[i].enabled:= pos('Enabled=-1',ls[j])>0;
      k:= j+1; st:= ls[k]; break;
    end;
    lt.Clear;
    assert(trim(st)='def '+Funcs[i].nm+'('+Funcs[i].prms+')');
    for j:= k+1 to ls.Count-1 do
    begin
      if pos('#]'+Funcs[i].nm,ls[j])>0 then break;
      lt.Add(ls[j]);
    end;
    Funcs[i].code:= lt.Text;
  end;
  ls.Free; lt.Free;
  Result:= true;
end;

procedure TSource.Save(IniFN,BlockName: string);
var
  ss,st: string; ls, lt: TStrings; i: integer;
begin
  if length(Funcs)=0 then exit; // the len must be set in Config of the block

  ls:= TStringList.Create; lt:= TStringList.Create;
  ls.Add('#[common');
  lt.Text:= commonCode; ls.AddStrings(lt);
  ls.Add('#]common');
  for i:= 0 to Count-1 do
  begin ls.Add('');
    ls.Add('#['+Funcs[i].nm+' Enabled='+BoolToStr(Funcs[i].enabled,false));
    ls.Add('def '+Funcs[i].nm+'('+Funcs[i].prms+')');
    lt.Text:= Funcs[i].code; ls.AddStrings(lt);
    ls.Add('#]'+Funcs[i].nm);
  end;
  ls.SaveToFile(ProduceFN(IniFN,BlockName));
  ls.Free; lt.Free;
end;
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

constructor TblkModel.Create(aOwner: TComponent; ThePSO: TObject; aBlkName: string);
begin
  inherited Create(aOwner);
  psoObj:= ThePSO;
  blkName:= aBlkName;
  props:= TStringList.Create;
  iViews:= TInterfaceList.Create;
  source:= TSource.Create(self); source.enabled:= true;
  Locked:= false;
  fCurrentPropName:= '<none>';
end;

procedure TblkModel.Remove(PropName: string);
var i: integer;
begin
  i:= props.IndexOf(PropName);
  if i=-1 then exit;
  TPropVal(props.Objects[i]).Free;
  props.Delete(i);
end;

procedure TblkModel.Clear;
var i: integer;
begin
  for i:= 0 to propCount-1 do
    TPropVal(props.Objects[i]).Free;
  props.Clear;
end;

function TblkModel.GetOnConfigure: TNotifyEvent;
begin
  Result:= fOnConfigure;
end;

procedure TblkModel.Init(idx: integer);
var
  gpy: TPythonEngine; ss: string; i: integer; ls,lt: TStrings;
begin
  if not PythonOK then exit;
  gpy:= GetPythonEngine;
  ls:= TStringList.Create; lt:= TStringList.Create;
  ls.Text:= source.commonCode;
  for i:= 0 to length(source.Funcs)-1 do
  begin
    if not source.Funcs[i].enabled then continue;
    if trim(source.Funcs[i].code)='' then lt.Text:= '  pass'
      else lt.Text:= source.Funcs[i].code;
    lt.Insert(0,'def '+source.Funcs[i].nm+'('+source.Funcs[i].prms+'):');
    ls.AddStrings(lt);
  end;
  if source.enabled then gpy.ExecStrings(ls);
  ls.Free; lt.Free;
end;

function TblkModel.LoadSrc(iniFN: string): boolean;
begin
  Result:= source.Open(iniFN,blkName);
end;

procedure TblkModel.SaveSrc(iniFN: string);
begin
  source.Save(iniFN,blkName);
end;

function TblkModel.GetSource: TSource;
begin
  Result:= source;
end;

destructor TblkModel.Destroy;
var
  i: integer;
begin
  Clear;
  FreeAndNil(props);
  FreeAndNil(iViews);
  inherited Destroy;
end;

procedure TblkModel.RegView(View: IView);
begin
  iViews.Add(View);
  View.SetOnChangeEvent(OnChangeView);
end;

procedure TblkModel.SetLocked(lck: boolean);
begin
  Locked:= lck;
end;

procedure TblkModel.OnChangeView(Sender: TObject);
var
  ii: TInspectorItem; pv: TPropVal; ls: TStrings;
begin
  ii:= TInspectorItem(Sender);
  if Locked or not ii.Enabled or (fCurrentPropName <> '<none>') then exit;
  pv:= GetProp(ii.Caption);
  case pv.Style of
    iiBoolean: pv.bool:= boolean(ii.Value);
    iiInteger: pv.int:= integer(ii.Value);
    iiDouble: pv.dbl:= double(ii.Value);
    iiString: pv.str:= string(ii.Value);
    iiSelection:
      begin
        ls:= TStringList.Create;
        ls.CommaText:= pv.selItems;
        pv.sel:= EnsureRange(ls.IndexOf(string(ii.Value)),0,255);
        ls.Free;
      end;
  end;
  SetProp(ii.Caption,pv);

  if SynLocked then exit; // avoid dead-lock SynchroUp
  SynLocked:= true;
  SynchroUp(ii.Caption);
  SynLocked:= false;
end;

procedure TblkModel.SynchroUp(PropName: string);
begin
  if ImplementsAbstractMethod(self) then Synchro(PropName);
end;

procedure TblkModel.UpdateAllViews(PropName: string = ''; PropVal: TPropVal = nil);
var
  i: byte;
begin
  if iViews.Count > 0 then
    for i := 0 to iViews.Count - 1 do
      IView(iViews.Items[i]).UpdateView(PropName, PropVal);
end;

procedure TblkModel.Notify(PropName: string; PropVal: TPropVal =nil);
var
  i: byte; View: IView; pv: TPropVal;
begin
  if (PropName='') then raise Exception.Create('Error: in Notify');
  if PropName=fCurrentPropName then exit; // avoid dead loop
  fCurrentPropName:= PropName;
  if PropName[1]<>'@' then
  begin
    if PropVal=nil then pv:= GetProp(PropName)
      else begin
        pv:= PropVal; SetProp(PropName,pv)
      end;
  end
  else pv:= PropVal;
  UpdateAllViews(PropName,pv);
  fCurrentPropName:= '<none>';
end;

procedure TblkModel.Notify(PropName: string; PropVal: double);
begin
  wpv:= GetProp(PropName); wpv.dbl:= PropVal;
  Notify(PropName,wpv);
end;

procedure TblkModel.Notify(PropName: string; PropVal: integer);
begin
  wpv:= GetProp(PropName); wpv.int:= PropVal;
  Notify(PropName,wpv);
end;

procedure TblkModel.Notify(PropName: string; PropVal: byte);
begin
  wpv:= GetProp(PropName); wpv.sel:= PropVal;
  Notify(PropName,wpv);
end;

procedure TblkModel.Notify(PropName: string; PropVal: boolean);
begin
  wpv:= GetProp(PropName); wpv.bool:= PropVal;
  Notify(PropName,wpv);
end;

procedure TblkModel.NotifyAll;
var i: byte;
begin
  if propCount=0 then
  begin
    UpdateAllViews('',nil); exit;
  end;
  for i:= 0 to propCount-1 do
    Notify(props[i]);
end;

function TblkModel.GetName: string;
begin
  Result:= blkName;
end;

function TblkModel.GetDesc: string;
begin
  Result:= Desc;
end;

function TblkModel.propCount: integer;
begin
  Result:= props.Count;
end;

function TblkModel.GetPropName(idx: integer): string; // from 0 till gets back empty
begin
  Result:= '';
  if InRange(idx, 0,props.Count-1) then
    Result:= props[idx];
end;

function TblkModel.GetProp(PropName: string): TPropVal;
var
  i: integer;
begin
  Result:= nil;
  if (PropName='') then raise Exception.Create('Error: in GetProp');
  i:= props.IndexOf(LowerCase(PropName));
  //assert(i>-1);
  if i>-1 then Result:= TPropVal(props.Objects[i]);
end;

// replace or add if PropName is there or not
procedure TblkModel.SetProp(PropName: string; PropVal: TPropVal);
var
  i: integer; pv: TPropVal;
begin
  if (PropName='') or not Assigned(PropVal) then raise Exception.Create('Error: in SetProp');
  pv:= GetProp(PropName);
  if pv=nil then props.AddObject(LowerCase(PropName), PropVal)
    else begin
      if not pv.ReadOnly then pv.Assign(PropVal);
    end;
end;

procedure TblkModel.SetProp(PropName: string; PropVal: double);
var pv: TPropVal;
begin
  if (PropName='') then raise Exception.Create('Error: in SetProp');
  pv:= GetProp(PropName);
  if pv=nil then pv:= TPropVal.Create(iiDouble);
  if pv.Style<>iiDouble then raise Exception.Create('Error: in SetProp style');
  pv.dbl:= PropVal;
  SetProp(PropName,pv);
end;

procedure TblkModel.SetProp(PropName: string; PropVal: integer);
var pv: TPropVal;
begin
  if (PropName='') then raise Exception.Create('Error: in SetProp');
  pv:= GetProp(PropName);
  if pv=nil then pv:= TPropVal.Create(iiInteger);
  if pv.Style<>iiInteger then raise Exception.Create('Error: in SetProp style');
  pv.int:= PropVal;
  SetProp(PropName,pv);
end;

procedure TblkModel.SetProp(PropName: string; PropVal: byte);
var
  pv: TPropVal;
begin
  if (PropName='') then raise Exception.Create('Error: in SetProp');
  pv:= GetProp(PropName);
  if pv=nil then pv:= TPropVal.Create(iiSelection);
  if pv.Style<>iiSelection then raise Exception.Create('Error: in SetProp style');
  pv.sel:= PropVal;
  SetProp(PropName,pv);
end;

procedure TblkModel.SetProp(PropName: string; PropVal: boolean);
var
  pv: TPropVal;
begin
  if (PropName='') then raise Exception.Create('Error: in SetProp');
  pv:= GetProp(PropName);
  if pv=nil then pv:= TPropVal.Create(iiBoolean);
  if pv.Style<>iiBoolean then raise Exception.Create('Error: in SetProp style');
  pv.bool:= PropVal;
  SetProp(PropName,pv);
end;

function TblkModel.GetPropVar(PropName: string): variant;
var PropVal: TPropVal;
begin
  PropVal:= GetProp(PropName);
  if Assigned(PropVal) then Result:= PropVal.AsVar
    else Result:= NULL;
end;

function TblkModel.getP(PropName: string): variant;
begin
  Result:= GetPropVar(PropName);
end;

procedure TblkModel.SetPropVar(PropName: string; PropVal: variant);
  // creates one if no there; if creates, the type/style is taken from PropVal
  // if exists, preserves the style
var
  pv: TPropVal; wd: word; newOne: boolean; ts: TStrings;
begin
  if (PropName='') or VarIsNull(PropVal) then raise Exception.Create('Error: in SetProp');
  pv:= GetProp(PropName); newOne:= (pv = nil);
  wd:= VarType(PropVal);
  if newOne then
  begin
    pv:= TPropVal.Create;
    case wd of
    varBoolean: begin pv.bool:= boolean(PropVal);
                pv.Style:= iiBoolean;
                end;
    varInteger: begin pv.int:= Integer(PropVal);
                pv.Style:= iiInteger;
                end;
    varDouble, varSingle, varCurrency:
                begin pv.dbl:= Double(PropVal);
                pv.Style:= iiDouble;
                end;
    varString, varOleStr, 258:
                begin pv.str:= String(PropVal);
                pv.Style:= iiString;
                end;
    varByte:    begin pv.sel:= Byte(PropVal);
                pv.Style:= iiSelection;
                end;
    end;
  end
  else begin
    case pv.Style of
      iiBoolean: pv.bool:= boolean(PropVal);
      iiInteger: pv.int:= Integer(PropVal);
      iiDouble: pv.dbl:= Double(PropVal);
      iiString:  pv.str:= String(PropVal);
      iiSelection:begin
                    case wd of
                    varByte, varInteger: pv.sel:= byte(PropVal);
                    varString, varOleStr, 258:
                    begin
                      ts:= TStringList.Create;
                      ts.CommaText:= pv.selItems;
                      pv.sel:= ts.IndexOf(String(PropVal));
                      ts.Free;
                    end;
                  end;
      end;
    end;
  end;
  SetProp(PropName,pv);
end;

procedure TblkModel.setP(PropName: string; PropVal: variant);
begin
  SetPropVar(PropName, PropVal);
  Notify(PropName);
end;

procedure TblkModel.setFuncCode(func, code: string);
var
  i: integer;
begin
  i:= source.IdxByName(func); if i=-1 then exit;
  source.Funcs[i].code:= code; source.Funcs[i].enabled:= true;
end;

function ImplementsAbstractMethod(AObj: TblkModel): Boolean;
type
  TAbstractMethod = procedure(pn: string) of object;
var
  BaseClass: TClass;
  BaseImpl, Impl: TAbstractMethod;
begin
  BaseClass := TblkModel;
  BaseImpl := TblkModel(@BaseClass).Synchro;
  Impl := AObj.Synchro;
  Result := TMethod(Impl).Code <> TMethod(BaseImpl).Code;
end;
//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

constructor TController.Create(aOwner: TComponent);
begin
  inherited Create(aOwner);
  iModels:= TInterfaceList.Create;
  if not (aOwner is TctrlCenter) then raise Exception.Create('76A79C50');
  forks:= TStringList.Create;
end;

destructor TController.Destroy;
begin
  forks.Free;
  iModels.Clear; FreeAndNil(iModels);
  FreeAndNil(IniFile);
  inherited Destroy;
end;

function TController.RegModel(mdl: TblkModel; fork: string): integer;
begin
  if forks.IndexOf(fork)>-1 then raise Exception.Create('Dublicated functionality in blocks');
  Result:= iModels.Add(IblkModel(mdl));
  forks.Add(fork+'='+IntToStr(Result));
  mdl.Config(); // create props in the model from instance
end;

procedure TController.UnregModel(mdl: TblkModel);
begin
  if mdl=nil then exit;
  iModels.Remove(IblkModel(mdl));
end;

function TController.GetModels(mdlName: string): IblkModel;
var
  i,j,k: integer;
begin
  for i:= 0 to iModels.Count-1 do
  begin
    Result:= IblkModel(iModels[i]);
    if SameText(mdlName,Result.GetName) then exit;
  end;
  Result:= nil;
end;

procedure TController.SetLockedUI(locked: boolean);
var
  i: integer;
begin
  fLockedUI:= locked;
  for i := 0 to iModels.Count-1 do
    IblkModel(iModels[i]).SetLocked(locked);
end;

procedure TController.IniLoad(fn: string); // after reg all the models/props
// for all sections that do not exist models are kept unchanged
var
  i,j,k: integer; ss,st: string;
  pv: TPropVal; mdl: IblkModel; ls: TStrings;
begin
  if not FileExists(fn) then raise Exception.Create(fn+' not found');
  IniFile:= TIniFile.Create(fn);
  ls:= TStringList.Create; IniFile.ReadSections(ls);
  for i := 0 to iModels.Count-1 do
  begin
    mdl:= IblkModel(iModels[i]);
    if ls.IndexOf(mdl.GetName)=-1 then continue;
    ss:= mdl.GetPropName(0); j:= 1;
    while ss<>'' do
    begin
      pv:= mdl.GetProp(ss);
      if not pv.ReadOnly then // skip those
        case pv.Style of
          iiBoolean: pv.bool:= IniFile.ReadBool(mdl.GetName,ss,pv.bool);
          iiInteger: pv.int:= IniFile.ReadInteger(mdl.GetName,ss,pv.int);
          iiDouble: pv.dbl:= IniFile.ReadFloat(mdl.GetName,ss,pv.dbl);
          iiString: pv.str:= IniFile.ReadString(mdl.GetName,ss,pv.str);
          iiSelection: pv.sel:= EnsureRange(IniFile.ReadInteger(mdl.GetName,ss,pv.sel),0,255);
        end;
      ss:= mdl.GetPropName(j); inc(j);
    end;
    assert(mdl.LoadSrc(fn));
    mdl.NotifyAll;
  end;
  ls.Free;
end;

procedure TController.IniSave(fn: string);
var
  i,j,k: integer; ss,st: string;
  pv: TPropVal; mdl: IblkModel; ini: string;
begin
  if fn='' then
  begin
    assert(Assigned(IniFile));
    ini:= IniFile.FileName;
  end
  else
    ini:= fn;
  FreeAndNil(IniFile);
  IniFile:= TIniFile.Create(ini);
  for i := 0 to iModels.Count-1 do
  begin
    mdl:= IblkModel(iModels[i]);
    ss:= mdl.GetPropName(0); j:= 1;
    while ss<>'' do
    begin
      pv:= mdl.GetProp(ss);
      case pv.Style of
        iiBoolean: IniFile.WriteBool(mdl.GetName,ss, pv.bool);
        iiInteger: IniFile.WriteInteger(mdl.GetName,ss, pv.int);
        iiDouble: IniFile.WriteFloat(mdl.GetName,ss, pv.dbl);
        iiString: IniFile.WriteString(mdl.GetName,ss, pv.str);
        iiSelection: IniFile.WriteInteger(mdl.GetName,ss, pv.sel);
      end;
      ss:= mdl.GetPropName(j); inc(j);
    end;
    mdl.SaveSrc(IniFile.FileName);
  end;
  IniFile.UpdateFile;
end;

function TController.modelCount: integer;
begin
  Result:= iModels.Count;
end;

function TController.modelByIdx(idx: integer): IblkModel;
begin
  Result:= nil;
  if InRange(idx,0,iModels.Count-1) then
    Result:= IblkModel(iModels[idx]);
end;

function TController.modelByFork(fork: string): IblkModel;
var
  i: integer;
begin
  i:= StrToIntDef(forks.Values[fork],-1);
  Result:= modelByIdx(i);
end;
//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
function TController.Eval(cmd: string): variant;
var gpy: TPythonEngine;
begin
  if not PythonOK then exit;
  gpy:= GetPythonEngine;
  Result:= gpy.PyObjectAsVariant(gpy.EvalString(cmd));
  if Assigned(OnLog) then OnLog('> '+cmd+#10+string(Result));
end;

procedure TController.Exec(script: string);
begin
  if not PythonOK then exit;
  GetPythonEngine.ExecString(script);
  if Assigned(OnLog) then OnLog(script);
end;
// ctrlPORT @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
constructor TctrlPort.Create(aCtrl: TController);
begin
  inherited Create;
  ctrl:= aCtrl;
end;

procedure TctrlPort.IniLoad(fn: string); // after reg all the models
begin
  ctrl.IniLoad(fn);
end;

procedure TctrlPort.IniSave(fn: string);
begin
  ctrl.IniSave(fn);
end;

function TctrlPort.SetRslt(vr: variant): boolean;
begin
  Result:= false;
  if ctrl=nil then exit;
  ctrl.rslt:= vr;
  Result:= true;
end;

function TctrlPort.modelCount: integer;
begin
  Result:= ctrl.modelCount;
end;

function TctrlPort.modelNameByIdx(idx: integer): string; // from 0 till gets back empty
begin
  Result:= '';
  if not InRange(idx,0,modelCount-1) then exit;
  Result:= ctrl.modelByIdx(idx).GetName;
end;

function TctrlPort.propCount(mdlNm: string): integer;
var mdl: IblkModel;
begin
  Result:= 0;
  mdl:= ctrl.GetModels(mdlNm);
  if not Assigned(mdl) then exit;
  Result:= mdl.propCount;
end;

function TctrlPort.GetPropName(mdlNm: string; idx: integer): string; // from 0 till gets back empty
begin
  Result:= ctrl.GetModels(mdlNm).GetPropName(idx);
end;

function TctrlPort.GetPropByIdx(mdlIdx, propIdx: integer): TPropVal;
var mn,pn: string;
begin
  Result:= nil;
  assert(InRange(mdlIdx,0,modelCount-1));
  mn:= ctrl.modelByIdx(mdlIdx).GetName;
  assert((mn<>'') and (InRange(propIdx,0,propCount(mn)-1)));
  pn:= ctrl.models[mn].GetPropName(propIdx);
  assert(pn<>'');
  Result:= GetProp(mn, pn);
end;

function TctrlPort.GetProp(mdlNm, propNm: string): TPropVal;
var mdl: IblkModel;
begin
  Result:= nil;
  mdl:= ctrl.Models[mdlNm];
  if (mdl=nil) or (propNm='') then exit;
  Result:= mdl.GetProp(propNm);
end;

function TctrlPort.SetProp(mdlNm, propNm: string; pv: TPropVal): boolean;
var mdl: IblkModel;
begin
  Result:= false;
  mdl:= ctrl.Models[mdlNm];
  if (mdl=nil) or (propNm='') then exit;
  mdl.SetProp(propnm,pv);
  Result:= true;
end;

procedure TctrlPort.Notify(mdlNm, propNm: string);
var mdl: IblkModel;
begin
  mdl:= ctrl.Models[mdlNm];
  if (mdl=nil) or (propNm='') then exit;
  mdl.Notify(propNm,nil);
  mdl.SynchroUp(propNm);
end;

end.
