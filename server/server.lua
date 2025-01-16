if Config.RadioOffByDefault then
    AddEventHandler('playerSpawned', function()
        TriggerClientEvent('DisableRadio', source)
    end)
end