purple = aks-purple
yellow = aks-yellow
tools = aks-tools

get-contexts:
	az aks get-credentials --resource-group group-purple --name $(purple) --admin
	az aks get-credentials --resource-group group-yellow --name $(yellow) --admin
	az aks get-credentials --resource-group group-tools --name $(tools) --admin

delete-purple:
	kubectl config unset users.clusterAdmin_Group-Purple_aks-purple
	kubectl config unset contexts.aks-purple-admin
	kubectl config delete-cluster aks-purple

delete-yellow:
	kubectl config unset users.clusterAdmin_Group-Yellow_aks-yellow
	kubectl config unset contexts.aks-yellow-admin
	kubectl config delete-cluster aks-yellow

delete-tools:
	kubectl config unset users.clusterAdmin_Group-Tools_aks-tools
	kubectl config unset contexts.aks-tools-admin
	kubectl config delete-cluster aks-tools

infra: delete-purple delete-yellow delete-tools get-contexts

##------

sealed-secrets:
	kubectl apply -f private/sealed-secret-key.yaml --context aks-tools-admin
	kubectl apply -f private/sealed-secret-key.yaml --context aks-yellow-admin
	kubectl apply -f private/sealed-secret-key.yaml --context aks-purple-admin

argocd:
	kubectl create ns argocd --dry-run -o yaml | kubectl apply --context aks-tools-admin -f -
	kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/master/manifests/install.yaml --context aks-tools-admin
	kubectl apply -f clusters/tools/argocd/s1.yaml --context aks-tools-admin
	kubectl apply -f clusters/tools/argocd/s2.yaml --context aks-tools-admin
	kubectl apply -f clusters/tools/argocd/configmap.yaml --context aks-tools-admin

restart-argocd:
	kubectl delete pod -l app.kubernetes.io/name=argocd-server --context aks-tools-admin -n argocd

install-argocd: sealed-secrets argocd restart-argocd

##-----

cert-manager:
	kubectl apply --validate=false -f https://raw.githubusercontent.com/jetstack/cert-manager/release-0.11/deploy/manifests/00-crds.yaml --context aks-tools-admin
	kubectl apply --validate=false -f https://raw.githubusercontent.com/jetstack/cert-manager/release-0.11/deploy/manifests/00-crds.yaml --context aks-purple-admin
	kubectl apply --validate=false -f https://raw.githubusercontent.com/jetstack/cert-manager/release-0.11/deploy/manifests/00-crds.yaml --context aks-yellow-admin

projects:
	kubectl apply -f clusters/tools/argocd/aks-tools-project.yaml --context aks-tools-admin -n argocd

packages: cert-manager projects

##--- Wait for nginx to kick in...

ingress: 
	kubectl apply -f clusters/tools/argocd/ingress.yaml

##--- Wait for the cli to be able to connect to ArgoCd

login:
	argocd login argocd.matsiremark.com --insecure

## Doesnt work when its named clusters?!?!?!
clusters2:
	argocd cluster add aks-purple-admin
	argocd cluster add aks-yellow-admin
	kubectl apply -f clusters/tools/argocd/aks-yellow-project.yaml --context aks-tools-admin -n argocd
	kubectl apply -f clusters/tools/argocd/aks-purple-project.yaml --context aks-tools-admin -n argocd

##----

01-project:
	kubectl apply -f 01/apps-and-projects/project.yaml

01-apps:
	kubectl apply -f 01/apps-and-projects/apps.yaml

01-delete-apps:
	argocd app delete app1
	argocd app delete app2

01-delete-proj:
	argocd proj delete 01-apps

#-----

02-app:
	kubectl apply -f 02/app-of-apps/

02-delete-apps:
	argocd app delete app1
	argocd app delete app2
	argocd app delete app-of-apps
	
02-delete-proj:
	argocd proj delete 02-apps
	argocd proj delete app-of-apps

#-----

03-app:
	kubectl apply -f 03/app-of-apps/

03-delete-apps:
	argocd app delete app1
	argocd app delete app2
	argocd app delete app-of-apps

03-delete-proj:
	argocd proj delete 03-apps
	argocd proj delete app-of-apps

#----

05-app:
	kubectl apply -f 05/app-of-apps.yaml

05-delete-purple:
	kubectl delete ns -l demo=demo --context aks-purple-admin

05-delete-yellow:
	kubectl delete ns -l demo=demo --context aks-yellow-admin

05-delete-apps:
	argocd app delete demoapp-test
	argocd app delete demoapp-qa
	argocd app delete demoapp-prod
	argocd app delete demoapp2-test
	argocd app delete demoapp2-qa
	argocd app delete demoapp2-prod
	argocd app delete app-of-apps

05-delete-proj:
	argocd proj delete demoapp
	argocd proj delete demoapp2
	argocd proj delete app-of-apps