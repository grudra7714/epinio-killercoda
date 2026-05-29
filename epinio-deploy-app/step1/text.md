# Deploy a Sample Application

If you explored the intro while the install ran, you may already see Epinio pods `Running`. Otherwise, confirm the stack is ready below (logged in as `admin`; password `password` if you need to log in again).

## Verify Epinio is Ready

Load the environment variables and check your Epinio connection:

```bash
source /etc/profile.d/epinio-env.sh
epinio settings show
```{{exec}}

Confirm Epinio pods are running:

```bash
kubectl get pods -n epinio
```{{exec}}

If `epinio settings show` fails, the background install may still be in progress. Wait a minute and try again.

If you see a client/server version mismatch warning, sync the CLI to the server:

```bash
epinio client-sync
epinio version
```{{exec}}

If you see `connection refused` on port 443, the ingress controller may still be starting:

```bash
kubectl get pods -n ingress-nginx
curl -k -sf "https://epinio.${EPINIO_SYSTEM_DOMAIN}" && echo "API reachable"
```{{exec}}

## Clone the Sample App

Epinio ships with a sample application:

```bash
git clone https://github.com/epinio/epinio.git /tmp/epinio-repo
```{{exec}}

## Push the Application

`epinio push` builds your app with Paketo buildpacks. On Killercoda this can take several minutes. A `504 Gateway Time-out` usually means nginx cut the connection off too early.

```bash
source /etc/profile.d/epinio-env.sh
export EPINIO_TIMEOUT_MULTIPLIER=2
```{{exec}}

Ensure the CLI matches the server (fixes `404` on `/deployments` when versions differ):

```bash
epinio client-sync
```{{exec}}

Deploy the sample app with a single command. Epinio uses **Paketo Buildpacks** to detect your language and build a container image - no Dockerfile needed. Use the Paketo `full` builder:

```bash
epinio push --name sample --path /tmp/epinio-repo/assets/sample-app --builder-image paketobuildpacks/builder:full
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

View detailed information:

```bash
epinio app show sample
```{{exec}}

## Access the Application

Epinio gives the app an **internal** route on your system domain (`<app-name>.<EPINIO_SYSTEM_DOMAIN>`), for example:

`sample.172.30.1.2.sslip.io`

The namespace (`workspace`) is not part of the hostname.

Get the exact route and test it from the terminal:

```bash
source /etc/profile.d/epinio-env.sh
echo "Expected route: sample.${EPINIO_SYSTEM_DOMAIN}"
export APP_URL=$(epinio app show sample | grep "Route:" | awk '{print $NF}' | head -1)
echo "Internal app URL: https://$APP_URL"
curl -k "https://$APP_URL"
```{{exec}}

You should see a response from the sample application.

## Expose the app on the internet (browser)

`https://sample.${EPINIO_SYSTEM_DOMAIN}` works inside this environment only. To reach the app from your browser, forward the app Service and use Killercoda **Traffic / Ports**:

```bash
kubectl port-forward -n workspace svc/sample 8080:80 >/tmp/sample-pf.log 2>&1 &
sleep 2
curl -sf http://127.0.0.1:8080 >/dev/null && echo "Port-forward OK"
```{{exec}}

Open:

- [Public URL on port 8080]({{TRAFFIC_HOST1_8080}}), or
- [Traffic / Ports]({{TRAFFIC_SELECTOR}}) → port **8080** → **Access**

```bash
echo "Public URL: $(sed 's/PORT/8080/g' /etc/killercoda/host)"
```{{exec}}

Tunneling port **443** alone usually fails because ingress expects `Host: sample.${EPINIO_SYSTEM_DOMAIN}`, not the Killercoda proxy hostname.
