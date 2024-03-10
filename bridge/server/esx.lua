if GetResourceState('es_extended') ~= 'started' then return end

local ESX = exports['es_extended']:getSharedObject()

local convertMoney = {
    ["cash"] = "money",
    ["bank"] = "bank"
}

function getPlayer(src)
    return ESX.GetPlayerFromId(src)
end

function getPlayerJob(src)
    local Player = getPlayer(src)
    return Player.job.name, Player.job.grade
end

function addMoney(src, amount, mType, reason)
    local type = convertMoney[mType]
    if not type then return end

    local player = getPlayer(src)
    if not player then return end

    player.addAccountMoney(type, amount, reason)

    return true
end