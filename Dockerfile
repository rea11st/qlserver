FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

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
        git \
        build-essential \
        python3-dev \
        libffi-dev \
        libssl-dev && \
    apt-get clean

# Установка Python-зависимостей
RUN pip3 install pysftp

# Клонируем и собираем minqlx
RUN mkdir -p /ql && \
    git clone https://github.com/MinoMino/minqlx.git /minqlx && \
    cd /minqlx && make && \
    cp /minqlx/bin/* /ql

# Установка SteamCMD
RUN mkdir -p /steamcmd && \
    curl -s https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz | tar -xz -C /steamcmd

ARG STEAM_USERNAME
ARG STEAM_PASSWORD

# Скачиваем Quake Live Dedicated Server
RUN /steamcmd/steamcmd.sh +@sSteamCmdForcePlatformType linux +force_install_dir /ql +login ${STEAM_USERNAME} ${STEAM_PASSWORD} +app_update 349090 validate +quit

# Копируем конфиги и entrypoint
COPY ./ql /ql
COPY ./entrypoint.sh /entrypoint.sh
COPY ./minqlx/plugins /ql/minqlx/plugins

RUN chmod +x /ql/run_server.sh /ql/run_server_x64.sh /entrypoint.sh

WORKDIR /ql
ENTRYPOINT ["/entrypoint.sh"]
CMD ["./run_server.sh"]
