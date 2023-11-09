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
|  192.168.100.200  | gateway     | kube-public | ** ingress controller      |
|  192.168.100.220  | jellyfin    | prod        | macvlan for DLNA broadcast |


## DNS rewrites

Wildcard resolve `*.ak1pro.n1l.ro` to ingress svc private Ip globally
