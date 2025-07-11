local ESX, QBCore = nil, nil

if Config.Framework == "esx" then
    ESX = exports['es_extended']:getSharedObject()
elseif Config.Framework == "qbcore" then
    QBCore = exports['qb-core']:GetCoreObject()
end

-- Perguntas
Questions = {
    { question = "Capital de Portugal?", answer = "lisboa" },
    { question = "Cor do céu em dias limpos?", answer = "azul" },
    { question = "Quanto é 5 + 7?", answer = "12" },
    { question = "Maior oceano do mundo?", answer = "pacífico" },
    { question = "Quem pintou a Mona Lisa?", answer = "leonardo da vinci" },
    { question = "Cor da bandeira do Japão?", answer = "branca e vermelha" },
    { question = "Qual o planeta vermelho?", answer = "marte" },
    { question = "Quantos lados tem um quadrado?", answer = "4" },
    { question = "Qual o maior animal terrestre?", answer = "elefante" },
    { question = "Capital da França?", answer = "paris" },
    { question = "Qual a capital da Alemanha?", answer = "berlim" },
    { question = "O que é H2O?", answer = "água" },
    { question = "Quantos continentes existem?", answer = "7" },
    { question = "Maior país do mundo?", answer = "rússia" },
    { question = "Qual o menor país do mundo?", answer = "vaticano" },
    { question = "Cor da clorofila?", answer = "verde" },
    { question = "Autor de 'Dom Quixote'?", answer = "miguel de cervantes" },
    { question = "Quem descobriu o Brasil?", answer = "pedro álvares cabral" },
    { question = "Capital do Brasil?", answer = "brasília" },
    { question = "Cidade da Torre Eiffel?", answer = "paris" },
    { question = "Quanto é 10 * 10?", answer = "100" },
    { question = "Animal que mia?", answer = "gato" },
    { question = "Animal que late?", answer = "cão" },
    { question = "Qual o metal do ouro?", answer = "au" },
    { question = "Soma de 15 + 5?", answer = "20" },
    { question = "Continente do Egito?", answer = "africa" },
    { question = "A Terra é um...?", answer = "planeta" },
    { question = "Forma da bola de futebol?", answer = "esférica" },
    { question = "5 x 3?", answer = "15" },
    { question = "10 dividido por 2?", answer = "5" },
    { question = "Cor da esmeralda?", answer = "verde" },
    { question = "Capital da Itália?", answer = "roma" },
    { question = "Instrumento com teclas?", answer = "piano" },
    { question = "Gás usado na respiração?", answer = "oxigênio" },
    { question = "Sabor do limão?", answer = "azedo" },
    { question = "Doce feito com chocolate?", answer = "brigadeiro" },
    { question = "Planeta mais próximo do sol?", answer = "mercúrio" },
    { question = "Qual o sexto mês do ano?", answer = "junho" },
    { question = "Estação após primavera?", answer = "verão" },
    { question = "Cor do carvão?", answer = "preto" },
    { question = "Melhor amigo do homem?", answer = "cão" },
    { question = "5 elevado a 2?", answer = "25" },
    { question = "Capital de Angola?", answer = "luanda" },
    { question = "O que usamos para ver?", answer = "olhos" },
    { question = "Cereja é uma...?", answer = "fruta" },
    { question = "Faz parte da perna?", answer = "joelho" },
    { question = "A água ferve a quantos graus?", answer = "100" },
    { question = "Elemento químico do sal?", answer = "nacl" },
    { question = "Quantas horas tem um dia?", answer = "24" }
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
