DOTA_MAX_TEAM_PLAYERS = 8

-- Base Mode settings
TEAM_KILLS_TO_WIN = 10
COUNTDOWNTIMER = 901
TIMER_UNLIMITED = false
HUNT_MODE = true

CLOSE_TO_VICTORY_THRESHOLD = 5

START_GOLD = 777
GOLD_PER_TICK = 10                       -- How much gold should players get per tick? This increases over time in OAA.
GOLD_TICK_TIME = 1                      -- How long should we wait in seconds between gold ticks?

CUSTOM_RUNE_SPAWN_INTERVAL = 20

mTeamColors = {}
mTeamColors[DOTA_TEAM_GOODGUYS] = { 61, 210, 150 }	--	Teal
mTeamColors[DOTA_TEAM_BADGUYS]  = { 243, 201, 9 }	--	Yellow
mTeamColors[DOTA_TEAM_CUSTOM_1] = { 197, 77, 168 }	--  Pink
mTeamColors[DOTA_TEAM_CUSTOM_2] = { 255, 108, 0 }	--	Orange
mTeamColors[DOTA_TEAM_CUSTOM_3] = { 52, 85, 255 }	--	Blue
mTeamColors[DOTA_TEAM_CUSTOM_4] = { 101, 212, 19 }	--	Green
mTeamColors[DOTA_TEAM_CUSTOM_5] = { 129, 83, 54 }	--	Brown
mTeamColors[DOTA_TEAM_CUSTOM_6] = { 61, 210, 150 }	--	Cyan

m_VictoryMessages = {}
m_VictoryMessages[DOTA_TEAM_GOODGUYS] = "#VictoryMessage_GoodGuys"
m_VictoryMessages[DOTA_TEAM_BADGUYS]  = "#VictoryMessage_BadGuys"
m_VictoryMessages[DOTA_TEAM_CUSTOM_1] = "#VictoryMessage_Custom1"
m_VictoryMessages[DOTA_TEAM_CUSTOM_2] = "#VictoryMessage_Custom2"
m_VictoryMessages[DOTA_TEAM_CUSTOM_3] = "#VictoryMessage_Custom3"
m_VictoryMessages[DOTA_TEAM_CUSTOM_4] = "#VictoryMessage_Custom4"
m_VictoryMessages[DOTA_TEAM_CUSTOM_5] = "#VictoryMessage_Custom5"
m_VictoryMessages[DOTA_TEAM_CUSTOM_6] = "#VictoryMessage_Custom6"

xp_table = {
    0,--1
	240,--1
	400,--2
	520,--3
	600,--4
	680,--5
	760,--6
	800,--7
	900,--8
	1000,--9
	1100,--10
	1200,--11
	1300,--12
	1400,--13
	1500,--14
	1600,--15
	1700,--16
	1800,--17
	1900,--18
	2000,--19
	2200,--20
	2400,--21
	2600,--22
	2800,--23
	3000,--24
	4000,--25
	5000,--26
	6000,--27
	7000,--28
	8000--29
}