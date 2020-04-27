# Raspberry Pi 4

Model: Raspberry Pi 4 4g
Architecture: arm64
OS: https://ubuntu.com/download/raspberry-pi Ubuntu Pi 64-bit

## Mount external storage

Mount Seagate 2T Slim drive as explained here: https://www.techrepublic.com/article/how-to-properly-automount-a-drive-in-ubuntu-linux/ 

```bash
mkdir -p /mnt/sgt2t
# `fdisk -l` and `blkid` for the the uuid
sudo vim /etc/fstab # and append below line 
UUID=98db3b27-e3fa-4cfe-906f-bcbd4db335b7 /mnt/sgt2t ext4    errors=remount-ro,auto,exec,rw,user 0       0
```

## Software

### Docker.io


```bash 
# atm there is no official docker support for focal (no focal in https://download.docker.com/linux/ubuntu/dists/)
# https://www.docker.com/blog/getting-started-with-docker-for-arm-on-linux/
# install docker from the official ubuntu repo
sudo apt install docker.io
```

### qbittorrent 

qBittorrent in docker (qBittorrent-nox)

```bash 
docker create \
  --name=qbittorrent \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Europe/London \
  -e UMASK_SET=022 \
  -e WEBUI_PORT=8080 \
  -p 6881:6881 \
  -p 6881:6881/udp \
  -p 8080:8080 \
  -v /mnt/sgt2t/config/qbittorrent:/config \
  -v /mnt/sgt2t/media:/downloads \
  --restart unless-stopped \
  linuxserver/qbittorrent

docker start qbittorrent 
```
Open the web ui on board IP and port 8080

### DLNA server (works with Samsung Smart TV's)


Small DLNA Server using `rclone serve dlna` (serve a local folder)
The image was build on raspberry pi using the Dockerfile from rclone-dlna folder

```bash
docker create \
  --name=rpi-dlna \
  --net=host \
  -e PUID=1000 \
  -e PGID=1000 \
  -e VERSION=docker \
  -e UMASK_SET=022 \
  -v /mnt/sgt2t/config/rclone:/config \
  -v /mnt/sgt2t/media:/media \
  --restart unless-stopped \
  ionutvilie/rclone

docker start rpi-dlna  
```

### Node Exporter (Prometheus)