if SRWarsGameMode == nil then
	SRWarsGameMode = class({})
end

function Precache( context )
	PrecacheResource( "particle", "particles/leader/leader_overhead.vpcf", context )
end

require("settings")
require('libraries/timers')
require('libraries/fun')
require('libraries/math')
require('libraries/playerresource')
require('libraries/playertables')

require('modifiers/link_modifiers')

require("utilities")
require("game_setup")
require("events")

function Activate()
	GameRules.AddonTemplate = SRWarsGameMode()
	GameRules.AddonTemplate:InitGameMode()
end

function SRWarsGameMode:InitGameMode()
	self.tActiveTeams = {}

	self.leadingTeam = -1
	self.leadingTeamScore = 0
	self.runnerupTeamScore = 0
	self.isGameTied = true

	GameSetup.init()
	link_modifiers()

	CustomGameEventManager:RegisterListener("setKills", setKills)
	CustomGameEventManager:RegisterListener("setTimer", setTimer)
	CustomGameEventManager:RegisterListener("setHunt", setHunt)
	
	ListenToGameEvent("dota_player_gained_level", Dynamic_Wrap(SRWarsGameMode, "OnPlayerGainLevel"), self)
	ListenToGameEvent("dota_player_pick_hero", Dynamic_Wrap(SRWarsGameMode, "OnPlayerPickHero"), self)
	ListenToGameEvent("entity_killed", Dynamic_Wrap(SRWarsGameMode, "OnKill"), self)
	ListenToGameEvent("dota_game_state_change", Dynamic_Wrap(SRWarsGameMode, "GameStateChange"), self)

	GameRules:GetGameModeEntity():SetThink( "OnThink", self, "GlobalThink", 2 )
	-- -createhero nevermore enemy
end

---------------------------------------------------------------------------
-- Get the color associated with a given teamID
---------------------------------------------------------------------------
function SRWarsGameMode:ColorForTeam( teamID )
	local color = mTeamColors[ teamID ]
	if color == nil then
		color = { 255, 255, 255 } -- default to white
	end
	return color
end
---------------------------------------------------------------------------

function SRWarsGameMode:OnPlayerGainLevel(params)
	local playerID = params.PlayerID
	local hero_index = params.hero_entindex
	local level = params.level

	local unit =  EntIndexToHScript(hero_index)
	unit:SetModifierStackCount("spells_upgrade", nil, level-1)
end

function SRWarsGameMode:UpdateScoreboard()
	local sortedTeams = {}
	for _, team in pairs( self.tActiveTeams ) do
		table.insert( sortedTeams, { teamID = team, teamScore = GetTeamHeroKills( team ) } )
	end
	-- -- reverse-sort by score
	table.sort( sortedTeams, function(a,b) return ( a.teamScore > b.teamScore ) end )
	-- for _, t in pairs( sortedTeams ) do
	-- 	local clr = self:ColorForTeam( t.teamID )

	-- 	-- Scaleform UI Scoreboard
	-- 	local score = 
	-- 	{
	-- 		team_id = t.teamID,
	-- 		team_score = t.teamScore
	-- 	}
	-- 	FireGameEvent( "score_board", score )
	-- end

	-- Leader effects (moved from OnTeamKillCredit)
	if sortedTeams == nil then
		-- print('no teams')
		return	
		
	elseif #sortedTeams == 1 then
		-- print('you solo')
		return
	end

	local leader = sortedTeams[1].teamID
	-- print("Leader = " .. leader)
	self.leadingTeam = leader

	self.runnerupTeam = sortedTeams[2].teamID
	self.leadingTeamScore = sortedTeams[1].teamScore
	self.runnerupTeamScore = sortedTeams[2].teamScore

	if sortedTeams[1].teamScore == sortedTeams[2].teamScore then
		self.isGameTied = true
	else
		self.isGameTied = false
	end

	local allHeroes = HeroList:GetAllHeroes()
	for _,entity in pairs( allHeroes) do
		if entity:GetTeamNumber() == leader and sortedTeams[1].teamScore ~= sortedTeams[2].teamScore then
			if entity:IsAlive() == true then
				-- Attaching a particle to the leading team heroes
				local existingParticle = entity:Attribute_GetIntValue( "particleID", -1 )
				
				if HUNT_MODE==true then
					local leaderPos = entity:GetOrigin()
					for i, hero in pairs(allHeroes) do
						local teamID = hero:GetTeamNumber()
						if teamID ~= leader then
							AddFOWViewer(teamID, leaderPos, 300, 1, true)
						end
					end
				end

       			if existingParticle == -1 then
       				local particleLeader = ParticleManager:CreateParticle( "particles/leader/leader_overhead.vpcf", PATTACH_OVERHEAD_FOLLOW, entity )
					ParticleManager:SetParticleControlEnt( particleLeader, PATTACH_OVERHEAD_FOLLOW, entity, PATTACH_OVERHEAD_FOLLOW, "follow_overhead", entity:GetAbsOrigin(), true )
					entity:Attribute_SetIntValue( "particleID", particleLeader )
				end
			else
				local particleLeader = entity:Attribute_GetIntValue( "particleID", -1 )
				if particleLeader ~= -1 then
					ParticleManager:DestroyParticle( particleLeader, true )
					entity:DeleteAttribute( "particleID" )
					entity:RemoveModifierByName("kill_leader")
				end
			end
		else
			local particleLeader = entity:Attribute_GetIntValue( "particleID", -1 )
			if particleLeader ~= -1 then
				ParticleManager:DestroyParticle( particleLeader, true )
				entity:DeleteAttribute( "particleID" )
				entity:RemoveModifierByName("kill_leader")
			end
		end
	end
