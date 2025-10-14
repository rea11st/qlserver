#!/bin/bash
set -e

echo "[INFO] Current working directory: $(pwd)"
echo "[INFO] Listing files:"
ls -la

echo "[INFO] Trying to run run_server_x64.sh with parameters..."
exec ./run_server_x64.sh +set fs_game ql +set zmq_rcon_enable 1 +set zmq_rcon_password "${QL_RCON_PASSWORD}" +exec server.cfg
