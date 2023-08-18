local xTc = {}

function xTc.CreateMeters()
    exports.ox_target:addModel(Config.Models, {
        {
            name = 'robMeters',
            label = 'Rob Parking Meter',
            icon = 'fas fa-coins',
            distance = 2.0,
            items = Config.AcceptedItems,
            anyItem = true,
            onSelect = function(data) 
                TriggerEvent('xt-meterrobbery:client:RobMeter', data)
            end,
        }
    })
end

function xTc.RemoveMeters()
    exports.ox_target:removeModel(Config.Models, 'robMeters')
end

return xTc