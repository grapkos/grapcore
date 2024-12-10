local Player = PlayerId()

SetPoliceIgnorePlayer(Player, true)
SetEveryoneIgnorePlayer(Player, true)
SetPlayerCanBeHassledByGangs(Player, false)
SetIgnoreLowPriorityShockingEvents(Player, true)

Citizen.CreateThread(function()
    while true do
        for key,pedNpc in pairs(GetAllPeds()) do
            SetBlockingOfNonTemporaryEvents(pedNpc,true)
            SetPedFleeAttributes(pedNpc, 0, 0)
            SetPedCombatAttributes(pedNpc, 17, 1)
            if(GetPedAlertness(pedNpc) ~= 0) then
                SetPedAlertness(pedNpc,0)
            end
        end
        Citizen.Wait(0)
    end
end)

local function EnumerateEntities(initFunc, moveFunc, disposeFunc)
    return coroutine.wrap(function()
        local iter, id = initFunc()
        if not id or id == 0 then
            disposeFunc(iter)
            return
        end
      
        local enum = {handle = iter, destructor = disposeFunc}
        setmetatable(enum, entityEnumerator)
      
        local next = true
        repeat
            coroutine.yield(id)
            next, id = moveFunc(iter)
        until not next
      
        enum.destructor, enum.handle = nil, nil
        disposeFunc(iter)
    end)
end

function EnumeratePeds()
    return EnumerateEntities(FindFirstPed, FindNextPed, EndFindPed)
end

function GetAllPeds()
    local peds = {}
    for ped in EnumeratePeds() do
        if DoesEntityExist(ped) and not IsEntityDead(ped) and IsEntityAPed(ped) and IsPedHuman(ped) and not IsPedAPlayer(ped) then
            table.insert(peds, ped)
        end
    end
    return peds
end