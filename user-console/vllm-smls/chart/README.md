# vLLM

[vLLM](https://github.com/vllm-project/vllm) 是一个快速、灵活且易用的开源 LLM 推理和服务库。

vLLM 的速度优势包括：

* 最先进的服务吞吐量
* 使用 PagedAttention 高效管理注意力键和值内存
* 连续批处理传入请求
* 使用 CUDA/HIP 图实现快速模型执行
* 量化技术：GPTQ、AWQ、SqueezeLLM、FP8 KV 缓存
* 优化的 CUDA 内核

vLLM 灵活且易用，具备以下特点：

* 无缝集成流行的 Hugging Face 模型
* 使用多种解码算法（包括并行采样、束搜索等）进行高吞吐量服务
* 支持分布式推理的张量并行
* 流式输出
* 兼容 OpenAI 的 API 服务器
* 支持 NVIDIA 和 AMD GPUs
* （实验性）前缀缓存支持
* （实验性）多 lora 支持

vLLM 无缝支持 HuggingFace 上大多数流行的开源模型，包括：

* 类 Transformer 的 LLM（例如 Llama）
* 专家混合 LLM（例如 Mixtral）
* 多模态 LLM（例如 LLaVA）
