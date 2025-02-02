RegisterCommand('clear', function(source, args)
    TriggerEvent('chat:clear')
end, false)

RegisterCommand('c', function(source, args)
    TriggerEvent('chat:clear')
end, false)


SetPedConfigFlag(PlayerPedId(), 424, true)
