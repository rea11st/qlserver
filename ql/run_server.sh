#!/bin/bash
cd /ql
./run_server_x64 +set fs_game ql +set zmq_rcon_enable 1 +set zmq_rcon_password strong_rcon_pass +exec server.cfg
