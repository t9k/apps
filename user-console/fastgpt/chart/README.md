# fastgpt

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: v4.6.6](https://img.shields.io/badge/AppVersion-v4.6.6-informational?style=flat-square)

A Helm chart for FastGPT

## Requirements

| Repository                               | Name       | Version |
| ---------------------------------------- | ---------- | ------- |
| oci://registry-1.docker.io/bitnamicharts | mongodb    | 15.0.1  |
| oci://registry-1.docker.io/bitnamicharts | postgresql | 15.0.0  |

## Values

| Key                                                | Type   | Default                     | Description                                                                                                                            |
| -------------------------------------------------- | ------ | --------------------------- | -------------------------------------------------------------------------------------------------------------------------------------- |
| affinity                                           | object | `{}`                        |                                                                                                                                        |
| autoscaling.enabled                                | bool   | `false`                     |                                                                                                                                        |
| autoscaling.maxReplicas                            | int    | `100`                       |                                                                                                                                        |
| autoscaling.minReplicas                            | int    | `1`                         |                                                                                                                                        |
| autoscaling.targetCPUUtilizationPercentage         | int    | `80`                        |                                                                                                                                        |
| fullnameOverride                                   | string | `""`                        |                                                                                                                                        |
| image.pullPolicy                                   | string | `"IfNotPresent"`            |                                                                                                                                        |
| image.repository                                   | string | `"ghcr.io/labring/fastgpt"` |                                                                                                                                        |
| image.tag                                          | string | `""`                        |                                                                                                                                        |
| imagePullSecrets                                   | list   | `[]`                        |                                                                                                                                        |
| ingress.annotations                                | object | `{}`                        |                                                                                                                                        |
| ingress.className                                  | string | `""`                        |                                                                                                                                        |
| ingress.enabled                                    | bool   | `false`                     |                                                                                                                                        |
| ingress.hosts[0].host                              | string | `"chart-example.local"`     |                                                                                                                                        |
| ingress.hosts[0].paths[0].path                     | string | `"/"`                       |                                                                                                                                        |
| ingress.hosts[0].paths[0].pathType                 | string | `"ImplementationSpecific"`  |                                                                                                                                        |
| ingress.tls                                        | list   | `[]`                        |                                                                                                                                        |
| livenessProbe.httpGet.path                         | string | `"/"`                       |                                                                                                                                        |
| livenessProbe.httpGet.port                         | string | `"http"`                    |                                                                                                                                        |
| mongodb.architecture                               | string | `"replicaset"`              |                                                                                                                                        |
| mongodb.auth.rootPassword                          | string | `"123456"`                  |                                                                                                                                        |
| mongodb.auth.rootUser                              | string | `"root"`                    |                                                                                                                                        |
| mongodb.enabled                                    | bool   | `true`                      | Enable or disable the built-in MangoDB                                                                                                 |
| nameOverride                                       | string | `""`                        |                                                                                                                                        |
| nodeSelector                                       | object | `{}`                        |                                                                                                                                        |
| podAnnotations                                     | object | `{}`                        |                                                                                                                                        |
| podLabels                                          | object | `{}`                        |                                                                                                                                        |
| podSecurityContext                                 | object | `{}`                        |                                                                                                                                        |
| postgresql.enabled                                 | bool   | `true`                      | Enable or disable the built-in PostgreSQL                                                                                              |
| postgresql.global.postgresql.auth.database         | string | `"postgres"`                | The default database of PostgreSQL                                                                                                     |
| postgresql.global.postgresql.auth.postgresPassword | string | `"postgres"`                | The password of PostgreSQL, default username is `postgres`                                                                             |
| postgresql.image.repository                        | string | `"linuxsuren/pgvector"`     | The PostgreSQL image which include the pgvector extension. See also the source code from https://github.com/LinuxSuRen/pgvector-docker |
| postgresql.image.tag                               | string | `"v0.0.1"`                  |                                                                                                                                        |
| readinessProbe.httpGet.path                        | string | `"/"`                       |                                                                                                                                        |
| readinessProbe.httpGet.port                        | string | `"http"`                    |                                                                                                                                        |
| replicaCount                                       | int    | `1`                         |                                                                                                                                        |
| resources                                          | object | `{}`                        |                                                                                                                                        |
| securityContext                                    | object | `{}`                        |                                                                                                                                        |
| service.port                                       | int    | `3000`                      |                                                                                                                                        |
| service.type                                       | string | `"ClusterIP"`               |                                                                                                                                        |
| serviceAccount.annotations                         | object | `{}`                        |                                                                                                                                        |
| serviceAccount.automount                           | bool   | `true`                      |                                                                                                                                        |
| serviceAccount.create                              | bool   | `true`                      |                                                                                                                                        |
| serviceAccount.name                                | string | `""`                        |                                                                                                                                        |
| tolerations                                        | list   | `[]`                        |                                                                                                                                        |
| volumeMounts                                       | list   | `[]`                        |                                                                                                                                        |
| volumes                                            | list   | `[]`                        |                                                                                                                                        |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.13.1](https://github.com/norwoodj/helm-docs/releases/v1.13.1)
