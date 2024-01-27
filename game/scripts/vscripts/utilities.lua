function dump(o)
    if type(o) == 'table' then
       local s = '{ '
       for k,v in pairs(o) do
          if type(k) ~= 'number' then k = '"'..k..'"' end
          s = s .. '['..k..'] = ' .. dump(v) .. ','
       end
       return s .. '} '
    else
       return tostring(o)
    end
 end

 function table_contains(tbl, x)
    found = false
    for _, v in pairs(tbl) do
        if v == x then 
            found = true 
        end
    end
    return found
end

function UnitVarToPlayerID(unitvar)
   if unitvar then
     if type(unitvar) == "number" then
       return unitvar
     elseif type(unitvar) == "table" and not unitvar:IsNull() and unitvar.entindex and unitvar:entindex() then
       if unitvar.GetPlayerID and unitvar:GetPlayerID() > -1 then
         return unitvar:GetPlayerID()
       elseif unitvar.GetPlayerOwnerID then
         return unitvar:GetPlayerOwnerID()
       end
     end
   end
   return -1
 end
 

 function CountdownTimer()
  nCOUNTDOWNTIMER = nCOUNTDOWNTIMER - 1
  local t = nCOUNTDOWNTIMER
  --print( t )
  local minutes = math.floor(t / 60)
  local seconds = t - (minutes * 60)
  local m10 = math.floor(minutes / 10)
  local m01 = minutes - (m10 * 10)
  local s10 = math.floor(seconds / 10)
  local s01 = seconds - (s10 * 10)
  local broadcast_gametimer = 
      {
          timer_minute_10 = m10,
          timer_minute_01 = m01,
          timer_second_10 = s10,
          timer_second_01 = s01,
      }
  CustomGameEventManager:Send_ServerToAllClients( "countdown", broadcast_gametimer )
  if t <= 120 then
      CustomGameEventManager:Send_ServerToAllClients( "time_remaining", broadcast_gametimer )
  end
end