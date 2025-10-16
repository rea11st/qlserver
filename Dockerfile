FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y lib32gcc-s1 curl ca-certificates python3 python3-pip redis-server unzip gnupg gettext software-properties-common && \
    apt-get clean

RUN pip3 install pysftp

RUN mkdir -p /steamcmd && \
    curl -s https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz | tar -xz -C /steamcmd

ARG STEAM_USERNAME
ARG STEAM_PASSWORD

# Скачиваем QL сервер сначала
RUN /steamcmd/steamcmd.sh +@sSteamCmdForcePlatformType linux +force_install_dir /ql +login ${STEAM_USERNAME} ${STEAM_PASSWORD} +app_update 349090 validate +quit

# Копируем свои скрипты и конфиги после скачивания, чтобы не затирать сервер
COPY ./ql /ql
COPY ./minqlx /ql/minqlx
COPY ./entrypoint.sh /entrypoint.sh

RUN chmod +x /ql/run_server.sh /ql/run_server_x64.sh /entrypoint.sh

WORKDIR /ql
ENTRYPOINT ["/entrypoint.sh"]
CMD ["./run_server.sh"]
