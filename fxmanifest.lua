fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author '0xIbra <cyberrp.france@gmail.com>'
description 'QB-Import-Export - a script that let\'s players purchase & haul cargo to from place to place for lucrative purpuses.'
version '1.0.0'

shared_scripts {
    'config.lua',
    '@qb-core/shared/locale.lua',
    'locales/en.lua',
    'locales/*.lua'
}

client_scripts {
    'client/main.lua',
    '@qb-inventory/shared/vehicleTrunk.lua'
}

server_scripts {
    'server/productItems.lua',
    'server/main.lua'
}

escrow_ignore {
    'locales/*.lua',
    'config.lua',
    'assets/*',
    'data/*'
}