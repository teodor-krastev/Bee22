function ExtendCompiler(Compiler: TPSPascalCompiler; const Name: AnsiString): Boolean;
var
	CustomClass: TPSCompileTimeClass;
begin
  try
    {Compiler.AddDelphiFunction('procedure print(const AText: AnsiString);'); }

    SIRegisterTObject(Compiler); // Add compile-time definition for TObject
    CustomClass := Compiler.AddClass(Compiler.FindClass('TObject'), TctrlPort);
    Customclass.RegisterMethod('function SetRslt(vr: variant): boolean;');
    Customclass.RegisterMethod('function GetProp(mdlNm, propNm: string): variant;');
    CustomClass.RegisterMethod('function SetProp(mdlNm, propNm: string; vl: variant): boolean;');
    Result := True;
  except
    Result := False; // will halt compilation
  end;
end;

function TController.CompileScript(Script: AnsiString; out Bytecode, Messages: AnsiString): Boolean;
var
    Compiler: TPSPascalCompiler;
    I: Integer;
begin
    Bytecode := '';
    Messages := '';

    Compiler := TPSPascalCompiler.Create;
    Compiler.OnUses := ExtendCompiler;
    try
        Result := Compiler.Compile(Script) and Compiler.GetOutput(Bytecode);
        for I := 0 to Compiler.MsgCount - 1 do
          if Length(Messages) = 0 then
            Messages := Compiler.Msg[I].MessageToString
          else
            Messages := Messages + #13#10 + Compiler.Msg[I].MessageToString;
    finally
        Compiler.Free;
    end;
end;

procedure TController.ExtendRuntime(Runtime: TPSExec; ClassImporter: TPSRuntimeClassImporter);
var
  RuntimeClass: TPSRuntimeClass;
begin
{  Runtime.RegisterDelphiMethod(Self, @TForm1.MyPrint, 'print', cdRegister);  }

  RIRegisterTObject(ClassImporter);
  RuntimeClass := ClassImporter.Add(TctrlPort);
  RuntimeClass.RegisterMethod(@TctrlPort.SetRslt, 'SetRslt');
  RuntimeClass.RegisterMethod(@TctrlPort.GetProp, 'GetProp');
  RuntimeClass.RegisterMethod(@TctrlPort.SetProp, 'SetProp');
end;

function TController.RunCompiledScript(Bytecode: AnsiString; out RuntimeErrors: AnsiString): Boolean;
var
  Runtime: TPSExec;
  ClassImporter: TPSRuntimeClassImporter;
begin
  Runtime := TPSExec.Create;
  ClassImporter := TPSRuntimeClassImporter.CreateAndRegister(Runtime, false);
  try
    ExtendRuntime(Runtime, ClassImporter);
    Result := Runtime.LoadData(Bytecode)
          and Runtime.RunScript
          and (Runtime.ExceptionCode = erNoError);
    if not Result then
      RuntimeErrors :=  PSErrorToString(Runtime.LastEx, '');
  finally
    ClassImporter.Free;
    Runtime.Free;
  end;
end;

function TController.Eval(script: string): variant;
var ss, bc, rte: AnsiString; strm: TStringStream;
begin
  ss:= 'var cp: TctrlPort; '#13#10' begin cp.SetRslt('+script+')'#13#10'end.';
  if Assigned(OnLog) then OnLog(ss);
  if not CompileScript(ss,bc,rte) then
  begin
    if Assigned(OnLog) then OnLog(rte);
    exit;
  end;

  if not RunCompiledScript(bc, rte) then
  begin
    if Assigned(OnLog) then OnLog(rte);
    exit;
  end;
  if Assigned(OnLog) then OnLog(VarToStr(rslt));
  Result:= rslt;
end;

procedure TController.Exec(script: string);
var bc, rte: AnsiString;
begin
  if Assigned(OnLog) then OnLog(script);
  if not CompileScript(AnsiString(script),bc,rte) then
  begin
    if Assigned(OnLog) then OnLog(rte);
    exit;
  end;

  if not RunCompiledScript(bc, rte) then
  begin
    if Assigned(OnLog) then OnLog(rte);
  end;
end;

