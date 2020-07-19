--use sjson
_G.cjson = sjson
--modify DEVICEID INPUTID APIKEY
DEVICEID = "1236"     --填你的
APIKEY = "ad538e10"   --填你的
INPUTID = "36"
host = host or "www.bigiot.net"
port = port or 8181
LED = 3
isConnect = false
gpio.mode(LED,gpio.OUTPUT)
local function run()
  local cu = net.createConnection(net.TCP)
  cu:on("receive", function(cu, c) 
    print(c)
    isConnect = true
    r = cjson.decode(c)
    if r.M == "say" then
      if r.C == "play" then   
        gpio.write(LED, gpio.LOW)  
        ok, played = pcall(cjson.encode, {M="say",ID=r.ID,C="LED turn on!"})
        cu:send( played.."\n" )
      end
      if r.C == "stop" then   
        gpio.write(LED, gpio.HIGH)
        ok, stoped = pcall(cjson.encode, {M="say",ID=r.ID,C="LED turn off!"})
        cu:send( stoped.."\n" ) 
      end
    end
  end)
  cu:on('disconnection',function(scu)
    cu = nil
    isConnect = false
    tmr.stop(1)
    tmr.alarm(6, 5000, 0, run)
  end
  cu:connect(port, host)
  ok, s = pcall(cjson.encode, {M="checkin",ID=DEVICEID,K=APIKEY})
  if ok then
    print(s)
  else
    print("failed to encode!")
  end
  if isConnect then
    cu:send(s.."\n")
  end
  tmr.alarm(1, 60000, 1, function()
    if isConnect then
      cu:send(s.."\n")
    end
  end)
end
run()
