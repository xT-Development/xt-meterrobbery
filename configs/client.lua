return {
    -- Police Configs --
    MinimumPolice = 0,          -- Minimum police required to start
    PoliceChance = 50,          -- Chance police are called

    -- Progressbar Time Configs --
    OpenMeterLength = 3,
    RobbingLength = 2,

    -- Accepted Items --
    -- Table of items that can be used to rob the meters
    -- Player only needs 1 of any of these items
    AcceptedItems = {
        'WEAPON_CROWBAR',
        'screwdriverset'
    },

    -- Parking Meter Models --
    Models = {
        "prop_parknmeter_01",
        "prop_parknmeter_02"
    },

    -- Dispatch --
    DispatchFunction = function(coords)
        local policeJobs = { 'police', 'lspd' }

        -- Add your own dispatch export/events

        exports["ps-dispatch"]:CustomAlert({
            coords = coords,
            job = policeJobs,
            message = 'Parking Meter Robbery',
            dispatchCode = '10-??',
            firstStreet = coords,
            description = 'Parking Meter Robbery',
            radius = 0,
            sprite = 58,
            color = 1,
            scale = 1.0,
            length = 3,
        })
    end,

    -- Add Your Own Minigame --
    MinigameFunction = function()
        local keys = { '1', '2', '3', '4' }
        local difficulty = {
            {'easy', 'easy'},
            {'easy', 'easy', 'easy'},
            {'easy', 'easy', 'easy', 'easy'},
        }
        local setDifficulty = difficulty[math.random(1, #difficulty)]

        return lib.skillCheck(setDifficulty, keys)
    end
}