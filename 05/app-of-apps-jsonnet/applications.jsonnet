local kube = import '../../libs/kube.libsonnet';
local configuration = import 'configuration.libsonnet';
local apps = import 'apps.libsonnet';

local inOnlyTest = ['test'];
local inTestAndQa = ['test','qa'];
local inProduction = ['test','qa','prod'];

local basePath = '05/';

// local all = [   
//     configuration.DemoApplication(name = 'app1', path = basePath + 'app1', envs = inProduction),
//     configuration.DemoApplication(name = 'app2', path = basePath + 'app2', envs = inProduction),
//     configuration.DemoApplication(name = 'app3', path = basePath + 'app3', envs = inTestAndQa)
//  ];

//configuration.DemoApplication(name = 'hej', path = basePath + 'hej', envs = ['test','qa']) + configuration.DemoApplication(name = 'hej2', path = basePath + 'hej2', envs = ['test','qa']) 
local newAll = [] + [configuration.DemoApplication(name = app.name, path = basePath + app.path, envs = app.envs) for app in apps];
// local newAll = configuration.DemoApplication(name = app.name, path = basePath + app.path, envs = app.envs)] for app in apps;
    

kube.List() {items+: std.flattenArrays(newAll)}
