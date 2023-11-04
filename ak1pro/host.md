# Host

- Model: Mini PC NIPOGI-AK1 Pro
- Architecture: amd64
- OS: Ubuntu

## External Storage

Mount Samsung 2T SSD as explained <a href="https://www.techrepublic.com/article/how-to-properly-automount-a-drive-in-ubuntu-linux/">here</a>

```bash
mkdir -p /mnt/smg2t
# `fdisk -l` and `blkid` for the the uuid
sudo vim /etc/fstab # and append below line
UUID=f962d525-0f83-4947-a2c5-42f525033fda /mnt/smg2t ext4    errors=remount-ro,auto,exec,rw,user 0       0
```

## IP Allocation

- metallb 192.168.100.200-192.168.100.220
- multus  192.168.100.220-192.168.100.230

| Ip                | Pod         | Ns          | Obs                        |
| ----------------- | ----------- | ----------- | -------------------------- |
|  192.168.100.200  | -------     | kube-public | ** ingress controller      |
|  192.168.100.202  | dashboard   | kube-system | kubernetes-dashboard       |
|  192.168.100.210  | jellyfin    | prod        | webui                      |
|  192.168.100.211  | qbittorrent | prod        | webui                      |
|  192.168.100.212  | jellyfin    | staging     | webui                      |
|  192.168.100.213  | qbittorrent | staging     | webui                      |
|                   |             |             |                            |
|  192.168.100.220  | jellyfin    | prod        | macvlan for DLNA broadcast |


## DNS rewrites

Wildcard resolve `*.ak1pro.n1l.ro` to ingress svc private Ip globally

If you read this, it is not used in the config but it works
as long as other DNS does not rewrite the DNS local query

| FQDN                         | Ip                | service      | DNS            |
| ---------------------------- | ----------------- | ------------ | -------------- |
| `*.stable.local`             | 192.168.100.200   | service      | ADGUARD        |
| `*.staging.local`            | 192.168.100.200   | service      | ADGUARD        |
| `jellyfin.stable.local`      | 192.168.100.200   | service      | Gateway        |
| `jellyfin.staging.local`	   | 192.168.100.200   | service      | Gateway        |
| `qbittorrent.staging.local`  | 192.168.100.200   | qbittorrent  | Gateway        |
| `qbittorrent.stable.local`   | 192.168.100.200   | qbittorrent  | Gateway        |
