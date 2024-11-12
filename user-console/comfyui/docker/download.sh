#!/bin/bash

set -euo pipefail

# 使用正则表达式，从链接中查找 REPO_NAME
# 先匹配 [https://example.com/xyz/REPO_NAME.git] 或 [git@example.com:xyz/REPO_NAME.git]
# 再匹配 [http(s)://example.com/xyz/REPO_NAME]
# 查找结果存放在 BASH_REMATCH[2]
function clone_or_pull () {
    if [[ $1 =~ ^(.*[/:])(.*)(\.git)$ ]] || [[ $1 =~ ^(http.*\/)(.*)$ ]]; then
        echo "${BASH_REMATCH[2]}" ;
        set +e ;
            git clone --depth=1 --no-tags --recurse-submodules --shallow-submodules "$1" \
                || git -C "${BASH_REMATCH[2]}" pull --ff-only ;
        set -e ;
    else
        echo "[ERROR] 无效的 URL: $1" ;
        return 1 ;
    fi ;
}


echo "########################################"
echo "[INFO] 下载 ComfyUI & Manager..."
echo "########################################"

# 使用稳定版 ComfyUI（GitHub 上有发布标签）
set +e
cd /root
git clone https://ghp.ci/https://github.com/comfyanonymous/ComfyUI.git || git -C ComfyUI pull --ff-only
cd /root/ComfyUI
git reset --hard v0.2.7
set -e

cd /root/ComfyUI/custom_nodes
clone_or_pull https://ghp.ci/https://github.com/ltdrdata/ComfyUI-Manager.git


echo "########################################"
echo "[INFO] 下载扩展组件（自定义节点）……"
echo "########################################"

cd /root/ComfyUI/custom_nodes

# 工作空间
clone_or_pull https://ghp.ci/https://github.com/AIGODLIKE/AIGODLIKE-ComfyUI-Translation.git
clone_or_pull https://ghp.ci/https://github.com/crystian/ComfyUI-Crystools.git
clone_or_pull https://ghp.ci/https://github.com/crystian/ComfyUI-Crystools-save.git

# 综合
clone_or_pull https://ghp.ci/https://github.com/bash-j/mikey_nodes.git
clone_or_pull https://ghp.ci/https://github.com/chrisgoringe/cg-use-everywhere.git
clone_or_pull https://ghp.ci/https://github.com/cubiq/ComfyUI_essentials.git
clone_or_pull https://ghp.ci/https://github.com/jags111/efficiency-nodes-comfyui.git
clone_or_pull https://ghp.ci/https://github.com/kijai/ComfyUI-KJNodes.git
clone_or_pull https://ghp.ci/https://github.com/pythongosssss/ComfyUI-Custom-Scripts.git
clone_or_pull https://ghp.ci/https://github.com/rgthree/rgthree-comfy.git
clone_or_pull https://ghp.ci/https://github.com/shiimizu/ComfyUI_smZNodes.git

# 控制
clone_or_pull https://ghp.ci/https://github.com/cubiq/ComfyUI_InstantID.git
clone_or_pull https://ghp.ci/https://github.com/cubiq/ComfyUI_IPAdapter_plus.git
clone_or_pull https://ghp.ci/https://github.com/Fannovel16/comfyui_controlnet_aux.git
clone_or_pull https://ghp.ci/https://github.com/florestefano1975/comfyui-portrait-master.git
clone_or_pull https://ghp.ci/https://github.com/Gourieff/comfyui-reactor-node.git
clone_or_pull https://ghp.ci/https://github.com/huchenlei/ComfyUI-layerdiffuse.git
clone_or_pull https://ghp.ci/https://github.com/Kosinkadink/ComfyUI-Advanced-ControlNet.git
clone_or_pull https://ghp.ci/https://github.com/ltdrdata/ComfyUI-Impact-Pack.git
clone_or_pull https://ghp.ci/https://github.com/ltdrdata/ComfyUI-Inspire-Pack.git
clone_or_pull https://ghp.ci/https://github.com/mcmonkeyprojects/sd-dynamic-thresholding.git
clone_or_pull https://ghp.ci/https://github.com/storyicon/comfyui_segment_anything.git
clone_or_pull https://ghp.ci/https://github.com/twri/sdxl_prompt_styler.git

# 视频
clone_or_pull https://ghp.ci/https://github.com/Fannovel16/ComfyUI-Frame-Interpolation.git
clone_or_pull https://ghp.ci/https://github.com/FizzleDorf/ComfyUI_FizzNodes.git
clone_or_pull https://ghp.ci/https://github.com/Kosinkadink/ComfyUI-AnimateDiff-Evolved.git
clone_or_pull https://ghp.ci/https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite.git
clone_or_pull https://ghp.ci/https://github.com/MrForExample/ComfyUI-AnimateAnyone-Evolved.git

# 更多
clone_or_pull https://ghp.ci/https://github.com/cubiq/ComfyUI_FaceAnalysis.git
clone_or_pull https://ghp.ci/https://github.com/pythongosssss/ComfyUI-WD14-Tagger.git
clone_or_pull https://ghp.ci/https://github.com/SLAPaper/ComfyUI-Image-Selector.git

# WAS NS 的依赖项并未完整安装，但可以正常运行
clone_or_pull https://ghp.ci/https://github.com/WASasquatch/was-node-suite-comfyui.git

# 配置为中文界面
if [ ! -f "/root/ComfyUI/user/default/comfy.settings.json" ] ; then
    mkdir -p /root/ComfyUI/user/default
    cp /runner-scripts/comfy.settings.json.example  /root/ComfyUI/user/default/comfy.settings.json
fi ;

echo "########################################"
echo "[INFO] 下载模型……"
echo "########################################"

cd /root/ComfyUI/models
aria2c \
  --input-file=/runner-scripts/download-models.txt \
  --allow-overwrite=false \
  --auto-file-renaming=false \
  --continue=true \
  --max-connection-per-server=3

# 标记为下载完成，下次启动不再尝试下载
touch /root/.download-complete
