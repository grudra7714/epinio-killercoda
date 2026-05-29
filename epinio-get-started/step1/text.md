# Install Epinio

Install Epinio on this Kubernetes cluster using Helm and the Epinio CLI.

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

Retrieve the node IP and set the system domain (wildcard DNS via sslip.io):

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

Install Epinio (pin the chart version so it matches the CLI):

```bash
export EPINIO_VERSION="1.14.0-rc5"
helm upgrade --install epinio epinio/epinio --version "${EPINIO_VERSION}" \
    --namespace epinio --create-namespace \
    --set global.domain="${EPINIO_SYSTEM_DOMAIN}" \
    --set server.disableTracking="true" \
    --set ingress.nginxSSLRedirect="false" \
    --set ingress.proxyReadTimeout=1800s \
    --set ingress.proxyConnectTimeout=300s \
    --set server.timeoutMultiplier=2 \
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

Download and install the Epinio CLI (same version as the server):

```bash
curl -o epinio -L "https://github.com/epinio/epinio/releases/download/v${EPINIO_VERSION}/epinio-linux-x86_64"
chmod +x epinio
mv epinio /usr/local/bin/
epinio version
```{{exec}}

## Log In to Epinio

On first login, Epinio provides a default `admin` user with password `password`. Change these credentials in production.

Confirm the Epinio API is reachable on port 443 (sslip.io resolves to your node IP):

```bash
curl -k -sf "https://epinio.${EPINIO_SYSTEM_DOMAIN}" && echo "API reachable"
```{{exec}}

If you see `connection refused`, wait for the ingress controller to finish starting (`kubectl get pods -n ingress-nginx`) and retry.

Log in to your Epinio installation:

```bash
epinio login -u admin -p password "https://epinio.${EPINIO_SYSTEM_DOMAIN}" --trust-ca
epinio client-sync
```{{exec}}

Verify the connection and that client/server versions match:

```bash
epinio version
epinio settings show
```{{exec}}
