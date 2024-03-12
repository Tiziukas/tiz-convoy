fx_version 'cerulean'
games { 'gta5' }

author 'Tizas'

description 'Convoy'

version '1.0.0'

lua54 'yes'


client_scripts {
    'client/client.lua'
}
server_script {
    'server/server.lua'
}

shared_scripts {
    '@es_extended/imports.lua',
    '@ox_lib/init.lua',
    'shared/**.lua',
}