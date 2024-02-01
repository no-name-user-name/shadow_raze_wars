if RuneSpawner == nil then
    RuneSpawner = class({})
end

local SPAWN_INTERVAL = CUSTOM_RUNE_SPAWN_INTERVAL or 30   -- CUSTOM_RUNE_SPAWN_INTERVAL is located in settings.lua
local RUNES = {
    -- DOTA_RUNE_INVALID,
    DOTA_RUNE_DOUBLEDAMAGE,
    DOTA_RUNE_HASTE,
    -- DOTA_RUNE_ILLUSION,
    DOTA_RUNE_INVISIBILITY,
    DOTA_RUNE_REGENERATION,
    -- DOTA_RUNE_BOUNTY,
    DOTA_RUNE_ARCANE,
    -- DOTA_RUNE_WATER,
    -- DOTA_RUNE_XP,
    -- DOTA_RUNE_SHIELD,
    -- DOTA_RUNE_COUNT,
}
function RuneSpawner:Init()
    print('-- RUNE SPAWNER INIT')
    self.moduleName = "RuneSpawner"
    Timers:CreateTimer(SPAWN_INTERVAL, Dynamic_Wrap(RuneSpawner, 'SpawnRune'))
end


function removeSpawnerFromTable(t, val)
    local count = 1
    for i, s in pairs(t) do
        if s:GetEntityIndex() == val:GetEntityIndex() then
            table.remove(t, count)
            return t
        end
        count = count + 1
    end
    return t
end

function RuneSpawner:SpawnRune()
    local clearSpawners = {}
    local badSpawners = {}
	local spawners = Entities:FindAllByName('custom_rune_spawner')
    print(dump(spawners))
    while #spawners ~= 0 do
        local randomSpawner = spawners[math.random(#spawners)]
        local spawnPosition = randomSpawner:GetOrigin()
        local ents = Entities:FindAllInSphere(spawnPosition, 50)

        local isBad = false
        for i, e in pairs(ents) do
            if e:GetClassname() == 'dota_item_rune' then
                spawners = removeSpawnerFromTable(spawners, randomSpawner)
                isBad = true
                break
            end
        end

        if isBad == false then
            local runeType = RUNES[math.random(#RUNES)]
            CreateRune(spawnPosition, runeType)
            break
        end
    end
    
    return SPAWN_INTERVAL
  end