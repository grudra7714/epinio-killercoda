# Epinio - From App to URL in One Step

[Epinio](https://epinio.io/) is an application development engine for Kubernetes. It takes you from application source code to a running URL in a single command, without needing to understand Kubernetes internals.

## What You Will Learn

In this scenario, you will:

1. **Install Epinio** on a Kubernetes cluster using Helm
2. **Deploy a sample application** from source code using `epinio push`
3. **Manage your application** - view logs, scale instances, and inspect details
4. **Work with namespaces** to organize your applications

## Prerequisites

This environment provides a single-node Kubernetes cluster with `kubectl` and `helm` pre-installed.

A background script is installing the cluster prerequisites Epinio expects:

- **cert-manager** (TLS certificates)
- **local-path-provisioner** (default storage class)
- **nginx ingress controller** (routing)

This may take several minutes to complete.

When you log in to Epinio for the first time, use the default credentials: user `admin`, password `password`.

Let's get started!
