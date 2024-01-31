custom_attack = class({})

--------------------------------------------------------------------------------


--------------------------------------------------------------------------------


function custom_attack:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_EVENT_ON_ATTACK_START
	}
	return funcs
end

function  custom_attack:IsHidden()return false end
function  custom_attack:IsPurgable()return false end
function  custom_attack:IsPermanent()return true end
function  custom_attack:IsDebuff()	return true end
function custom_attack:GetAbsoluteNoDamagePhysical() return true end

function custom_attack:GetTexture()
    return "item_modifier_custom_attack"
end

function custom_attack:OnAttackStart(k)
    local attacker = k.attacker
    local target = k.target
    if IsServer() then
        if target:GetOwner()==nil then
            return
        end
        
        if target:IsHero() then
            attacker:Stop()
        end
    end
end
