function table_contains(tbl, x)
    found = false
    for _, v in pairs(tbl) do
        if v == x then 
            found = true 
        end
    end
    return found
end
lib.callback.register('tizkonvojus:checkJob', function(source)
    local source = source
    local player = nil
    player = ESX.GetPlayerFromId(source)
    local playerJob = player.job.name
    local jobai = table_contains(Config.JobNames,playerJob)
    if jobai == true then
        return true
    else
        return false
    end
end)
lib.callback.register('tizkonvojus:checkpolice', function(source)
	local xPlayers = ESX.GetExtendedPlayers('job', Config.PoliceJob)
	if #xPlayers >= Config.PoliceRequired then
        return true
    else
        return false
    end
end)
RegisterNetEvent('tizkonvojus:final')
AddEventHandler("tizkonvojus:final", function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local playerCoords = xPlayer.getCoords(true)
    local distance = #(playerCoords - vector3(Config.EndLocation.x, Config.EndLocation.y, Config.EndLocation.z))
    local _source = source
    if distance <= 15 then
        exports.ox_inventory:AddItem(_source, Config.RewardItem, Config.RewardAmount)
    else
        print("Player attempted to trigger the event outside of the allowed area. ID - "..source)
    end
end)



