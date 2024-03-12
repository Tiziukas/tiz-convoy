RegisterNetEvent('konvojus:policealertas')
AddEventHandler('konvojus:policealertas', function()
    lib.notify({
        title = Config.Language.notifytitle,
        description = 'Pradetas Konvojus',
        icon = Config.Language.notifyicon,
        type = 'success',
        position = 'top'
    })
    local alpha = 250
    local blipiukas = AddBlipForRadius(Config.KonvojusLocationXYZ.x, Config.KonvojusLocationXYZ.y, Config.KonvojusLocationXYZ.z, 50.0)

    SetBlipHighDetail(blipiukas, true)
    SetBlipColour(blipiukas, 1)
    SetBlipAlpha(blipiukas, alpha)
    SetBlipAsShortRange(blipiukas, true)

    while alpha ~= 0 do
        Citizen.Wait(500)
        alpha = alpha - 1
        SetBlipAlpha(blipiukas, alpha)

        if alpha == 0 then
            RemoveBlip(blipiukas)
            return
        end
    end
end)