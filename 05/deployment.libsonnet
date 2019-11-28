local kube = import '../libs/kube.libsonnet';

{
    Deploy(p) : {
      namespace: kube.Namespace(p.name + '-' + p.env){
        metadata+: {
          labels+: {
            demo: 'demo'
          },
        },
      },
        deployment: kube.Deployment(p.name) {
    
    metadata+: {
      labels+: {
        app: p.name,
      }
    },
    spec+: {
      replicas: p.replicas,
      revisionHistoryLimit: 3,
      strategy+: {
        type: 'RollingUpdate',
        rollingUpdate: {
          maxSurge: 0,
          maxUnavailable: 1,
        },
      },

      template+: {
        spec+: {
          containers_+: {
            default_container: kube.Container(p.name) {
              image: p.docker_image + ':' + p.docker_image_tag,
              resources: {
                limits: { cpu: '1' , memory: '1000Mi'},
                requests: { cpu: '100m' , memory: '200Mi' },
              },
              ports_+: {
                http: { containerPort: 80 },
              },
            },
          },
        },
      },
    },
  },
    }
}