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

function RuneSpawner:SpawnRune()
	local spawners = Entities:FindAllByName('custom_rune_spawner')
    local clearSpawners = {}
    local badSpawners = {}

    local randomSpawner = spawners[math.random(#spawners)]
    local spawnPosition = randomSpawner:GetOrigin()

    local ents = Entities:FindAllInSphere(spawnPosition, 50)

    for i, e in pairs(ents) do
        if e:GetClassname() == 'dota_item_rune' then
            e:Destroy()
        end
    end

    local runeType = RUNES[math.random(#RUNES)]
    CreateRune(spawnPosition, runeType)

    return SPAWN_INTERVAL
  end