#!/bin/bash

kubectl get namespace epinio > /dev/null 2>&1 \
  && kubectl get pods -n ingress-nginx -l app.kubernetes.io/component=controller 2>/dev/null | grep -q Running \
  && epinio settings show > /dev/null 2>&1
