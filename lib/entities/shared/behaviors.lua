Behaviors = {
    All = {},
    isSetup = false,
    invoked = {}
}

Behaviors.init = {
    "anim",
    "attach",
    'clothing',
    'follow',
    'particles',
    'scenarios',
    'shop',
    'stash',
    'targets',
    'weapon'
}

function Behaviors.Init()
    if Behaviors.isSetup then return end
    Behaviors.isSetup = true
    for k, v in pairs(Behaviors.init) do
        Require(string.format("lib/entities/shared/behaviors/%s.lua", v))
    end
end

function Behaviors.Create(behaviorId, behavior)
    if not behaviorId or not behavior then return end
    Behaviors.All = Behaviors.All or {}
    local invoking = GetInvokingResource() or "community_bridge"
    Behaviors.All[invoking] = Behaviors.All[invoking] or {}
    Behaviors.All[invoking][behaviorId] = behavior
end

function Behaviors.Get(behaviorId)
    local invoking = GetInvokingResource() or "community_bridge"
    return Behaviors.All[invoking] and Behaviors.All[invoking][behaviorId]
end

function Behaviors.Remove(behaviorId)
    local invoking = GetInvokingResource() or "community_bridge"
    if not Behaviors.All[invoking] or not Behaviors.All[invoking][behaviorId] then return end
    Behaviors.All[invoking][behaviorId] = nil
    return true
end

function Behaviors.Trigger(actionName, clientEntityData, ...)
    if not clientEntityData or not actionName then return end
    local invoking = clientEntityData.invoked or GetInvokingResource() or "community_bridge"
    for property, behavior in pairs(Behaviors.All[invoking] or {}) do
        local hasBehaviorArgs = Behaviors.Has(property, clientEntityData) -- this is everything that's contained inside the object's individual property
        if hasBehaviorArgs and behavior[actionName] then
            local success, result = pcall(behavior[actionName], clientEntityData, hasBehaviorArgs, ...)
            if not success then
                print(string.format("[ClientEntity] Behavior %s failed: %s", property, result))
            end
        end
    end
    for property, behavior in pairs(Behaviors.All['community_bridge'] or {}) do
        local hasBehaviorArgs = Behaviors.Has(property, clientEntityData) -- this is everything that's contained inside the object's individual property
        if hasBehaviorArgs and behavior[actionName] and not Behaviors.All[invoking]?[actionName] then
            local success, result = pcall(behavior[actionName], clientEntityData, hasBehaviorArgs, ...)
            if not success then
                print(string.format("[ClientEntity] Behavior %s failed: %s", property, result))
            end
        end
    end
end

function Behaviors.Inherit(behaviorId, clientEntityData, defaultData)
    local invoking = GetInvokingResource() or "community_bridge"
    if not Behaviors.All[invoking] or not Behaviors.All[invoking][behaviorId] then
        print(string.format("[ClientEntity] Behavior %s does not exist", behaviorId))
        return false
    end
    if not clientEntityData or not clientEntityData.id then
        print("[ClientEntity] Invalid client entity data provided for inheritance")
        return false
    end
    clientEntityData[behaviorId] = defaultData or {} -- Mark the entity as having this behavior
    return true
end

function Behaviors.Has(behaviorId, clientEntityData)
    return clientEntityData and clientEntityData[behaviorId]
end

function Behaviors.Cleanup(resourceName)
    if not resourceName or not Behaviors.All[resourceName] then return end
    for _, behaviorId in ipairs(Behaviors.All[resourceName]) do
        Behaviors.Remove(behaviorId)
    end
    Behaviors.All[resourceName] = nil
end

AddEventHandler("onResourceStop", function(resourceName)
    Behaviors.Cleanup(resourceName)
    if resourceName ~= GetCurrentResourceName() then return end
    for invoking, behaviors in pairs(Behaviors.All) do
        for behaviorId, _ in pairs(behaviors) do
            Behaviors.Remove(behaviorId)
        end
    end
end)

if IsDuplicityVersion() then
    RegisterNetEvent("onResourceStart", function(resourceName)
        if resourceName ~= GetCurrentResourceName() then return end
        Wait(500)
        Behaviors.Init()
    end)
else
    RegisterNetEvent("onClientResourceStart", function(resource)
        if resource ~= GetCurrentResourceName() then return end
        Wait(500)
        Behaviors.Init()
    end)
end

return Behaviors
