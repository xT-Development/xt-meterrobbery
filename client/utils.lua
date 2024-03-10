local clConfig = require 'configs.client'

function createMeterTargets()
    exports.ox_target:addModel(clConfig.Models, {
        {
            name = 'robMeters',
            label = 'Rob Parking Meter',
            icon = 'fas fa-coins',
            distance = 2.0,
            items = clConfig.AcceptedItems,
            anyItem = true,
            onSelect = function(data)
                robParkingMeter(data)
            end,
        }
    })
end

function removeMeterTargets()
    exports.ox_target:removeModel(clConfig.Models, 'robMeters')
end

function playPTFX(ENT)
    local entCoords = GetEntityCoords(ENT)
    local offset, rotation = vec3(entCoords.x, entCoords.y, entCoords.z), GetEntityRotation(ENT)
    local dict, ptfx = 'core', 'ent_brk_coins'

    lib.requestNamedPtfxAsset(dict, 1000)

    UseParticleFxAsset(dict)

    local startPTFX = StartParticleFxLoopedAtCoord(ptfx, offset.x, offset.y, (offset.z + 1), rotation.x, rotation.y, rotation.z, 1.0, false, false, false)

    RemoveNamedPtfxAsset(dict)
    StopParticleFxLooped(startPTFX, false)
end