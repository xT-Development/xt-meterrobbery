local svConfig = require 'configs.server'
local activeCooldowns = {}
local meterTimers = {}

local function setMeterCooldown(state, entity)
    if activeCooldowns[entity] or activeCooldowns[entity] == state then return end

    activeCooldowns[entity] = state

    if state and not meterTimers[entity] then
        meterTimers[entity] = lib.timer((svConfig.MeterCooldowns * 1000), function()
            activeCooldowns[entity] = nil
            meterTimers[entity] = nil
        end, true)
    end

    return (activeCooldowns[entity] == state)
end

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
    local setCoodlown = setMeterCooldown(true, meterInfo.entity)
    if setCoodlown then
        if addMoney(src, payOut, 'cash') then
            callback = true
        end
    end

    return callback
end)