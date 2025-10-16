FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

# Установка системных зависимостей
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
        git && \
    apt-get clean

# Установка Python-зависимостей
RUN pip3 install pysftp

# Клонируем minqlx (ядро и стандартные плагины)
RUN git clone https://github.com/MinoMino/minqlx.git /ql/minqlx

# Перемещаем ядро minqlx на нужный уровень
RUN mv /ql/minqlx/python/minqlx /ql/minqlx/ && \
    mv /ql/minqlx/python/version.py /ql/minqlx/ && \
    rm -rf /ql/minqlx/python

# Установка SteamCMD
RUN mkdir -p /steamcmd && \
    curl -s https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz | tar -xz -C /steamcmd

# Передаём аргументы Steam (задать при сборке)
ARG STEAM_USERNAME
ARG STEAM_PASSWORD

# Скачиваем Quake Live Dedicated Server
RUN /steamcmd/steamcmd.sh +@sSteamCmdForcePlatformType linux +force_install_dir /ql +login ${STEAM_USERNAME} ${STEAM_PASSWORD} +app_update 349090 validate +quit

# Копируем конфиги, скрипты сервера и entrypoint
COPY ./ql /ql
COPY ./entrypoint.sh /entrypoint.sh

# Копируем свои плагины поверх дефолтных
COPY ./minqlx/plugins /ql/minqlx/plugins

# Делаем скрипты исполняемыми
RUN chmod +x /ql/run_server.sh /ql/run_server_x64.sh /entrypoint.sh

# Установка рабочей директории и команды запуска
WORKDIR /ql
ENTRYPOINT ["/entrypoint.sh"]
CMD ["./run_server.sh"]
