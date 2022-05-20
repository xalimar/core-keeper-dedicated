#!/bin/bash

xvfbpid=""
ckpid=""

function kill_corekeeperserver {
        if [[ ! -z "$ckpid" ]]; then
                kill $ckpid
        fi
        sleep 1
        if [[ ! -z "$xvfbpid" ]]; then
                kill $xvfbpid
        fi
}

trap kill_corekeeperserver EXIT

set -m

# Currently Core Keeper requires an authenticated user to update
echo "Loading Core Keeper"
bash "${STEAMCMDDIR}/steamcmd.sh" +force_install_dir "${STEAMAPPDIR}" \
        +login "${STEAMUSER}" "${STEAMPASS}" \
        +app_update "${STEAMAPPID}" \
        +quit

Xvfb :99 -screen 0 1x1x24 -nolisten tcp &
xvfbpid=$!

cd "${STEAMAPPDIR}/Server/"

rm -f GameID.txt
DISPLAY=:99 ./CoreKeeperServer -batchmode -logfile CoreKeeperServerLog.txt "$@" &
ckpid=$!

echo "Started server process with pid $ckpid"

while [ ! -f GameID.txt ]; do
        sleep 0.1
done

echo "Game ID: $(cat GameID.txt)"

wait $ckpid
ckpid=""
