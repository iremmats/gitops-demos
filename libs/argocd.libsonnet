local kube = import 'kube.libsonnet';

{
    Application(name, namespace = 'default'): kube._Object("argoproj.io/v1alpha1", "Application", name){
      local this = self,
      spec: {
            project: name,
            destination: {
                  namespace: namespace,
                  server: error "Spec/Destination/server must be set."
            },
            source : {
                path: error "Spec/Source/path must be set.",
                repoURL: error "Spec/Source/repoURL must be set.",
                targetRevision: 'HEAD'
            },
        },
    },
    
  AppProject(name, server, namespace = 'default'): kube._Object("argoproj.io/v1alpha1", "AppProject", name){
      local this = self,
      spec: {
            clusterResourceWhitelist: [
                {
                    group: '*',
                    kind: '*'
                }],
            description: name,
            destinations: [{
                server: server,
                namespace: namespace
            },],
            sourceRepos: []
        }
      },

  AppProjectOnlyName(name): kube._Object("argoproj.io/v1alpha1", "AppProject", name){
      local this = self,
      spec: {
            clusterResourceWhitelist: [
                {
                    group: '*',
                    kind: '*'
                }],
            description: name,
        }
      },
}