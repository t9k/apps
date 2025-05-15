# 自定义 dify-web 镜像

操作步骤：

1. 拉取 Dify 源码

```bash
cd apps/user-console/dify/docker  # 切换到当前目录
git clone https://github.com/langgenius/dify.git
cd dify
git checkout 85eb55d
```

2. 将 `Dockerfile` 和 `entrypoint.sh` 和 `build.sh` 复制到 `dify/web/` 目录下

```bash
cd ..
cp Dockerfile dify/web/
cp entrypoint.sh dify/web/docker/
cp build.sh dify/web/docker/
```

3. 构建 dify-web 镜像并推送

```bash
cd dify/web
docker build . -t registry.cn-hangzhou.aliyuncs.com/t9k/dify-web:1.3.1.post1
docker push registry.cn-hangzhou.aliyuncs.com/t9k/dify-web:1.3.1.post1
```
