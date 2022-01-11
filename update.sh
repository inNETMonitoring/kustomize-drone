#!/bin/bash

if [ ! -z ${PLUGIN_KUBERNETES_TOKEN} ]; then
  KUBERNETES_TOKEN=${PLUGIN_KUBERNETES_TOKEN}
else
  echo "WARNING: No kubernetes token found"
fi

if [ ! -z ${PLUGIN_KUBERNETES_SERVER} ]; then
  KUBERNETES_SERVER=${PLUGIN_KUBERNETES_SERVER}
fi

if [ ! -z ${PLUGIN_KUBERNETES_CERT} ]; then
  KUBERNETES_CERT=${PLUGIN_KUBERNETES_CERT}
fi

if [ ! -z ${PLUGIN_KUSTOMIZE_IMAGE} ]; then
  KUSTOMIZE_IMAGE=${PLUGIN_KUSTOMIZE_IMAGE}
fi

kubectl config set-credentials default --token=${KUBERNETES_TOKEN}
if [ ! -z ${KUBERNETES_CERT} ]; then
  echo "${KUBERNETES_CERT}" | base64 -d > ca.crt
  kubectl config set-cluster default --server=${KUBERNETES_SERVER} --certificate-authority=ca.crt
else
  echo "WARNING: Using insecure connection to cluster"
  kubectl config set-cluster default --server=${KUBERNETES_SERVER} --insecure-skip-tls-verify=true
fi

kubectl config set-context default --cluster=default --user=default
kubectl config use-context default

cd "${PLUGIN_KUSTOMIZE_DEFINITION}"

echo "Applying configuration in ${PLUGIN_KUSTOMIZE_DEFINITION}"
if [ ! -z ${KUSTOMIZE_IMAGE} ]; then
  kustomize edit set image ${PLUGIN_KUSTOMIZE_IMAGE}=${PLUGIN_IMAGE}:${PLUGIN_VERSION}
  echo "Set image ${PLUGIN_KUSTOMIZE_IMAGE} to ${PLUGIN_IMAGE}:${PLUGIN_VERSION}"
fi

kustomize build | kubectl apply -f -
