
if IsDuplicityVersion() then return end
local Scenarios = {
    property = "scenarios",
    default = {
        introClip = true,
        duration = -1
    }
}
-- scenarios.Play(id, entity, scenariosDict, scenariosName, blendIn, blendOut, duration, flag, playbackRate, onComplete)
function Scenarios.Play(entityData)
    if entityData.entityType ~= "ped" then return end
    local entity = entityData.spawned
    if not entity then return end
    local name = entityData.scenarios?.name
    if not name then return end
    local duration = entityData.scenarios?.duration or Scenarios.default.duration
    local introClip = entityData.scenarios?.introClip or Scenarios.default.introClip
    TaskStartScenarioInPlace(entity, name, duration, introClip)
    if duration < 0 then return end
    SetTimeout(duration, function()
        if not entityData.scenarios then return end
        ClearPedTasks(entity)
        if not entityData.scenarios.onComplete then return end
        entityData.scenarios.disabled = true
        Bridge.Entity.Set(entityData.id, "scenarios", entityData.scenarios)
        entityData.scenarios.onComplete(entityData)        
    end)
   
end

function Scenarios.OnSpawn(entityData)
    if not entityData.spawned or not entityData.scenarios then return end
    Scenarios.Play(entityData)
end

function Scenarios.OnRemove(entityData)
    if not entityData.spawned or not entityData.scenarios then return end
    ClearPedTasks(entityData.spawned)
end

function Scenarios.OnUpdate(entityData)
    if not entityData.spawned or not entityData.scenarios then return end
    if entityData.scenarios.disable then return end
    if IsPedUsingScenario(entityData.spawned, entityData.scenarios.name) then return end
    local entities = GetGamePool('CObject')
    for _, obj in ipairs(entities or {}) do
        obj = tonumber(obj)
        local entityCoords = GetEntityCoords(obj)
        local coords = vector3(entityData.coords.x, entityData.coords.y, entityData.coords.z)
        if entityCoords then
            local distance = #(entityCoords - coords)
            if distance < 2.0 then
                SetEntityAsMissionEntity(obj, false, false)
                DeleteObject(obj)
                break
            end
        end
    end
    Scenarios.Play(entityData)
end

Bridge.Entity.RegisterBehavior("scenarios", Scenarios)
return Scenarios