if IsDuplicityVersion() then return end
local Attach = {
    property = "attach",
    default = {
        bone = 0,
        offset = vector3(0.0, 0.0, 0.0),
        rotation = vector3(0.0, 0.0, 0.0)
    }
}


function Attach.OnSpawn(entityData)
    if not entityData.spawned or not entityData.attach then return end
    local entity = entityData.spawned
    local targetEntity =  entityData.attach.target
    if type(targetEntity) == "string" then
        targetEntity = Bridge.Entity.Get(targetEntity)?.spawned or targetEntity
    else
        local player = GetPlayerFromServerId(targetEntity)
        if player and player ~= -1 then
            targetEntity = GetPlayerPed(player)
        end
    end
    targetEntity = tonumber(targetEntity)
    if not targetEntity then return end
    local bone = entityData.attach.bone or Attach.default.bone
    local offset = entityData.attach.offset or Attach.default.offset
    local rotation = entityData.attach.rotation or Attach.default.rotation
    AttachEntityToEntity(entity, targetEntity, GetPedBoneIndex(targetEntity, bone), offset.x, offset.y, offset.z, rotation.x, rotation.y, rotation.z, true, true, false, true, 1, true)
    Bridge.Entity.Set(entityData.id, "attach", entityData.attach)
end

function Attach.Detach(entityData)
    if not entityData.spawned or not IsEntityAttached(entityData.spawned) then return end
    DetachEntity(entityData.spawned, true, true)
    Bridge.Entity.Set(entityData.id, "attach", entityData.attach)
end

function Attach.OnUpdate(entityData)
    if not entityData.spawned then return end
    if entityData.attach.disable then 
        return Attach.Detach(entityData) 
    end
    local entity = entityData.spawned
    local coords = GetEntityCoords(entity)
    Bridge.Entity.Set(entityData.id, "coords", vector3(coords.x, coords.y, coords.z))
    if IsEntityAttached(entity) then return end
    Attach.OnSpawn(entityData)
end

Bridge.Entity.RegisterBehavior("attach", Attach)
return Attach