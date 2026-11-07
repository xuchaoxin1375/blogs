# About rock images

A rock is an [Ubuntu-based container image](https://ubuntu.com/containers/rockcraft/docs/latest/explanation/rocks/). Rocks are [OCI-compliant](https://opencontainers.org/) and thus compatible with all popular container management tools (such as [Docker](../../reference/glossary.md#term-Docker) and Kubernetes) and container registries (such as Docker Hub and Amazon ECR). They are built to be secure and stable by design.

Rocks are [created using Rockcraft](https://ubuntu.com/containers/rockcraft/docs/latest/explanation/rockcraft/), which in turn [uses Chisel](https://ubuntu.com/containers/rockcraft/docs/latest/explanation/chisel/) to extract the relevant parts of Debian packages needed to form a minimal container image. By keeping rocks small and specific, their exposure to vulnerabilities is minimized.

Although rocks can be useful for anyone using containers, in the Ubuntu Server context they are particularly helpful for system administrators who want to use containers to manage their infrastructure. To find out how to run rocks on your server, refer to [our how-to guide](../../how-to/containers/run-rocks-on-your-server.md#run-rocks-on-your-server). Alternatively, to find out more about rocks and Rockcraft, refer to the [official Rockcraft documentation](https://ubuntu.com/containers/rockcraft/docs/latest/).

---

> 来源：https://ubuntu.com/server/docs/explanation/virtualisation/about-rock-images/  
> 站点：Ubuntu Server documentation（canonical/ubuntu-server-documentation）
