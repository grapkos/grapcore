if Config.RadioOffByDefault then
    RegisterNetEvent('DisableRadio')
    AddEventHandler('DisableRadio', function()
        SetVehRadioStation(GetVehiclePedIsIn(PlayerPedId(), false), 'OFF')
    end)

    AddEventHandler('playerEnteredVehicle', function(vehicle, seat)
        SetVehRadioStation(vehicle, 'OFF')
    end)
end

if Config.InfiniteFireExtinguisher then
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
end


if Config.DisableFlightMusic then
    Citizen.CreateThread(function()
	    while true do
	    SetAudioFlag('DisableFlightMusic', true)
	    Citizen.Wait(0)
	    end
    end)
end


if Config.DisablePoliceScanner then
    Citizen.CreateThread(function()
	    while true do
        SetAudioFlag("PoliceScannerDisabled", true)
	    Citizen.Wait(0)
	    end
    end)
end


if Config.DisableIdleCam then
    DisableIdleCamera(true)
end


if Config.DisableVehicleDamage then
    Citizen.CreateThread(function()
        while true do
            SetWeaponDamageModifier(-1553120962, 0.0)
            Wait(0)
        end
    end)
end


if Config.EnablePropFixer then
	CreateThread(function()
		while true do
			local playerPed = PlayerPedId()
			if IsPedUsingActionMode(playerPed) then
				SetPedUsingActionMode(playerPed, false, -1, 0)
        	else
            Wait(500)
        	end
        	Wait(0)
		end
	end)


	Citizen.CreateThread(function()
    	while true do
        	Citizen.Wait(1000)
        	SetPedCanLosePropsOnDamage(PlayerPedId(), false, 0)
    	end
	end)

	RegisterNetEvent('RemoveStuckProps', function()
    	for k, v in pairs(GetGamePool('CObject')) do
        	if IsEntityAttachedToEntity(PlayerPedId(), v) then
            	SetEntityAsMissionEntity(v, true, true)
            	DeleteObject(v)
            	DeleteEntity(v)
        	end
    	end
	end)
end


if Config.EnablePresistentWheels then
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
end


if Config.LeaveEngineRunning then
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)
            local ped = GetPlayerPed(-1)
            local veh = GetVehiclePedIsIn(ped, false)

            if Config.EmergencyOnly then
                if GetVehicleClass(veh) == 18 then
                    if IsPedInAnyVehicle(ped, false) and IsControlPressed(2, 75) and not IsEntityDead(ped) then
                        Citizen.Wait(150)
                        if IsPedInAnyVehicle(ped, false) and IsControlPressed(2, 75) and not IsEntityDead(ped) then
                            SetVehicleEngineOn(veh, true, true, false)
			    if Config.UseHighBeams then
			        SetVehicleLights(veh, 2)
			        SetVehicleFullbeam(veh, true) 
			        SetVehicleLightMultiplier(veh, 1.0)
			    end
                            if Config.KeepDoorOpen then
                                TaskLeaveVehicle(ped, veh, 256)
                            else
                                TaskLeaveVehicle(ped, veh, 0)
                            end
                        end
                    end
                end
            else
                if IsPedInAnyVehicle(ped, false) and IsControlPressed(2, 75) and not IsEntityDead(ped) then
                    Citizen.Wait(150)
                    if IsPedInAnyVehicle(ped, false) and IsControlPressed(2, 75) and not IsEntityDead(ped) then
                        SetVehicleEngineOn(veh, true, true, false)
		        if Config.UseHighBeams then
			    SetVehicleLights(veh, 2)
			    SetVehicleFullbeam(veh, true) 
			    SetVehicleLightMultiplier(veh, 1.0)
		        end
                        if Config.KeepDoorOpen then
                            TaskLeaveVehicle(ped, veh, 256)
                        else
                            TaskLeaveVehicle(ped, veh, 0)
                        end
                    end
                end
            end
	    end
    end)
end


if Config.HideRadarOnFoot then
    Citizen.CreateThread(function()
	    Citizen.Wait(100)

	    while true do
		    local sleepThread = 500

		    local radarEnabled = IsRadarEnabled()

		    if not IsPedInAnyVehicle(PlayerPedId()) and radarEnabled then
			    DisplayRadar(false)
		    elseif IsPedInAnyVehicle(PlayerPedId()) and not radarEnabled then
			    DisplayRadar(true)
		    end

		    Citizen.Wait(sleepThread)
	    end
    end)
end


if Config.HideWeaponReticle then
    Citizen.CreateThread(function()
        local isSniper = false
        while true do
            Citizen.Wait(0)
    
            local ped = GetPlayerPed(-1)
    
            local currentWeaponHash = GetSelectedPedWeapon(ped)
    
            if currentWeaponHash == 100416529 then
                isSniper = true
            elseif currentWeaponHash == 205991906 then
                isSniper = true
            elseif currentWeaponHash == -952879014 then
                isSniper = true
            elseif currentWeaponHash == GetHashKey('WEAPON_HEAVYSNIPER_MK2') then
                isSniper = true
            else
                isSniper = false
            end
    
            if not isSniper then
                HideHudComponentThisFrame(14)
            end
        end
    end)
end


if Config.HideHudElements then
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)
            for _, v in pairs(Config.HudElements) do
                HideHudComponentThisFrame(v)
            end
        end
    end)
end


if Config.AIMultiplier then
    Citizen.CreateThread(function()
	    for i = 1, 13 do
		    EnableDispatchService(i, Config.EnableDispatch)
	    end
	    while true do
		    SetVehicleDensityMultiplierThisFrame((Config.TrafficAmount/100)+.0)
		    SetPedDensityMultiplierThisFrame((Config.PedestrianAmount/100)+.0)
		    SetRandomVehicleDensityMultiplierThisFrame((Config.TrafficAmount/100)+.0)
		    SetParkedVehicleDensityMultiplierThisFrame((Config.ParkedAmount/100)+.0)
		    SetScenarioPedDensityMultiplierThisFrame((Config.PedestrianAmount/100)+.0, (Config.PedestrianAmount/100)+.0)
		    SetRandomBoats(Config.EnableBoats)
		    SetRandomTrains(Config.EnableTrains)
            SetGarbageTrucks(Config.EnableGarbageTrucks)
		    Citizen.Wait(0)
	    end
    end)
end