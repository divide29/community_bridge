local Shop = {
    property = "shop",
    default = {
        label = "Default Shop Label",
        items = {
            {item = "water", price = 10}
        },
        target = {
            label = "Open Shop",
            icon = "fa-solid fa-box"
        }
    }
}

function Shop.OnCreate(entityData)
    local shop = entityData.shop
    if not shop then return end
    if IsDuplicityVersion() then 
        local label = shop.label or Shop.default.label
        local items = shop.items or Shop.default.items
        local coords = entityData.coords
        local groups = shop.groups
        Bridge.Inventory.RegisterShop(label, items, nil, groups)
        return
    end
    entityData.targets = entityData.targets or {}
    print(json.encode(entityData.targets))
    table.insert(entityData.targets,
        {
            label = shop.target.label or "Shop",
            icon = shop.target.icon or "fa-solid fa-box",
            onSelect = function()                    
                TriggerServerEvent("community_bridge:server:OpenShop", entityData.id)
            end
        }
    )
end

if not IsDuplicityVersion() then return Bridge.Entity.RegisterBehavior("shop", Shop) end

RegisterNetEvent("community_bridge:server:OpenShop", function(id)
    local src = source
    if not src then return end
    local entityData = Bridge.Entity.Get(id)
    if not entityData or not entityData.shop then 
        return print(string.format("[Shop] OpenShop: Entity %s does not exist or has no shop", id)) 
    end
    local coords = entityData.coords
    if not coords then return end
    local distance = #(GetEntityCoords(GetPlayerPed(src)) - coords)
    if distance > 3.0 then 
        return print(string.format("[Shop] OpenShop: Player %s is too far from entity %s", src, id)) 
    end
    Bridge.Inventory.OpenShop(src, id)
end)


return Shop