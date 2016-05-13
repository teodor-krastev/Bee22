function sleep(s)
  local ntime = os.time() + s
  repeat until os.time() > ntime
end

local o = luacom.CreateObject("Bee22.coBee22")

oh = {}
oh:OnEpoch function (objObject, objAsyncContext)
Print ("epoch")
End

local c = [[term.setP(max.iters,252)]]
sleep(2)
Luacom.Connect (o, oh) 
o.Config(c)
--print(c)

Luacom.StartMessageLoop ()


