# Raspberry Pi 4

- Model: Raspberry Pi 4 4g
- Architecture: arm64
- OS: <a href="https://ubuntu.com/download/raspberry-pi"> Ubuntu Pi 64-bit</a>

## Mount external storage

Mount Seagate 2T Slim drive as explained <a href="https://www.techrepublic.com/article/how-to-properly-automount-a-drive-in-ubuntu-linux/">here</a>

```bash
mkdir -p /mnt/sgt2t
# `fdisk -l` and `blkid` for the the uuid
sudo vim /etc/fstab # and append below line
UUID=98db3b27-e3fa-4cfe-906f-bcbd4db335b7 /mnt/sgt2t ext4    errors=remount-ro,auto,exec,rw,user 0       0
```

## Software

### Docker

Install Docker & docker-compose

```bash
# atm there is no official docker support for focal (no focal in https://download.docker.com/linux/ubuntu/dists/)
# https://www.docker.com/blog/getting-started-with-docker-for-arm-on-linux/
# install docker from the official ubuntu repo
sudo apt install docker.io
```

## Docker docker-compose

```sh
# run the stack
docker-compose up -d
# pull latest images
docker-compose pull
```


## Docker manual run

### qbittorrent

Deploy qBittorrent in Docker

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

### filebrowser


```bash
docker create \
  --name=filebrowser \
  -v /mnt/sgt2t/media/:/srv \
  -v /mnt/sgt2t/config/filebrowser/database.db:/database.db \
  -v /mnt/sgt2t/config/filebrowser/.filebrowser.json:/.filebrowser.json \
  -p 8081:80 \
  --restart unless-stopped \
  filebrowser/filebrowser

docker start filebrowser
```


### DLNA server (works with Samsung Smart TV's)


Small DLNA Server using `rclone serve dlna` (serve a local folder) The image was build on raspberry pi using the Dockerfile from [rclone-dlna folder](../rclone-dlna)

Deploy DLNA Server in Docker

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


[node_exporter folder](../node_exporter)



### ADGUARD HOME

https://blog.linuxserver.io/2019/05/20/adguard-home-first-thoughts/

```
# create macvlan network
# https://docs.docker.com/network/macvlan/

docker network create \
  --driver macvlan \
  --subnet=192.168.100.0/24 \
  --ip-range=192.168.100.128/25 \
  --gateway=192.168.100.1 \
  --opt parent=eth0 macvlan


# create and start a new adguard home container
docker create \
  --name=adguardhome \
  --hostname=adguardhome-dns \
  --label=dns-server \
  --net=macvlan \
  --ip 192.168.100.128 \
  -v /mnt/sgt2t/config/adguard-home/work:/opt/adguardhome/work \
  -v /mnt/sgt2t/config/adguard-home/conf:/opt/adguardhome/conf \
  --restart unless-stopped \
  adguard/adguardhome:arm64-latest

docker start adguardhome
```
### Envoy Proxy




```bash
# qbittorrent and portainer does not work because in the html there
# are assets requested from the root path.
# envoy arm64 binary can be copied from the official docker image.
./envoy -c envoy.yaml -l debug --service-cluster proxy

docker run --rm \
  --name=envoy-proxy \
  -e CONFIG_FILE=/opt/envoy/envoy.yaml \
  -e LOG_LEVEL=info \
  -e SERVICE_CLUSTER=proxy \
  -v ${PWD}/envoy.yaml:/opt/envoy/envoy.yaml \
  -p 8085:8090 \
  -p 8086:8091 \
  envoyproxy/envoy:v1.20-latest -c /opt/envoy/envoy.yaml -l info --service-cluster proxy
```

### Test

```
docker run -d \
  --name=homeassistant \
  --net=host \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Europe/London \
  -p 8123:8123 `#optional` \
  -v /mnt/sgt2t/config/homeassistant/conf:/config \
  --restart unless-stopped \
  lscr.io/linuxserver/homeassistant
```