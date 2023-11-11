#!/bin/sh
set -eu

SCRIPT_DIR=$( cd  $( dirname "$0" ) && pwd )
cd "$SCRIPT_DIR"

docker run --rm -it goldsourceservers/cstrike 'hlds_linux -game cstrike +version +exit' > hlds-cstrike
docker run --rm -it goldsourceservers/czero 'hlds_linux -game czero +version +exit' > hlds-czero
docker run --rm -it goldsourceservers/dmc 'hlds_linux -game dmc +version +exit' > hlds-dmc
docker run --rm -it goldsourceservers/dod 'hlds_linux -game dod +version +exit' > hlds-dod
docker run --rm -it goldsourceservers/gearbox 'hlds_linux -game gearbox +version +exit' > hlds-gearbox
docker run --rm -it goldsourceservers/ricochet 'hlds_linux -game ricochet +version +exit' > hlds-ricochet
docker run --rm -it goldsourceservers/tfc 'hlds_linux -game tfc +version +exit' > hlds-tfc
docker run --rm -it goldsourceservers/valve 'hlds_linux -game valve +version +exit' > hlds-valve
docker run --rm -it sourceservers/cs2 'game/bin/linuxsteamrt64/cs2 -dedicated +quit' > srcds-cs2
docker run --rm -it sourceservers/csgo 'srcds_linux -game csgo +version +exit' > srcds-csgo
docker run --rm -it sourceservers/cstrike 'srcds_linux -game cstrike +version +exit' > srcds-cstrike
docker run --rm -it sourceservers/dod 'srcds_linux -game dod +version +exit' > srcds-dod
docker run --rm -it sourceservers/hl2mp 'srcds_linux -game hl2mp +version +exit' > srcds-hl2mp
docker run --rm -it sourceservers/left4dead 'srcds_linux -game left4dead +version +exit' > srcds-left4dead
docker run --rm -it sourceservers/left4dead2 'srcds_linux -game left4dead2 +version +exit' > srcds-left4dead2
docker run --rm -it sourceservers/tf 'srcds_linux -game tf +version +exit' > srcds-tf
