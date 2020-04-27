# rclone dlna image build

https://github.com/rclone/rclone image built on Raspberry Pi 

```bash
docker build -t ionutvilie/rclone -f rclone.Dockerfile .
```

## Issues

TV is disconnecting after 5s or so if qbittorrent container is not working probably HDD is put to sleep by the OS. 
Did not investigate as qbittorrent is always on. 