--[[
██████   █████  ██████  ██  █████  ███    ██ ████████
██   ██ ██   ██ ██   ██ ██ ██   ██ ████   ██    ██   
██████  ███████ ██   ██ ██ ███████ ██ ██  ██    ██   
██   ██ ██   ██ ██   ██ ██ ██   ██ ██  ██ ██    ██   
██   ██ ██   ██ ██████  ██ ██   ██ ██   ████    ██    

             R A D I A N T   D E V E L O P M E N T
]]

local oxmysql = exports.oxmysql

-----------------------------------------------------
--  LOAD HYDRANTS ON SERVER START
-----------------------------------------------------
CreateThread(function()
    oxmysql:execute("SELECT * FROM radiant_hydrants", {}, function(result)
        for _, hydrant in ipairs(result) do
            local data = {
                id = hydrant.id,
                x = hydrant.x,
                y = hydrant.y,
                z = hydrant.z,
                heading = hydrant.heading
            }

            TriggerClientEvent("radiant_hydrants:spawnHydrant", -1, data)
        end

        print("^5[RADIANT DEV] ^7Loaded ^2" .. #result .. "^7 persistent hydrants.")
    end)
end)

-----------------------------------------------------
--  /hydrant place  |  /hydrant delete
-----------------------------------------------------
RegisterCommand("hydrant", function(source, args)
    local src = source

    if args[1] == "place" then
        TriggerClientEvent("radiant_hydrants:placeHydrant", src)

    elseif args[1] == "delete" then
        TriggerClientEvent("radiant_hydrants:deleteNearest", src)

    else
        TriggerClientEvent("chat:addMessage", src, {
            color = {255, 100, 0},
            args = {"Hydrants", "/hydrant place | /hydrant delete"}
        })
    end
end)

-----------------------------------------------------
--  SAVE HYDRANT TO DATABASE
-----------------------------------------------------
RegisterNetEvent("radiant_hydrants:saveHydrant")
AddEventHandler("radiant_hydrants:saveHydrant", function(coords, heading)

    oxmysql:insert(
        "INSERT INTO radiant_hydrants (x, y, z, heading) VALUES (?, ?, ?, ?)",
        {coords.x, coords.y, coords.z, heading},

        function(id)
            if not id then
                print("^1[RADIANT DEV ERROR] Could not insert hydrant into DB.^7")
                return
            end

            local data = {
                id = id,
                x = coords.x,
                y = coords.y,
                z = coords.z,
                heading = heading
            }

            TriggerClientEvent("radiant_hydrants:spawnHydrant", -1, data)

            print("^5[RADIANT DEV] ^7Hydrant saved & spawned with ID: ^2" .. id)
        end
    )
end)

-----------------------------------------------------
--  DELETE HYDRANT FROM DATABASE
-----------------------------------------------------
RegisterNetEvent("radiant_hydrants:deleteHydrant")
AddEventHandler("radiant_hydrants:deleteHydrant", function(id)

    oxmysql:execute("DELETE FROM radiant_hydrants WHERE id = ?", {id}, function(affected)
        if affected and affected > 0 then
            TriggerClientEvent("radiant_hydrants:removeHydrant", -1, id)
            print("^1[RADIANT DEV] Hydrant deleted ID: " .. id)
        else
            print("^1[RADIANT DEV] ERROR: ID not found / no rows removed.^7")
        end
    end)
end)
