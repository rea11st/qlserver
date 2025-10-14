#!/bin/bash
set -e

echo "[INFO] Generating server.cfg from template..."

envsubst < /ql/baseq3/server.cfg.template > /ql/baseq3/server.cfg

exec "$@"
