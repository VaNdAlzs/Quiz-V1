fx_version 'cerulean'
game 'gta5'

author 'VaNdAl'
description 'Sistema de Quiz para ESX/QBCore'

shared_script 'config.lua'
client_script 'client/main.lua'
server_script {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua'
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css'
}