end

function SRWarsGameMode:GameStateChange(key)
	print(key.new_state)
	if key.new_state == DOTA_GAMERULES_STATE_PRE_GAME then
		CustomNetTables:SetTableValue( "game_state", "victory_condition", { kills_to_win = TEAM_KILLS_TO_WIN } );

	elseif key.new_state == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		CustomGameEventManager:Send_ServerToAllClients( "show_timer", {} )

		RuneSpawner:Init()
		local allHeroes = HeroList:GetAllHeroes()
		for i, hero in pairs(allHeroes) do
			local nearest_shop = Entities:FindByClassnameNearest('ent_dota_shop', hero:GetOrigin(), 99999)
			GameRules:ExecuteTeamPing( hero:GetTeamNumber(), nearest_shop:GetOrigin().x, nearest_shop:GetOrigin().y, nearest_shop, 0)
		end
		
	end
end

function GetSpawnPoint()
	local spawners = Entities:FindAllByName("player_spawner")
	local spawner = spawners[math.random(#spawners)]
	return spawner:GetOrigin()
end

function SRWarsGameMode:OnKill(keys)
	local killer =  EntIndexToHScript( keys.entindex_attacker )
	local nKillerID = killer:GetPlayerID()
	local nKillerTeamID = killer:GetTeam()
	local nTeamKillsCount = GetTeamHeroKills(nKillerTeamID)
	local nKillsRemaining = TEAM_KILLS_TO_WIN - nTeamKillsCount

	local tBroadcastEvent =
	{
		killer_id = nKillerID,
		team_id = nKillerTeamID,
		team_kills = nTeamKillsCount,
		kills_remaining = nKillsRemaining,
		victory = 0,
		close_to_victory = 0,
		very_close_to_victory = 0,
	}

	if nKillsRemaining <= 0 then
		self:EndGame(nKillerTeamID)
		tBroadcastEvent.victory = 1
		return

	elseif nKillsRemaining == 1 then
		EmitGlobalSound( "ui.npe_objective_complete" )
		tBroadcastEvent.very_close_to_victory = 1

	elseif nKillsRemaining <= CLOSE_TO_VICTORY_THRESHOLD then
		EmitGlobalSound( "ui.npe_objective_given" )
		tBroadcastEvent.close_to_victory = 1
	end

	local victim =  EntIndexToHScript(keys.entindex_killed)
	local nVictinID = victim:GetPlayerID()
	local nVictimTeamID = PlayerResource:GetTeam(nVictinID)
	local spawner = Entities:FindByName(nil, "player_" .. nVictimTeamID)
	local allHeroes = HeroList:GetAllHeroes()

	for _, hero in pairs(allHeroes) do
		local hero_team = hero:GetTeam()
		if hero_team == nVictimTeamID then
			hero:SetRespawnPosition(GetSpawnPoint())
			hero:SetModifierStackCount("modifier_nevermore_necromastery", nil, 20)
			break
		end
	end
end

function SRWarsGameMode:OnPlayerPickHero(keys)
	local unit =  EntIndexToHScript(keys.heroindex)
	if unit:IsHero() then  
		local player_id = unit:GetPlayerID()
		local raze = unit:GetAbilityByIndex(1)
		local necro = unit:GetAbilityByIndex(3)
		local podl = unit:GetAbilityByIndex(4)
		local req = unit:GetAbilityByIndex(5)

		raze:SetLevel(1)
		necro:SetLevel(4)
		podl:SetLevel(4)
		req:SetLevel(1)

		local allHeroes = HeroList:GetAllHeroes()
		local team = PlayerResource:GetTeam(player_id)

		if self.tActiveTeams[team] == nil then
			table.insert(self.tActiveTeams, team)
		end
		
		for _, hero in pairs(allHeroes) do
			local hero_team = hero:GetTeam()
			if hero_team == team then
				hero:SetRespawnPosition(GetSpawnPoint())
				hero:SetModifierStackCount("modifier_nevermore_necromastery", nil, 20)

				hero:AddNewModifier(hero, nil, "zero_souls", nil)
				hero:AddNewModifier(hero, nil, "custom_attack", nil)
				hero:AddNewModifier(hero, nil, "spells_upgrade", nil)			

				hero:SetModifierStackCount("spells_upgrade", nil, 0)
				pcall(function()hero:FindItemInInventory("item_tpscroll"):Destroy()end)
				break
			end
		end
	end
end


function SRWarsGameMode:EndGame( victoryTeam )
	GameRules:SetCustomVictoryMessage( m_VictoryMessages[victoryTeam] )
	GameRules:SetGameWinner( victoryTeam )
end

-- Evaluate the state of the game
function SRWarsGameMode:OnThink()
	if GameRules:IsGamePaused() == true then
        return 1
    end

	if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		self:UpdateScoreboard()

		if TIMER_UNLIMITED == false then
			CountdownTimer()
			if COUNTDOWNTIMER == 30 then
				CustomGameEventManager:Send_ServerToAllClients( "timer_alert", {} )
			end

			if COUNTDOWNTIMER <= 0 then
				--Check to see if there's a tie
				if self.isGameTied == false then
					SRWarsGameMode:EndGame( self.leadingTeam )
				else
					self.TEAM_KILLS_TO_WIN = self.leadingTeamScore + 1
					local broadcast_killcount = 
					{
						killcount = self.TEAM_KILLS_TO_WIN
					}
					CustomGameEventManager:Send_ServerToAllClients( "overtime_alert", broadcast_killcount )
				end
			end
		end
	
	elseif GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then
		return nil
	end
	return 1
end