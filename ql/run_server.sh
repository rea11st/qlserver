#!/bin/bash
set -e

echo "[INFO] Current working directory: $(pwd)"
echo "[INFO] Listing files:"
ls -la

echo "[INFO] Trying to run run_server_x64.sh..."
exec ./run_server_x64.sh

./run_server_x64.sh +set fs_game ql +set zmq_rcon_enable 1 +set zmq_rcon_password strong_rcon_pass +exec server.cfg
