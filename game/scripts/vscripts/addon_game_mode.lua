if SRWarsGameMode == nil then
	SRWarsGameMode = class({})
end

function Precache( context )
	PrecacheResource( "particle", "particles/leader/leader_overhead.vpcf", context )
	PrecacheResource( "particle", "particles/leader/leader_overhead.vpcf", context )
end

require("settings")

require('libraries/timers')
-- require('libraries/fun')
-- require('libraries/math')
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
	CustomGameEventManager:RegisterListener("setHunt", setHunt)
	
	ListenToGameEvent("dota_player_gained_level", Dynamic_Wrap(SRWarsGameMode, "OnPlayerGainLevel"), self)
	ListenToGameEvent("dota_player_pick_hero", Dynamic_Wrap(SRWarsGameMode, "OnPlayerPickHero"), self)
	ListenToGameEvent("entity_killed", Dynamic_Wrap(SRWarsGameMode, "OnKill"), self)
	ListenToGameEvent("dota_game_state_change", Dynamic_Wrap(SRWarsGameMode, "GameStateChange"), self)
	-- ListenToGameEvent("dota_item_purchased", Dynamic_Wrap(SRWarsGameMode, "OnItemPurchase"), self)

	GameRules:GetGameModeEntity():SetModifyGoldFilter( Dynamic_Wrap( SRWarsGameMode, "GoldFilter" ), self )
	GameRules:GetGameModeEntity():SetModifyExperienceFilter( Dynamic_Wrap( SRWarsGameMode, "ExpFilter" ), self )

	GameRules:GetGameModeEntity():SetThink( "OnThink", self, "GlobalThink", 2 )

	-- local test_hero = CreateUnitByName("npc_dota_hero_nevermore", Vector(-500, -320, 189), true, nil, nil, DOTA_TEAM_CUSTOM_6)
	-- if test_hero then
    --     test_hero:SetControllableByPlayer(0, true) -- Установите контролируемого игрока (0 - первый игрок)
    --     -- test_hero:SetOwner(nil) -- Установите владельца, если нужно
    -- end
end

-- function SRWarsGameMode:OnItemPurchase(keys)
-- 	-- OnItemEquipped
-- 	local playerID = keys.PlayerID
-- 	local hero = PlayerResource:GetSelectedHeroEntity(playerID)
-- 	local item_name = "item_world_travel_boots"

-- 	if hero:HasItemInInventory(item_name) then
-- 		-- local item = hero:FindItemInInventory(item_name)
-- 		-- local slot = item:GetItemSlot()
-- 		-- hero:SwapItems(slot, 15)
-- 	end
-- end 

-- Global gold filter function
function SRWarsGameMode:GoldFilter(keys)
	local reason = keys.reason_const
	local sourceIndex = keys.source_entindex_const
	local deadHero = EntIndexToHScript(sourceIndex)

	if reason == 12 then 
		if deadHero:HasModifier('kill_leader') then
			keys.gold = keys.gold * 2
		end
	end
	return true
end

-- Global experience filter function
function SRWarsGameMode:ExpFilter(keys)
	local playerID = keys.player_id_const
	local reason = keys.reason_const
	local sourceIndex = keys.source_entindex_const
	local exp  = keys.experience

	local base_exp = 0
	local comeback_exp = 0
	local hunt_exp_multiply = 1

	if reason == 1 then
		local heroIndex = keys.hero_entindex_const

		local killerHero = EntIndexToHScript(heroIndex)
		local deadHero = EntIndexToHScript(sourceIndex)

		local killerLVL = killerHero:GetLevel()
		local deadLVL = deadHero:GetLevel()

		local killerCurrentXP = killerHero:GetCurrentXP()
		local deadCurrentXP = deadHero:GetCurrentXP()

		if killerLVL ~= 30 then
			base_exp = (xp_table[killerLVL + 1] - xp_table[killerLVL]) / 3

			if deadLVL > killerLVL then
				comeback_exp = (deadCurrentXP - killerCurrentXP) / 3
			end
	
			if deadHero:HasModifier('kill_leader') then
				hunt_exp_multiply = 2
			end
		end
	end
	keys.experience = base_exp * hunt_exp_multiply + comeback_exp
	return true
