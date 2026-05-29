#!/usr/bin/env bash
set -e

# Cluster prerequisites for Epinio

echo "Installing Cert Manager..."
helm repo add cert-manager https://charts.jetstack.io
helm repo update
helm upgrade --install cert-manager --create-namespace -n cert-manager \
    --set crds.enabled=true \
    --set crds.keep=false \
    --set extraArgs[0]=--enable-certificate-owner-ref=true \
    cert-manager/cert-manager --version 1.18.1 \
    --wait

echo "Installing local-path storage provisioner..."
kubectl apply -f https://raw.githubusercontent.com/rancher/local-path-provisioner/master/deploy/local-path-storage.yaml
kubectl patch storageclass local-path -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'

echo "Installing nginx ingress (bare-metal: bind host ports 80/443)..."
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
helm upgrade --install ingress-nginx ingress-nginx/ingress-nginx \
    --namespace ingress-nginx \
    --create-namespace \
    --set controller.hostNetwork=true \
    --set controller.dnsPolicy=ClusterFirstWithHostNet \
    --set controller.service.type=ClusterIP \
    --set controller.ingressClassResource.default=true \
    --set controller.admissionWebhooks.enabled=false \
    --wait
