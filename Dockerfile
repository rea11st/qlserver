FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

# Установка зависимостей
RUN apt-get update && apt-get install -y \
    lib32gcc-s1 \
    lib32stdc++6 \
    wget \
    unzip \
    curl \
    python3 \
    python3-pip \
    git \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Установка steamcmd
RUN mkdir -p /steamcmd && \
    curl -sSL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar -xz -C /steamcmd

# Установка сервера Quake Live
RUN mkdir -p /qlserver
WORKDIR /qlserver

RUN /steamcmd/steamcmd.sh +login anonymous +force_install_dir /qlserver +app_update 349090 validate +quit

# Установка minqlx
RUN git clone https://github.com/MinoMino/minqlx.git /minqlx && \
    cd /minqlx && make

# Копируем бинарники и распаковываем minqlx.zip правильно
RUN mkdir -p /qlserver/minqlx && \
    unzip /minqlx/bin/minqlx.zip 'minqlx/*' -d /tmp && \
    mv /tmp/minqlx/* /qlserver/minqlx/ && \
    rm -rf /tmp/minqlx

# Установка Python-зависимостей для minqlx
COPY plugins/ /qlserver/minqlx/plugins/
RUN pip3 install websocket-client

# Копируем скрипт запуска
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Копируем серверный конфиг (при необходимости)
COPY server.cfg /qlserver/baseq3/server.cfg

WORKDIR /qlserver

EXPOSE 27960/udp

ENTRYPOINT ["/entrypoint.sh"]
