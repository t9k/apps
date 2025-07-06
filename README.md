# TensorStack AI Platform Applications

This repository contains a curated collection of third-party applications packaged for easy deployment on the [TensorStack AI Platform](https://www.tensorstack.dev/). These applications, referred to as "Apps," are designed to be managed through the platform's User Console, simplifying the process of installation, configuration, and management for end-users.

## How It Works

The application model is built on Kubernetes primitives. Each application is defined by a set of files that includes:

*   **`template.yaml`**: A manifest that defines the application's metadata, versions, and deployment configurations.
*   **Helm Charts**: The core packaging format for the application's Kubernetes resources.
*   **Dockerfiles & Images**: Source for building the necessary container images.
*   **Configuration Files**: Default values and settings for different application versions.

Administrators can use the `t9k-app` command-line tool to register these applications with the platform's App Server, making them available for users to launch from the User Console.

## Repository Structure

The repository is organized as follows:

```
.
├── .github/            # CI/CD workflows for releasing applications
├── docs/               # Detailed documentation on the Apps system, development, and release process
├── tools/              # Helper scripts for mirroring Helm charts and container images
├── user-console/       # The primary catalog of active, deployable applications
└── archived/           # Older or deprecated application definitions
```

- **`user-console/`**: This is the main directory containing the application packages. Each subdirectory represents a single application.
- **`docs/`**: Contains all the necessary documentation for understanding the App architecture, developing a new App, and the release process. See the [Docs README](./docs/README.md) to get started.
- **`tools/`**: Includes scripts like `image-mirror.sh` and `chart-mirror.sh` to help manage application dependencies.
- **`archived/`**: Contains definitions for applications that are no longer actively maintained but are kept for historical purposes.

## Development and Contribution

To learn how to develop and package your own application for the TensorStack AI Platform, please refer to the [Application Development Guide](./docs/dev.md).

For information on releasing and contributing applications to this repository, see the [App Release Guide](./docs/release.md).