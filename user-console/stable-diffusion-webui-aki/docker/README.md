# 镜像

请从 <https://www.bilibili.com/video/BV1iM4y1y7oA> 下载整合包到当前路径下并解压，然后执行以下命令：

```bash
mv Dockerfile ./sd-webui-aki-v4.8
mv launch.sh ./sd-webui-aki-v4.8
cd sd-webui-aki-v4.8
mv outputs outputs_backup
mv models models_backup
docker build . -t t9kpublic/stable-diffusion-webui:20240514
```
