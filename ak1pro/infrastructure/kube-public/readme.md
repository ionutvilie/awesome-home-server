# kube-public

## Deploy Envoy Gateway

- https://gateway.envoyproxy.io/latest/

Namespace: kube-public

```bash
# executed from the ak1pro host because microk8s already had helm
# envoy was generating some DNS warnings in k8s events so enable DNS in microk8s
microk8s enable dns
microk8s helm install envoy-gateway oci://docker.io/envoyproxy/gateway-helm \
--version v0.6.0 \
--namespace kube-public \
--create-namespace \
# --skip-crds
microk8s helm uninstall envoy-gateway -n kube-public
kubectl get svc -n kube-public  --selector=gateway.envoyproxy.io/owning-gateway-namespace=kube-public,gateway.envoyproxy.io/owning-gateway-name=envoy-gateway -o jsonpath='{.items[0].metadata.name}'
#   $ microk8s helm status envoy-gateway -n kube-public
#   $ microk8s helm get all envoy-gateway -n kube-public
#@TODO -  patch svc to use IP 192.168.100.200
```

## Deploy k8s GatewayClass/Gateway

```bash
kubectl apply -f ak1pro/kube-public/gateway.yaml
```

## Deploy k8s http-to-https HTTPRoute

```bash
kubectl apply -f ak1pro/kube-public/httproutes.yaml
```
