# Deploy a Sample Application

Now that Epinio is installed, let's deploy an application from source code. Epinio uses **Paketo Buildpacks** to automatically detect your language and build a container image - no Dockerfile needed.

## Clone the Sample App

Epinio ships with a sample application. Let's grab it:

```bash
git clone https://github.com/epinio/epinio.git /tmp/epinio-repo
```{{exec}}

## Push the Application

Deploy the sample app with a single command:

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

View detailed information about the app:

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
