if Config.DisableAimAssist then
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(500) 
            local weaponHash = GetSelectedPedWeapon(PlayerPedId())
            if weaponHash and weaponHash ~= GetHashKey("WEAPON_PISTOL") then
                SetPlayerLockonRangeOverride(PlayerId(), 0.0)
            end
        end
    end)
end


if Config.DisableDriveBy then
    local passengerDriveBy = true
    local speedLimit = Config.DriveBySpeed

    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(100)

            local playerPed = GetPlayerPed(-1)
            local vehicle = GetVehiclePedIsIn(playerPed, false)
            local speed = GetEntitySpeed(vehicle) * 2.23694

            local vehicleClass = GetVehicleClass(vehicle)
            if vehicleClass ~= 15 and vehicleClass ~= 16 then
                if math.floor(speed) > speedLimit then
                    SetPlayerCanDoDriveBy(PlayerId(), false)
                else
                    SetPlayerCanDoDriveBy(PlayerId(), passengerDriveBy)
                end
            end
        end
    end)
end

--[[ CURRENTLY OUT OF SERVICE, WORKING ON A FIX
if not Config.DisableMelee then
    Citizen.CreateThread(function()
        local ped = PlayerPedId()
        while true do
            Citizen.Wait(0)
            if IsPedArmed(ped, 6) then
                DisableControlAction(1, 140, true)
                DisableControlAction(1, 141, true)
                DisableControlAction(1, 142, true)
            end
        end
    end)
end
--]]


if Config.DisableStaminaRegen then
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)
            RestorePlayerStamina(GetPlayerPed(-1), 2.0)
        end
    end)
end

if not Config.DisableHealthRegen then
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(00)
            SetPlayerHealthRechargeMultiplier(PlayerId(), 0.0)
            SetPlayerHealthRechargeLimit(PlayerId(), 0.0)
        end
    end)
end


if Config.DisableVehicleWeaponDrops then
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(10)
            DisablePlayerVehicleRewards(PlayerId())
        end
    end)
end


if Config.DisableWeaponDrops then
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(1000)
            local handle, ped = FindFirstPed()
            local finished = false

            repeat
                if not IsEntityDead(ped) then
                    SetPedDropsWeaponsWhenDead(ped, false)
                end
                finished, ped = FindNextPed(handle)
            until not finished

            EndFindPed(handle)
        end
    end)
end


if Config.DisableBunnyHopping then
    local NumberJump = 10

    Citizen.CreateThread(function()
        local Jump = 0
        while true do
          Citizen.Wait(1)
          local ped = PlayerPedId()
            if IsPedOnFoot(ped) and not IsPedSwimming(ped) and (IsPedRunning(ped) or IsPedSprinting(ped)) and not IsPedClimbing(ped) and IsPedJumping(ped) and not IsPedRagdoll(ped) then
            Jump = Jump + 1
              if Jump == NumberJump then
                  SetPedToRagdoll(ped, 5000, 1400, 2)
                  Jump = 0
              end
            else 
            Citizen.Wait(500) 
            end
        end
    end)
end


if Config.DisableAutoWeaponReload then
    SetWeaponsNoAutoreload(true)
end


if Config.DisableCombatRoll then
    Citizen.CreateThread(function()
	    while true do
		    Citizen.Wait(0)
		    if IsPedArmed(GetPlayerPed(-1), 4 | 2) and IsControlPressed(0, 25) then
			    DisableControlAction(0, 22, true)
		    end
	    end
    end)
end


if Config.DisableAimExploit then
    CreateThread(function()
        while true do
        Wait(0)
            if IsPedArmed(PlayerPedId(), 2) and IsPedArmed(PlayerPedId(), 4) then
                SetPlayerLockon(PlayerId(), false)
            end
        end
    end)
end


if Config.EnablePresistentFlashlight then
    SetFlashLightKeepOnWhileMoving(true)
end