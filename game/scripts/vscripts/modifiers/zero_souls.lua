zero_souls = class({})

--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
function zero_souls:DeclareFunctions()
	local funcs = 
	{
        MODIFIER_EVENT_ON_DEATH_PREVENTED,
	}
	return funcs
end

function  zero_souls:IsHidden()return true end
function  zero_souls:IsPurgable()return false end
function  zero_souls:IsPermanent()return true end
function  zero_souls:IsDebuff()	return true end

function zero_souls:OnDeathPrevented(params)
	local deadman = params.unit
    if self:GetParent() == deadman then
        deadman:SetModifierStackCount('modifier_nevermore_necromastery', nil, 0)
    end
end