if GetResourceState('es_extended') ~= 'started' then return end

AddEventHandler('esx:playerLoaded', function()
    TriggerEvent('xt-meterrobbery:client:onLoad')
end)

AddEventHandler('esx:onPlayerLogout', function()
    TriggerEvent('xt-meterrobbery:client:onUnload')
end)