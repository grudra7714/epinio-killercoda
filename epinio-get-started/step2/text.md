# Deploy a Sample Application

Now that Epinio is installed, let's deploy an application from source code. Epinio uses **Paketo Buildpacks** to automatically detect your language and build a container image - no Dockerfile needed.

## Clone the Sample App

Epinio ships with a sample application. Let's grab it:

```bash
git clone https://github.com/epinio/epinio.git /tmp/epinio-repo
```{{exec}}

## Push the Application

`epinio push` builds your app with Paketo buildpacks. On Killercoda this can take several minutes. A `504 Gateway Time-out` usually means nginx cut the connection off too early (fixed by longer proxy timeouts in the install step).

Give the CLI more time while you wait:

```bash
export EPINIO_TIMEOUT_MULTIPLIER=2
```{{exec}}

Ensure the CLI matches the server (fixes `404` on `/deployments` when versions differ):

```bash
epinio client-sync
```{{exec}}

Deploy the sample app with a single command. Use the Paketo `base` builder (a good default between `tiny` and `full`):

```bash
epinio push --name sample --path /tmp/epinio-repo/assets/sample-app --builder-image paketobuildpacks/builder:base
```{{exec}}

This command:
- Uploads your source code to Epinio
- Uses buildpacks to detect the language and create a container image
- Deploys the container to Kubernetes
- Sets up ingress routing with a URL

## Verify the Deployment

Check that your application is running:

```bash
epinio app list
```{{exec}}

You should see the `sample` app with status `1/1` and a route URL.

View detailed information about the app:

```bash
epinio app show sample
```{{exec}}

## Access the Application

Epinio gives the app an **internal** route on your system domain (`<app-name>.<EPINIO_SYSTEM_DOMAIN>`), for example:

`sample.172.30.1.2.sslip.io`

The namespace (`workspace`) is not part of the hostname. sslip.io embeds the node IP in the domain so traffic reaches the cluster ingress.

Get the exact route and test it from the terminal (this works inside Killercoda):

```bash
echo "Expected route: sample.${EPINIO_SYSTEM_DOMAIN}"
export APP_URL=$(epinio app show sample | grep "Route:" | awk '{print $NF}' | head -1)
echo "Internal app URL: https://$APP_URL"
curl -k "https://$APP_URL"
```{{exec}}

You should see a response from the sample application.

## Expose the app on the internet (browser)

The route `https://sample.${EPINIO_SYSTEM_DOMAIN}` only works **inside** Killercoda (it resolves to `172.30.1.2`). Your laptop cannot open that hostname directly.

Killercoda can tunnel a **port** on the VM to a public URL ([Traffic / Ports](https://killercoda.com/creators)). Use **port-forward** so the browser does not need the sslip.io hostname:

```bash
kubectl port-forward -n workspace svc/sample 8080:80 >/tmp/sample-pf.log 2>&1 &
sleep 2
curl -sf http://127.0.0.1:8080 >/dev/null && echo "Port-forward OK"
```{{exec}}

Open the app in your browser:

- [Public URL on port 8080]({{TRAFFIC_HOST1_8080}}), or
- **Traffic / Ports** (top right) → host **1** → port **8080** → **Access**

To print the same link in the terminal:

```bash
echo "Public URL: $(sed 's/PORT/8080/g' /etc/killercoda/host)"
```{{exec}}

**Why not tunnel port 443?** Ingress routes by `Host` (for example `sample.172.30.1.2.sslip.io`). The Killercoda proxy URL uses a different hostname, so HTTPS on 443 often fails unless you add a browser extension to set the `Host` header to `$APP_URL`.
