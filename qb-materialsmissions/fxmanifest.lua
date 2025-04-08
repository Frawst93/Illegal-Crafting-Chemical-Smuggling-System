fx_version 'cerulean'
game 'gta5'

description 'Mainframe RP - Illegal Blueprint Mission System'
author 'Frawst'
version '1.0.0'

shared_scripts {
    '@qb-core/shared/locale.lua',
    'shared/sh_items.lua'
}

client_scripts {
    '@ox_lib/init.lua',
    'client/cl_blueprints.lua',
    'client/cl_craftingbench.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/sv_blueprints.lua'
}
