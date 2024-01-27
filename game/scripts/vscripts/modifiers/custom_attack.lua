custom_attack = class({})

--------------------------------------------------------------------------------


--------------------------------------------------------------------------------

function custom_attack:DeclareFunctions()
	local funcs = 
	{
        MODIFIER_EVENT_ON_DEATH_PREVENTED,
		MODIFIER_EVENT_ON_ATTACK_START,
	}
	return funcs
end

function  custom_attack:IsHidden()return false end

function  custom_attack:IsPurgable()return false end

function  custom_attack:IsPermanent()return true end

function  custom_attack:IsDebuff()	return true end

function custom_attack:OnDeathPrevented(params)
	local deadman = params.unit
    if self:GetParent() == deadman then
        deadman:SetModifierStackCount('modifier_nevermore_necromastery', nil, 0)
    end
end

function custom_attack:OnAttackStart(k)
    local attacker = k.attacker
    local target = k.target
    if target~=nil and target:IsHero() then
        attacker:Stop()
    end
end
