#!/bin/bash
set -e

echo "[INFO] Setting PYTHONPATH for minqlx"
export PYTHONPATH=/ql/minqlx:$PYTHONPATH

echo "[INFO] Trying to run run_server_x64.sh with parameters..."
exec ./run_server_x64.sh +set fs_game minqlx +set zmq_rcon_enable 1 +set zmq_rcon_password "${QL_RCON_PASSWORD}" +set steam_token "${STEAM_TOKEN}" +exec server.cfg
