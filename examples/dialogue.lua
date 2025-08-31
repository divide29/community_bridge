Bridge = Bridge or exports['community_bridge']:Bridge()
RegisterCommand("dialogue", function()
    local pos = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0, 2.0, 0)
    local timeout = 500
    local model = `a_f_y_hipster_01`
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(0)
        timeout = timeout - 1
        if timeout == 0 then
            print("Failed to load model")
            return
        end
    end
    local ped = CreatePed(0, model, pos.x, pos.y, pos.z, 0.0, false, false)
    SetEntityHeading(ped, 50.0)
    local characterData = {
        entity = ped,
        offset = vector3(0, 0, 0),
        rotationOffset = vector3(0, 0, 0)
    }
    Bridge.Dialogue.Open("Akmed", "Hello how are you doing my friend?", ped, {
        {
            label = "Trade with me",
            id = 'something',
        },
        {
            label = "Goodbye",
            id = 'someotherthing',
        },
    },
    function(selectedId)
        if selectedId == 'something' then
            Dialogue.Open( "Akmed" , "Thank you for wanting to purchase me lucky charms", characterData, {
                {
                    label = "Fuck off",
                    id = 'something',
                },
                {
                    label = "Goodbye",
                    id = 'someotherthing',
                },
            },
            function(selectedId)
                DeleteEntity(ped)
                if selectedId == "something" then
                    print("You hate lucky charms")
                else
                    print("Thanks for keeping it civil")
                end
            end)
        else
            DeleteEntity(ped)
        end
    end)
end)




