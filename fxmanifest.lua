fx_version "cerulean"
game "gta5"

description "Razed's Crypto Mining"

author 'Razed Scripts'

version '1.0'

lua54 'yes'

client_script {
    'client/client.lua'
}

server_script {
    'server/server.lua',
    '@oxmysql/lib/MySQL.lua'
}

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}
