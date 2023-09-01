Config = {}

-- Debug Configs --
Config.Debug = true

-- Police Configs --
Config.MinimumPolice = 0
Config.PoliceChance = 100
Config.PoliceJobs = { 'police' }

-- Dispatch Function --
function Config.DispatchFunction(COORDS)
    exports["ps-dispatch"]:CustomAlert({
        coords = COORDS,
        job = Config.PoliceJobs,
        message = 'Parking Meter Robbery',
        dispatchCode = '10-??',
        firstStreet = COORDS,
        description = 'Parking Meter Robbery',
        radius = 0,
        sprite = 58,
        color = 1,
        scale = 1.0,
        length = 3,
    })
end

-- Minigame to Rob Meter --
Config.Minigame = {
    keys = {'1', '2', '3', '4'},
    difficulty = {
        {'easy', 'easy'},
        {'easy', 'easy', 'easy'},
        {'easy', 'easy', 'easy', 'easy'},
    }
}

-- Meter Payouts --
Config.Payout = {
    min = 100,
    max = 200
}

-- Time Configs --
Config.OpenMeterLength = 2
Config.RobbingLength = 2
Config.MeterCooldowns = 20

-- Accepted Items --
-- Table of items that can be used to rob the meters
-- Player only needs 1 of any of these items
Config.AcceptedItems = {
    'WEAPON_CROWBAR',
    'screwdriverset'
}

-- Parking Meter Models --
Config.Models = {
    "prop_parknmeter_01",
    "prop_parknmeter_02"
}

-------------------------------------------------

QBCore = exports['qb-core']:GetCoreObject()