# 镜像

## 镜像构建

Service Manager 应用需要构建以下镜像：

- `service-manager-web`: 前端界面镜像，在私有的 gitlab 仓库 `mdeploy-web` 中，使用通用发布脚本 `./repo/workflows/docker-build-common.sh` 进行构建。

构建完成之后，需要修改镜像的名称并上传：

```bash
$ docker tag ${IMAGE_PREFIX}/mdeploy-web:${VERSION} ${IMAGE_PREFIX}/service-manager-web:${VERSION}
$ docker push ${IMAGE_PREFIX}/service-manager-web:${VERSION}
```
