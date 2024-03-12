local qtarget = exports.qtarget
local JobStartLocation = lib.points.new(Config.StartJobLocation, Config.StartJobRadius)
local EndLocation = lib.points.new(Config.EndJobLocation, Config.StartJobRadius)

function Scaleformas(textas)
    local scaleform = lib.requestScaleformMovie("MP_BIG_MESSAGE_FREEMODE")
    local draw = true
    CreateThread(
        function()
            Wait(4100)
            draw = false
        end
    )

    BeginScaleformMovieMethod(scaleform, "SHOW_SHARD_WASTED_MP_MESSAGE")
    BeginTextCommandScaleformString("STRING")
    AddTextComponentSubstringPlayerName("~y~"..textas)
    EndTextCommandScaleformString()
    EndScaleformMovieMethod()
    PlaySoundFrontend(-1, 'Mission_Pass_Notify', 'DLC_HEISTS_GENERAL_FRONTEND_SOUNDS')

    while draw do
        DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255, 0)
        Wait(0)
    end
end

function spawnKonvojus()
    local nearbyVehicles = lib.getClosestVehicle(Config.KonvojusLocation, 3, false)
    if nearbyVehicles == nil then
        lib.requestModel(Config.Car)
        vehicle = CreateVehicle(Config.Car, Config.KonvojusLocation, Config.KonvojusHeading, true, true)
        Entity(vehicle).state.fuel = 100.0
        Masina = lib.getClosestVehicle(Config.KonvojusLocation, 3, false)
        spawnedVehicle = vehicle
    else
        lib.notify({
            title = Config.Language.notifytitle,
            description = Config.Language.alreadyhavecar,
            icon = Config.Language.notifyicon,
            type = 'error',
            position = 'top'
        })
    end
end
function setWaypoint()
    SetNewWaypoint(Config.EndLocation.x, Config.EndLocation.y)
    jobAssigned = true
end
lib.registerContext({
    id = 'KonvojusMenu',
    title = Config.Language.menutitle,
    options = {
      {
        title = Config.Language.menustarttitle,
        description = Config.Language.menustartdesc,
        icon = 'circle',
        onSelect = function()
            local player = PlayerPedId()
            if Config.CDDispatch == true then
                local data = exports['cd_dispatch']:GetPlayerInfo()
                TriggerServerEvent('cd_dispatch:AddNotification', {
                    job_table = {Config.PoliceJob}, 
                    coords = data.coords,
                    title = Config.Language.cddispatchtitle,
                    message = Config.Language.cdstartmission, 
                    flash = 0,
                    unique_id = data.unique_id,
                    sound = 1,
                    blip = {
                        sprite = 67, 
                        scale = 1.2, 
                        colour = 3,
                        flashes = false, 
                        text = Config.Language.cdtext,
                        time = 5,
                        radius = 0,
                    }
                })
            else
                TriggerServerEvent('tizkonvojus:customdispatch')
            end
            lib.showTextUI(Config.Language.waittalking)
            FreezeEntityPosition(player, true)
            lib.progressCircle({
                duration = 60000,
                position = 'bottom',
                useWhileDead = false,
                canCancel = false,
                disable = {
                    car = true,
                },
                anim = {
                    dict = 'missheistdockssetup1ig_5@base',
                    clip = 'workers_talking_base_dockworker1'
                },
            })
            lib.hideTextUI()
            FreezeEntityPosition(player, false)
            PlaySoundFrontend(-1, 'Mission_Pass_Notify', 'DLC_HEISTS_GENERAL_FRONTEND_SOUNDS')
            spawnKonvojus()
            setWaypoint()
            TaskWarpPedIntoVehicle(player, Masina, -1)
            lib.notify({
                title = Config.Language.notifytitle,
                description = Config.Language.gowaypoint,
                icon = Config.Language.notifyicon,
                type = 'success',
                position = 'top'
            })
        end,
      }
    }
})
function JobStartLocation:onEnter()
    spawnJobNPC()
    qtarget:AddTargetEntity(createTowJobNPC, {
        options = {
            {
                name = 'talkToStart',
                icon = 'fas fa-car',
                label = Config.Language.targetnpc,
                action = function()
                    local jobCheck = lib.callback.await('tizkonvojus:checkJob', false)
                    local policerequired = lib.callback.await('tizkonvojus:checkpolice', false)
                    if jobCheck then
                        if policerequired then
                            lib.showContext('KonvojusMenu')
                        else
                            lib.notify({
                                title = Config.Language.notifytitle,
                                description = Config.Language.nopolicejob,
                                icon = Config.Language.notifyicon,
                                type = 'error',
                                position = 'top'
                            })
                        end
                    else
                        lib.notify({
                            title = Config.Language.notifytitle,
                            description = Config.Language.nogangjob,
                            icon = Config.Language.notifyicon,
                            type = 'error',
                            position = 'top'
                        })
                    end
                end,
                distance = 10
            }
        }
    })
