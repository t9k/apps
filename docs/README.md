# Overview

[中文](./overview_zh.md)

Applications (Apps) are software modules that implement specific functions and can be independently installed and uninstalled in a TensorStack AI cluster. Currently, the TensorStack AI platform supports defining Apps in Helm Chart format. Other methods (such as Operator) can be extended if needed.

![architecture](./img/arch.drawio.svg)

**Figure 1: Architectural diagram of the TensorStack platform Apps system. 1) The App Server provides interfaces for App registration, viewing, etc.; 2) Administrators manage deployable applications through the t9k-app command-line tool; 3) Users create Instance CRD objects through the User Console or kubectl to install Apps; AIC listens for CRD objects, obtains application information from the App Server, and deploys it to the cluster.**

The Apps system consists of the following components:

1.  **App Instance Controller (AIC):** Responsible for handling user requests for application installation and uninstallation. The AIC automatically deploys (installs) Apps in the cluster as Helm Releases.
2.  **App Server:** Provides application management APIs, including operations such as application registration, unregistration, and querying.
3.  **t9k-app:** A command-line tool for administrators to register and unregister applications.
4.  **User Console:** A web front-end for users to install, manage, and use Apps.

## Next Steps

*   Learn how to [Register and Unregister Apps](./register.md)
*   Understand the [Application Template Format](./template.md)
*   Learn how to [Develop an App](./dev.md)
*   Learn how to [Release an App](./release.md)
