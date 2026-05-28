# Install Epinio

## Verify cert-manager is Ready

First, confirm that cert-manager (installed in the background) is running:

```bash
kubectl get pods -n cert-manager
```{{exec}}

All three pods should show `Running` status. If they are not ready yet, wait a moment and retry.

## Get the Node IP

Retrieve the internal IP of your node — Epinio uses this to set up its domain:

```bash
export NODE_IP=$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type=="InternalIP")].address}')
echo "Node IP: $NODE_IP"
```{{exec}}

## Install Epinio via Helm

Add the Epinio Helm repository and install Epinio:

```bash
helm repo add epinio https://epinio.github.io/helm-charts
helm repo update
```{{exec}}

Now install Epinio using your node's IP for the domain:

```bash
helm upgrade --install epinio epinio/epinio \
    --namespace epinio --create-namespace \
    --set global.domain="$NODE_IP.sslip.io" \
    --wait
```{{exec}}

This will take a few minutes. Epinio deploys several components including a container registry, build system, and ingress routing.

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
epinio login -u admin "https://epinio.$NODE_IP.sslip.io" --trust-ca
```{{exec}}

Verify the connection:

```bash
epinio settings show
```{{exec}}
