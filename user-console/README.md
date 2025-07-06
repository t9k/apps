# User Console Apps

[中文](./README_zh.md)

The User Console of the TensorStack AI platform provides the functionality to run **Apps**. Administrators need to register Apps with the App Server first, then users can install and use them in the User Console.

## Directory Structure

This directory organizes all the files related to registrable Apps, with the following structure:

1. Each subdirectory generally corresponds to one App, but can also correspond to multiple (e.g., [notebook](./notebook/)).
2. The `template.yaml` file in each subdirectory is the **App Template** (see: [App Template Specification](../docs/template.md)), used to register the App.
3. Subdirectories can be created within each App's directory to store other development files, such as `chart/` for Helm Chart files and `docker/` for Dockerfiles.

## App Tiers

All Apps are categorized into two tiers: Core and Experimental.

*   **Core**: These Apps carry the core functionalities of the platform, with high availability and reliability, and are continuously updated and maintained. They are suitable for production environments.
*   **Experimental**: These Apps are for exploring new or experimental features. They may be unstable or have imperfections in their usage, and their update frequency is uncertain. Please use them with caution in production environments.

### Core Apps

| App               | Description                                                                                                                                                           |
| ----------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Argo Workflows    | An open-source workflow engine for orchestrating multi-step parallel jobs.                                                                                            |
| Code Server       | A browser-based VSCode environment.                                                                                                                                   |
| ComfyUI           | A powerful and modular Stable Diffusion GUI and backend that supports designing and executing advanced pipelines with a graph-based interface.                        |
| Dify              | An open-source LLM application development platform. Its intuitive interface combines smart AI workflows, RAG pipelines, agent capabilities, model management, and more. |
| File Browser      | Provides a file management interface for a specified directory, used for uploading, deleting, previewing, renaming, and editing files.                                |
| Job Manager       | A console for managing T9k Jobs, providing an intuitive interface for users to create Jobs, view Job details, and monitor resource usage.                             |
| Label Studio      | An open-source data annotation tool that supports labeling audio, text, images, videos, and time-series data.                                                         |
| Milvus            | A high-performance vector database designed for massive-scale data. It provides core support for various AI applications by efficiently organizing and retrieving unstructured data. |
| MongoDB           | An open-source NoSQL database that uses JSON-style documents to store data, supporting automatic scaling and high performance for cloud-native applications.          |
| MySQL             | An open-source relational database management system known for its high performance, reliability, and ease of use, widely used for data storage and management.        |
| JupyterLab        | A web-based interactive development environment for code development and data processing, supporting data science, scientific computing, and machine learning tasks.    |
| RStudio           | An integrated development environment that helps you improve your development efficiency with R and Python.                                                           |
| Ollama            | Provides a solution for using LLMs locally.                                                                                                                           |
| Open WebUI        | A user-friendly chat interface for web-based interaction.                                                                                                             |
| PostgreSQL        | An open-source object-relational database that supports ACID transactions, foreign keys, joins, views, triggers, and stored procedures.                               |
| Redis             | An in-memory database that supports various data structures like strings, lists, and sets, while also persisting data to disk.                                         |
| Service Manager   | A console for managing inference services, allowing you to create services, view their status, and monitor service events.                                            |
| TensorBoard       | A visualization toolkit for TensorFlow, displaying various data from the model training process.                                                                      |
| Terminal          | A cluster terminal that can be opened and operated directly in the browser, facilitating cluster management.                                                          |
| Virtual Machine   | A complete computer system simulated by software with full hardware system functionality, running in a completely isolated environment.                               |
| vLLM              | A high-throughput and memory-efficient LLM inference and serving engine.                                                                                              |
| Workflow          | A console for managing workflows, allowing you to create workflows and view their running status.                                                                     |

### Experimental Apps

| App                        | Description                                                                                                                                                                   |
| -------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| AnythingLLM                | A full-stack application that can convert any document, resource, or content into context that an LLM can use as a reference during a chat.                                      |
| AutoGen Studio             | A no-code tool for prototyping and running multi-agent workflows.                                                                                                             |
| AutoTune                   | An automated machine learning (AutoML) tool.                                                                                                                                  |
| Chat Nio                   | A next-generation, all-in-one AI solution for B/C end-users, with comprehensive support for various mainstream AI models.                                                      |
| DB-GPT                     | An open-source, AI-native data application development framework with AWEL (Agentic Workflow Expression Language) and agent capabilities.                                       |
| FastGPT                    | A knowledge-based platform based on LLM, providing a full set of out-of-the-box features like data processing, RAG retrieval, and visual AI workflow orchestration.             |
| Fish Speech                | A brand-new TTS solution that supports zero-shot voice cloning.                                                                                                               |
| GPT Researcher             | An intelligent agent specialized in comprehensive online research for various tasks.                                                                                          |
| Llama Board                | A web UI for the LLaMA-Factory project, used for (incremental) pre-training, instruction fine-tuning, and evaluation of open-source LLMs.                                      |
| MLflow                     | A platform to streamline machine learning development, including tracking experiments, packaging code into reproducible runs, and sharing and deploying models.                 |
| NextChat                   | A well-designed ChatGPT web UI that supports multiple chat services, including ChatGPT, Claude, Gemini, and local inference services.                                          |
| One API                    | An OpenAI interface management and distribution system that supports multiple mainstream LLM service providers.                                                                 |
| Qdrant                     | A vector database for AI applications.                                                                                                                                        |
| Search with Lepton         | An open-source conversational search engine.                                                                                                                                  |
| SearXNG                    | A free internet metasearch engine that aggregates results from various search services and databases. Users are not tracked or profiled.                                        |
| Stable Diffusion WebUI aki | An integrated package based on the open-source project Stable Diffusion WebUI, created by bilibili@秋葉aaaki.                                                                 |

## Related Documentation

*   [Apps System Overview](../docs/overview.md)
*   [App Registration and Unregistration](../docs/register.md)
*   [App Template Format](../docs/template.md)
*   [App Development](../docs/dev.md)
*   [App Release](../docs/release.md)
*   [Command-Line Tool - t9k-app](../docs/appendix.md)