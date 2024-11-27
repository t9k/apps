# 镜像

参照 <https://www.yuque.com/eosphoros/dbgpt-docs/glf87qg4xxcyrp89#SwuM9>，本地构建 all-in-one 镜像：

```bash
git clone https://github.com/eosphoros-ai/DB-GPT.git
cd DB-GPT && git reset --hard v0.6.2
bash docker/build_all_images.sh --pip-index-url https://pypi.tuna.tsinghua.edu.cn/simple --language zh
```

然后安装缺少的 Python 库：

```bash
cd ..
docker build . -t t9kpublic/dbgpt-allinone:v0.6.2
```
