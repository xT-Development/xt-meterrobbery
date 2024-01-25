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
                robParkingMeter(data)
            end,
        }
    })
end

function xTc.RemoveMeters()
    exports.ox_target:removeModel(Config.Models, 'robMeters')
end

function xTc.PTFX(ENT)
    local entCoords = GetEntityCoords(ENT)
    local offset, rotation = vec3(entCoords.x, entCoords.y, entCoords.z), GetEntityRotation(ENT)
    local dict, ptfx = 'core', 'ent_brk_coins'

    lib.requestNamedPtfxAsset(dict, 1000)

    UseParticleFxAsset(dict)

    local startPTFX = StartParticleFxLoopedAtCoord(ptfx, offset.x, offset.y, (offset.z + 1), rotation.x, rotation.y, rotation.z, 1.0, false, false, false)

    RemoveNamedPtfxAsset(dict)
    StopParticleFxLooped(startPTFX, false)
end

return xTc