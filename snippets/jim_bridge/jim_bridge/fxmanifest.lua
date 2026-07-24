name "Jim_Bridge"
author "Jimathy"
version "2.1.09"
description "Framework Bridge By Jimathy"
fx_version "cerulean"
games { 'gta5' }
lua54 'yes'

files {
    'starter.lua',
    'shared/*.lua',
    'shared/make/*.lua',
    'shared/auth/*.lua',
    'shared/make/*.lua',
    'shared/modules/*.lua',
    'shared/scaleforms/*.lua',
    'shared/wrappers/*.lua',
}

-- Version checker
server_scripts {
    'frameworkCache.lua',
    '_versioncheck.lua',
}

client_scripts {
    'clientFrameworkCache.lua',
    'ui_modules/*.lua',
}

suppress_updates 'false'   -- set to 'true' to disable update pings