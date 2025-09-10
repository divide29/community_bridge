if IsDuplicityVersion() then return end
local Follow = {
    All = {},
    property = "follow",
    default = {
        speed = 1.0,
        distance = 2.0
    }
}

function Follow.PedWalkToPos(entityData)
    if not entityData?.follow?.target or entityData?.entityType ~= "ped" then return end
    local entity = entityData.spawned
    local targetCoords = entityData.follow.target
    if not targetCoords then return end
    if type(targetCoords) == "number" then
        local player = GetPlayerFromServerId(targetCoords)
        if player and player ~= -1 then
            targetCoords = GetEntityCoords(GetPlayerPed(player))
        else
            targetCoords = GetEntityCoords(targetCoords)
        end
    elseif type(targetCoords) == "string" then
        local targetEntityData = Bridge.Entity.Get(targetCoords)
        if targetEntityData then
            targetCoords = GetEntityCoords(targetEntityData.spawned)
        end
    end
    local entityPos = GetEntityCoords(entity)
    local distance = #(targetCoords - entityPos)
    if distance > (entityData.follow.distance or Follow.default.distance) then
        if entityData.anim then
            entityData.anim.disable = true
            Bridge.Entity.Set(entityData.id, "anim", entityData.anim)
        end
        if entityData.scenarios then
            entityData.scenarios.disable = true
            Bridge.Entity.Set(entityData.id, "scenarios", entityData.scenarios)
        end
        local speed = entityData.follow.speed or Follow.default.speed
        local heading = GetHeadingFromVector_2d(targetCoords.x - entityPos.x, targetCoords.y - entityPos.y)
        TaskGoStraightToCoord(entity, targetCoords.x, targetCoords.y, targetCoords.z, speed, -1, heading, 0.0)
        entityData.coords = GetEntityCoords(entity)
        entityData.follow.walking = true
        Bridge.Entity.Set(entityData.id, "coords", entityData.coords - vector3(0,0,1))
        Bridge.Entity.Set(entityData.id, "follow", entityData.follow)
        if entityData.follow.OnExit then entityData.follow.OnExit(entityData) end
        return false
    end
    if not entityData.follow.walking then return end
    entityData.follow.walking = false
    Bridge.Entity.Set(entityData.id, "follow", entityData.follow)
    if entityData.anim then
        entityData.anim.disable = false
        Bridge.Entity.Set(entityData.id, "anim", entityData.anim)
    end
    if entityData.scenarios then
        entityData.scenarios.disable = false
        Bridge.Entity.Set(entityData.id, "scenarios", entityData.scenarios)
    end    
    ClearPedTasks(entity)
    if entityData.follow.OnEnter then entityData.follow.OnEnter(entityData) end
    return true
end


function Follow.OnUpdate(entityData)
    assert(entityData?.id, "Entity ID is required")
    local entity = entityData.spawned
    if not entity or not DoesEntityExist(entity) then return end
    return Follow.PedWalkToPos(entityData)
end

Bridge.Entity.RegisterBehavior("follow", Follow)
return Follow