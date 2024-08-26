# LLaMA Board

[LLaMA-Factory](https://github.com/hiyouga/LLaMA-Factory) 是一个（增量）预训练、指令微调、评估和部署开源大型语言模型的项目。LLaMA Board 是 LLaMA-Factory 的网页 UI。

LLaMA-Factory 支持：

* 多种模型：LLaMA、LLaVA、Mistral、Mixtral-MoE、Qwen、Yi、Gemma、Baichuan、ChatGLM、Phi 等等。
* 集成方法：（增量）预训练、（多模态）指令监督微调、奖励模型训练、PPO 训练、DPO 训练、KTO 训练、ORPO 训练等等。
* 多种精度：16 比特全参数微调、冻结微调、LoRA 微调和基于 AQLM/AWQ/GPTQ/LLM.int8/HQQ/EETQ 的 2/3/4/5/6/8 比特 QLoRA 微调。
* 先进算法：GaLore、BAdam、DoRA、LongLoRA、LLaMA Pro、Mixture-of-Depths、LoRA+、LoftQ、PiSSA 和 Agent 微调。
* 实用技术：FlashAttention-2、Unsloth、RoPE scaling、NEFTune 和 rsLoRA。
* 实验监控：LlamaBoard、TensorBoard、Wandb、MLflow 等等。
* 极速推理：基于 vLLM 的 OpenAI 风格 API、浏览器界面和命令行接口。

## 使用方法

待应用就绪后，按照应用信息的指引进入网页 UI，即可开始微调模型：

![](https://s2.loli.net/2024/07/31/ahQPJViry2D7cXf.png)

网页 UI 的使用方法请参阅 [LLaMA-Factory README](https://github.com/hiyouga/LLaMA-Factory/blob/main/README_zh.md) 开头的视频。

## 使用说明

* 网页 UI 所下载的模型和数据集文件存储在随应用创建的 PVC `app-llama-board-xxxxxxxx` 的 `.cache/huggingface/` 目录下，`data/` 目录下的数据集文件为镜像自带；训练的配置和检查点，以及评估的配置和结果存储在 `saves/` 目录下；导出的模型文件的保存路径由用户指定，建议存储在 `models/` 目录下。

* 你可以安装挂载该存储卷的 Terminal 或 JupyterLab 应用，查看上述文件或进行进一步的操作（例如删除检查点，将导出模型上传到外部存储）。你也可以安装挂载该存储卷的子目录的 vLLM 应用，以将导出模型部署为推理服务。

## 配置

### 示例

默认配置：

```yaml
resources:
  limits:
    cpu: 4
    memory: 64Gi
    nvidia.com/gpu: 1

persistence:
  size: 50Gi
  storageClass: ""
  accessModes:
    - ReadWriteOnce
```

### 字段

| 名称                                | 描述                              | 值                      |
| ----------------------------------- | --------------------------------- | ----------------------- |
| `image.registry`                    | Docker 镜像的存储库               | `docker.io`             |
| `image.repository`                  | Docker 镜像的存储库名称           | `t9kpublic/llama-board` |
| `image.tag`                         | Docker 镜像的标签                 | `20240730`              |
| `image.pullPolicy`                  | Docker 镜像的拉取策略             | `IfNotPresent`          |
| `service.type`                      | Kubernetes 服务的类型             | `ClusterIP`             |
| `service.port`                      | Kubernetes 服务的端口             | `7860`                  |
| `ingress.enabled`                   | 启用/禁用 Kubernetes Ingress      | `false`                 |
| `ingress.className`                 | Ingress 类名称                    | ``                      |
| `ingress.annotations`               | Kubernetes Ingress 注释           | `{}`                    |
| `ingress.hosts`                     | Kubernetes Ingress 的主机列表     | `[]`                    |
| `ingress.tls`                       | Kubernetes Ingress 的 TLS 配置    | `[]`                    |
| `resources.limits.cpu`              | Kubernetes 资源的 CPU 限制        | `4`                     |
| `resources.limits.memory`           | Kubernetes 资源的内存限制         | `64Gi`                  |
| `resources.limits."nvidia.com/gpu"` | Kubernetes 资源的 NVIDIA GPU 限制 | `1`                     |
| `persistence.size`                  | 持久卷声明的大小                  | `50Gi`                  |
| `persistence.storageClass`          | 持久卷声明的存储类别              | ``                      |
| `persistence.accessModes`           | 持久卷声明的访问模式              | `["ReadWriteOnce"]`     |
