<a id="perf-tune-hwloc"></a>

# hwloc

> **Note**
>
> System tuning tools are either about better understanding the system’s performance, or applying such knowledge to improve it. See our common [system tuning thoughts](../performance.md#explanation-system-tuning-disclaimer) for some generally applicable considerations about that.

The package `hwloc-nox` provides various tools to discover the hardware topology, including the chip’s internal structures and any associated devices like PCI cards, NVMe devices, and memory.

By default the tools provide command line interfaces, but it can also render those complex relations in a [GUI](../../reference/glossary.md#term-GUI) environment. Depending on which one you want to use you can install them with `apt install hwloc-nox` or `apt install hwloc` respectively.

It can be important with a sensitive workload to align the CPU cores it runs on, to be close to the nodes where the related devices are attached to the system. That will help to avoid crossing topology boundaries that add additional latencies. But for that, one needs tools to inspect the CPU and device topology on the system.

## hwloc-info - hierarchy and details

By default, `hwloc-info` provides a summary of the topology levels that are present on this system. In these examples we use a consumer-grade laptop.

Command:

```console
$ hwloc-info
```

But the tool also allows us to get detailed information on any of these elements. Here is an example to get details on the first core.

Command:

```console
$ hwloc-info -p core:0
```

See the *[hwloc-info(1)](https://manpages.ubuntu.com/manpages/resolute/man1/hwloc-info.1.html)* manual page for a list of all the potential objects that can be queried.

## hwloc-ls - system topology in CLI

If executed without graphical capabilities `hwloc-ls` will provide a text representation of the CPU, its caches and how they relate to each other between cores, sockets and hardware in the system.

Command:

```console
$ hwloc-ls
```

Output (example on a server – shortened for readability):

```console
```

## hwloc-ls - system topology in GUI

Instead of `hwloc-nox` there also is `hwloc` with graphical capabilities which would render the same in a graphical representation. CLI output shows navigation info, the real content is in the GUI.

Command:

```console
$ hwloc-ls
```

Output (GUI):

![hwlowc-ls UI](../../../_assets/hwloc-example.png)

## Further reading

- *[lstopo(1)](https://manpages.ubuntu.com/manpages/resolute/man1/lstopo.1.html)* manual page

- *[hwloc(7)](https://manpages.ubuntu.com/manpages/resolute/man7/hwloc.7.html)* manual page

- *[hwloc-diff(1)](https://manpages.ubuntu.com/manpages/resolute/man1/hwloc-diff.1.html)* manual page

---

> 来源：https://ubuntu.com/server/docs/explanation/performance/perf-tune-hwloc/  
> 站点：Ubuntu Server documentation（canonical/ubuntu-server-documentation）
