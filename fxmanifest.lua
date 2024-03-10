fx_version   'cerulean'
use_experimental_fxv2_oal 'yes'
lua54 'yes'
game 'gta5'

description 'Parking Meter Robbing | xT Development'
author 'xT Development'

shared_scripts { '@ox_lib/init.lua' }
client_scripts { 'bridge/client/*.lua', 'configs/client.lua', 'client/*.lua' }
server_scripts { 'bridge/server/*.lua', 'configs/server.lua', 'server/*.lua' }