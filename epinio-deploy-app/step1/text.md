# Deploy a Sample Application

Epinio is installed and configured in the background. Let's confirm it is ready, then deploy an application.

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

Deploy the sample app with a single command. Epinio uses **Paketo Buildpacks** to detect your language and build a container image - no Dockerfile needed.

```bash
epinio push --name sample --path /tmp/epinio-repo/assets/sample-app
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

Get the application URL and test it:

```bash
export APP_URL=$(epinio app show sample | grep "Route:" | awk '{print $NF}' | head -1)
echo "App URL: https://$APP_URL"
curl -k "https://$APP_URL"
```{{exec}}

You should see a response from the sample application.
