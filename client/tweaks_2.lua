if Config.EnableSurrenderAnim then
    RegisterKeyMapping('handsup', 'Toggle Hands Up', 'keyboard', 'O')

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
                -- DisableControlAction(0, 0, true)
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
end


if Config.EnableCrouch then
        local isCrouched = false
        local isCrouchedForce = false
        local Aimed = false
        local Cooldown = false
        local CoolDownTime = 200
    
        local PlayerInfo = {
            playerPed = PlayerPedId(),
            playerID = GetPlayerIndex(),
            nextCheck = GetGameTimer() + 1500
        }
    
        local function NormalWalk()
            SetPedMaxMoveBlendRatio(PlayerInfo.playerPed, 1.0)
            ResetPedMovementClipset(PlayerInfo.playerPed, 0.55)
            ResetPedStrafeClipset(PlayerInfo.playerPed)
            SetPedCanPlayAmbientAnims(PlayerInfo.playerPed, true)
            SetPedCanPlayAmbientBaseAnims(PlayerInfo.playerPed, true)
            ResetPedWeaponMovementClipset(PlayerInfo.playerPed)
            isCrouched = false
        end
    
        local function SetupCrouch()
            while not HasAnimSetLoaded('move_ped_crouched') do
                Citizen.Wait(10)
                RequestAnimSet('move_ped_crouched')
            end
        end
    
        local function RemoveCrouchAnim()
            RemoveAnimDict('move_ped_crouched')
        end
    
        local function CanCrouch()
            local ped = PlayerInfo.playerPed
            return IsPedOnFoot(ped) and not IsPedInAnyVehicle(ped, false) and 
                   not IsPedJumping(ped) and not IsPedFalling(ped) and not IsPedDeadOrDying(ped)
        end
    
        local function CrouchPlayer()
            SetPedUsingActionMode(PlayerInfo.playerPed, false, -1, "DEFAULT_ACTION")
            SetPedMovementClipset(PlayerInfo.playerPed, 'move_ped_crouched', 0.55)
            SetPedStrafeClipset(PlayerInfo.playerPed, 'move_ped_crouched_strafing')
            isCrouched = true
            Aimed = false
        end
    
        local function SetPlayerAimSpeed()
            SetPedMaxMoveBlendRatio(PlayerInfo.playerPed, 0.2)
            Aimed = true
        end
    
        local function IsPlayerFreeAimed()
            return IsPlayerFreeAiming(PlayerInfo.playerID) or IsAimCamActive() or IsAimCamThirdPersonActive()
        end
    
        local function CrouchLoop()
            SetupCrouch()
    
            while isCrouchedForce do
                Citizen.Wait(10)
    
                local now = GetGameTimer()
                if now >= PlayerInfo.nextCheck then
                    PlayerInfo.playerPed = PlayerPedId()
                    PlayerInfo.playerID = GetPlayerIndex()
                    PlayerInfo.nextCheck = now + 1500
                end
    
                local canCrouch = CanCrouch()
                if canCrouch and isCrouched and IsPlayerFreeAimed() then
                    SetPlayerAimSpeed()
                elseif canCrouch and (not isCrouched or Aimed) then
                    CrouchPlayer()
                elseif not canCrouch and isCrouched then
                    isCrouchedForce = false
                    NormalWalk()
                end
            end
    
            NormalWalk()
            RemoveCrouchAnim()
        end
    
        RegisterCommand('crouch', function()
            DisableControlAction(0, 36, true)
    
            if not Cooldown then
                isCrouchedForce = not isCrouchedForce
    
                if isCrouchedForce then
                    Citizen.CreateThread(CrouchLoop)
                end
    
                Cooldown = true
                SetTimeout(CoolDownTime, function()
                    Cooldown = false
                end)
            end
        end, false)
    
        RegisterKeyMapping('crouch', 'Toggle Crouch', 'keyboard', 'LCONTROL')
end


if Config.EnableRagdoll then
    local isInRagdoll = false
    local ragdollKey = 'U'
    
    RegisterCommand('ragdoll', function()
        local playerPed = PlayerPedId()
    
        if isInRagdoll then
            isInRagdoll = false
        else
            isInRagdoll = true
        end
    end, false)
    
    RegisterKeyMapping('ragdoll', 'Toggle Ragdoll', 'keyboard', ragdollKey)
    
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(10)
            if isInRagdoll then
                SetPedToRagdoll(GetPlayerPed(-1), 1000, 1000, 0, 0, 0, 0)
            end
        end
    end)
    
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)
            if IsControlJustPressed(2, 36) and IsPedOnFoot(PlayerPedId()) then
                if isInRagdoll then
                    isInRagdoll = false
                else
                    isInRagdoll = true
                    Wait(500)
                end
            end
        end
    end)    
end


if Config.EnableBrakeLights then
    local brakeLightSpeedThresh = 0.30

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
end
