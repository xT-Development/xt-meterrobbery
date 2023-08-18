local Utils = require('modules.shared')
local Cooldowns = {}

-- Get Meter Cooldown --
lib.callback.register('xt-meterrobbery:server:GetMeterCooldown', function(source, ID) return Cooldowns[ID] end)

-- Rob Meters --
lib.callback.register('xt-meterrobbery:server:RobMeter', function(source, COORDS, METERID)
    local Player = QBCore.Functions.GetPlayer(source)
    local pCoords = GetEntityCoords(GetPlayerPed(source))
    local dist = #(COORDS - pCoords)
    local callback = false

    if not Player then return callback end
    if dist >= 5 then return callback end

    local payOut = math.random(Config.Payout.min, Config.Payout.max)
    if Player.Functions.AddMoney('cash', payOut) then
        TriggerEvent('xt-parkingmeter:server:MeterCooldown', source, COORDS, METERID, true)
        callback = true
    end
    return callback
end)

-- Parking Meter Cooldown --
RegisterNetEvent('xt-parkingmeter:server:MeterCooldown', function(SRC, COORDS, METERID, BOOL)
    local pCoords = GetEntityCoords(GetPlayerPed(SRC))
    local dist = #(COORDS - pCoords)
    if dist >= 5 then return end
    
    if Cooldowns[METERID] == BOOL then return end
    Cooldowns[METERID] = BOOL
    if BOOL then
        SetTimeout((Config.MeterCooldowns * 1000), function()
            Cooldowns[METERID] = nil
        end)
    end
end)