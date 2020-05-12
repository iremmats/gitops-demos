local kube = import '../../../../libs/kube.libsonnet';
local app = import '../../../../libs/a-typical-application.libsonnet';
local p = import 'params.libsonnet';

local h = app.Deploy(p);

h