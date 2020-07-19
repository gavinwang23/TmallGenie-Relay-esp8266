--init.lua web config
print("set up wifi mode")
enduser_setup.start(
  function()
    --tmr.delay(100000000)
    print("Connected to wifi as:" .. wifi.sta.getip())
    dofile("kaiguan.lua")
  end,
  function(err, str)
    print("enduser_setup: Err #" .. err .. ": " .. str)
  end
)
