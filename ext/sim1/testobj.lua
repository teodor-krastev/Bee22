-- This is the implementation of the COM object
path_to_script = "g:\\Bee22\\ext\\sim1\\"

TestObj = {}

function TestObj:showWindow()
  print("Show!")
  events:OnShow()
end

function TestObj:hideWindow()
  print("Hide!")
  events:OnHide()
end

COM = {}

function COM:StartAutomation()
  -- creates the object using its default interface
  COMAppObject, events, e = luacom.NewObject(TestObj, "TEST.Test")
  -- This error will be caught by detectAutomation
  if COMAppObject == nil then
     error("NewObject failed: "..e)
  end
  -- Exposes the object
  cookie = luacom.ExposeObject(COMAppObject)
  if cookie == nil then
     error("ExposeObject failed!")
  end
end

function COM:Register()
  -- fills table with registration information
  local reginfo = {}
  reginfo.VersionIndependentProgID = "TEST.Test"
  reginfo.ProgID = reginfo.VersionIndependentProgID..".1"
  reginfo.TypeLib = "test.tlb"
  reginfo.CoClass = "Test"
  reginfo.ComponentName = "Test Component"
  reginfo.Arguments = "/Automation"
  reginfo.ScriptFile = path_to_script .. "testobj.lua"
  -- stores component information in the registry
  local res = luacom.RegisterObject(reginfo)
  if res == nil then
     error("RegisterObject failed!")
  end
end

function COM:UnRegister()
  -- fills table with registration information
  local reginfo = {}
  reginfo.VersionIndependentProgID = "TEST.Test"
  reginfo.ProgID = reginfo.VersionIndependentProgID..".1"
  reginfo.TypeLib = "test.tlb"
  reginfo.CoClass = "Test"
  -- removes component information from the registry
  local res = luacom.UnRegisterObject(reginfo)
  if res == nil then
     error("UnRegisterObject failed!")
  end
end

-- Starts automation server
return luacom.DetectAutomation(COM)