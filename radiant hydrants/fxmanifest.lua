fx_version 'cerulean'
game 'gta5'

author 'Radiant Development'
description 'Persistent Placeable Fire Hydrants for z_fires & SmartFires'
version '1.0.0'
lua54 'yes'

shared_script 'config.lua'
shared_script 'version.lua'

client_script 'client.lua'
server_script 'server.lua'

dependencies {
    'oxmysql'
}

escrow_ignore {
    "config.lua",
    
}
