--[[
██████   █████  ██████  ██  █████  ███    ██ ████████
██   ██ ██   ██ ██   ██ ██ ██   ██ ████   ██    ██   
██████  ███████ ██   ██ ██ ███████ ██ ██  ██    ██   
██   ██ ██   ██ ██   ██ ██ ██   ██ ██  ██ ██    ██   
██   ██ ██   ██ ██████  ██ ██   ██ ██   ████    ██    

             R A D I A N T   D E V E L O P M E N T
]]

local oxmysql = exports.oxmysql

-- Load all hydrants on startup
CreateThread(function()
    oxmysql:execute("SELECT * FROM radiant_hydrants", {}, function(result)
        for _, hydrant in ipairs(result) do
            TriggerClientEvent("radiant_hydrants:spawnHydrant", -1, hydrant)
        end
        print("^5[RADIANT DEV] ^7Loaded ^2" .. #result .. "^7 persistent hydrants.")
    end)
end)

-- Command: place hydrant
RegisterCommand("hydrant", function(source, args)
    local src = source

    if args[1] == "place" then
        TriggerClientEvent("radiant_hydrants:placeHydrant", src)
    elseif args[1] == "delete" then
        TriggerClientEvent("radiant_hydrants:deleteNearest", src)
    else
        TriggerClientEvent("chat:addMessage", src, {
            color = {255, 0, 0},
            multiline = true,
            args = {"Hydrants", "/hydrant place | /hydrant delete"}
        })
    end
end)

-- Save hydrant to DB
RegisterNetEvent("radiant_hydrants:saveHydrant")
AddEventHandler("radiant_hydrants:saveHydrant", function(coords, heading)
    oxmysql:insert(
        "INSERT INTO radiant_hydrants (x, y, z, heading) VALUES (?, ?, ?, ?)",
        {coords.x, coords.y, coords.z, heading},
        function(id)
            coords.id = id
            TriggerClientEvent("radiant_hydrants:spawnHydrant", -1, coords)
            print("^5[RADIANT DEV] ^7Hydrant placed & saved with ID: ^2" .. id)
        end
    )
end)

-- Remove hydrant from DB
RegisterNetEvent("radiant_hydrants:deleteHydrant")
AddEventHandler("radiant_hydrants:deleteHydrant", function(id)
    oxmysql:execute("DELETE FROM radiant_hydrants WHERE id = ?", {id})
    TriggerClientEvent("radiant_hydrants:removeHydrant", -1, id)
    print("^1[RADIANT DEV] Hydrant deleted ID: " .. id)
end)
