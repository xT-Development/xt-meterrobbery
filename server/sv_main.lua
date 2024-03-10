local svConfig = require 'configs.server'
local activeCooldowns = {}

-- Get Meter Cooldown --
lib.callback.register('xt-meterrobbery:server:getMeterCooldown', function(source, entityID)
    return activeCooldowns[entityID]
end)

-- Return Police Count --
lib.callback.register('xt-meterrobbery:server:getPoliceCount', function(source)
    return getPoliceCount()
end)

-- Rob Meters --
lib.callback.register('xt-meterrobbery:server:robParkingMeter', function(source, meterInfo)
    local src = source
    local dist = distanceCheck(src, meterInfo.coords)
    local callback = false
    if not dist then return callback end

    local payOut = math.random(svConfig.Payout.min, svConfig.Payout.max)
    if addMoney(src, payOut, 'cash') then
        TriggerEvent('xt-parkingmeter:server:setMeterCooldown', source, meterInfo, true)
        callback = true
    end

    return callback
end)

-- Parking Meter Cooldown --
RegisterNetEvent('xt-parkingmeter:server:setMeterCooldown', function(src, meterInfo, bool)
    local dist = distanceCheck(src, meterInfo.coords)
    if not dist then return end

    if activeCooldowns[meterInfo.entity] == bool then return end
    activeCooldowns[meterInfo.entity] = bool

    if bool then
        SetTimeout((svConfig.MeterCooldowns * 1000), function()
            activeCooldowns[meterInfo.entity] = nil
        end)
    end
end)