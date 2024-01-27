if Gold == nil then
    Gold = class({})
end
  
local GOLD_CAP = 99999
local GPM_TICK_INTERVAL = GOLD_TICK_TIME or 1  -- GOLD_TICK_TIME is located in settings.lua
local GOLD_PER_INTERVAL = GOLD_PER_TICK or 1   -- GOLD_PER_TICK is located in settings.lua
  
function Gold:Init()
    self.moduleName = "Gold"
    Timers:CreateTimer(GPM_TICK_INTERVAL, Dynamic_Wrap(Gold, 'PassiveGPM'))
end
  

  
  function Gold:UpdatePlayerGold(unitvar, newGold)
    local playerID = UnitVarToPlayerID(unitvar)
    if playerID and playerID > -1 then
      PlayerResource:SetGold(playerID, newGold, false)
      PlayerResource:SetGold(playerID, 0, true)
    end
  end
  
  function Gold:SetGold(unitvar, gold)
    local playerID = UnitVarToPlayerID(unitvar)
    local newGold = math.floor(gold)
    Gold:UpdatePlayerGold(playerID, newGold)
  end
  
  function Gold:RemoveGold(unitvar, gold)
    local playerID = UnitVarToPlayerID(unitvar)
    -- self:Think()
    local oldGold = PlayerTables:GetTableValue("gold", "gold")[playerID]
    local newGold = math.max((oldGold or 0) - math.ceil(gold), 0)
    Gold:UpdatePlayerGold(playerID, newGold)
  end
  
  function Gold:AddGold(unitvar, gold)
    local playerID = UnitVarToPlayerID(unitvar)
    -- self:Think()
    local oldGold = PlayerResource:GetGold(playerID)
    local newGold = (oldGold or 0) + math.floor(gold)
    Gold:UpdatePlayerGold(playerID, newGold)
  end
  
--   function Gold:AddGoldWithMessage(unit, gold, optPlayerID)
--     local player = optPlayerID and PlayerResource:GetPlayer(optPlayerID) or PlayerResource:GetPlayer(UnitVarToPlayerID(unit))
--     SendOverheadEventMessage(player, OVERHEAD_ALERT_GOLD, unit, math.floor(gold), player)
--     Gold:AddGold(optPlayerID or unit, gold)
--   end
  
  function Gold:GetGold(unitvar)
    local playerID = UnitVarToPlayerID(unitvar)
    local currentGold = PlayerTables:GetTableValue("gold", "gold")[playerID]
    return math.floor(currentGold or 0)
  end
  
--   -- exponential gpm increase
  function Gold:PassiveGPM()
    local tAllPlayerIDs = PlayerResource:GetAllTeamPlayerIDs()
    local time = GameRules:GetGameTime()

    if time then
        local tick =  math.floor(time/GPM_TICK_INTERVAL)
        local gold_per_tick = math.max(GOLD_PER_INTERVAL, math.floor(GPM_TICK_INTERVAL*(tick*tick - 140*tick + 192200)/115000))

        for i, hero in pairs(tAllPlayerIDs) do
            if gold_per_tick > 0 then
                Gold:AddGold(hero, gold_per_tick)
            elseif gold_per_tick < 0 then
                Gold:RemoveGold(hero, -gold_per_tick)
            end
        end
    end

    return GPM_TICK_INTERVAL
  end