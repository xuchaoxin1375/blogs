<a id="run-rocks-on-your-server"></a>

# How to run rocks on your server

## Deploying rocks with Docker

As with any other OCI-compliant container image, [rocks](https://ubuntu.com/containers/rockcraft/docs/latest/explanation/rocks/) can be deployed with your favorite container management tool. This section depicts a typical deployment workflow for a generic Grafana rock, using [Docker](../../reference/glossary.md#term-Docker).

First, install Docker if it’s not already installed:

```console
$ sudo apt-get install -y docker.io docker-compose
```

We can deploy a container with the `docker run` command. This command has a number of [possible parameters](https://docs.docker.com/reference/cli/docker/container/run/). The [“Usage” section](https://hub.docker.com/r/ubuntu/grafana) of the Grafana rock’s documentation has a table with an overview of parameters specific to the image.

```console
$ sudo docker run -d --name grafana-container -e TZ=UTC -p 3000:3000 ubuntu/grafana:10.3.3-22.04_stable
```

In this particular case, we’re using:

- `-d` to run the container in the background.

- We are also specifying a well-defined name for the container, with the `--name` parameter.

- With `-e` we are setting the container’s timezone (`TZ`) environment variable to `UTC`.

- We also use `-p` to map port 3000 of the container to 3000 on localhost.

- The last parameter indicates the name of the rock, as listed in Docker Hub. Notice that the image tag we requested has the `_stable` suffix to indicate the image’s risk. This is called a **Channel Tag** and it follows a similar convention to [snap “channels”](https://snapcraft.io/docs/channels).

This container, named `grafana-container`, serves Grafana 10.3.3 in an Ubuntu 22.04 LTS environment and can be accessed via local port 3000. Load the website up in your local web browser:

![Welcome to Grafana](../../../_assets/a6b735b3-welcome-to-grafana.png)

If you don’t have Firefox handy, `curl` can be used instead:

```console
$ curl -s http://localhost:3000/login | grep "<title>"
```

Now that we’ve tested the deployment of the Grafana rock as a single container, let’s clean it up:

```console
$ sudo docker ps
```

We can stop and remove the container as follows:

```console
$ sudo docker stop grafana-container
```

```console
$ sudo docker rm grafana-container
```

The [Grafana rock’s documentation](https://hub.docker.com/r/ubuntu/grafana) will also show you how to use Docker’s `-v` bind mounts to configure Grafana’s provisioning directory and data persistence.

## Multi-container deployment

The section above explained the use of a single container for running a single software instance, but one of the benefits of using rocks is the ability to easily create and architecturally organize (or “orchestrate”) them to operate together in a modular fashion.

This section will demonstrate use of `docker-compose` to set up two container services that inter-operate to implement a trivial observability stack with the [Prometheus](https://hub.docker.com/r/ubuntu/prometheus) and [Grafana](https://hub.docker.com/r/ubuntu/grafana) rocks.

Start by creating a Prometheus configuration file called `prometheus.yml` with the following contents:

```yaml
global:
  scrape_interval: 1m

scrape_configs:
  - job_name: 'prometheus'
    scrape_interval: 1m
    static_configs:
      - targets: ['localhost:9090']
```

Note that this is a very simplistic example, where Prometheus only collects metrics about itself. You could expand the above configuration to tell Prometheus to scrape metrics from other sources.

Then, create the Compose file `docker-compose.yml` and define both services:

```yaml
services:
  grafana:
    image: ubuntu/grafana:10.3.3-22.04_stable
    container_name: grafana-container
    environment:
      TZ: UTC
    ports:
      - "3000:3000"
  prometheus:
    image: ubuntu/prometheus:2.49.1-22.04_stable
    container_name: prometheus-container
    environment:
      TZ: UTC
    ports:
      - "9090:9090"
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml
```

Note that the Prometheus configuration file is being given to the container via a Docker volume (of type “bind mount”). The above sample could also be improved to also use another volume for persisting data, and even a Grafana default configuration for the Prometheus datasource.

Since we already installed Docker in the section above, all that is needed is to create and start the containers defined in this Compose file. This can be achieved with:

```console
$ sudo docker compose up -d
```

As before, the `-d` indicates that all containers in this stack should be started in the background. You can confirm they are live and running with:

```console
$ sudo docker compose ps
```

Opening [`http://localhost:3000`](http://localhost:3000) will give you the same Grafana login page as before:

![Welcome to Grafana](../../../_assets/a6b735b3-welcome-to-grafana.png)

Use the default username `admin` and password `admin` to login:

![Grafana login](../../../_assets/2e14e3f3-login-to-grafana.png)

By clicking on “Data Sources” you can then add Prometheus and provide the server URL [`http://prometheus:9090`](http://prometheus:9090):

![Prometheus data source](../../../_assets/2a252ada-prometheus-data-source.png)

This URL works because Docker Compose ensures both containers are on the same Docker network and that they can be discovered via their service name.

Finally, click on “Explore” from the Grafana menu, and select the `prometheus` datasource. You can now query and visualize the Prometheus metrics. For example:

![Prometheus data source](../../../_assets/bd93d9c1-prometheus-metrics.png)

## Next steps

As you can see, `docker-compose` makes it convenient to set up multi-container applications without needing to perform runtime changes to the containers. As you can imagine, this can permit building a more sophisticated management system to handle fail-over, load-balancing, scaling, upgrading old nodes, and monitoring status. But rather than needing to implement all of this directly on top of `docker-container`, you may want to investigate Kubernetes-style cluster management software such as [MicroK8s](https://canonical.com/microk8s/docs).

---

> 来源：https://ubuntu.com/server/docs/how-to/containers/run-rocks-on-your-server/  
> 站点：Ubuntu Server documentation（canonical/ubuntu-server-documentation）
