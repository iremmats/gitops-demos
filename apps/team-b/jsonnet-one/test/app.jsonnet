local kube = import '../../../../libs/kube.libsonnet';
local app = import '../../../../libs/a-typical-application.libsonnet';
local p = import 'params.libsonnet';


local all = app.Deploy(p);

kube.List() {items_:: std.prune(all)}