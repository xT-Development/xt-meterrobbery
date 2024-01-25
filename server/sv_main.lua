local Utils = require('modules.shared')
local Cooldowns = {}

-- Distance Between Player & Meter --
local function distanceCheck(src, meterCoords)
    local callback = false
    local pCoords = GetEntityCoords(GetPlayerPed(src))
    local dist = #(meterCoords - pCoords)

    if dist <= 5 then
        callback = true
    end

    return callback
end

-- Get Meter Cooldown --
lib.callback.register('xt-meterrobbery:server:getMeterCooldown', function(source, entityID) return Cooldowns[entityID] end)

-- Rob Meters --
lib.callback.register('xt-meterrobbery:server:robParkingMeter', function(source, meterInfo)
    local src = source
    local dist = distanceCheck(src, meterInfo.coords)
    local callback = false
    if not dist then return callback end

    local payOut = math.random(Config.Payout.min, Config.Payout.max)
    if Bridge.addMoney(src, payOut, 'cash') then
        TriggerEvent('xt-parkingmeter:server:setMeterCooldown', source, meterInfo, true)
        callback = true
    end

    return callback
end)

-- Parking Meter Cooldown --
RegisterNetEvent('xt-parkingmeter:server:setMeterCooldown', function(src, meterInfo, bool)
    local dist = distanceCheck(src, meterInfo.coords)
    if not dist then return end

    if Cooldowns[meterInfo.entity] == bool then return end
    Cooldowns[meterInfo.entity] = bool

    if bool then
        SetTimeout((Config.MeterCooldowns * 1000), function()
            Cooldowns[meterInfo.entity] = nil
        end)
    end
end)