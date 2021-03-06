# cloud-native-7
Demo during meetup Cloud Native 7 in Gothenburg

## Useful Links

- ArgoCD: https://argocd.matsiremark.com
- ArgoCD: https://github.com/argoproj/argo-cd
- Azure Devops: https://dev.azure.com/iremark-consulting/cloud-native-7-demo
- GitHub code: https://github.com/iremmats/azure-devops-demo
- GitHub pipelines: https://github.com/iremmats/azure-devops-templates
- Sealed Secrets:  https://github.com/bitnami-labs/sealed-secrets
- Bitnami kube.libsonnet: https://github.com/bitnami-labs/kube-libsonnet
- Jsonnet styleguide: https://github.com/databricks/jsonnet-style-guide

- Kubecon videos
  -  ArgoCD workshop: https://www.youtube.com/watch?v=r50tRQjisxw​
  -  Reddit: https://www.youtube.com/watch?v=WTbIBqNcjoQ​
  -  Cern (helm and Flux helm-operator): https://www.youtube.com/watch?v=g9FQxzK9E_M

## Steps to replicate

### Create three clusters using terraform.

```
terraform apply
```

### Retrieve contexts

```
make get-contexts
```

Or if you have the same contexts before...

```
make infra
```

### Install argocd and sealed-secrets

```
make install-argocd
```
This requires that you have a key pair under a folder named private.

Packages

```
make packages
```

Once nginx is up and running the ingress for ArgoCD can be installed.

```
make ingress
```

Wait for domain to propagate and login with ArgoCD cli.

```
make login
```

Add the clusters to argocd and create the necessary projects.

```
make clusters2
```

### Run the actual demos.
Check the Makefile for steps for each demo. 