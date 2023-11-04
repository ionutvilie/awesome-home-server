# Readme

MicroK8s config for Home Server.

- [HostConfig](host.md)
- [MicroK8s](microk8s.md)
- [Runbooks](runbooks.md)

## Apps

- <a href="https://homarr.dev/">Homar</a>
- <a href="https://www.qbittorrent.org/">qBittorrent</a>
- <a href="https://jellyfin.org/">Jellyfin</a>
- <a href="https://filebrowser.org/">FileBrowser</a>

## Deploy

### prod

```bash
kubectl apply -k ak1pro/prod
```

### staging

```bash
kubectl apply -k ak1pro/staging
```

## ToDo
