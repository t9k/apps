# SearXNG

[SearXNG](https://github.com/searxng/searxng) 是一个尊重隐私、可破解的元搜索引擎。元搜索引擎（或搜索聚合器）是一种在线信息检索工具，它利用网络搜索引擎的数据生成自己的搜索结果。SearXNG 接收用户的输入，立即查询多个搜索引擎以获取结果，并将收集到的数据进行排序后呈现给用户。

## 使用方法

待应用就绪后，点击右侧的 <svg width="1em" height="1em" class="MuiSvgIcon-root MuiSvgIcon-colorPrimary MuiSvgIcon-fontSizeMedium css-jxtyyz" focusable="false" aria-hidden="true" viewBox="0 0 24 24" data-testid="OpenInNewIcon"><path d="M19 19H5V5h7V3H5c-1.11 0-2 .9-2 2v14c0 1.1.89 2 2 2h14c1.1 0 2-.9 2-2v-7h-2zM14 3v2h3.59l-9.83 9.83 1.41 1.41L19 6.41V10h2V3z"></path></svg> 进入网页 UI，即可开始搜索。

![](https://s2.loli.net/2024/11/21/EtKkJTqHvbRpazd.png)

网页 UI 的使用方法与一般的搜索引擎无异。

## 配置

### 说明

对于国内用户，如要使用 Google、DuckDuckGo、Wikipedia 等搜索引擎，在 settings 配置的 `outgoing.proxies` 字段下提供代理。

### 示例

默认配置：

```yaml
image:
  registry: "$(T9K_APP_IMAGE_REGISTRY)"
  repository: "$(T9K_APP_IMAGE_NAMESPACE)/searxng"
  tag: "2024.11.17-10d3af84b"
  pullPolicy: IfNotPresent

config:

  settings:
    enabled: true
    data: |-
      use_default_settings: true

      engines:
        - name: bing
          disabled: false

      search:
        safe_search: 0
        autocomplete: ""
        default_lang: ""
        formats:
          - html
          - json

      server:
        base_url: $(T9K_HOME_DOMAIN)/apps/{{ .Release.Namespace }}/searxng/{{ .Release.Name }}/
        port: 8080
        bind_address: "0.0.0.0"
        secret_key: "57dc63125e7eef404481411b99c21fb9a5763b724b0bc88f2440ef373cf94809"
        limiter: false
        image_proxy: true

      ui:
        static_use_hash: true

      outgoing:
        request_timeout: 2.0
        max_request_timeout: 10.0
        useragent_suffix: ""
        pool_connections: 100
        pool_maxsize: 10
        enable_http2: true

  limiter:
    enabled: true
    data: |-
      [botdetection.ip_limit]
      # activate link_token method in the ip_limit method
      link_token = true

  uwsgi:
    enabled: true
    data: |-
      [uwsgi]
      # Who will run the code
      uid = searxng
      gid = searxng

      # Number of workers (usually CPU count)
      # default value: %k (= number of CPU core, see Dockerfile)
      workers = %k

      # Number of threads per worker
      # default value: 4 (see Dockerfile)
      threads = 4

      # The right granted on the created socket
      chmod-socket = 666

      # Plugin to use and interpreter config
      single-interpreter = true
      master = true
      plugin = python3
      lazy-apps = true
      enable-threads = 4

      # Module to import
      module = searx.webapp

      # Virtualenv and python path
      pythonpath = /usr/local/searxng/
      chdir = /usr/local/searxng/searx/

      # automatically set processes name to something meaningful
      auto-procname = true

      # Disable request logging for privacy
      disable-logging = true
      log-5xx = true

      # Set the max size of a request (request-body excluded)
      buffer-size = 8192

      # No keep alive
      # See https://github.com/searx/searx-docker/issues/24
      add-header = Connection: close

      # uwsgi serves the static files
      static-map = /static=/usr/local/searxng/searx/static
      # expires set to one day
      static-expires = /* 86400
      static-gzip-all = True
      offload-threads = 4

resources:
  limits:
    cpu: 4
    memory: 8Gi

env:
  - name: TZ
    value: "Asia/Shanghai"
```

### 字段

| 名称                      | 描述                          | 值                                           |
| ------------------------- | ----------------------------- | -------------------------------------------- |
| `image.registry`          | SearXNG 镜像注册表            | `$(T9K_APP_IMAGE_REGISTRY)`                  |
| `image.repository`        | SearXNG 镜像仓库              | `$(T9K_APP_IMAGE_NAMESPACE)/searxng`         |
| `image.tag`               | SearXNG 镜像标签              | `2024.11.17-10d3af84b`                       |
| `image.pullPolicy`        | SearXNG 镜像拉取策略          | `IfNotPresent`                               |
| `config.settings.enabled` | 是否启用设置配置              | `true`                                       |
| `config.settings.data`    | 设置配置                      |                                              |
| `config.limiter.enabled`  | 是否启用限流器配置            | `true`                                       |
| `config.limiter.data`     | 限流器配置                    |                                              |
| `config.uwsgi.enabled`    | 是否启用 uWSGI 配置           | `true`                                       |
| `config.uwsgi.data`       | uWSGI 配置                    |                                              |
| `resources.limits.cpu`    | SearXNG 容器能使用的 CPU 上限 | `4`                                          |
| `resources.limits.memory` | SearXNG 容器能使用的内存上限  | `8Gi`                                        |
| `env`                     | 额外的环境变量数组            | `[{"name": "TZ", "value": "Asia/Shanghai"}]` |