end

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
	table.sort( sortedTeams, function(a,b) return ( a.teamScore > b.teamScore ) end )

	if #sortedTeams == 0 then
		return	
	elseif #sortedTeams == 1 then
		return
	end

	local leader = sortedTeams[1].teamID
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
							AddFOWViewer(teamID, leaderPos, 350, 1, true)
						end
					end
				end

       			if existingParticle == -1 then
       				local particleLeader = ParticleManager:CreateParticle( "particles/leader/leader_overhead.vpcf", PATTACH_OVERHEAD_FOLLOW, entity )
					ParticleManager:SetParticleControlEnt( particleLeader, PATTACH_OVERHEAD_FOLLOW, entity, PATTACH_OVERHEAD_FOLLOW, "follow_overhead", entity:GetAbsOrigin(), true )
					entity:Attribute_SetIntValue( "particleID", particleLeader )
					entity:AddNewModifier(entity, nil, "kill_leader", nil)

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

	elseif key.new_state == 5 then
		CustomGameEventManager:Send_ServerToAllClients( "show_timer", {} )

		Gold:Init()
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

	CustomGameEventManager:Send_ServerToAllClients( "update_score", tBroadcastEvent )

	local victim =  EntIndexToHScript(keys.entindex_killed)
	local nVictimTeamID = victim:GetTeam()
	local spawner = Entities:FindByName(nil, "player_" .. nVictimTeamID)
	local allHeroes = HeroList:GetAllHeroes()
	
	victim:ClearStreak()
	victim:SetRespawnPosition(GetSpawnPoint())
	victim:SetModifierStackCount("modifier_nevermore_necromastery", nil, 20)

end

function SRWarsGameMode:OnPlayerPickHero(keys)
	CustomGameEventManager:Send_ServerToAllClients( "update_hero_selection", {} )

	local unit =  EntIndexToHScript(keys.heroindex)
	if unit:IsHero() then  
		local player_id = unit:GetPlayerID()
		local team = PlayerResource:GetTeam(player_id)
		
		local color = mTeamColors[team]
		PlayerResource:SetCustomPlayerColor(player_id, color[1], color[2], color[3])

		if self.tActiveTeams[team] == nil then
			table.insert(self.tActiveTeams, team)
		end
		
		local raze = unit:GetAbilityByIndex(1)
		local necro = unit:GetAbilityByIndex(3)
		local podl = unit:GetAbilityByIndex(4)
		local req = unit:GetAbilityByIndex(5)

		raze:SetLevel(1)
		necro:SetLevel(4)
		podl:SetLevel(4)
		req:SetLevel(1)

		unit:SetRespawnPosition(GetSpawnPoint())
		unit:SetModifierStackCount("modifier_nevermore_necromastery", nil, 20)

		-- unit:AddNewModifier(unit, nil, "zero_souls", nil)
		unit:AddNewModifier(unit, nil, "custom_attack", nil)
		unit:AddNewModifier(unit, nil, "spells_upgrade", nil)			
		
		-- unit:AddNewModifier(unit, nil, "abilities_fire_set", nil)					

		unit:SetModifierStackCount("spells_upgrade", nil, 0)
		pcall(function()unit:FindItemInInventory("item_tpscroll"):Destroy()end)

		-- local hItem = CreateItem("item_world_travel_boots", nil, nil)
		-- unit:AddItem(hItem)

	end
end

function SRWarsGameMode:EndGame( victoryTeam )
	-- local tTeamScores = {}
	-- for team = DOTA_TEAM_FIRST, (DOTA_TEAM_COUNT-1) do
	-- 	tTeamScores[team] = GetTeamHeroKills(team)
	-- end
	-- CustomGameEventManager:Send_ServerToAllClients( "final_scores", tTeamScores )
	GameRules:SetCustomVictoryMessage( m_VictoryMessages[victoryTeam] )
	GameRules:SetGameWinner( victoryTeam )
end

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