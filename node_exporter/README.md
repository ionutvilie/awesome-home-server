# Node Exporter 

Install Prometheus Node Exporter 

```bash
# download node_exporter
curl -L https://github.com/prometheus/node_exporter/releases/download/v1.0.0-rc.0/node_exporter-1.0.0-rc.0.linux-arm64.tar.gz -o node_exporter-1.0.0-rc.0.linux-arm64.tar.gz
# deploy in /opt/node_exporter
sudo mkdir /opt/node_exporter/
sudo cp node_exporter*/node_exporter /opt/node_exporter/
sudo useradd --system node_exporter # not sure if it is necessary
```

## systemd service

Deploy as systemd service. Docker container version requires many volumes to be mounted inside the container.. got bored gave up !

- Create the service file: `/etc/systemd/system/node_exporter.service`
- create the env file    : `/opt/node_exporter/env` (empty or not it needs to be there)  

```bash
sudo systemctl daemon-reload           # 
sudo systemctl start node_exporter     # start the service
sudo systemctl status node_exporter    # verify it is running
sudo systemctl enable node_exporter    # enable it to start up on boot
```