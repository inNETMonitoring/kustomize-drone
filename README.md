# Kustomize drone

This plugins allows to update a Kubernetes deployment using [Kustomize](https://kustomize.io/).

## Usage

This pipeline will apply the `kustomization.yaml` in `overlays/testing`:

```
- name: deploy
  image: innetmonitoring/kustomize-drone
  settings:
    kubernetes_token:
      from_secret: kubernetes-key
    kubernetes_cert:
        from_secret: kubernetes-cert
    kubernetes_server: https://kubernetes.server
    kustomize_definition: overlays/testing
```

It is further possible to update an image before applying the `kustomization.yaml`:

```
- name: deploy
  image: innetmonitoring/kustomize-drone
  settings:
    kubernetes_token:
      from_secret: kubernetes-key
    kubernetes_cert:
        from_secret: kubernetes-cert
    kubernetes_server: https://kubernetes.server
    kustomize_definition: overlays/testing
    kustomize_image: MY-APP
    image: hello-world
    version: latest
```

The above pipeline will update the MY-APP image defined in your kubernetes resources using the `kustomize edit set image` command.

## Required Secrets/Kubernetes tokens

A service account having `get`, `update`, `patch` and `create` access on the resources defined in your `kustomization.yanl` is required.

The `kubernetes_cert` is required to be a base64 encoded string.

## Special thanks

Inspired by [drone-kubernetes](https://github.com/honestbee/drone-kubernetes).
