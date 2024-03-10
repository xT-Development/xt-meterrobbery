if GetResourceState('ox_core') ~= 'started' then return end

local file = ('imports/%s.lua'):format(IsDuplicityVersion() and 'server' or 'client')
local import = LoadResourceFile('ox_core', file)
local chunk = assert(load(import, ('@@ox_core/%s'):format(file)))
chunk()

function getPlayer(id)
    return Ox.GetPlayer(id)
end

function getPlayerJob(src)
    local player = getPlayer(src)
    return player.getGroup()
end

function addMoney(src, amount, mType, reason)
    if mType == 'cash' then
        return exports.ox_inventory:AddItem(src, 'money', amount)
    else
        return
    end
end