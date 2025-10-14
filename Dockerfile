FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

# Зависимости
RUN apt-get update && \
    apt-get install -y \
        lib32gcc-s1 \
        curl \
        ca-certificates \
        python3 \
        python3-pip \
        redis-server \
        unzip \
        gnupg \
        gettext \
        software-properties-common && \
    apt-get clean

# SteamCMD
RUN mkdir -p /steamcmd && \
    curl -s https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz \
        | tar -xz -C /steamcmd

# Логин через build args
ARG STEAM_USERNAME
ARG STEAM_PASSWORD

# Установка QL
RUN mkdir -p /ql && \
    /steamcmd/steamcmd.sh \
        +@sSteamCmdForcePlatformType linux \
        +force_install_dir /ql \
        +login ${STEAM_USERNAME} ${STEAM_PASSWORD} \
        +app_update 349090 validate \
        +quit

# Копируем файлы
COPY ./ql /ql
COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /ql/run_server.sh /ql/run_server_x64.sh /entrypoint.sh

WORKDIR /ql
ENTRYPOINT ["/entrypoint.sh"]

