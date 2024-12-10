RegisterKeyMapping('handsup', 'Toggle hands up', 'keyboard', 'O')

local handsUp = false

function loadAnimDict(dict)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Citizen.Wait(100)
    end
end

RegisterCommand('handsup', function()
    local playerPed = PlayerPedId()
    if not handsUp then
        loadAnimDict('random@mugging3')
        if not IsPedInAnyVehicle(playerPed, false) then
            TaskPlayAnim(playerPed, 'random@mugging3', 'handsup_standing_base', 2.0, -2.0, -1, 49, 0, 0, 0, 0)
        else
            TaskPlayAnim(playerPed, 'random@mugging3', 'handsup_standing_base', 2.0, -2.0, -1, 49, 0, 0, 0, 0)
            disableVehicleControls(true)
        end
        handsUp = true
    else
	Citizen.Wait(100)
        ClearPedTasks(playerPed)
        if IsPedInAnyVehicle(playerPed, false) then
            disableVehicleControls(false)
        end
        handsUp = false
    end
end, false)

function disableVehicleControls(state)
    Citizen.CreateThread(function()
        while handsUp and state do
            Citizen.Wait(0)
            local playerPed = PlayerPedId()
            DisableControlAction(0, 63, true)
            DisableControlAction(0, 64, true)
            DisableControlAction(0, 59, true)
        end
    end)
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerPed = PlayerPedId()

        if handsUp and (IsPedDeadOrDying(playerPed, true) or IsPedRagdoll(playerPed)) then
            ClearPedTasks(playerPed)
            if IsPedInAnyVehicle(playerPed, false) then
                disableVehicleControls(false)
            end
            handsUp = false
        end
    end
end)