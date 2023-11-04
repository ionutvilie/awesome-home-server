# Runbooks

## Clean-up containerd

``` bash
# https://github.com/kubernetes-sigs/cri-tools/releases
curl -L -o crictl.tar.gz https://github.com/kubernetes-sigs/cri-tools/releases/download/v1.28.0/crictl-v1.28.0-linux-amd64.tar.gz
tar -xvf crictl.tar.gz -C ${HOME}/bin
rm  crictl.tar.gz
crictl -r unix:///var/snap/microk8s/common/run/containerd.sock rmi --prune
```
