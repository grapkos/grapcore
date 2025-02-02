if Config.EnableInjuredAnimation then
	Citizen.CreateThread(function()
		while true do
			Wait(500)
			if GetEntityHealth(GetPlayerPed(-1)) <= 150 then
				setHurt()
			elseif GetEntityHealth(GetPlayerPed(-1)) > 151 then
				setNotHurt()
			end
		end
	end)

	function setHurt()
		RequestAnimSet("move_m@injured")
		SetPedMovementClipset(GetPlayerPed(-1), "move_m@injured", true)
	end

	function setNotHurt()
		ResetPedMovementClipset(GetPlayerPed(-1))
		ResetPedWeaponMovementClipset(GetPlayerPed(-1))
		ResetPedStrafeClipset(GetPlayerPed(-1))
	end
end