-- PRESISTENT FLASHLIGHT
SetFlashLightKeepOnWhileMoving(true)

-- DISABLE AUTO RELOAD
SetWeaponsNoAutoreload(true)

-- DISABLE FLIGHT MUSIC
Citizen.CreateThread(function()
	while true do
	SetAudioFlag('DisableFlightMusic', true)
	Citizen.Wait(0)
	end
end)

-- INFINITE FIRE EXTINGUISHER
local playerPed = PlayerPedId()
local weapHash = GetHashKey('WEAPON_FIREEXTINGUISHER')

Citizen.CreateThread(function()
      while true do
            Citizen.Wait(0)
            
            if HasPedGotWeapon(playerPed, weapHash, false) then
                  SetPedInfiniteAmmoClip(playerPed, true)
            end
            
      end

end)

-- DISABLE VEHICLE RADIO
--[
AddEventHandler('playerEnteredVehicle', function(vehicle, seat)
    if seat == -1 then
        Citizen.Wait(100)

        SetVehRadioStation(vehicle, "OFF")
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        local playerPed = PlayerPedId()
        if IsPedInAnyVehicle(playerPed, false) then
            local vehicle = GetVehiclePedIsIn(playerPed, false)
            local seat = GetPedInVehicleSeat(vehicle, -1)

            if seat == playerPed then
                TriggerEvent('playerEnteredVehicle', vehicle, -1)
            end
        end
    end
end)
--]]

-- ENABLE BRAKE LIGHTS
local brakeLightSpeedThresh = 0.25

Citizen.CreateThread(function()
	while true do
        Citizen.Wait(0)
        
        local player = GetPlayerPed(-1)
        local vehicle = GetVehiclePedIsIn(player, false)

        if (vehicle ~= nil) and (GetEntitySpeed(vehicle) <= brakeLightSpeedThresh) then
            SetVehicleBrakeLights(vehicle, true)
        end
	end
end)

-- PRESISTENT WHEEL
Citizen.CreateThread(function()
    local angle = 0.0
    local speed = 0.0
    while true do
        Citizen.Wait(0)
        local veh = GetVehiclePedIsUsing(PlayerPedId())
        if DoesEntityExist(veh) then
            local tangle = GetVehicleSteeringAngle(veh)
            if tangle > 10.0 or tangle < -10.0 then
                angle = tangle
            end
            speed = GetEntitySpeed(veh)
            local vehicle = GetVehiclePedIsIn(PlayerPedId(), true)
            if speed < 0.1 and DoesEntityExist(vehicle) and not GetIsTaskActive(PlayerPedId(), 151) and not GetIsVehicleEngineRunning(vehicle) then
                SetVehicleSteeringAngle(GetVehiclePedIsIn(PlayerPedId(), true), angle)
            end
        end
    end
end)


