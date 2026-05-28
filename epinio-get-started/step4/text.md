# Namespaces and Cleanup

Epinio uses **namespaces** to organize applications, similar to Kubernetes namespaces but managed at the Epinio level.

## List Namespaces

View existing namespaces:

```bash
epinio namespace list
```{{exec}}

You should see the default `workspace` namespace.

## Create a New Namespace

Create a namespace for a separate project:

```bash
epinio namespace create production
```{{exec}}

## Target the New Namespace

Switch your CLI context to the new namespace:

```bash
epinio target production
```{{exec}}

Verify the target:

```bash
epinio target
```{{exec}}

## Deploy to the New Namespace

Deploy another instance of the sample app in the production namespace:

```bash
epinio push --name sample-prod --path /tmp/epinio-repo/assets/sample-app
```{{exec}}

Now list apps — you'll only see apps in the current namespace:

```bash
epinio app list
```{{exec}}

## Switch Back and Clean Up

Switch back to the default workspace:

```bash
epinio target workspace
```{{exec}}

Delete the sample app from the workspace namespace:

```bash
epinio app delete sample
```{{exec}}

Switch to production and delete the app there too:

```bash
epinio target production
epinio app delete sample-prod
```{{exec}}

Delete the production namespace:

```bash
epinio namespace delete production
```{{exec}}
