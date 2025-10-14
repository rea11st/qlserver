#!/bin/bash
set -e

# Генерация server.cfg из шаблона
echo "[INFO] Generating server.cfg from template..."
envsubst < /ql/baseq3/server.cfg.template > /ql/baseq3/server.cfg

echo "[INFO] Generated server.cfg:"
cat /ql/baseq3/server.cfg

# Запуск сервера
exec /ql/run_server.sh
