function sleep(s)
  local ntime = os.time() + s
  repeat until os.time() > ntime
end

function myprint(cmd, txt)
  --print("> "..cmd.." >> "..txt) --remove comment for debug
end

o = luacom.CreateObject("Bee22.coBee22")
ds = {}

o_event = {}
function o_event:OnEpoch(cmd, arr)
  if cmd == 'exit' then os.exit() end
  if cmd == 'set' then 
    ds = arr
    myprint(cmd,table.getn(ds)) 
    return true
  end
  if cmd == 'fly' then 
    local f = 0
    local ss = ""
    for i=1,table.getn(arr) do 
      f = f + arr[i]*arr[i]
      ss = ss .. arr[i].."; "
    end 
    myprint(cmd,ss.."f= "..f)
    return f
  end
  if cmd == 'exec' then 
    myprint(cmd,arr)
    loadstring(arr)()
    return true
  end
  if cmd == 'eval' then 
    myprint(cmd,arr)
    return loadstring("return " .. arr)()
  end
end

res, cookie = luacom.Connect(o, o_event)
  if res == nil then
    exit(1)
  end
sleep(1)
o:Config() --config Bee22 internal events

--methods of Bee22 server
--o.Reset(3) --of user(GUI) level
--local c = [[term.setP('max.iters',252)]]
--print(o:Exec(c)) --execute some python code including Bee22 objects in it
--local d = [[term.getP('max.iters')]]
--print(o:Eval(d)) --evaluate some python variable (expression) including Bee22 objects

while true do
  luacom.StartMessageLoop(function () --print ("new message:") 
                          end) 
end