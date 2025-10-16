FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

# Установка зависимостей
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
        software-properties-common \
        git \
        make \
        gcc \
        python3-dev && \
    apt-get clean

# Установка Python-зависимостей
RUN pip3 install pysftp

# Клонируем minqlx и собираем .so
RUN git clone https://github.com/MinoMino/minqlx.git /minqlx && \
    cd /minqlx && make && \
    cp /minqlx/bin/minqlx.x64.so /ql/

# Установка SteamCMD
RUN mkdir -p /steamcmd && \
    curl -s https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz | tar -xz -C /steamcmd

# Передаём аргументы Steam
ARG STEAM_USERNAME
ARG STEAM_PASSWORD

# Скачиваем Quake Live Dedicated Server
RUN /steamcmd/steamcmd.sh +@sSteamCmdForcePlatformType linux +force_install_dir /ql +login ${STEAM_USERNAME} ${STEAM_PASSWORD} +app_update 349090 validate +quit

# Копируем скрипты, конфиги, плагины и entrypoint
COPY ./ql /ql
COPY ./minqlx /ql/minqlx
COPY ./entrypoint.sh /entrypoint.sh

# Копируем minqlx.cfg и плагины в ~/.quakelive
RUN mkdir -p /root/.quakelive/minqlx && \
    cp /ql/minqlx/minqlx.cfg /root/.quakelive/minqlx/minqlx.cfg && \
    cp -r /ql/minqlx/plugins /root/.quakelive/minqlx/plugins

# Делаем скрипты исполняемыми
RUN chmod +x /ql/run_server.sh /ql/run_server_x64.sh /entrypoint.sh

WORKDIR /ql
ENTRYPOINT ["/entrypoint.sh"]
CMD ["./run_server.sh"]
