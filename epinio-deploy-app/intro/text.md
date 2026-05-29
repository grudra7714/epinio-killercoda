# Deploy Your First App with Epinio

[Epinio](https://epinio.io/) takes you from application source code to a running URL in a single command. This scenario focuses on the developer workflow - no cluster setup required.

## What You Will Learn

In this scenario, you will:

1. **Deploy a sample application** from source code using `epinio push`
2. **Manage your application** - view logs, scale instances, and set environment variables
3. **Work with namespaces** to organize applications and clean up resources

## What Is Installing in the Background?

A script is installing the full Epinio stack. This usually takes **5-15 minutes** on Killercoda.

| Order | Component | Purpose |
|-------|-----------|---------|
| 1 | cert-manager | TLS certificates for Epinio and apps |
| 2 | local-path storage | Default `PersistentVolume` storage class |
| 3 | nginx ingress | Routes HTTP/HTTPS to Epinio and your apps |
| 4 | Epinio (Helm) | API server, registry, staging, Dex, UI |
| 5 | Epinio CLI + login | Pre-configured `admin` session |

Default login: user `admin`, password `password`.

You can move to **Step 1** anytime, but deploy commands will only work once Epinio pods are ready.

## While You Wait: Explore the Cluster

Run these in the terminal to see components come online. Re-run them every minute or two.

See the cluster node and runtime:

```bash
kubectl get nodes -o wide
```{{exec}}

Watch cert-manager start:

```bash
kubectl get pods -n cert-manager
```{{exec}}

Watch the ingress controller (needs `Running` before Epinio URLs work on port 443):

```bash
kubectl get pods -n ingress-nginx
```{{exec}}

Watch Epinio components appear (this namespace is created during the Helm install):

```bash
kubectl get pods -n epinio
```{{exec}}

List Helm releases when Epinio has been installed:

```bash
helm list -A
```{{exec}}

## Optional: Wait Until the Install Finishes

This loop prints status every 15 seconds until the background script creates `/var/run/epinio-ready`. Press **Ctrl+C** if you want to stop watching and check again later.

```bash
while ! test -f /var/run/epinio-ready 2>/dev/null; do
  echo "--- $(date +%H:%M:%S) install in progress ---"
  kubectl get pods -n epinio 2>/dev/null || echo "(epinio namespace not created yet)"
  sleep 15
done
echo "Epinio is ready. Continue to Step 1."
```{{exec}}

Quick readiness check (run anytime):

```bash
test -f /var/run/epinio-ready && echo "Ready" || echo "Still installing - explore the commands above"
```{{exec}}

## How Epinio Push Works (Preview)

You will use one command later; under the hood Epinio:

1. Uploads your source code to internal storage
2. Runs a **staging** job (Paketo buildpacks build a container image)
3. Pushes the image to Epinio's registry
4. Deploys the app and creates a route like `sample.<node-ip>.sslip.io`

More detail: [Epinio push process](https://docs.epinio.io/explanations/detailed-push-process).

When the background install is done (or Step 1 checks pass), continue to deploy your first app.
