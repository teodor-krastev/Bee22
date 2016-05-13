function myprint(cmd, txt)
  --print("> "..cmd.." >> "..txt.."  &&&&&&&&&&&&&&&&&&&&&&") --remove comment for debug
end

-- Creates a GEM file "tune.gem" with the given
-- parameterization.
-- dx is the axial x-offset in grid units.
function make_gem(dx)
  local filename = "tune.gem"
  local fh = assert(io.open(filename, "w"))
  local x1 = 40 + dx  -- x position of central electrode left edge
  fh:write ([[
pa_define(100,40,1, cylindrical, electrostatic)
electrode(1) { fill { within { corner_box(0,0, 4,39) } } }
electrode(2) { fill { within { corner_box(]] .. x1 .. [[,21, 16,39) } } }
electrode(3) { fill { within { corner_box(96,0, 3,39) } } }
  ]])
  fh:close()

  return filename
end

-- Performs a simulation on a single parameterization
-- of the geometry.
-- dx is the axial x-offset in grid units.
-- returns calculated y-offset of outermost splat.
function test(dx)
  -- create GEM file of proper dimensions
  local gem_filename = make_gem(dx)

  -- convert GEM file to PA# file.
  local pasharp_filename = string.gsub(gem_filename, ".gem", ".pa#")
  simion.command("gem2pa " .. gem_filename .. " " .. pasharp_filename)

  -- refine PA# file.
  simion.command("refine " .. pasharp_filename)

  -- Fly ions and collect results to _G table.
  simion.command("fly g:\\bee22\\ext\\sim1\\tune.iob")

  print("RESULT: dx=" .. dx .. ", ion_py_gu=" .. _G.result_y)

  return _G.result_y
end

-- Simulates all parameterizations.
function sleep(s)
  local ntime = os.time() + s
  repeat until os.time() > ntime
end

local o = luacom.CreateObject("Bee22.coBee22")
local ds = {}

o_event = {}
function o_event:OnEpoch(cmd, arr)
  if cmd == 'exit' then os.exit() end
  if cmd == 'set' then 
    ds = arr
    myprint(cmd,table.getn(ds)) 
    return true
  end
  if cmd == 'fly' then 
    local ss = ""
    for i=1,table.getn(arr) do 
      ss = ss .. arr[i].."; "
    end 
    local dx = arr[1]
    local f = test(dx) --arr[1]*arr[1]
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
os.execute('cd p:\sim1')
os.execute('p:')

sleep(1)
o:Config() --config Bee22 internal events

while true do
  luacom.StartMessageLoop(function () --print ("new message:") 
                          end) 
end