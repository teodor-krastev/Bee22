-- tune.lua
--
-- SIMION user program for tune.pa0.
--
-- Author David Manura, 2006-08
-- (c) 2006-2007 Scientific Instrument Services, Inc. (Licensed under SIMION 8.0)
simion.workbench_program()

-- voltage for central electrode
-- Note: the default value here was found using the _tune example.
adjustable test_voltage = 965.57617
 
-- called on PA initialization
function segment.init_p_values()
    -- sets central electrode voltage
    adj_elect02 = test_voltage
end

-- called on particle splat
function segment.terminate()
  -- tune only on ion #6
  if ion_number ~= 6 then return end

  -- output results to data recording
  _G.result_y = ion_py_gu
end
