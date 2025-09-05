local Stash = {
    property = "stash",
    default = {
        label = "default_stash_label",
        slots = 20,
        maxWeight = 100000,
        target = {
            label = "Open Stash",
            icon = "fa-solid fa-box",
        }
    }
}

function Stash.OnCreate(entityData)
    if not entityData.stash then return end
    if IsDuplicityVersion() then 
        local label = entityData.stash.label or Stash.default.label
        local slots = entityData.stash.slots or Stash.default.slots
        local weight = entityData.stash.maxWeight or Stash.default.maxWeight
        local owner = entityData.stash.owner
        local groups = entityData.stash.groups
        Bridge.Inventory.RegisterStash(entityData.id, label, slots, weight, owner, groups)
        return
    end
    entityData.targets = entityData.targets or {}
    entityData.targets['stash'] = {
        label = entityData.stash.target.label or Stash.default.target.label,
        icon = entityData.stash.target.icon or Stash.default.target.icon,
        description = entityData.stash.target.description, 
        groups = entityData.stash.target.groups,
        canInteract = function(_)
            local entData = Bridge.Entity.Get(entityData.id)
            return not entData.stash.disable
        end,
        onSelect = function()                    
            TriggerServerEvent("community_bridge:server:OpenStash", entityData.id)
        end
    }
    
    Bridge.Entity.Set(entityData.id, 'targets', entityData.targets)    
end

if not IsDuplicityVersion() then return Bridge.Entity.RegisterBehavior("stash", Stash) end

RegisterNetEvent("community_bridge:server:OpenStash", function(id)
    local src = source
    if not src then return end
    local entityData = Bridge.Entity.Get(id)
    if not entityData or not entityData.stash then 
        return print(string.format("[Stash] OpenStash: Entity %s does not exist or has no stash", id)) 
    end
    local coords = vector3(entityData.coords.x, entityData.coords.y, entityData.coords.z)
    if not coords then return end
    local distance = #(GetEntityCoords(GetPlayerPed(src)) - coords)
    if distance > 3.0 then 
        return print(string.format("[Stash] OpenStash: Player %s is too far from entity %s", src, id)) 
    end
    Bridge.Inventory.OpenStash(src, "stash", id)
end)

Bridge.Entity.RegisterBehavior("stash", Stash)