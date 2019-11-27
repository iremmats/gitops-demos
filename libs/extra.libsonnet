{
  Service(name): kube._Object('v1', 'Service', name) {
    local service = self,

    target_pod:: error 'service target_pod required',
    target_ports:: [],
    local default_port = service.target_pod.spec.containers[0].ports[0],

    ports:: (
      if std.length(service.target_ports) == 0 then
        [
          {
            name: default_port.name,
            port: default_port.containerPort,
            targetPort: default_port.containerPort,
          },
        ]
      else
        [
          {
            name: port.name,
            port: port.containerPort,
            targetPort: port.containerPort,
          }
          for port in std.flattenArrays(std.map(function(o) o.ports, service.target_pod.spec.containers))
          if std.count(service.target_ports, port.name) > 0
        ]
    ),

    spec: {
      selector: service.target_pod.metadata.labels,
      type: 'ClusterIP',
      ports: service.ports,
    },
  },
}
