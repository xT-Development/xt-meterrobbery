if not lib.checkDependency('ND_Core', '2.0.0') then return end

NDCore = {}

lib.load('@ND_Core.init')

function getPlayer(src)
    return NDCore.getPlayer(src)
end

function getPlayerJob(src)
    local Player = getPlayer(src)
    return Player.getJob()
end

function addMoney(src, amount, mType, reason)
    local player = getPlayer(src)
    if not player then return end

    return player.addMoney(mType, amount, reason or "unknown")
end