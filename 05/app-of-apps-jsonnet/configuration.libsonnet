local kube = import '../../libs/kube.libsonnet';
local argocd = import '../../libs/argocd.libsonnet';

local repo = 'git@github.com:iremmats/cloud-native-7.git';
local yellow = 'https://yellow-a2a4e2e7.hcp.westeurope.azmk8s.io:443';
local purple = 'https://purple-80a3fc0e.hcp.westeurope.azmk8s.io:443';

local defaultRepo = { spec+: { sourceRepos: [repo]}};
local namespace = {metadata+: {namespace: 'argocd'}};


### Change this to change placement of all applications.
local getActiveServer() = yellow;


local destinations = [
    {
        url : getActiveServer(),
        name: 'test'
    },
    {
        url : getActiveServer(),
        name: 'qa'
    },
    {
        url : getActiveServer(),
        name: 'prod'
    }];

local defaultDestinations(name) = {
    spec+: {
        destinations: [
            { namespace: name + '-' + item.name, server: item.url } for item in destinations
        ],
    }};

local getServerFromEnv(env) = std.filter(function(v) v.name == env , destinations);

{
    DemoApplication(name,path,envs) :
        [argocd.Application(name + '-' + item, 'argocd')  {
            
            ## Check so that applications follow naming standards for environments.
            assert std.length(std.filter(function(v) v == item, ['test','qa','prod'])) > 0,
            
            spec+: {
            destination+: {
                  server: getActiveServer(),
                  namespace: name + '-' + item
            },
            source : {
                path: path + '/' + item,
                repoURL: repo,
                targetRevision: 'HEAD'
            },
            project: name
        } + if std.startsWith(item,'prod') then {} else {syncPolicy: { automated: {}}} ,
        } for item in envs] + 
        [argocd.AppProjectOnlyName(name) + namespace + defaultDestinations(name) + defaultRepo] //+
        // [{} + kube.Namespace(name + '-' + env) for env in envs]
}