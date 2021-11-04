FROM ghcr.io/linuxserver/baseimage-ubuntu:bionic
LABEL maintainer="unafraid89@gmail.com"

ARG DEBIAN_FRONTEND="noninteractive"
ENV STEAMCMD_DIR=/app/Steam
ENV STEAM_APP_ID=1690800
ENV STEAM_APP_NAME=SatisfactoryDedicatedServer

RUN echo "**** install packages ****" && \
	apt-get update && apt-get install -y --no-install-recommends --no-install-suggests curl lib32stdc++6 lib32gcc1 ca-certificates libsdl2-2.0-0 xdg-user-dirs xdg-utils locales && \
	echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen && locale-gen && \
	dpkg --add-architecture i386 && apt-get update && apt-get install -y --no-install-recommends --no-install-suggests libsdl2-2.0-0:i386 && \
	echo "**** cleanup ****" && \
	rm -rf \
    /tmp/* \
    /var/lib/apt/lists/* \
    /var/tmp/*

RUN mkdir -p $STEAMCMD_DIR && cd $STEAMCMD_DIR && \
	curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxf - && \
	$STEAMCMD_DIR/steamcmd.sh +login anonymous +quit && \
	mkdir -p "/app/${STEAM_APP_NAME}" && \
	mkdir -p "/config/.steam/sdk32/" && cp "${STEAMCMD_DIR}/linux32/steamclient.so" "/config/.steam/sdk32/steamclient.so"  && \
	mkdir -p "/config/.steam/sdk64/" && cp "${STEAMCMD_DIR}/linux64/steamclient.so" "/config/.steam/sdk64/steamclient.so" 

EXPOSE 15777/udp 15000/udp 7777/udp

# add local files
COPY root/ /
