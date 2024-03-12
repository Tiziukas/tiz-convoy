RegisterNetEvent('tizkonvojus:customdispatch')
AddEventHandler("tizkonvojus:customdispatch", function()
    local players = ESX.GetPlayers()
    for i = 1, #players do
        local player = ESX.GetPlayerFromId(players[i])
        if player.job.name == Config.PoliceJob then
            TriggerClientEvent('konvojus:policealertas', players[i])
        end
    end
end)