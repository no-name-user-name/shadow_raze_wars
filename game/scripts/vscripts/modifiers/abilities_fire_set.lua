abilities_fire_set = class({})
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
function abilities_fire_set:IsHidden()return false end
function abilities_fire_set:IsPurgable()return false end
function abilities_fire_set:IsPermanent()return true end
function abilities_fire_set:IsDebuff()	return false end
function abilities_fire_set:GetAbsoluteNoDamagePhysical() return true end
function abilities_fire_set:GetTexture() return "item_ability_fire_set_activator" end

function abilities_fire_set:OnCreated()
    if IsServer() then
        local parent = self:GetParent() -- Получаем героя, к которому применен модификатор

        -- Удаляем старые способности (если нужно)
        for i = 0, 15 do -- Проверяем все слоты способностей
            local ability = parent:GetAbilityByIndex(i)
            if ability then
                local ability_name = ability:GetAbilityName()
                print(ability_name)
                -- if ability_name == "old_ability_1" or ability_name == "old_ability_2" then
                --     parent:RemoveAbility(ability_name) -- Удаляем старую способность
                -- end
            end
        end

        -- -- Добавляем новые способности
        -- parent:AddAbility("new_ability_1") -- Заменяем на новую способность 1
        -- parent:AddAbility("new_ability_2") -- Заменяем на новую способность 2

        -- -- Убедимся, что способности активированы
        -- local new_ability_1 = parent:FindAbilityByName("new_ability_1")
        -- local new_ability_2 = parent:FindAbilityByName("new_ability_2")
        -- if new_ability_1 then
        --     new_ability_1:SetLevel(1) -- Устанавливаем уровень способности
        -- end
        -- if new_ability_2 then
        --     new_ability_2:SetLevel(1) -- Устанавливаем уровень способности
        -- end

        -- print('Fire modificator set: Abilities replaced')
    end
end