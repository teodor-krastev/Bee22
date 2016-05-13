-- geometry_optimize.lua
--
-- Simple Lua program for geometry optimization in SIMION.
-- See README.html.
--
-- Author David Manura, 2006-08
-- (c) 2006-2007 Scientific Instrument Services, Inc. (Licensed under SIMION 8.0)

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
  simion.command("fly tune.iob")

  print("RESULT: dx=" .. dx .. ", ion_py_gu=" .. _G.result_y)

  return _G.result_y
end

-- Simulates all parameterizations.
-- Results are summarized in results.csv.
function test_all()
  -- cleanup any old files.
  os.remove("results.csv")

  local results_file = assert(io.open("results.csv", "w")) -- write mode
  results_file:write("dx, dy\n")

  -- run each test, collecting results to results.csv
  for dx=-40,40,1 do
    local dy = test(dx)
    results_file:write(dx .. ", " .. dy .. "\n")
    results_file:flush()  -- immediately output to disk
  end
  results_file:close()

  print("DONE!  See results.csv.")
  os.execute("start notepad results.csv") -- show it
end

test_all()  -- do main function

