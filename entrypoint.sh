#!/bin/bash
set -e

echo "Starting Quake Live server with minqlx..."

export LD_LIBRARY_PATH=".:$LD_LIBRARY_PATH"
chmod +x qzeroded.x64

exec ./qzeroded.x64 +set fs_basepath /qlserver +set fs_homepath /qlserver +set dedicated 1 +set net_port 27960 +set sv_hostname "My QL Server" +exec server.cfg
