# Travis-live: An advanced helm chart
This Helm chart provides Helm's powerful features for Travis-live.

This is a production-grade chart.

The chart installs a simple travis-live application according to the following pattern:

A ConfigMap is used to store the files the server will serve. (templates/configmap.yaml)
A Deployment is used to create a Replica Set of travis-live pods. (templates/deployment.yaml)
A Service is used to create a gateway to the pods running in the replica set (templates/service.yaml)
The values.yaml exposes a few of the configuration options in the charts, though there are some that are not exposed there (like .image).

The templates/_helpers.tpl file contains helper templates. The leading underscore (_) on the filename is semantic. It tells the template renderer that this file does not contain a manifest. That file declares some templates that are used elsewhere in the chart.

Helpers (usually called "partials" in template languages) are an advanced way for developers to structure their templates for optimal reuse.

You can deploy this chart with replicated helm.