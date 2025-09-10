Bridge = Bridge or exports['community_bridge']:Bridge()

RegisterCommand('testboxzone', function(source, args, rawCommand)
    local playerPos = GetEntityCoords(PlayerPedId())
    Bridge.Zones.Create("box", {
        coords = vector3(playerPos.x, playerPos.y, playerPos.z),
        size = vector3(2, 2, 6),
        heading = 90,
        debug = true,
        onEnter = function(data)
            print("Entered Zone: " .. data.id)
        end,
        onExit = function(data)
            print("Exited Zone:")
        end
    })
end, false)

RegisterCommand('testpolyzone', function(source, args, rawCommand)
    local playerPos = GetEntityCoords(PlayerPedId())
    Bridge.Zones.Create("poly", {
        points = {
            vector3(playerPos.x - 1, playerPos.y - 1, playerPos.z),
            vector3(playerPos.x + 1, playerPos.y - 1, playerPos.z),
            vector3(playerPos.x + 1, playerPos.y + 1, playerPos.z),
            vector3(playerPos.x - 1, playerPos.y + 1, playerPos.z)
        },
        size = vector3(1, 1, 1),
        heading = 90,
        debug = true,
        onEnter = function(data)
            print("Entered Zone: " .. data.id)
        end,
        onExit = function(data)
            print("Exited Zone:")
        end
    })
end, false)

RegisterCommand('testspherezone', function(source, args, rawCommand)
    local playerPos = GetEntityCoords(PlayerPedId())
    Bridge.Zones.Create("sphere", {
        coords = vector3(playerPos.x, playerPos.y, playerPos.z),
        radius = 2.0,
        debug = true,
        onEnter = function(data)
            print("Entered Zone: " .. data.id)
        end,
        onExit = function(data)
            print("Exited Zone:")
        end
    })
end, false)
