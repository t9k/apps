# Deploy [airbyte](https://airbyte.io/)

Build image `tsz.io/t9k/airbyte-webapp:0.32.5-alpha` according to https://github.com/t9k/airbyte/blob/master/README.md.

Deploy:

```bash
k apply -k kube/overlays/stable
```

Note what has been changed compared to original airbyte yamls in [this commit](https://github.com/t9k/apps/commit/4bbde71a6c2cfc2540e761f9c2cab1ef3f267e17).

Go to https://proxy.nc201.kube.tensorstack.net/apps/airbyte/ and enjoy!
