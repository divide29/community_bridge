Bridge = Bridge or exports['community_bridge']:Bridge()

RegisterCommand("ServerEntityStash", function(src)
    local position = GetEntityCoords(GetPlayerPed(src)) - vector3(0,0,1)
    Bridge.ServerEntity.Create({
        model = "mp_m_freemode_01",
        coords = position,
        entityType = "ped",
        stash = {
            label = "Test Stash",
            slots = 20,
            maxWeight = 10000,
            target = {
                label = "Open Stash",
                description = "Access the stash to store or retrieve items.",
                icon = "fas fa-boxes"
            }
        }
    })
end, false)

RegisterCommand("ServerEntityScenarios", function(src)
    local position = GetEntityCoords(GetPlayerPed(src)) - vector3(0,0,1)
    Bridge.ServerEntity.Create({
        model = "mp_m_freemode_01",
        coords = position,
        entityType = "ped",
        scenarios = {
            name = "WORLD_HUMAN_CLIPBOARD",
            introClip = true,
            duration = 20000
        }
    })
end, false)

RegisterCommand("ServerEntityAnim", function(src)
    local position = GetEntityCoords(GetPlayerPed(src)) - vector3(0,0,1)
    Bridge.ServerEntity.Create({
        model = "mp_m_freemode_01",
        coords = position,
        entityType = "ped",
        anim = {
            dict = "anim@mp_player_intcelebrationmale@wave",
            name = "wave",
            flags = 49,
            duration = -1,
        }
    })
end, false)

RegisterCommand("ServerEntityParticles", function(src)
    local position = GetEntityCoords(GetPlayerPed(src)) - vector3(0,0,1)
    Bridge.ServerEntity.Create({
        model = "mp_m_freemode_01",
        coords = position,
        entityType = "ped",
        particles = {
            {
                dict = "core",
                ptfx = "ent_dst_electrical",
                offset = vector3(0.0, 1.0, 0.0),
                looped = true
            },
            {
                dict = "core",
                ptfx = "ent_dst_electrical",
                offset = vector3(0.0, -1.0, 0.0),
                rotation = vector3(0.0, 0.0, 180.0),
                looped = true,
                loopLength = 1000
            }
        }
    })
end, false)

RegisterCommand("ServerEntityClothing", function(src)
    local position = GetEntityCoords(GetPlayerPed(src)) - vector3(0,0,1)
    Bridge.ServerEntity.Create({
        model = "mp_m_freemode_01",
        coords = position,
        entityType = "ped",
        clothing = {
            components = {
                { drawable = 0,  texture = 0, component_id = 0 },
                { drawable = 0,  texture = 0, component_id = 1 },
                { drawable = 19, texture = 0, component_id = 2 },
                { drawable = 6,  texture = 0, component_id = 3 },
                { drawable = 0,  texture = 0, component_id = 4 },
                { drawable = 0,  texture = 0, component_id = 5 },
                { drawable = 0,  texture = 0, component_id = 6 },
                { drawable = 0,  texture = 0, component_id = 7 },
                { drawable = 23, texture = 0, component_id = 8 },
                { drawable = 0,  texture = 0, component_id = 9 },
                { drawable = 0,  texture = 0, component_id = 10 },
                { drawable = 4,  texture = 2, component_id = 11 }
            },
            props = {
                { drawable = 27, prop_id = 0,  texture = 0 },
                { drawable = 0,  prop_id = 1,  texture = 0 },
                { drawable = 0,  prop_id = 2,  texture = 0 },
                { drawable = 0,  prop_id = 3,  texture = 0 },
                { drawable = 0,  prop_id = 4,  texture = 0 },
                { drawable = 0,  prop_id = 5,  texture = 0 },
                { drawable = 0,  prop_id = 6,  texture = 0 },
                { drawable = 0,  prop_id = 7,  texture = 0 },
                { drawable = 0,  prop_id = 8,  texture = 0 },
                { drawable = 0,  prop_id = 9,  texture = 0 },
                { drawable = 0,  prop_id = 10, texture = 0 },
                { drawable = 0,  prop_id = 11, texture = 0 },
                { drawable = 0,  prop_id = 12, texture = 0 },
                { drawable = 0,  prop_id = 13, texture = 0 }
            }
        }
    })
end, false)
