kill_leader = class({})

function  kill_leader:IsHidden()return false end
function  kill_leader:IsPurgable()return false end
function  kill_leader:IsPermanent()return true end
function  kill_leader:IsDebuff()	return true end

function kill_leader:CheckState()
	return {
        [MODIFIER_STATE_INVISIBLE] = false
    }
end

function kill_leader:GetTexture()
	return "item_modifier_kill_leader"
end