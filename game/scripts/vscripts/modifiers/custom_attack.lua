custom_attack = class({})

--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
-- function custom_attack:CheckState()
-- 	local state = {
-- 		[MODIFIER_STATE_ATTACK_IMMUNE] = true,
-- 	}
-- 	return state
-- end

function custom_attack:DeclareFunctions()
	local funcs = 
	{
        -- MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL
		MODIFIER_EVENT_ON_ATTACK_START
	}
	return funcs
end

function  custom_attack:IsHidden()return false end
function  custom_attack:IsPurgable()return false end
function  custom_attack:IsPermanent()return true end
function  custom_attack:IsDebuff()	return true end
function custom_attack:GetAbsoluteNoDamagePhysical() return true end

function custom_attack:OnAttackStart(k)
    local attacker = k.attacker
    local target = k.target

    if target:GetOwner()==nil then
        return
    end
    
    if target:IsHero() then
        attacker:Stop()
    end
end
