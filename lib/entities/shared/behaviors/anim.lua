if IsDuplicityVersion() then return end
local Animation = {
    property = "anim",
    default = {
        flags = 49,
        duration = -1
    }
}
-- Anim.Play(id, entity, animDict, animName, blendIn, blendOut, duration, flag, playbackRate, onComplete)
function Animation.Play(entityData)
    if entityData.entityType ~= "ped" then return end
    local entity = entityData.spawned
    if not entity then return end
    local dict = entityData.anim?.dict
    local name = entityData.anim?.name
    local onComplete = entityData.anim?.onComplete and function() entityData.anim.onComplete(entityData) end
    if not dict or not name then return end
    local flags = entityData.anim.flags or Animation.default.flags
    local duration = entityData.anim.duration or Animation.default.duration
    entityData.anim.id = Bridge.Anim.Play(nil, entity, dict, name, 8.0, -8.0, duration, flags, 0.0, onComplete)
    Bridge.Entity.Set(entityData.id, "anim", entityData.anim)
    entityData.oldAnim = entityData.anim
    Bridge.Entity.Set(entityData.id, "oldAnim", entityData.oldAnim)
    --  SetTimeout(1000, function()
    --     if entityData.anim then
    --         entityData.anim.disable = false
    --         Bridge.Entity.Set(entityData.id, "anim", entityData.anim)
    --     end
    -- end)
end

function Animation.OnSpawn(entityData)
    print("Spawning animation for entity:", entityData.id)
    if not entityData.spawned or not entityData.anim then return end
    Animation.Play(entityData)
    entityData.anim.disable = false
    TaskSetBlockingOfNonTemporaryEvents(entityData.spawned, true)
    SetBlockingOfNonTemporaryEvents(entityData.spawned, true)
    Bridge.Entity.Set(entityData.id, "anim", entityData.anim)
end

function Animation.OnRemove(entityData)
    if not entityData.spawned or not entityData.anim then return end
    entityData.oldAnim = nil
    entityData.anim.disable = true
    Bridge.Entity.Set(entityData.id, "anim", entityData.anim) 
    Bridge.Entity.Set(entityData.id, "oldAnim", entityData.oldAnim)
end

function Animation.OnUpdate(entityData)
    if not entityData.spawned or not entityData.anim then return end
    if entityData.anim.disable then return end
    if not IsEntityPlayingAnim(entityData.spawned, entityData.anim.dict, entityData.anim.name, 3) then
        Bridge.Anim.Stop(entityData.anim?.id)
        ClearPedTasksImmediately(entityData.spawned)
        Wait(100)
        Animation.Play(entityData)
    end
end

Bridge.Entity.RegisterBehavior("anim", Animation)
return Animation