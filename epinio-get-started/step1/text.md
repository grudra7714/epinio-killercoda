# Install Epinio

These steps follow the Epinio Helm install from the [devcontainer setup script](https://github.com/epinio/epinio/blob/main/.devcontainer/setup.sh), adapted for this Killercoda Kubernetes environment.

## Verify Prerequisites

Confirm cert-manager is running:

```bash
kubectl get pods -n cert-manager
```{{exec}}

Confirm the default storage class is available:

```bash
kubectl get storageclass
```{{exec}}

You should see `local-path` marked as the default `(default)`.

Confirm the nginx ingress controller is running:

```bash
kubectl get pods -n ingress-nginx
```{{exec}}

If any components are not ready yet, wait a moment and retry.

## Set the Epinio Domain

Retrieve the node IP and set the system domain (the devcontainer uses `127.0.0.1.sslip.io`; here we use the node IP with sslip.io):

```bash
export NODE_IP=$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type=="InternalIP")].address}')
export EPINIO_SYSTEM_DOMAIN="${NODE_IP}.sslip.io"
echo "Epinio domain: ${EPINIO_SYSTEM_DOMAIN}"
```{{exec}}

## Install Epinio via Helm

Add the Epinio Helm repository:

```bash
helm repo add epinio https://epinio.github.io/helm-charts
helm repo update
```{{exec}}

Install Epinio with the same chart values as the official dev setup:

```bash
helm upgrade --install epinio epinio/epinio \
    --namespace epinio --create-namespace \
    --set global.domain="${EPINIO_SYSTEM_DOMAIN}" \
    --set server.disableTracking="true" \
    --set ingress.nginxSSLRedirect="false" \
    --set "extraEnv[0].name=KUBE_API_QPS" --set-string "extraEnv[0].value=50" \
    --set "extraEnv[1].name=KUBE_API_BURST" --set-string "extraEnv[1].value=100" \
    --wait
```{{exec}}

This will take a few minutes. Epinio deploys several components including a container registry, build system, and ingress routing.

Check that Epinio pods are running:

```bash
kubectl get all -n epinio
```{{exec}}

## Install the Epinio CLI

Download and install the Epinio CLI:

```bash
curl -o epinio -L https://github.com/epinio/epinio/releases/latest/download/epinio-linux-x86_64
chmod +x epinio
mv epinio /usr/local/bin/
```{{exec}}

## Log In to Epinio

Log in to your Epinio installation:

```bash
epinio login -u admin "https://epinio.${EPINIO_SYSTEM_DOMAIN}" --trust-ca
```{{exec}}

Verify the connection:

```bash
epinio settings show
```{{exec}}
