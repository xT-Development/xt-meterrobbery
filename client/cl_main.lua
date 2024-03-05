local xTc = require('modules.client')
local CurrentCops = 0

-- Rob Meter --
function robParkingMeter(data)
    local playerPed = cache.ped
    local playerPedPos = GetEntityCoords(playerPed, true)

    if not data.entity then return end
    if CurrentCops >= Config.MinimumPolice then

        local Cooldown = lib.callback.await('xt-meterrobbery:server:getMeterCooldown', false, data.entity)
        if Cooldown then lib.notify({ title = 'This meter is broken!', type = 'error' }) return end

        TriggerEvent('xt-meterrobbery:client:AlertPolice')

        lib.requestAnimDict('anim@melee@machete@streamed_core@')
        TaskPlayAnim(cache.ped, 'anim@melee@machete@streamed_core@', 'plyr_walking_attack_a', 3.0, 3.0, -1, 16, 0, false, false, false)

        local difficulty = Config.Minigame.difficulty[math.random(1, #Config.Minigame.difficulty)]
        local success = lib.skillCheck(difficulty, Config.Minigame.keys)

        if success then

            if lib.progressCircle({
                label = 'Opening Parking Meter...',
                duration = (Config.OpenMeterLength * 1000),
                position = 'bottom',
                useWhileDead = false,
                canCancel = true,
                disable = { car = true, move = true },
                anim = { dict = 'anim@melee@machete@streamed_core@', clip = 'plyr_walking_attack_a' },
            }) then

                xTc.PTFX(data.entity)

                if lib.progressCircle({
                    label = 'Robbing Parking Meter...',
                    duration = (Config.RobbingLength * 1000),
                    position = 'bottom',
                    useWhileDead = false,
                    canCancel = true,
                    disable = { car = true, move = true },
                    anim = { dict = 'anim@scripted@player@freemode@tun_prep_grab_midd_ig3@male@', clip = 'tun_prep_grab_midd_ig3' },
                }) then
                    ClearPedTasks(cache.ped)
                    local meterInfo = { coords = data.coords, entity = data.entity }
                    local getMoney = lib.callback.await('xt-meterrobbery:server:robParkingMeter', false, meterInfo)
                    if getMoney then return end
                else
                    ClearPedTasks(cache.ped)
                    lib.notify({ title = 'Canceled...', type = 'error' })
                end
            else
                ClearPedTasks(cache.ped)
                lib.notify({ title = 'Canceled...', type = 'error' })
            end
        else
            ClearPedTasks(cache.ped)
        end
    else
        lib.notify({ title = 'Not enough Police!', type = 'error' })
    end
end

-- Police Alert --
RegisterNetEvent('xt-meterrobbery:client:AlertPolice', function()
    local pCoords = GetEntityCoords(cache.ped, true)
    local chance = math.random(1, 100)
    if chance <= Config.PoliceChance then
        Config.DispatchFunction(pCoords)
    end
end)

AddEventHandler('onResourceStart', function(resource) if resource == GetCurrentResourceName() then xTc.CreateMeters() end end)
AddEventHandler('onResourceStop', function(resource) if resource == GetCurrentResourceName() then xTc.RemoveMeters() end end)
RegisterNetEvent('Renewed-Lib:client:PlayerLoaded', function() xTc.CreateMeters() end)
RegisterNetEvent('Renewed-Lib:client:PlayerUnloaded', function() xTc.RemoveMeters() end)
RegisterNetEvent('police:SetCopCount', function(amount) CurrentCops = amount end)