# cert-manager

## Install Cert-Manager

- https://cert-manager.io/docs/installation/kubectl/#steps

```bash
# kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.13.2/cert-manager.yaml
kubectl apply -k ak1pro/cert-manager
```

## ClusterIssuers

Cloudflare ACME DNS01 Challenge

- https://cert-manager.io/docs/configuration/acme/dns01/cloudflare/#api-tokens

```bash
# find me in a bw note :)
export BWS_ACCESS_TOKEN=<>
export CLOUDFLARE_API_TOKEN_SECRET_NAME=<>
kubectl -n cert-manager  create secret generic cloudflare-api-token-secret \
--from-literal=api-token=$(bws secret get ${CLOUDFLARE_API_TOKEN_SECRET_NAME} | jq -r '.value')  \
--dry-run=client -o yaml

kubectl apply -f ak1pro/cert-manager/ClusterIssuer.yaml
```

## Certificates

Certificates config is in kube public folder/namespace.
Te certificate is ordered with a wildcard an configured on the Gateway (envoy-gateway).

```bash
kubectl apply -f ak1pro/kube-public/certificate.yaml
```

## DNS Checks

check Cloudflare DNS propagation issues
`propagation check failed" err="DNS record for \"ak1pro.n1l.ro\" not yet propagated`

```bash
dig -t txt _acme-challenge.ak1pro.n1l.ro
dig @8.8.8.8 -t txt _acme-challenge.ak1pro.n1l.ro
dig @1.1.1.1 -t txt _acme-challenge.ak1pro.n1l.ro
```
