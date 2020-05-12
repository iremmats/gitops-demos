local kube = import 'kube.libsonnet';

local defaultReadinessProbe = {
  httpGet: { path: '/swagger/docs/overview/', port: 'http' },
  initialDelaySeconds: 5,
  periodSeconds: 5,
  timeoutSeconds: 3,
};

local defaultIngressAnnotations = {
  'kubernetes.io/ingress.class': 'nginx-external',
  'nginx.ingress.kubernetes.io/force-ssl-redirect': 'true',
  'ingress.kubernetes.io/ssl-redirect': 'true',
};

local certManagerIngressAnnotations = {
  'certmanager.k8s.io/cluster-issuer': 'letsencrypt-dns',
  'kubernetes.io/tls-acme': 'true',
  'certmanager.k8s.io/acme-dns01-provider': 'dns',
};

local envFromConfigMap(p) =
  if std.objectHas(p, 'data') then
    {
      envFrom+: [
        {
          configMapRef: {
            name: p.name,
          },
        },
      ],
    }
  else
    {};

local commonMetadata(p) = {
      metadata+: {
        labels+: {
          name: p.name,
          'company.io/team': p.team.name,
          'app.kubernetes.io/name': p.name,
        },
      },
    };

local envFromSecret(p) =
  if std.objectHas(p, 'encryptedData') then
    {
      envFrom+: [
        {
          secretRef: {
            name: p.name,
          },
        }
      ],
    }
  else
    {};

local envVars(p) =
  if std.objectHas(p, 'env') then
    {
      env_:: p.env,
    }
  else
    {};

local envFrom(p) = envFromConfigMap(p) + envFromSecret(p) + envVars(p) {
};

local Container(p) = kube.Container(p.name) + envFrom(p) {

  image: p.docker.image + ':' + p.docker.tag,
  ports_+: if std.objectHas(p, 'port') then {
    http: { containerPort: p.port },
  }
  else {},
  args: if std.objectHas(p, 'args') && std.isArray(p.args) then p.args else [],
  command: if std.objectHas(p, 'command') && std.isArray(p.command) then p.command else [],
  readinessProbe: if std.objectHas(p, 'readinessProbe') then defaultReadinessProbe + p.readinessProbe else defaultReadinessProbe,
};

{
  Deploy(p): {
      local outer = self,
    namespace: if std.objectHas(p, 'namespace') then kube.Namespace(p.namespace) + commonMetadata(p) else kube.Namespace(p.team.name + '-' + p.name + '-' + p.environment) + commonMetadata(p),
    deployment: kube.Deployment(p.name) {

      metadata+: {
        labels+: {
          app: p.name,
        },
      },
      spec+: {
        replicas: p.replicas,
        revisionHistoryLimit: 1,

        template+: {

          spec+: {
            containers_+: {
              default_container: Container(p),
            },
          },
        },
      },
    },
    configmap: kube.ConfigMap(p.name) +
               commonMetadata(p) {
                 data: p.data,
               },
    ingress: kube.Ingress(p.name) +
             commonMetadata(p) {
               local this = self,

               target_svc:: outer.service,

               metadata+: {
                 annotations+: defaultIngressAnnotations + certManagerIngressAnnotations,
               },

               spec+: {
                 tls: [
                   {
                     hosts: [rule.host],
                     secretName: '%s-tls' % [std.strReplace(rule.host, '.', '-')],
                   }
                   for rule in this.spec.rules
                 ],

                 // Default to single-service - override if you want something else.
                 rules: [
                   {
                     host: host,
                     http: {
                       paths: [
                         //{ path: '/', backend: ing.target_svc.name_port },
                         { path: '/', backend: this.target_svc.name_port },
                       ],
                     },
                   }
                   for host in p.hosts
                 ],
               },
             },
    service: kube.Service(p.name) + commonMetadata(p){
        target_pod:: outer.deployment.spec.template
  },

    //#horizontal auto scaling...
    //#networkpolicies...
    //#pod policies...
    //#custom stuff...
  },
}
