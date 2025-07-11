Config = {}

Config.Framework = "esx" -- ou "qbcore"
Config.QuestionInterval = 60 -- segundos entre perguntas
Config.AnswerTimeLimit = 30 -- segundos para responder
Config.CooldownSeconds = 5 -- tempo entre respostas para o mesmo jogador

Config.Reward = {
    type = "money", -- "money" ou "item"
    amount = 1000,
    itemName = "bread" -- usado se type for "item"
}

Config.UseOkOkNotify = true -- usa notificação okokNotify se true, senão usa chat

Config.DiscordWebhook = "https://discord.com/api/webhooks/SEU_WEBHOOK_AQUI"
