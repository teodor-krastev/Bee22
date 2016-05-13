function sleep(s)
  local ntime = os.time() + s
  repeat until os.time() > ntime
end

local o = luacom.CreateObject("Bee22.coBee22")

o_event = {}
function o_event:OnEpoch(cmd, arr)
  if cmd == 'exit' then 
    --o = nil
    --collectgarbage()
    os.exit() 
   end
  print(cmd)
  print(table.getn(arr) .. ": " .. arr[1])
  return 2.5
end

res, cookie = luacom.Connect(o, o_event)
  if res == nil then
    exit(1)
  end
sleep(1)
o:Config()

--sleep(1)
--o.Reset()
--local c = [[term.setP('max.iters',252)]]
--print(o:Exec(c))
--local d = [[term.getP('max.iters')]]
--print(o:Eval(d))

while true do
  luacom.StartMessageLoop(function () --print ("new message:") 
                          end) 
end