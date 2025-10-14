FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y lib32gcc-s1 curl ca-certificates python3 python3-pip redis-server gettext-base && \
    apt-get clean

# Установка SteamCMD
RUN mkdir -p /steamcmd && \
    curl -s https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz | tar -xz -C /steamcmd

# Копируем локальные файлы ДО установки QLDS, чтобы не затирать установку
COPY ./ql /ql
COPY ./minqlx /ql/minqlx

# Установка QLDS
RUN /steamcmd/steamcmd.sh +force_install_dir /ql +login ${QL_STEAM_USER} ${QL_STEAM_PASSWORD} +app_update 349090 validate +quit

# Генерация server.cfg при старте
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /ql/run_server.sh /ql/run_server_x64.sh /entrypoint.sh

WORKDIR /ql
ENTRYPOINT ["/entrypoint.sh"]
CMD ["./run_server.sh"]
