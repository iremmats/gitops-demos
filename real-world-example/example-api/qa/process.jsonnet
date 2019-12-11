
local p = import 'params.libsonnet';
local api_with_ingress = import '../../../../libs/jsonnet/apilib.v3.libsonnet';
local kube = import '../../../../libs/jsonnet/kube.v3.libsonnet';

local all = api_with_ingress.ApiWithIngress(p);

kube.List() { items_+: all }