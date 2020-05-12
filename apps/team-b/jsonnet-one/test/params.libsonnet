{
    team: {
        name: 'team-b'
    },
    name: 'jsonnet-one',
    docker: {
        image: 'tutum/hello-world',
        tag: 'latest'
    },
    replicas: 1,
    environment: 'test',

    env: {
        KEY: 'value',
        ANOTHER_KEY: 'another_value'
    },

    port: 80,

    data: {
        key_in_configmap: 'value_in_configmap'
    },

    hosts: [
        'jsonnet-one-test.matsiremark.com'
    ],
}