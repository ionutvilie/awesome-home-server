#!/usr/bin/env bash


DOCKER_IMAGES=(
    # 'adguard/adguardhome:latest'
    'filebrowser/filebrowser:latest'
    'gerbera/gerbera:latest'
    'ghcr.io/ajnart/homarr:latest'
    'jellyfin/jellyfin:'
    'linuxserver/qbittorrent:latest'
    'lscr.io/linuxserver/sonarr:latest'
    'portainer/portainer-ce:alpine'
)

for DOCKER_IMAGE in ${DOCKER_IMAGES[@]}; do
    printf "\n%s\n\n" $DOCKER_IMAGE
    docker pull $DOCKER_IMAGE
done
