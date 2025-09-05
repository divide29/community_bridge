if IsDuplicityVersion() then return end
local Clothing = {
    property = "clothing",
    default = {
        components = {},
        props = {}
    }
}

function Clothing.ChangeClothes(entityData)
    if entityData.entityType ~= "ped" then return end
    local entity = entityData.spawned
    if not entity or not DoesEntityExist(entity) then return end
    local clothing = entityData.clothing.target
    if clothing then 
         if type(clothing) == "number" then 
            local player = GetPlayerFromServerId(clothing)
            if player and player ~= -1 then
                clothing = Bridge.Clothing.GetAppearance(GetPlayerPed(player))
            end
        elseif type(clothing) == "string" then 
            local targetEntityData = Bridge.Entity.Get(clothing)
            if targetEntityData then
                clothing = Bridge.Clothing.GetAppearance(targetEntityData.spawned)
            end
        end
    else
        clothing = entityData.clothing
    end
   
    Bridge.Clothing.SetAppearance(entity, clothing)
    Bridge.Entity.Set(entityData.id, "clothing", clothing)
    entityData.oldClothing = clothing
    Bridge.Entity.Set(entityData.id, "oldClothing", clothing)

end


function Clothing.OnSpawn(entityData)
    if not entityData.spawned or not entityData.clothing then return end
    Clothing.ChangeClothes(entityData)
    entityData.clothing.updating = false
end

function Clothing.OnRemove(entityData)
    if not entityData.spawned or not entityData.clothing then return end
    entityData.oldClothing = nil
    entityData.clothing.updating = true
end

function Clothing.OnUpdate(entityData)
    if not entityData.spawned or not entityData.clothing then return end
    if entityData.clothing.updating then return end
    entityData.clothing.updating = true
    if not entityData.oldClothing then
        Clothing.ChangeClothes(entityData)
        return
    end
    for componentId, component in pairs(entityData.clothing.components or {}) do
        local oldComponent = entityData.oldClothing.components and entityData.oldClothing.components[componentId]
        if not oldComponent or oldComponent.drawable ~= component.drawable or oldComponent.texture ~= component.texture then
            Clothing.ChangeClothes(entityData)
            return
        end
    end
    for propId, prop in pairs(entityData.clothing.props or {}) do
        local oldProp = entityData.oldClothing.props and entityData.oldClothing.props[propId]
        if not oldProp or oldProp.drawable ~= prop.drawable or oldProp.texture ~= prop.texture then
            Clothing.ChangeClothes(entityData)
            return
        end
    end
    SetTimeout(1000, function()
        if entityData.clothing then
            entityData.clothing.updating = false
            Bridge.Entity.Set(entityData.id, "clothing", entityData.clothing)
        end
    end)
end

Bridge.Entity.RegisterBehavior("clothing", Clothing)
return Clothing