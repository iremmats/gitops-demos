# cloud-native-7
Demo during meetup Cloud Native 7 in Gothenburg

## Useful Links

- ArgoCD: https://argocd.matsiremark.com
- Azure Devops: https://dev.azure.com/iremark-consulting/cloud-native-7-demo
- GitHub code: https://github.com/iremmats/azure-devops-demo
- GitHub pipelines: https://github.com/iremmats/azure-devops-templates

## Steps to replicate

## Create three clusters using terraform.

```
terraform apply
```

## Retrieve contexts

```
make get-contexts
```

Or if you have the same contexts before...

```
make infra
```

## Install argocd and sealed-secrets

```
make install-argocd
```

Packages

```
make packages
```

Ingress for argocd

```
make ingress
```

Wait for domain to propagate

```
make argocd-login
```



To generate secrets 
k create secret generic azuredns -n kube-system --dry-run --from-file azure.json -o json | kubeseal
k create secret generic azuredns -n kube-system --dry-run --from-file s.yaml -o json | kubeseal