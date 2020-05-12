### Sealed Secrets

- Show and apply secret.yaml
- Show and apply application.yaml

- Add another secret using 

echo hemligt | kubeseal --raw --from-file=/dev/stdin --namespace 03-sealed-secrets --name mysecret

- Doesnt matter what the key is called... 