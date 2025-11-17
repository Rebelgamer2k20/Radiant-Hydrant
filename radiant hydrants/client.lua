local hydrants = {}
local placing = false

RegisterNetEvent("radiant_hydrants:spawnHydrant")
AddEventHandler("radiant_hydrants:spawnHydrant", function(data)
    local model = Config.HydrantModel
    RequestModel(model)
    while not HasModelLoaded(model) do Wait(10) end

    local obj = CreateObject(model, data.x, data.y, data.z - 1.0, false, false, false)
    SetEntityHeading(obj, data.heading)
    FreezeEntityPosition(obj, true)

    hydrants[data.id] = obj

    -- z_fires integration
    if Config.zFiresCompatibility then
        TriggerEvent("zfires:addWaterSource", data.x, data.y, data.z, 6.0)
    end

    -- SmartFires integration
    if Config.SmartFiresCompatibility then
        TriggerEvent("SmartFires:AddHydrant", vector3(data.x, data.y, data.z))
    end
end)

RegisterNetEvent("radiant_hydrants:removeHydrant")
AddEventHandler("radiant_hydrants:removeHydrant", function(id)
    if hydrants[id] then
        DeleteObject(hydrants[id])
        hydrants[id] = nil
    end
end)

-- Begin placement mode
RegisterNetEvent("radiant_hydrants:placeHydrant")
AddEventHandler("radiant_hydrants:placeHydrant", function()
    placing = true

    CreateThread(function()
        while placing do
            Wait(0)

            local ped = PlayerPedId()
            local coords = GetEntityCoords(ped)
            local heading = GetEntityHeading(ped)

            DrawMarker(28, coords.x, coords.y, coords.z - 1.0, 0, 0, 0, 0, 0, 0, 0.4, 0.4, 0.4, 0, 150, 255, 180)

            if IsControlJustPressed(0, 38) then -- E
                placing = false
                TriggerServerEvent("radiant_hydrants:saveHydrant", coords, heading)
                TriggerEvent('chat:addMessage', {
                    color = {0, 255, 0},
                    args = {"Hydrants", "Hydrant placed successfully!"}
                })
            end
        end
    end)
end)

-- Delete nearest hydrant
RegisterNetEvent("radiant_hydrants:deleteNearest")
AddEventHandler("radiant_hydrants:deleteNearest", function()
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)

    local nearest
    local nearestDist = 3.0

    for id, obj in pairs(hydrants) do
        local dist = #(pos - GetEntityCoords(obj))
        if dist < nearestDist then
            nearest = id
            nearestDist = dist
        end
    end

    if nearest then
        TriggerServerEvent("radiant_hydrants:deleteHydrant", nearest)
    else
        TriggerEvent("chat:addMessage", {color={255,0,0}, args={"Hydrants","No hydrant nearby."}})
    end
end)
