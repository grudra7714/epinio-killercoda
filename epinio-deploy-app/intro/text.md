# Deploy Your First App with Epinio

[Epinio](https://epinio.io/) takes you from application source code to a running URL in a single command. This scenario focuses on the developer workflow - no cluster setup required.

## What You Will Learn

In this scenario, you will:

1. **Deploy a sample application** from source code using `epinio push`
2. **Manage your application** - view logs, scale instances, and set environment variables
3. **Work with namespaces** to organize applications and clean up resources

## Environment

A background script is installing and configuring everything Epinio needs:

- cert-manager, storage, and nginx ingress
- Epinio server (Helm)
- Epinio CLI and an authenticated session as `admin`

On first login, the default password is `password`. If you need to log in again manually, use `epinio login -u admin -p password <URL> --trust-ca`.

This can take several minutes. If a command fails because Epinio is not ready yet, wait and retry.

Let's deploy an app!
