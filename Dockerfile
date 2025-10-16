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
        python3-dev \ 
        redis-server \
        unzip \
        gnupg \
        gettext \
        software-properties-common \
        git && \
    apt-get clean

# Установка Python-зависимостей
RUN pip3 install pysftp

# Клонируем minqlx (ядро и стандартные плагины)
RUN git clone https://github.com/MinoMino/minqlx.git /minqlx && \
    cd /minqlx && \
    make && \
    echo "FILES:" && ls -l /minqlx/bin && \
    mkdir -p /ql/minqlx && \
    cp -r /minqlx/bin/* /ql/minqlx && \
    cp -r /minqlx/bin/* /ql

RUN unzip /minqlx/bin/minqlx.zip 'minqlx/*' -d /tmp && \
    mv /tmp/minqlx/* /ql/minqlx/ && \
    rm -rf /tmp/minqlx

# Установка SteamCMD
RUN mkdir -p /steamcmd && \
    curl -s https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz | tar -xz -C /steamcmd

# Передаём аргументы Steam (будут заданы при сборке)
ARG STEAM_USERNAME
ARG STEAM_PASSWORD

# Скачиваем Quake Live Dedicated Server
RUN /steamcmd/steamcmd.sh +@sSteamCmdForcePlatformType linux +force_install_dir /ql +login ${STEAM_USERNAME} ${STEAM_PASSWORD} +app_update 349090 validate +quit

# Копируем конфиги, скрипты сервера и entrypoint
COPY ./ql /ql
COPY ./entrypoint.sh /entrypoint.sh

RUN mkdir -p /ql/minqlx/plugins
COPY ./minqlx/minqlx.cfg /ql/minqlx/
COPY ./minqlx/plugins /ql/minqlx/plugins/

# Делаем исполняемые скрипты действительно исполняемыми
RUN chmod +x /ql/run_server.sh /ql/run_server_x64.sh /entrypoint.sh

# Устанавливаем рабочую директорию и запуск
WORKDIR /ql

ENV PYTHONPATH=/ql/minqlx

ENTRYPOINT ["/entrypoint.sh"]
CMD ["./run_server.sh"]
