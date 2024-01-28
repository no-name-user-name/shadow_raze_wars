spells_upgrade = class({})

--------------------------------------------------------------------------------


--------------------------------------------------------------------------------

function spells_upgrade:DeclareFunctions()
	local funcs = 
	{
        -- MODIFIER_EVENT_ON_TAKEDAMAGE,
        MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
	}
	return funcs
end

function  spells_upgrade:IsHidden()return false end

function  spells_upgrade:IsPurgable()return false end

function  spells_upgrade:IsPermanent()return true end

function  spells_upgrade:IsDebuff()	return false end

-- function spells_upgrade:OnTakeDamage(params)
--     -- print(dump(params.inflictor))

--     local inflictor = params.inflictor
--     local attacker = params.attacker
--     local unit = params.unit
--     local stacks = self:GetStackCount()
--     local spellName = inflictor:GetAbilityName()
    
--     if inflictor == nil then
--         return
--     end

--     -- print(inflictor:GetAbilityIndex())
--     -- print(inflictor:GetAbilityName())

--     if spellName == 'nevermore_shadowraze1' or spellName == "nevermore_shadowraze2" or spellName == "nevermore_shadowraze2" or spellName == "nevermore_shadowraze3" then
--         if self:GetCaster() == attacker then
--             if stacks <= 0 then
--                 return
--             end

--             local damage = 20 * stacks
            
--             attacker:SetModifierStackCount("spells_upgrade", nil, 0)
--             ApplyDamage({attacker = attacker, victim = unit, ability = inflictor, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
--             attacker:SetModifierStackCount("spells_upgrade", nil, stacks)
--         end
--     elseif spellName == 'nevermore_requiem' then
--         if self:GetCaster() == attacker then
--             if stacks <= 0 then
--                 return
--             end

--             local damage = 5 * stacks

--             attacker:SetModifierStackCount("spells_upgrade", nil, 0)
--             ApplyDamage({attacker = attacker, victim = unit, ability = inflictor, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
--             attacker:SetModifierStackCount("spells_upgrade", nil, stacks)
--         end
--     end
-- end

function spells_upgrade:GetModifierSpellAmplify_Percentage()
	return 15 * self:GetStackCount()
end