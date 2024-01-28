-----------------------------------------------------------------------------
-- Custom game events functions
-----------------------------------------------------------------------------
function setKills(eventSourceIndex, data)
	TEAM_KILLS_TO_WIN = data.value
	CustomGameEventManager:Send_ServerToAllClients("setKills", { 
		value  =  TEAM_KILLS_TO_WIN
	})
end

function setTimer(eventSourceIndex, data)
	local time = data.value
	if time == -1 then
		TIMER_UNLIMITED = true
	else
		COUNTDOWNTIMER = time * 60 + 1
	end
	CustomGameEventManager:Send_ServerToAllClients("setTimer", { 
		value  =  time
	})
end

function setHunt(eventSourceIndex, data)
	local r = data.value
    if r == 1 then
        HUNT_MODE = true
    else
        HUNT_MODE = false
    end
    CustomGameEventManager:Send_ServerToAllClients("setHunt", { 
        value  =  r
    })
end
-----------------------------------------------------------------------------
