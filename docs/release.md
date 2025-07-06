# Application Release

[中文](./release_zh.md)

This article describes how to release an application on the TensorStack AI platform after completing [application development](./dev.md). The content to be released includes three categories:

1.  The corresponding [image](./dev.md#building-the-image);
2.  The corresponding [Helm Chart](./dev.md#developing-the-helm-chart);
3.  The corresponding [registration-related files](./dev.md#publishing-the-app).

## Private Release

If the developed application is only used in your own environment (such as a privately deployed TensorStack AI platform), you need to:

1.  Upload the image to a private image repository, such as a self-hosted [Harbor](https://goharbor.io/);
2.  Upload the Helm Chart to a private Chart repository, such as a self-hosted [Harbor](https://goharbor.io/);
3.  Save the Apps [registration-related files](./dev.md#publishing-the-app), for example, by uploading them to your own Git repository.

## Public Release

If you want the developed application to be used by more users and can be released publicly, you need to:

1.  Upload the image to a public image repository, such as DockerHub or the public image repository provided by TensorStack;
2.  Upload the Helm Chart to a public Chart repository, such as DockerHub or the public Chart repository provided by TensorStack;
3.  Submit the registration-related files to the [TensorStack GitHub repository](https://github.com/t9k/apps/pulls) via a Pull Request.

Note: When making a public release, the chosen "image/Chart repository" should be one that can be accessed quickly and easily by the target user cluster.
