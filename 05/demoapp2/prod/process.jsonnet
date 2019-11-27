local kube = import '../../../libs/kube.libsonnet';
local p = import 'params.libsonnet';
local globals = import '../globals.libsonnet';
local d = import '../../deployment.libsonnet';

local all = d.Deploy(globals + p);

kube.List(){items_+: all}