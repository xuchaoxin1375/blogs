<a id="perf-tune-affinity-numa"></a>

# CPU affinity, NUMA placement, and isolation

> **Note**
>
> System tuning tools are either about better understanding the system’s performance, or applying such knowledge to improve it. See our common [system tuning thoughts](../performance.md#explanation-system-tuning-disclaimer) for some generally applicable considerations about that.

Controlling where a workload runs cuts contention for central processing unit ([CPU](../../reference/glossary.md#term-CPU)) resources and reduces memory latency. Without care, manual restrictions can also leave cores idle or overload a single memory node. This guide covers CPU affinity, non-uniform memory access ([NUMA](../../reference/glossary.md#term-NUMA)) policies, CPU isolation, and how they interact.

Manual placement works best when you already know how a workload uses threads, memory, and devices together. Always measure the default scheduler against a representative workload first, since tuning for lower latency can reduce overall throughput or starve background services.

## CPU and memory topology

A NUMA system groups CPUs and memory into nodes. A CPU can access memory on another node, but that access generally has higher latency than access to local memory. Nodes do not necessarily correspond one-to-one with processor sockets: a socket can contain several NUMA nodes.

*[lscpu(1)](https://manpages.ubuntu.com/manpages/resolute/man1/lscpu.1.html)* maps logical CPU numbers to nodes, sockets, and cores. *[numactl(8)](https://manpages.ubuntu.com/manpages/resolute/man8/numactl.8.html)* reports the CPUs, memory capacity, free memory, and relative distances for each NUMA node. Ubuntu provides `lscpu` and *[taskset(1)](https://manpages.ubuntu.com/manpages/resolute/man1/taskset.1.html)* in the `util-linux` package; `numactl` and *[numastat(8)](https://manpages.ubuntu.com/manpages/resolute/man8/numastat.8.html)* are in the `numactl` package.

To inspect the topology visible to the kernel:

```console
$ lscpu -e=CPU,NODE,SOCKET,CORE,ONLINE
```

```console
$ numactl --hardware
```

CPU lists in `taskset` and `numactl` use logical CPU numbers, not core or socket numbers. With simultaneous multithreading (SMT), several logical CPUs share a physical core. Rows with the same socket and core identify these siblings. Consecutive CPU numbers are not necessarily separate cores or members of the same node.

In `numactl --hardware`, lower distance numbers indicate closer nodes. In this output, the relative access latency from a core to memory on the same node is 10, and the relative access latency to memory on the other node is 20, which means that it would take twice as long. These numbers reflect relative distance rather than measured latency. If the command reports only node 0, there are no remote nodes to balance against, but CPU affinity still applies. Keep in mind that virtual machines (VMs) report the virtual topology presented by their hypervisor, which does not always mirror the host hardware (and the host would need to pin virtual CPUs to a topology that the guests can rely on).

For cache sharing and the relationship between CPUs and attached devices, see [hardware topology with hwloc](perf-tune-hwloc.md#perf-tune-hwloc).

## CPU affinity

CPU affinity is the set of logical CPUs on which a thread may run. The scheduler can move the thread within that set. Pinning a thread to a single CPU removes that choice; allowing several CPUs retains some scheduling flexibility.

The Linux scheduler already balances tasks for CPU locality. Setting explicit affinity helps when you need deterministic placement or want cooperating threads to share cache levels. However, it hurts performance when the chosen CPUs saturate while other cores sit idle. Affinity does not reserve CPU cycles, prevent other tasks from using those cores, or migrate existing memory.

The following examples assume that CPUs 2 and 3 are online and available to your workload. In the topology shown above, those two CPUs belong to node 1.

In the examples below, replace `./workload` with your executable and its arguments, and `1864` with the process ID (PID) of a running workload.

To start a program pinned to CPUs 2 and 3:

```console
$ taskset -c 2-3 ./workload
```

Spawned threads and child processes inherit this affinity mask, though applications can alter their own masks later.

When targeting a running process ID, `taskset` affects only the main thread unless you pass `--all-tasks` (`-a`) to include every thread. To query every thread in a process:

```console
$ taskset --all-tasks --pid --cpu-list 1864
```

To move all threads to CPUs 2 and 3:

```console
$ taskset --all-tasks --pid --cpu-list 2-3 1864
```

Take note of original affinity masks before altering them. Applying a single mask across an entire process overwrites any internal thread placement configured by the application. You can adjust your own processes, but changing tasks owned by another user requires root privileges. A process also cannot use CPUs disallowed by its control group (cgroup), regardless of requested affinity.

Affinity dictates where code runs, not how the scheduler shares time among tasks. Tools like *[nice(1)](https://manpages.ubuntu.com/manpages/resolute/man1/nice.1.html)* and *[renice(1)](https://manpages.ubuntu.com/manpages/resolute/man1/renice.1.html)* adjust relative scheduling priorities instead. Lower nice values grant higher priority, while higher values ensure background jobs yield to time-sensitive work.

## NUMA memory policies

CPU placement and memory placement are separate decisions. Under the default memory policy, the kernel generally allocates a new private memory page on the node of the CPU that first triggers a [page fault](../../reference/glossary.md#term-page-fault) for it. This is often called *first-touch allocation*. If one thread initializes memory before worker threads start on other nodes, those workers can end up accessing remote memory.

Automatic NUMA balancing, when enabled, can move eligible memory pages and tasks to improve locality. Explicit CPU and memory restrictions limit the placements it can choose. Changing affinity with `taskset` does not itself migrate pages that a process has already allocated.

`numactl` launches a program with a CPU binding, a memory policy, or both. `--cpunodebind=0` selects the available CPUs belonging to node 0, whereas `--physcpubind=2-3` selects logical CPUs 2 and 3. Despite its name, `--physcpubind` does not select whole physical cores. Neither option sets a memory policy.

For memory placement, `numactl` provides options such as `--preferred` and `--membind`. While `--preferred` expresses a soft preference that falls back to other nodes under memory pressure, `--membind` strictly confines allocations to the specified nodes.

The main memory-policy choices are:

| Option | Allocation behavior | Trade-off |
|----|----|----|
| `--localalloc` | Prefer the node of the CPU making the allocation, with fallback to other nodes. | Locality follows the allocating thread, which may move between nodes. |
| `--preferred=0` | Prefer node 0, with fallback to other nodes. | Keeps a preferred location without making it a strict requirement. |
| `--membind=0` | Allocate only from node 0. | Allocation can fail when that node lacks memory, even if other nodes have free memory. |
| `--interleave=all` | Distribute allocations round-robin across the allowed nodes, with fallback under memory pressure. | Can spread memory-bandwidth demand but increases remote accesses for threads running on one node. |

To run a workload on node 0 and prefer memory allocations from that same node:

```console
$ numactl --cpunodebind=0 --preferred=0 -- ./workload
```

To pin strictly to CPUs 2 and 3 and require memory allocation exclusively from node 1:

```console
$ numactl --physcpubind=2-3 --membind=1 -- ./workload
```

This policy applies to the launched process and its children. It governs future allocations rather than migrating existing shared or file-backed pages already resident in memory. NUMA-aware software can also configure policies for specific memory ranges programmatically using *[numa(3)](https://manpages.ubuntu.com/manpages/resolute/man3/numa.3.html)* from the `libnuma-dev` package. As with CPU affinity, cgroup memory limits constrain the nodes available to the program.

`numactl --show` reports the policy of `numactl` itself, not an external running process. To inspect where a running workload holds resident memory across nodes, run `numastat -p`:

```console
$ numastat -p 1864
```

This workload started on node 0 and was moved to the CPUs of node 1 by the earlier `taskset` command. Most of its memory remains on node 0, which is what makes those accesses remote.

The columns show memory resident on each node, in megabytes. They do not measure how often the CPUs access remote memory. Similarly, the `numa_hit` and `numa_miss` counters from `numastat` without arguments describe allocation decisions, not processor cache hits and misses. Memory on several nodes is not by itself evidence of a problem.

## Placement for systemd services

Changes made with `taskset` disappear when a service restarts. For persistent placement across restarts, systemd provides `CPUAffinity=`, `NUMAPolicy=`, and `NUMAMask=` in *[systemd.exec(5)](https://manpages.ubuntu.com/manpages/resolute/man5/systemd.exec.5.html)*.

```ini
[Service]
CPUAffinity=2-3
NUMAPolicy=preferred
NUMAMask=1
```

```console
$ systemctl show -p CPUAffinity -p NUMAPolicy -p NUMAMask workload.service
```

These directives set initial process policies rather than dedicated CPU reservations. To enforce boundaries through cgroup cpuset controls, use `AllowedCPUs=` from *[systemd.resource-control(5)](https://manpages.ubuntu.com/manpages/resolute/man5/systemd.resource-control.5.html)*. Constraining one service does not keep unconstrained units off the same CPUs.

## CPU isolation

Isolation shields designated CPUs from general system work and scheduler balancing. This prevents context switches from interrupting latency-sensitive tasks, but leaves fewer CPUs for the rest of the system. Pinning alone does not isolate cores: it only dictates where a workload runs, without keeping other tasks away.

The `isolcpus` kernel command-line parameter removes CPUs from normal scheduler load balancing. For example:

```text
isolcpus=domain,2-3
```

This removes logical CPUs 2 and 3 from standard scheduling domains. Tasks will not run on these cores unless assigned there explicitly using affinity masks or cpusets. Because the scheduler will not balance load across isolated cores automatically, you must position individual worker threads deliberately. Note that any other process with matching affinity can still run on these CPUs.

Domain isolation configured via `isolcpus` is locked at boot. Updating or clearing the isolated list requires a reboot. If you need dynamic isolation at runtime without rebooting, use cgroup v2 cpuset partitions instead. Limiting `cpuset.cpus` alone is not equivalent to an isolated scheduling partition; consult the kernel’s CPU isolation documentation for partition setup requirements.

To inspect the active kernel parameters and isolated CPUs:

```console
$ cat /proc/cmdline
```

```console
$ cat /sys/devices/system/cpu/isolated
```

An empty `isolated` file means no CPUs have this form of boot-time domain isolation. It does not report every form of isolation, such as runtime cpuset partitions.

`isolcpus=domain` only affects thread balancing. It does not disable device interrupts, suppress kernel background threads, or stop the scheduler clock tick. Hardware [IRQ](../../reference/glossary.md#term-IRQ) steering (*[irqbalance(1)](https://manpages.ubuntu.com/manpages/resolute/man1/irqbalance.1.html)*) must be configured separately. You can combine isolation with `nohz_full` to disable the timer tick when a single task runs on a core, and `isolcpus=managed_irq` to divert managed device interrupts, though neither offers a complete guarantee against system jitter.

> **Warning**
>
> Reserve enough housekeeping CPUs for operating-system tasks, device drivers, and SSH access. Remember SMT siblings: an unconstrained task running on a sibling thread will still contend for execution pipelines on the same core. Always verify boot isolation on a test host with remote console access before modifying production bootloaders.

## Placement for virtual machines and packet processing

For virtual machines managed by [Libvirt](../../how-to/virtualisation/libvirt.md#libvirt), pinning and memory policies belong in the host’s domain XML. A guest’s virtual CPU ([vCPU](../../reference/glossary.md#term-vCPU)) index does not map directly to host CPU numbers: setting affinity inside the VM only constrains guest processes to guest vCPUs, leaving the hypervisor’s underlying execution threads floating across the host.

Libvirt separates these controls:

| Domain setting | Purpose |
|----|----|
| `cputune/vcpupin` | Map each guest vCPU to an allowed set of host logical CPUs. |
| `cputune/emulatorpin` | Place emulator threads separately from vCPU threads. |
| `cputune/iothreadpin` | Place configured input/output (I/O) threads. |
| `numatune/memory` | Set the host NUMA memory policy and node set for the guest. |
| `cpu/numa` | Describe the NUMA topology visible inside the guest. |

Guest-visible topology alone does not establish host placement. A practical configuration pins a guest’s vCPU threads and memory to matching host nodes, while leaving enough host capacity for emulator and I/O work. Strict memory binding can prevent a guest from starting if the chosen nodes run out of memory. Host CPU and node numbers also need adjustment when migrating guests between physical hosts. See [Libvirt](../../how-to/virtualisation/libvirt.md#libvirt) for guest-management instructions and the upstream references below for domain configuration details.

## Checking the effect

Verify affinity masks and node-resident memory with `taskset --all-tasks --pid --cpu-list` and `numastat -p`. To monitor CPU utilization and voluntary or involuntary context switches per thread, use *[pidstat(1)](https://manpages.ubuntu.com/manpages/resolute/man1/pidstat.1.html)* from the `sysstat` package:

```console
$ pidstat -t -u -w -p 1864 1 1
```

This command takes a 1-second sample across all threads of PID 1864 (omitting final summary averages). Note that the `CPU` column shows which core ran the task during that snapshot, not its allowed mask, and context-switch counts do not measure cross-node migrations. Always measure application throughput and latency under identical load before and after tuning: verifying an affinity mask only confirms that placement took effect, not that it improved performance.

## Further reading

- *[sched_setaffinity(2)](https://manpages.ubuntu.com/manpages/resolute/man2/sched_setaffinity.2.html)* for affinity inheritance and restrictions

- *[numa(7)](https://manpages.ubuntu.com/manpages/resolute/man7/numa.7.html)* and *[set_mempolicy(2)](https://manpages.ubuntu.com/manpages/resolute/man2/set_mempolicy.2.html)* for Linux NUMA policy semantics

- [Linux kernel CPU isolation documentation](https://www.kernel.org/doc/html/latest/admin-guide/cpu-isolation.html)

- [Linux kernel parameters](https://www.kernel.org/doc/html/latest/admin-guide/kernel-parameters.html) for `isolcpus` and `nohz_full`

- [Control group v2 cpuset controller](https://www.kernel.org/doc/html/latest/admin-guide/cgroup-v2.html#cpuset)

- [Libvirt CPU tuning](https://libvirt.org/formatdomain.html#cpu-tuning) and [NUMA node tuning](https://libvirt.org/formatdomain.html#numa-node-tuning)

---

> 来源：https://ubuntu.com/server/docs/explanation/performance/perf-tune-affinity-numa/  
> 站点：Ubuntu Server documentation（canonical/ubuntu-server-documentation）
