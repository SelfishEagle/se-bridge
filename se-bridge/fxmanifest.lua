fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'SE Scripts'
description 'SE Bridge - Universal Framework Bridge'
version '1.0.0'

shared_scripts {
    'version_config.lua',
    'config.lua',
    'bridge/shared.lua'
}

client_scripts {
    'bridge/client.lua',
    'modules/inventory/client.lua'
}

server_scripts {
    'server/version.lua',
    'bridge/server.lua',
    'modules/inventory/server.lua'
}
