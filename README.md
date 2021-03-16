# ark-cluster helm chart

## How It Works
### Requirements for Kubernetes
* ARK communicates its port to the client, thus the external port must be identical to the port where the ARK pod is listening.
* Required persistent volumes:
  * one volume for each server (mounted as `/ark`)
  * one volume for the shared cluster files (mounted as `/arkclusters`)
  * one volume for the shared server (game) files (the biggest volume) to save space (mounted as `/arkserver`)

### Installation
First start ONE server, he should also have all mods configured that you want to use

Start the server with the following settings:
```yaml
servers:
  - name: extinction
    updateOnStart: true
    mods: [ "889745138", "731604991", ... ]
```

TODO: publish chart to https://artifacthub.io/
```shell script
# git clone https://github.com/DrPsychick/ark-cluster-chart.git
helm dependency update ark-cluster-chart
helm chart save ark-cluster-chart ark-cluster-chart
helm upgrade --create-namespace --install --values values.yaml arkcluster1 ark-cluster-chart
```

This will download and install ark server and modules.

### Clustering
Minimal definition of a server:
```yaml
servers:
  - name: extinction
    map: Extinction
```
If you only have 1 public IP address available, you **must** set ports for each server:
```yaml
servers:
  - name: extinction
    ports:
      queryudp: 27015
      gameudp: 7770
      rcon: 32330
```

### Shared Server Files
TODO: make this optional!

Server files are shared across multiple ARK instances of the cluster
```yaml
extraEnvVars:
  - name: am_arkStagingDir
    value:
  - name: ARKSERVER_SHARED
    value: /arkserver
``` 

