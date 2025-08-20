# 镜像

## 镜像构建

Workflow 应用需要构建一个镜像：

- `workflow-app`: 应用镜像，在私有的 gitlab 仓库 `workflow-app` 中，使用通用发布脚本 `./repo/workflows/docker-build-app.sh` 进行构建。

### 镜像说明

- **支持架构**: AMD64, ARM64
- **版本号**: 通过 `VERSION` 环境变量配置，建议使用日期格式（如 `250423` 表示 2025年4月23日）
