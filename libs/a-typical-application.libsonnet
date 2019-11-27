local kube = import 'kube.libsonnet';

{
    Deploy(p) : {
        deployment: {},
        configmap: {},
        ingress: {},
        service: {},

        ##horizontal auto scaling...
        ##networkpolicies...
        ##pod policies...
        ##custom stuff...
    },
}