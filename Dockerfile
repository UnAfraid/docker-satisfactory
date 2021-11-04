FROM ghcr.io/linuxserver/baseimage-ubuntu:bionic as steamcmd
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="unafraid89@gmail.com"

ARG DEBIAN_FRONTEND="noninteractive"
ENV STEAMCMD_DIR=/app/Steam

RUN mkdir -p $STEAMCMD_DIR
RUN echo "**** install packages ****" && apt-get update && apt-get install -y --no-install-recommends --no-install-suggests curl lib32stdc++6 lib32gcc1 ca-certificates libsdl2-2.0-0 xdg-user-dirs xdg-utils locales
RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen && locale-gen
RUN dpkg --add-architecture i386 && apt-get update && apt-get install -y --no-install-recommends --no-install-suggests libsdl2-2.0-0:i386
RUN echo "**** cleanup ****" && \
  rm -rf \
    /tmp/* \
    /var/lib/apt/lists/* \
    /var/tmp/*
RUN cd $STEAMCMD_DIR && curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxf -
RUN $STEAMCMD_DIR/steamcmd.sh +login anonymous +quit

FROM steamcmd

ARG STEAM_APP_ID=1690800
ARG STEAM_APP_NAME=SatisfactoryDedicatedServer

RUN mkdir -p "/app/${STEAM_APP_NAME}"
RUN mkdir -p "/config/.steam/sdk32/" && cp "${STEAMCMD_DIR}/linux32/steamclient.so" "/config/.steam/sdk32/steamclient.so" 
RUN mkdir -p "/config/.steam/sdk64/" && cp "${STEAMCMD_DIR}/linux64/steamclient.so" "/config/.steam/sdk64/steamclient.so" 
RUN "${STEAMCMD_DIR}/steamcmd.sh" +login anonymous +force_install_dir "/app/${STEAM_APP_NAME}" +app_update $STEAM_APP_ID validate +quit
RUN chown -R abc:abc "/app/${STEAM_APP_NAME}"

EXPOSE 15777/udp
EXPOSE 15000/udp
EXPOSE 7777/udp

# add local files
COPY root/ / 