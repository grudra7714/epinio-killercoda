#!/usr/bin/env bash
set -e

# Full Epinio install (aligned with epinio/.devcontainer/setup.sh)
# https://github.com/epinio/epinio/blob/main/.devcontainer/setup.sh

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

NODE_IP=$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type=="InternalIP")].address}')
export EPINIO_SYSTEM_DOMAIN="${NODE_IP}.sslip.io"

cat > /etc/profile.d/epinio-env.sh <<EOF
export NODE_IP="${NODE_IP}"
export EPINIO_SYSTEM_DOMAIN="${EPINIO_SYSTEM_DOMAIN}"
EOF

echo "Installing Epinio..."
helm repo add epinio https://epinio.github.io/helm-charts
helm repo update
helm upgrade --install epinio epinio/epinio \
    --namespace epinio --create-namespace \
    --set global.domain="${EPINIO_SYSTEM_DOMAIN}" \
    --set server.disableTracking="true" \
    --set ingress.nginxSSLRedirect="false" \
    --set "extraEnv[0].name=KUBE_API_QPS" --set-string "extraEnv[0].value=50" \
    --set "extraEnv[1].name=KUBE_API_BURST" --set-string "extraEnv[1].value=100" \
    --wait

echo "Installing Epinio CLI..."
curl -fsSL -o /tmp/epinio https://github.com/epinio/epinio/releases/latest/download/epinio-linux-x86_64
chmod +x /tmp/epinio
mv /tmp/epinio /usr/local/bin/epinio

echo "Waiting for Epinio API on port 443..."
for i in $(seq 1 60); do
  if curl -k -sf --connect-timeout 3 "https://epinio.${EPINIO_SYSTEM_DOMAIN}" >/dev/null 2>&1; then
    break
  fi
  echo "  not ready yet (${i}/60)..."
  sleep 10
done

echo "Logging in to Epinio..."
epinio login -u admin "https://epinio.${EPINIO_SYSTEM_DOMAIN}" --trust-ca

touch /var/run/epinio-ready
echo "Epinio is ready at https://epinio.${EPINIO_SYSTEM_DOMAIN}"
