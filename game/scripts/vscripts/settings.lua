DOTA_MAX_TEAM_PLAYERS = 8

_G.nCOUNTDOWNTIMER = 901

TEAM_KILLS_TO_WIN = 10
CLOSE_TO_VICTORY_THRESHOLD = 5

START_GOLD = 777
GOLD_PER_TICK = 10                       -- How much gold should players get per tick? This increases over time in OAA.
GOLD_TICK_TIME = 1                      -- How long should we wait in seconds between gold ticks?

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