end
function EndLocation:onEnter()
    spawnEndNPC()
    qtarget:AddTargetEntity(createEndNPC, {
        options = {
            {
                name = 'talkToEnd',
                icon = 'fas fa-car',
                label = Config.Language.targetnpc,
                action = function()
                    if jobAssigned == true then
                        local nearbyVehicles = lib.getClosestVehicle(Config.EndJobLocation, 10, false)
                        if nearbyVehicles == Masina then
                            PlayMissionCompleteAudio("FRANKLIN_BIG_01")
                            endJob()
                            TriggerServerEvent('tizkonvojus:final')
                            Scaleformas("Convoy Delivered")
                            PlaySoundFrontend(-1, 'LOCAL_PLYR_CASH_COUNTER_COMPLETE', 'DLC_HEISTS_GENERAL_FRONTEND_SOUNDS')
                            jobAssigned = false
                            lib.notify({
                                title = Config.Language.notifytitle,
                                description = Config.Language.jobdone,
                                icon = Config.Language.notifyicon,
                                type = 'success',
                                position = 'top'
                            })
                            if Config.CDDispatch == true then
                                local data = exports['cd_dispatch']:GetPlayerInfo()
                                TriggerServerEvent('cd_dispatch:AddNotification', {
                                    job_table = {Config.PoliceJob}, 
                                    coords = data.coords,
                                    title = Config.Language.cddispatchtitle,
                                    message = Config.Language.cdsomeonefinishedmission, 
                                    flash = 0,
                                    unique_id = data.unique_id,
                                    sound = 1,
                                    blip = {
                                        sprite = 67, 
                                        scale = 1.2, 
                                        colour = 3,
                                        flashes = false, 
                                        text = Config.Language.cdtext,
                                        time = 5,
                                        radius = 0,
                                    }
                                })
                            else
                                TriggerServerEvent('tizkonvojus:customdispatch')
                            end
                        else 
                            lib.notify({
                                title = Config.Language.notifytitle,
                                description = Config.Language.wrongcarinproximity,
                                icon = Config.Language.notifyicon,
                                type = 'error',
                                position = 'top'
                            })
                        end
                    else
                        lib.notify({
                            title = Config.Language.notifytitle,
                            description = Config.Language.notstartedjob,
                            icon = Config.Language.notifyicon,
                            type = 'error',
                            position = 'top'
                        })
                    end
                end,
                distance = 10
            }
        }
    })
end

function spawnJobNPC()
    lib.RequestModel(Config.StartJobPedModel)
    createTowJobNPC = CreatePed(0, Config.StartJobPedModel, Config.StartJobLocation, Config.StartJobPedHeading, false, true)
    FreezeEntityPosition(createTowJobNPC, true)
    SetBlockingOfNonTemporaryEvents(createTowJobNPC, true)
    SetEntityInvincible(createTowJobNPC, true)
end
function spawnEndNPC()
    lib.RequestModel(Config.StartJobPedModel)
    createEndNPC = CreatePed(0, Config.StartJobPedModel, Config.EndJobLocation, Config.EndJobPedHeading, false, true)
    FreezeEntityPosition(createEndNPC, true)
    SetBlockingOfNonTemporaryEvents(createEndNPC, true)
    SetEntityInvincible(createEndNPC, true)
end
function JobStartLocation:onExit()
    DeleteEntity(createTowJobNPC)
    qtarget:RemoveTargetEntity(createTowJobNPC, nil)
end
function EndLocation:onExit()
    DeleteEntity(createEndNPC)
    qtarget:RemoveTargetEntity(createEndNPC, nil)
end
function endJob()
    DeleteEntity(spawnedVehicle)
end