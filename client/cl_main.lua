local clConfig = require 'configs.client'

-- Rob Meter --
function robParkingMeter(data)
    if not data.entity then return end

    local playerPed = cache.ped
    local playerPedPos = GetEntityCoords(playerPed, true)

    local copCount = lib.callback.await('xt-meterrobbery:server:getPoliceCount', false)
    if copCount < clConfig.MinimumPolice then
        lib.notify({ title = 'Not enough Police!', type = 'error' })
        return
    end

    local onCooldown = lib.callback.await('xt-meterrobbery:server:getMeterCooldown', false, data.entity)
    if onCooldown then
        lib.notify({ title = 'This meter is broken!', type = 'error' })
        return
    end

    TriggerEvent('xt-meterrobbery:client:AlertPolice')

    lib.requestAnimDict('anim@melee@machete@streamed_core@')
    TaskPlayAnim(cache.ped, 'anim@melee@machete@streamed_core@', 'plyr_walking_attack_a', 3.0, 3.0, -1, 16, 0, false, false, false)
    RemoveAnimDict('anim@melee@machete@streamed_core@')

    local success = clConfig.MinigameFunction()
    if not success then
        ClearPedTasks(cache.ped)
        return
    end

    if lib.progressCircle({
        label = 'Opening Parking Meter...',
        duration = (clConfig.OpenMeterLength * 1000),
        position = 'bottom',
        useWhileDead = false,
        canCancel = true,
        disable = { car = true, move = true },
        anim = { dict = 'anim@melee@machete@streamed_core@', clip = 'plyr_walking_attack_a' },
    }) then

        playPTFX(data.entity)

        if lib.progressCircle({
            label = 'Robbing Parking Meter...',
            duration = (clConfig.RobbingLength * 1000),
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
end

-- Police Alert --
RegisterNetEvent('xt-meterrobbery:client:AlertPolice', function()
    local pCoords = GetEntityCoords(cache.ped, true)
    local chance = math.random(1, 100)
    if chance <= clConfig.PoliceChance then
        clConfig.DispatchFunction(pCoords)
    end
end)

-- Handlers --
AddEventHandler('onResourceStart', function(resource)
    if resource ~= GetCurrentResourceName() then return end
    createMeterTargets()
end)

AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() then return end
    removeMeterTargets()
end)

RegisterNetEvent('xt-meterrobbery:client:onLoad', function()
    createMeterTargets()
end)

RegisterNetEvent('xt-meterrobbery:client:onUnload', function()
    removeMeterTargets()
end)