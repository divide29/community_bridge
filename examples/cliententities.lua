Bridge = Bridge or exports['community_bridge']:Bridge()
-- RegisterCommand("ClientEntityParticles", function()
--     local position = GetEntityCoords(PlayerPedId())
--     local data = Bridge.ClientEntity.Create({
--         id = "particle_" .. math.random(1, 10000),
--         model = "mp_m_freemode_01",
--         coords = position,
--         entityType = "ped",
--         freeze = false,
--         follow = {
--             target = 1,
--         },
--         weapon = {
--             name = "WEAPON_PISTOL",
--             ammo = 100
--         },
--         stash = {
--             -- id = "generate from server",
--             label = "Test Stash",
--             target = {
--                 label = "Open Stash",
--                 description = "Access the stash to store or retrieve items.",
--                 icon = "fas fa-boxes"
--             }
--         },
--         attach = {
--             target = 1,
--             bone = 57005, -- right hand
--         },      
--         scenarios = {
--             name = "WORLD_HUMAN_CLIPBOARD",
--             introClip = true,
--             duration = 20000
--         },
--         anim = {
--             dict = "anim@mp_player_intcelebrationmale@wave",
--             name = "wave",
--             flags = 49,
--             duration = -1,
--             onComplete = function(entityData) 
--                   Bridge.ClientEntity.Set(entityData.id, "anim", {
--                       dict = "rcmnigel1c",
--                       name = "hailing_whistle_waive_a",
--                       flags = entityData.anim.flags,
--                       duration = 10000,
--                       onComplete = function(entityData) 
--                             Bridge.ClientEntity.Set(entityData.id, "anim", {
--                                 dict = "timetable@denice@ig_1",
--                                 name = "idle_b",
--                                 flags = entityData.anim.flags,
--                                 duration = 10000,
--                                 onComplete = function(entityData) 
--                                     print("hello")
--                                 end
--                             })
--                       end
--                   })
--             end
--         },
--         clothing = {
--             components = {
--                 { drawable = 0,  texture = 0, component_id = 0 },
--                 { drawable = 0,  texture = 0, component_id = 1 },
--                 { drawable = 19, texture = 0, component_id = 2 },
--                 { drawable = 6,  texture = 0, component_id = 3 },
--                 { drawable = 0,  texture = 0, component_id = 4 },
--                 { drawable = 0,  texture = 0, component_id = 5 },
--                 { drawable = 0,  texture = 0, component_id = 6 },
--                 { drawable = 0,  texture = 0, component_id = 7 },
--                 { drawable = 23, texture = 0, component_id = 8 },
--                 { drawable = 0,  texture = 0, component_id = 9 },
--                 { drawable = 0,  texture = 0, component_id = 10 },
--                 { drawable = 4,  texture = 2, component_id = 11 }
--             },
--             props = {
--                 { drawable = 27, prop_id = 0,  texture = 0 },
--                 { drawable = 0,  prop_id = 1,  texture = 0 },
--                 { drawable = 0,  prop_id = 2,  texture = 0 },
--                 { drawable = 0,  prop_id = 3,  texture = 0 },
--                 { drawable = 0,  prop_id = 4,  texture = 0 },
--                 { drawable = 0,  prop_id = 5,  texture = 0 },
--                 { drawable = 0,  prop_id = 6,  texture = 0 },
--                 { drawable = 0,  prop_id = 7,  texture = 0 },
--                 { drawable = 0,  prop_id = 8,  texture = 0 },
--                 { drawable = 0,  prop_id = 9,  texture = 0 },
--                 { drawable = 0,  prop_id = 10, texture = 0 },
--                 { drawable = 0,  prop_id = 11, texture = 0 },
--                 { drawable = 0,  prop_id = 12, texture = 0 },
--                 { drawable = 0,  prop_id = 13, texture = 0 }
--             }
--         },
--         particles = {
--             {
--                 dict = "core",
--                 ptfx = "ent_dst_electrical",
--                 offset = vector3(0.0, 1.0, 0.0),
--                 looped = true
--             },
--             {
--                 dict = "core",
--                 ptfx = "ent_dst_electrical",
--                 offset = vector3(0.0, -1.0, 0.0),
--                 rotation = vector3(0.0, 0.0, 180.0),
--                 looped = true,
--                 loopLength = 1000
--             }
--         },
--         targets = {
--             {
--                 label = "Follow Test",
--                 distance = 2,
--                 description = "A test particle for demonstration purposes.",
--                 onSelect = function (entityData, entity)
--                     FreezeEntityPosition(entity, false)
--                     Bridge.ClientEntity.Set(entityData.id, "follow", {
--                         target = PlayerPedId()
--                     })
--                 end
--             }
--         },
--         -- OnUpdate = function(entityData)
            
--         -- end,
--     })
--     -- Wait(5000)
--     Bridge.ClientEntity.Set(data.id, "targets", {
--         label = "This should be the new label",
--         distance = 2,
--         description = "Herpa derpa gihad",
--         onSelect = function (entityData, entity)
--             print("round 2 baby", entityData.id)
--         end
--     })
-- end, false)


