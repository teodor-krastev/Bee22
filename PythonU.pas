(************************************************************************)
(*  Bee22 - Particle Swarm Optimization framework     http://bee22.com  *)
(*  developed by and copyright(c) Teodor Krastev 2015-2016              *)
(************************************************************************)
unit PythonU;

interface
uses System.SysUtils, System.Variants, System.Classes, Vcl.Controls, Math,
  Forms, Dialogs, Vcl.ComCtrls, System.Contnrs, StdCtrls, System.Generics.Collections,
  PythonEngine, PythonGUIInputOutput, WrapDelphi, WrapDelphiTypes,
  WrapDelphiClasses;

Type
  TPythonPlug = class(TComponent)
  private
    NameSpaces: TStrings;
    wrapped: TStrings;
    PyModules: TList<TPythonModule>;
    PyDelphiWrappers: TList<TPyDelphiWrapper>;
    PyGUIInpOut: TPythonGUIInputOutput;
  public
    PyEngine: TPythonEngine;

    constructor Create(AOwner: TComponent); override;
    procedure CreateModule(aNameSpace: string = '');
    // if namespace is empty pso and blocks (models) are called by their names
    // if - not; pso and blocks use prefix of namespace; e.g. bee22.pso.etc..
    procedure Init;
    destructor Destroy; override;
    function NsCount: integer;
    procedure SetOut(pyOut: TCustomMemo);
    procedure Wrap(ns: string; comp: TComponent; nm: string);
  end;

  var py: TPythonPlug; // one for all

implementation
const defaultNamespace = 'bee22'; // in case Namespace = ''

constructor TPythonPlug.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  if PythonOK then PyEngine:= GetPythonEngine  // support more than one ctrlCenter
    else begin
      PyEngine:= TPythonEngine.Create(self);
      PyEngine.AutoFinalize:= true;
      PyEngine.LoadDll;
    end;
  PyGUIInpOut:= TPythonGUIInputOutput.Create(PyEngine);
  PyEngine.IO:= PyGUIInpOut;

  NameSpaces:= TStringList.Create;
  wrapped:= TStringList.Create;
  PyModules:= TList<TPythonModule>.Create;
  PyDelphiWrappers:= TList<TPyDelphiWrapper>.Create;
end;

procedure TPythonPlug.CreateModule(aNameSpace: string = '');
var
  i,j,k: integer;
begin
  if not PythonOK then exit;
  i:= NameSpaces.Add(aNameSpace);
  j:= PyModules.Add(TPythonModule.Create(PyEngine));
  assert(i=j);
  PyModules[j].Engine:= PyEngine; // vary (namespace) if more than one pso/cc
  if NameSpaces[i] = '' then PyModules[j].ModuleName:= defaultNamespace
                        else PyModules[j].ModuleName:= NameSpaces[i];
  PyModules[j].Initialize;

  k:= PyDelphiWrappers.Add(TPyDelphiWrapper.Create(PyEngine));  // no need to explicit destroy
  assert(i=k);
  PyDelphiWrappers[k].Engine := PyEngine;
  PyDelphiWrappers[k].Module := PyModules[j];
  PyDelphiWrappers[k].Initialize;  // Should only be called if PyDelphiWrapper is created at run time
end;

procedure TPythonPlug.Init;
var
  ls: TStrings; i,j: integer;
begin
  if not PythonOK then exit;
  ls:= TStringList.Create;
  for i:= 0 to NsCount-1 do
    if NameSpaces[i] = ''
      then ls.Add('from '+PyModules[i].ModuleName+' import *') // mask module name (default)
      else ls.Add('import '+PyModules[i].ModuleName); // explicit module name
  PyEngine.ExecStrings(ls);
  ls.Free;
end;

destructor TPythonPlug.Destroy;
var
  i,j: integer;
begin
  for i:= 0 to NsCount-1 do
    PyDelphiWrappers[i].Finalize;
  PyDelphiWrappers.Free;
  PyModules.Free;
  wrapped.Free;
  NameSpaces.Free;
  inherited;
end;

function TPythonPlug.NsCount: integer;
begin
  Result:= Namespaces.Count;
end;

procedure TPythonPlug.SetOut(pyOut: TCustomMemo);
begin
  if not PythonOK then exit;
  PyGUIInpOut.Output:= pyOut; // default print-out
  PyEngine.DoRedirectIO;
end;

procedure TPythonPlug.Wrap(ns: string; comp: TComponent; nm: string);
var  p: PPyObject; i: integer;
begin
  if not PythonOK then exit;
  i:= Namespaces.IndexOf(ns);
  if (i=-1) then exit;
  if ns='' then wrapped.AddObject(defaultNamespace+'.'+nm,comp)
           else wrapped.AddObject(ns+nm,comp);
  p := PyDelphiWrappers[i].Wrap(comp,soReference);
  PyModules[i].SetVar(nm, p);
  PyEngine.Py_DecRef(p);
end;

end.
