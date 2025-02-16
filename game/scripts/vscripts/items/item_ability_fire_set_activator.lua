LinkLuaModifier( "modifier_item_ability_fire_set_activator", "items/item_ability_fire_set_activator.lua", LUA_MODIFIER_MOTION_NONE )

item_ability_fire_set_activator = class({})

function item_ability_fire_set_activator:GetIntrinsicModifierName()
  return "modifier_item_ability_fire_set_activator"
end

-- function item_ability_fire_set_activator:CastFilterResultLocation(targetPoint)
--   if IsServer() then
--     local hCaster = self:GetCaster()
--     local ents = Entities:FindAllInSphere(targetPoint, 50)

--     for i, e in pairs(ents) do
--         if e:GetName() == 'tp_block' then
--           return UF_FAIL_CUSTOM 
--         end
--     end

--     self.targetPoint = targetPoint
--     return UF_SUCCESS
--   end
-- end

-- function item_ability_fire_set_activator:GetCustomCastErrorLocation()
--   -- "Cannot find nearby valid target" error
--   return "#dota_hud_error_target_no_dark_rift"
-- end

-- function item_ability_fire_set_activator:OnInventoryContentsChanged()
--   print('EQUIPED')
-- end

-- function item_ability_fire_set_activator:OnEquip()
--   print('EQUIPED')
-- end

-- function item_ability_fire_set_activator:OnSpellStart()
--   local hCaster = self:GetCaster()
--   local hTarget = self:GetCursorTarget()
--   self.targetOrigin = self:GetCursorPosition()
--   local casterTeam = hCaster:GetTeamNumber()

--   if hTarget then
--     if hTarget == hCaster then
--       self.targetOrigin = GetClearSpaceForUnit(hCaster, Vector(RandomInt(-2400, 2400), RandomInt(-2000, 2000), 160))
--     end
--   end
  
--   -- Minimap teleport display
--   MinimapEvent(casterTeam, hCaster, self.targetOrigin.x, self.targetOrigin.y, DOTA_MINIMAP_EVENT_TEAMMATE_TELEPORTING, self:GetChannelTime() + 0.5)

--   local allHeroes = HeroList:GetAllHeroes()
--   for i, hero in pairs(allHeroes) do
--     local teamID = hero:GetTeam()

--   -- Vision
--     if teamID == casterTeam then
--       MinimapEvent(teamID, hCaster, self.targetOrigin.x, self.targetOrigin.y, DOTA_MINIMAP_EVENT_TEAMMATE_TELEPORTING, self:GetChannelTime() + 0.5)
--       self:CreateVisibilityNode(self.targetOrigin, 50, self:GetChannelTime() + 1)

--     else
--       MinimapEvent(teamID, hCaster, self.targetOrigin.x, self.targetOrigin.y, DOTA_MINIMAP_EVENT_ENEMY_TELEPORTING, self:GetChannelTime() + 0.5)
--       AddFOWViewer(teamID, self.targetOrigin, 150, 5, true)
--     end
--   end

--   -- Teleport animation
--   hCaster:StartGesture(ACT_DOTA_TELEPORT)

--   -- Teleport sounds
--   hCaster:EmitSound("Portal.Loop_Disappear")
-- --   hTarget:EmitSound("Portal.Loop_Appear")

--   -- Particle effects
--   local teleportFromEffectName = "particles/items2_fx/teleport_start.vpcf"
--   local teleportToEffectName = "particles/items2_fx/teleport_end.vpcf"
--   self.teleportFromEffect = ParticleManager:CreateParticle(teleportFromEffectName, PATTACH_ABSORIGIN, hCaster)
--   self.teleportToEffect = ParticleManager:CreateParticle(teleportToEffectName, PATTACH_ABSORIGIN_FOLLOW, hCaster)

--   ParticleManager:SetParticleControlEnt(self.teleportFromEffect, 0, hCaster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self.targetOrigin, true)
--   ParticleManager:SetParticleControl(self.teleportToEffect, 1, self.targetOrigin)
--   ParticleManager:SetParticleControlEnt(self.teleportFromEffect, 3, hCaster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self.targetOrigin, true)
--   ParticleManager:SetParticleControl(self.teleportToEffect, 4, self.targetOrigin)
--   ParticleManager:SetParticleControlEnt(self.teleportFromEffect, 5, hCaster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self.targetOrigin, true)
-- end

-- function item_ability_fire_set_activator:OnChannelFinish(wasInterupted)
--   local hCaster = self:GetCaster()

--   MinimapEvent(hCaster:GetTeamNumber(), hCaster, 0, 0, DOTA_MINIMAP_EVENT_CANCEL_TELEPORTING, 0)

--   -- End animation
--   hCaster:RemoveGesture(ACT_DOTA_TELEPORT)

--   -- End particle effects
--   ParticleManager:DestroyParticle(self.teleportFromEffect, false)
--   ParticleManager:DestroyParticle(self.teleportToEffect, false)
--   ParticleManager:ReleaseParticleIndex(self.teleportFromEffect)
--   ParticleManager:ReleaseParticleIndex(self.teleportToEffect)

--   -- End sounds
--   hCaster:StopSound("Portal.Loop_Disappear")
--   -- hCaster:StopSound("Hero_Tinker.MechaBoots.Loop")

--   if wasInterupted then
--     return -- do nothing
--   end

--   hCaster:StartGesture(ACT_DOTA_TELEPORT_END)
--   EmitSoundOnLocationWithCaster(hCaster:GetOrigin(), "Portal.Hero_Disappear", hCaster)
--   FindClearSpaceForUnit(hCaster, self.targetOrigin, true)
--   GridNav:DestroyTreesAroundPoint(self.targetOrigin, 150, false)
-- end
---------------------------------------------------------------------------------------------------

modifier_item_ability_fire_set_activator = class({})

function modifier_item_ability_fire_set_activator:IsHidden()
  return true
end

function modifier_item_ability_fire_set_activator:IsDebuff()
  return false
end

function modifier_item_ability_fire_set_activator:IsPurgable()
  return false
end

function modifier_item_ability_fire_set_activator:OnCreated()
  if IsServer() then
    Timers:CreateTimer(0.1, function()
      local parent = self:GetParent() -- Получаем владельца модификатора (героя)
      local item = self:GetAbility() -- Получаем предмет, связанный с модификатором

      -- Проверяем, что предмет существует и находится в инвентаре
      if item and parent:HasItemInInventory(item:GetName()) then
        parent:RemoveItem(item) -- Удаляем предмет
        print("Предмет удален из инвентаря")
      else
        print("Предмет не найден в инвентаре")
      end
    end)
  end
end

-- function modifier_item_ability_fire_set_activator:GetTexture()
--   return "item_ability_fire_set_activator"
-- end