-- Bridge.ClientEntity.Behaviors.Create("plate", {
--     tag = "something",
--     OnCreate = function(entityData)
        
--     end,
--     OnSpawn = function(entityData)
        
--     end,
--     OnUpdate = function(entityData)
--         -- Update logic here
--     end,
--     OnRemove = function(entityData)

--     end,
--     OnDestroy = function(entityData)

--     end
-- })

RegisterCommand("ClientEntityFreeze", function()
    local position = GetEntityCoords(PlayerPedId())
    local data = Bridge.ClientEntity.Create({
        model = "mp_m_freemode_01",
        coords = position,
        entityType = "ped",
        freeze = true
    })
    Wait(10000)
    Bridge.ClientEntity.Set(data.id, "freeze", false)
end, false)

RegisterCommand("ClientEntityFollow", function()
    local position = GetEntityCoords(PlayerPedId())
    local serverId = GetPlayerServerId(PlayerId())
    local data = Bridge.ClientEntity.Create({
        model = "mp_m_freemode_01",
        coords = position,
        entityType = "ped",
        freeze = false,
        follow = {
            speed = 3.0,
            target = serverId,
            distance = 5.0
        }
    })
    print(data.id)
end, false)

RegisterCommand("ClientEntityWeapon", function()
    local position = GetEntityCoords(PlayerPedId())
    local data = Bridge.ClientEntity.Create({
        model = "mp_m_freemode_01",
        coords = position,
        entityType = "ped",
        weapon = {
            name = "WEAPON_PISTOL",
            ammo = 100
        }
    })
end, false)


RegisterCommand("ClientEntityAttach", function()
    local position = GetEntityCoords(PlayerPedId())
    local serverId = GetPlayerServerId(PlayerId())
    Bridge.ClientEntity.Create({
        id = "attach_" .. math.random(1, 10000),
        model = "mp_m_freemode_01",
        coords = position,
        entityType = "ped",
        attach = {
            target = serverId,
            bone = 57005
        }
    })
end, false)

RegisterCommand("ClientEntityScenarios", function()
    local position = GetEntityCoords(PlayerPedId())
    Bridge.ClientEntity.Create({
        id = "scenarios_" .. math.random(1, 10000),
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

RegisterCommand("ClientEntityAnim", function()
    local position = GetEntityCoords(PlayerPedId())
    Bridge.ClientEntity.Create({
        id = "anim_" .. math.random(1, 10000),
        model = "mp_m_freemode_01",
        coords = position,
        entityType = "ped",
        anim = {
            dict = "anim@mp_player_intcelebrationmale@wave",
            name = "wave",
            flags = 49,
            duration = -1,
            onComplete = function(entityData) 
                Bridge.ClientEntity.Set(entityData.id, "anim", {
                    dict = "rcmnigel1c",
                    name = "hailing_whistle_waive_a",
                    flags = entityData.anim.flags,
                    duration = 10000,
                    onComplete = function(entityData) 
                        Bridge.ClientEntity.Set(entityData.id, "anim", {
                            dict = "timetable@denice@ig_1",
                            name = "idle_b",
                            flags = entityData.anim.flags,
                            duration = 10000,
                            onComplete = function(entityData) 
                                print("hello")
                            end
                        })
                    end
                })
            end
        }
    })
end, false)

RegisterCommand("ClientEntityClothing", function()
    local position = GetEntityCoords(PlayerPedId())
    Bridge.ClientEntity.Create({
        id = "clothing_" .. math.random(1, 10000),
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

RegisterCommand("ClientEntityParticles", function()
    local position = GetEntityCoords(PlayerPedId())
    Bridge.ClientEntity.Create({
        id = "particles_" .. math.random(1, 10000),
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

RegisterCommand("ClientEntityTargets", function()
    local position = GetEntityCoords(PlayerPedId())
    local derp = Bridge.ClientEntity.Create({
        id = "targets_" .. math.random(1, 10000),
        model = "mp_m_freemode_01",
        coords = position,
        entityType = "ped",
        targets = {
            {
                label = "Initial test",
                distance = 2,
                description = "A test particle for demonstration purposes.",
                onSelect = function (entityData, entity)
                    print("Selected entity:", entityData.id)
                end
            }
        }
    })
    Wait(10000)
    Bridge.ClientEntity.Set(derp.id, "targets", 
        {
            {
                label = "Follow Test",
                distance = 2,
                description = "A test particle for demonstration purposes.",
                onSelect = function (entityData, entity)
                    Bridge.ClientEntity.Set(entityData.id, "freeze", false)
                    Bridge.ClientEntity.Set(entityData.id, "follow", {
                        target = PlayerPedId()
                    })
                end
            }
        }
    )
end, false)

