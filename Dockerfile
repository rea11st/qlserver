FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

# Установка зависимостей
RUN apt-get update && \
    apt-get install -y lib32gcc-s1 curl ca-certificates python3 python3-pip redis-server unzip gnupg gettext software-properties-common git && \
    apt-get clean

# Устанавливаем pysftp
RUN pip3 install pysftp

# Клонируем minqlx целиком (ядро и стандартные плагины)
RUN git clone https://github.com/MinoMino/minqlx.git /ql/minqlx

# Установка SteamCMD
RUN mkdir -p /steamcmd && \
    curl -s https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz | tar -xz -C /steamcmd

ARG STEAM_USERNAME
ARG STEAM_PASSWORD

# Скачиваем QL сервер
RUN /steamcmd/steamcmd.sh +@sSteamCmdForcePlatformType linux +force_install_dir /ql +login ${STEAM_USERNAME} ${STEAM_PASSWORD} +app_update 349090 validate +quit

# Копируем свои скрипты и конфиги после скачивания и клонирования minqlx
COPY ./ql /ql

# Копируем только свои плагины поверх стандартных
COPY ./minqlx/plugins /ql/minqlx/plugins

# Копируем entrypoint
COPY ./entrypoint.sh /entrypoint.sh

# Делаем скрипты исполняемыми
RUN chmod +x /ql/run_server.sh /ql/run_server_x64.sh /entrypoint.sh

# Устанавливаем рабочую директорию и команду запуска
WORKDIR /ql
ENTRYPOINT ["/entrypoint.sh"]
CMD ["./run_server.sh"]
