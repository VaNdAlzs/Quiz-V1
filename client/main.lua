local display = false

RegisterNetEvent('quiz:openRankingUI', function(data)
 --   print("^2[Quiz]^0 Recebi ranking do servidor")
    SendNUIMessage({ action = "show", data = data })
    SetNuiFocus(true, true)
    display = true
end)

RegisterNUICallback('close', function(_, cb)
    SetNuiFocus(false, false)
    display = false
    SendNUIMessage({ action = "hide" })
    cb('ok')
end)

RegisterCommand('quizrank', function()
  --  print("^2[Quiz]^0 Pedido ranking enviado ao servidor")
    TriggerServerEvent('quiz:getRanking')
end)

RegisterNetEvent("quiz:showNotification")
AddEventHandler("quiz:showNotification", function(msg)
    if Config.UseOkOkNotify then
        exports['okokNotify']:Alert("Quiz", msg, 5000, "info")
    else
        TriggerEvent('chat:addMessage', { args = { "[Quiz] " .. msg } })
    end
end)


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if display and IsControlJustReleased(0, 322) then
            SetNuiFocus(false, false)
            display = false
            SendNUIMessage({ action = "hide" })
        end
    end
end)
