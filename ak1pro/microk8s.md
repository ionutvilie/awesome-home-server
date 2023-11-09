# microk8s (Kubernetes)

```bash
# install
snap install microk8s --classic --channel=1.28/stable
# Update
sudo snap refresh microk8s --channel=1.28/stable
```

## microk8s addons

### MetalLB

```bash
# kubernetes metallb
microk8s enable metallb:192.168.100.200-192.168.100.220
```

### Multus

For Jellyfin's DLNA Broadcast

```bash
# microk8s enable multus
microk8s enable community
microk8s enable multus
microk8s kubectl apply -f ak1pro/infrastructure/microk8s-config/network-attach-def.yaml
```

### HostPath Storage

```bash
# HostPath Storage
microk8s enable hostpath-storage
microk8s kubectl apply -f ak1pro/infrastructure/microk8s-config/storage-class.yaml
```

### K8s Gateway-Api

```bash
## Gateway API
# https://github.com/envoyproxy/gateway/tree/main/charts/gateway-helm
# kubectl apply -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.0.0/standard-install.yaml
microk8s enable dns
microk8s helm install envoy-gateway oci://docker.io/envoyproxy/gateway-helm \
--version v0.6.0 \
--namespace kube-public \
--create-namespace
# --skip-crds
microk8s helm uninstall envoy-gateway -n kube-public
kubectl get svc -n kube-public  --selector=gateway.envoyproxy.io/owning-gateway-namespace=kube-public,gateway.envoyproxy.io/owning-gateway-name=envoy-gateway -o jsonpath='{.items[0].metadata.name}'

#   $ microk8s helm status envoy-gateway -n envoy-gateway
#   $ microk8s helm get all envoy-gateway -n envoy-gateway
```

### Dashboard

```bash
# kubernetes dashboard
# https://vividcode.io/disable-authentication-and-https-in-kubernetes-dashboard/
# microk8s enable dashboard
# microk8s kubectl patch service kubernetes-dashboard -n kube-system --type merge --patch  '{"spec" : {"type":"LoadBalancer","loadBalancerIP": "192.168.100.202"}}'
# microk8s kubectl -n kube-system get secret microk8s-dashboard-token -o jsonpath="{.data.token}" | base64 --decode && echo

# Add kubernetes-dashboard repository
helm repo add kubernetes-dashboard https://kubernetes.github.io/dashboard/
helm search repo kubernetes-dashboard/kubernetes-dashboard --versions
# Deploy a Helm Release named "kubernetes-dashboard" using the kubernetes-dashboard chart
helm upgrade --install kubernetes-dashboard kubernetes-dashboard/kubernetes-dashboard \
--namespace kube-system \
--values=ak1pro/infrastructure/microk8s-config/kubernetes-dashboard/values.yaml \
--version=6.0.8 --dry-run

# create HTTP Route
kubectl apply -f ak1pro/infrastructure/microk8s-config/k8s-dash-httproute.yaml
kubectl patch ns kube-system --type='json' \
-p='[{"op": "add", "path": "/metadata/labels/shared-gateway-access", "value": "true"}]'

```

### CertManager

documented in ak1pro/cert-manager/readme.md
