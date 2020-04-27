# Tinkerboard (Pre-Prod Server)

Is it just me or this seems more responsive than Raspberry Pi 4 4g ? :)

Model: Asus Tinkerboard
OS: https://www.armbian.com/tinkerboard/ 
Architecture: armhf

```bash
# Emby
docker run -d \
    --volume /mnt/media/config:/config \
    --volume /mnt/media/media:/mnt/share1 \
    --device /dev/dri/renderD128:/dev/dri/renderD128 \
    --net=host \
    --publish 8096:8096 \
    --publish 8920:8920 \
    --publish 7359:7359/udp \
    --publish 1900:1900/udp \
    --env UID=1000 \
    --env GID=100 \
    --env GIDLIST=100 \
    --name emby \
    emby/embyserver_arm32v7

# Plex    
docker create \
  --name=plex \
  --net=host \
  -e PUID=1000 \
  -e PGID=1000 \
  -e VERSION=docker \
  -e UMASK_SET=022 \
  -e PLEX_CLAIM= \
  -v /mnt/media/config/plex:/config \
  -v /mnt/media/media:/tv \
  -v /path/to/movies:/movies \
  --restart unless-stopped \
  linuxserver/plex
```