if GameSetup == nil then
    GameSetup = class({})
end
  
local forceHero = "npc_dota_hero_nevermore"

require('components/index')

function GameSetup:init()
	GameRules:EnableCustomGameSetupAutoLaunch(true)
	GameRules:SetCustomGameSetupAutoLaunchDelay(60) -- !!!!!!!!!!!!
	-- GameRules:SetCustomGameSetupAutoLaunchDelay(0) -- !!!!!!!!!!!!

	local GameMode = GameRules:GetGameModeEntity()

	GameMode:SetFixedRespawnTime(3)
	GameMode:SetCustomGameForceHero(forceHero)
	GameMode:SetDaynightCycleDisabled(false)
	GameMode:SetDaynightCycleAdvanceRate(2.5)
	GameMode:SetCustomHeroMaxLevel(10)

	GameMode:SetCustomXPRequiredToReachNextLevel(xp_table)
	GameMode:SetUseCustomHeroLevels(true)
	GameMode:SetGiveFreeTPOnDeath(false)
	GameMode:ClearRuneSpawnFilter()

	-- GameMode:SetTPScrollSlotItemOverride("item_world_travel_boots")

	GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_GOODGUYS, 1 )
	GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_BADGUYS, 1 )
	GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_CUSTOM_1, 1 )
	GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_CUSTOM_2, 1 )
	GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_CUSTOM_3, 1 )
	GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_CUSTOM_4, 1 )
	GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_CUSTOM_5, 1 )
	GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_CUSTOM_6, 1 )

	GameRules:SetUseCustomHeroXPValues(true)
	GameRules:SetSameHeroSelectionEnabled(true)
	GameRules:SetStartingGold(START_GOLD)
	GameRules:SetFirstBloodActive(false)
	GameRules:SetHideKillMessageHeaders(true)
	GameRules:SetHeroMinimapIconScale(1.4)
	GameRules:SetRuneMinimapIconScale(0.9)
	GameRules:SetUseUniversalShopMode(true)
	GameRules:SetCustomGameEndDelay(0)
	GameRules:SetCustomVictoryMessageDuration(10)
	GameRules:SetPreGameTime(3)
	GameRules:SetHeroSelectionTime(60.0)
	GameRules:SetTreeRegrowTime(15.0)

	GameRules:GetGameModeEntity():SetCameraDistanceOverride( 1250.0 )
	GameRules:GetGameModeEntity():SetBuybackEnabled( false )

	GameRules:SetTimeOfDay(2.2)

	-------------------------
	-- HUD VISION SETTINGS --
	-------------------------
	GameMode:SetHUDVisible(DOTA_HUD_VISIBILITY_TOP_TIMEOFDAY, false)
	GameMode:SetHUDVisible(DOTA_HUD_VISIBILITY_TOP_HEROES, false)
	GameMode:SetHUDVisible(DOTA_HUD_VISIBILITY_TOP_SCOREBOARD, false)
	-------------------------
end

