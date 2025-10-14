FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y lib32gcc-s1 curl ca-certificates python3 python3-pip redis-server && \
    apt-get clean

# Установка SteamCMD
RUN mkdir -p /steamcmd && \
    curl -s https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz | tar -xz -C /steamcmd

# Установка QLDS
RUN mkdir -p /ql && \
    /steamcmd/steamcmd.sh +force_install_dir /ql +login 76561198192184519 +app_update 349090 validate +quit


# Копируем файлы сервера
COPY ./ql /ql
COPY ./minqlx /ql/minqlx

# Настройка прав
RUN chmod +x /ql/run_server.sh

WORKDIR /ql
CMD ["./run_server.sh"]
