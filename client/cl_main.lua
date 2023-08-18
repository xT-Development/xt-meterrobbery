local xTc = require('modules.client')
local CurrentCops = 0

-- Police Alert --
RegisterNetEvent('xt-meterrobbery:client:AlertPolice', function()
    local pCoords = GetEntityCoords(cache.ped, true)
    local chance = math.random(1, 100)
    if chance <= Config.PoliceChance then
        Config.DispatchFunction(pCoords)
    end
end)

-- Rob Meter --
RegisterNetEvent('xt-meterrobbery:client:RobMeter', function(DATA)
    local playerPed = cache.ped
    local playerPedPos = GetEntityCoords(playerPed, true)

    if not DATA.entity then return end
    if CurrentCops >= Config.MinimumPolice then

        local Cooldown = lib.callback.await('xt-meterrobbery:server:GetMeterCooldown', false, DATA.entity)
        if Cooldown then QBCore.Functions.Notify('This meter is broken!', 'error') return end

        TriggerEvent('xt-meterrobbery:client:AlertPolice')

        lib.requestAnimDict('anim@gangops@facility@servers@')
        TaskPlayAnim(cache.ped, 'anim@gangops@facility@servers@', 'hotwire', 3.0, 3.0, -1, 1, 0, false, false, false)

        local difficulty = Config.Minigame.difficulty[math.random(1, #Config.Minigame.difficulty)]
        local success = lib.skillCheck(difficulty, Config.Minigame.keys)

        if success then
            QBCore.Functions.Progressbar('open_meter', 'Opening Parking Meter...', (Config.OpenMeterLength * 1000), false, true, {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            }, {}, {}, {}, function()
                QBCore.Functions.Progressbar('rob_meter', 'Robbing Parking Meter...', (Config.RobbingLength * 1000), false, true, {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true,
                }, {
                    animDict = 'oddjobs@shop_robbery@rob_till',
                    anim = 'loop',
                    flags = 17,
                }, {}, {}, function()
                    ClearPedTasks(cache.ped)
                    local getMoney = lib.callback.await('xt-meterrobbery:server:RobMeter', false, DATA.coords, DATA.entity)
                    if getMoney then return end
                end, function()
                    ClearPedTasks(cache.ped)
                    QBCore.Functions.Notify('Canceled...', 'error')
                end)
            end, function()
                ClearPedTasks(cache.ped)
                QBCore.Functions.Notify('Canceled...', 'error')
            end)
        else
            ClearPedTasks(cache.ped)
        end
    else
        QBCore.Functions.Notify('Not enough Police!', 'error')
    end
end)

AddEventHandler('onResourceStart', function(resource) if resource == GetCurrentResourceName() then xTc.CreateMeters() end end)
AddEventHandler('onResourceStop', function(resource) if resource == GetCurrentResourceName() then xTc.RemoveMeters() end end)
RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function() xTc.CreateMeters() end)
RegisterNetEvent('QBCore:Client:OnPlayerUnload', function() xTc.RemoveMeters() end)
RegisterNetEvent('police:SetCopCount', function(amount) CurrentCops = amount end)