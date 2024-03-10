if GetResourceState('qb-core') ~= 'started' then return end

local QBCore = exports['qb-core']:GetCoreObject()

function getPlayer(src)
    return QBCore.Functions.GetPlayer(src)
end

function getPlayerJob(src)
    local player = getPlayer(src)
    return player.PlayerData.job.name, player.PlayerData.job.grade.level
end

function addMoney(src, amount, mType, reason)
    local player = getPlayer(src)
    if not player then return end
    return player.Functions.AddMoney(mType, amount, reason or "unknown")
end