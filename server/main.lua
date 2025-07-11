local ESX, QBCore = nil, nil

if Config.Framework == "esx" then
    ESX = exports['es_extended']:getSharedObject()
elseif Config.Framework == "qbcore" then
    QBCore = exports['qb-core']:GetCoreObject()
end

-- Perguntas
Questions = {
    { question = "Qual é a capital de Portugal?", answer = "lisboa" },
    { question = "Quanto é 2 + 2?", answer = "4" },
    { question = "Qual é a cor do céu?", answer = "azul" },
    -- Adiciona até 50 perguntas
}

local currentQuestion = nil
local playersAnswered = {}

local function getIdentifier(src)
    if Config.Framework == "esx" then
        local xPlayer = ESX.GetPlayerFromId(src)
        return xPlayer and xPlayer.identifier or nil
    else
        local player = QBCore.Functions.GetPlayer(src)
        return player and player.PlayerData.citizenid or nil
    end
end

local function getPlayerName(src)
    return GetPlayerName(src) or "Desconhecido"
end

local function rewardPlayer(src)
    if Config.Reward.type == "money" then
        if Config.Framework == "esx" then
            ESX.GetPlayerFromId(src).addMoney(Config.Reward.amount)
        else
            QBCore.Functions.GetPlayer(src).Functions.AddMoney("cash", Config.Reward.amount)
        end
    elseif Config.Reward.type == "item" then
        if Config.Framework == "esx" then
            ESX.GetPlayerFromId(src).addInventoryItem(Config.Reward.itemName, 1)
        else
            QBCore.Functions.GetPlayer(src).Functions.AddItem(Config.Reward.itemName, 1)
        end
    end
end

local function askQuestion()
    currentQuestion = Questions[math.random(#Questions)]
    playersAnswered = {}
   -- print("[Quiz] Enviando pergunta: " .. currentQuestion.question)
    TriggerClientEvent("quiz:showNotification", -1, "❓ Pergunta: " .. currentQuestion.question)

    CreateThread(function()
        Wait(Config.AnswerTimeLimit * 1000)
        currentQuestion = nil
    end)
end

RegisterCommand("answer", function(src, args)
    if not currentQuestion then return end
    local answer = table.concat(args, " "):lower()
    local identifier = getIdentifier(src)
    if not identifier or playersAnswered[identifier] then return end

    playersAnswered[identifier] = true

    if answer == currentQuestion.answer then
        rewardPlayer(src)
        TriggerClientEvent("quiz:showNotification", src, "✅ Correto! Recompensa atribuída.")
        exports.oxmysql:insert(
            'INSERT INTO quiz_ranking (identifier, name, points) VALUES (?, ?, 1) ON DUPLICATE KEY UPDATE points = points + 1',
            { identifier, getPlayerName(src) }
        )
    else
        TriggerClientEvent("quiz:showNotification", src, "❌ Resposta errada.")
    end
end)

RegisterNetEvent("quiz:getRanking", function()
    local src = source
    exports.oxmysql:query('SELECT name, points FROM quiz_ranking ORDER BY points DESC LIMIT 10', {}, function(result)
        TriggerClientEvent("quiz:openRankingUI", src, result)
    end)
end)

CreateThread(function()
    while true do
        Wait(Config.QuestionInterval * 1000)
        askQuestion()
    end
end)
