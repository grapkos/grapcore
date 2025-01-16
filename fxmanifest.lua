fx_version 'cerulean'
game 'gta5'

lua54 'yes'

author 'grapkos' 
description 'Miscellaneous, enhancing game experience'
version '2.0.0 <2025>'

data_file 'VEHICLE_METADATA_FILE' 'handling.meta'

files {
	'handling.meta'
}

server_scripts {
    'server/*.lua'
}

client_scripts {
    'client/*.lua'
}

shared_scripts {
    'config.lua'
}