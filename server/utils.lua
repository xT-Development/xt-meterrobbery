local svConfig = require 'configs.server'

-- Distance Between Player & Meter --
function distanceCheck(src, meterCoords)
    local callback = false
    local pCoords = GetEntityCoords(GetPlayerPed(src))
    local dist = #(meterCoords - pCoords)

    if dist <= 5 then
        callback = true
    end

    return callback
end

-- Check if Player has Police Job --
function hasPoliceJob(source, jobs)
    local callback = false
    local jobType = type(jobs)
    local playerJob = getPlayerJob(source)
    if jobType == 'table' then
        for x = 1, #jobs do
            print(x, jobs[x], playerJob)
            if playerJob == jobs[x] then
                callback = true
                break
            end
        end
    else
        callback = (playerJob == jobs)
    end
    return callback
end

-- Gets Total Police --
function getPoliceCount()
    local allPlayers = GetPlayers()
    local copCount = 0

    for _, src in pairs(allPlayers) do
        if hasPoliceJob(tonumber(src), svConfig.PoliceJobs) then
            copCount += 1
        end
    end

    return copCount
end