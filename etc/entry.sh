#!/bin/bash

# Update Core Keeper server
echo "Loading Core Keeper"
bash "${STEAMCMDDIR}/steamcmd.sh" +force_install_dir "${STEAMAPPDIR}" \
        +login anonymous \
        +app_update "${STEAMAPPID}" \
        +quit

# Launch server
cd ${STEAMAPPDIR}
./_launch.sh

