<a id="perf-tune-cpupower"></a>

# The cpupower tool

> **Note**
>
> System tuning tools are either about better understanding the system’s performance, or applying such knowledge to improve it. See our common [system tuning thoughts](../performance.md#explanation-system-tuning-disclaimer) for some generally applicable considerations about that.

This page is about the `cpupower` tool, which can be handy to inspect and manage the CPU power settings. This is mostly controlled via [CPU Power states](perf-p-states.md#perf-p-states) which are important to be understood before taking action.

## Monitor CPU frequency

Before changing anything, look at the current frequencies via `cpupower monitor`. Many systems have various potential monitors, and by default one sees all of them which can be quite confusing. Therefore start with looking at the available power monitors.

Command (list all available `cpupower` monitors available on the system):

```console
$ sudo cpupower monitor -l
```

This example output is from a common consumer laptop. Here we can see that the machine has four available monitors shown in `"`.

- `Nehalem` - Hardware specific C states.

- `Mperf` - Average of frequencies and time in active (`C0`) or sleep (`Cx`) states.

- `RAPL` - Running Average Power Limit covering different system elements.

- `Idle_Stats` - Statistics of the `cpuidle` kernel subsystem (software based).

Those counters can represent different system units:

- \[T\] -\> Thread

- \[C\] -\> Core

- \[P\] -\> Processor Package (Socket)

- \[M\] -\> Machine/Platform wide counter

So if we want to know what frequency the CPU threads were in (`Mperf`) and what was consumed at the different system levels of package, dram, core and uncore (RAPL) averages over a minute (`-i <seconds>`) we would run:

Command:

```console
$ sudo cpupower monitor -i 60 -m Mperf,RAPL
```

## Get details about the boundaries for the CPU frequency

There are more details influencing the CPU frequency, such as the driver used to control the hardware, the min and max frequencies, and potential boost states. These can be collected with `cpupower frequency-info`

Command:

```console
$ cpupower frequency-info
```

By default this checks the CPU it is executed on. The argument `-c` can be set to either a number representing a core or `all` to get the info for all available CPUs.

## Get details about the idle states

[Idle states](https://docs.kernel.org/admin-guide/pm/cpuidle.html) represent situations when a CPU enters a state of suspension to save power. The tool `cpupower idle-info` reports about the available idle states, their description and attributes. These can be useful when debugging CPU performance if one is curious about the details of a given state after running `cpupower monitor` above.

Command:

```console
$ cpupower idle-info
```

After reading a bit (much more in the *Further reading* section) into C-states, P-states and Idle states we can also re-run `cpupower monitor` without filtering as now the further columns can be related to the above output.

Command:

```console
$ sudo cpupower monitor
```

## What should I do with all of this?

All this information is usually only *data* without any insight until you either:

- compare them with historical data (it is generally recommended to gather performance and power metrics regularly to be able to compare them to the healthy state in case of any debugging scenario), or

- compare them with your expectations and act on any mismatch

## Does it match what you expect?

One might have expectations about the behavior of a system. Examples are:

- I’m not doing much – it should be idling most of the time

- I have a very busy workload, I expect it to run at highest frequency

- I do not expect my workload to allow the system to go into low power states

You can hold any of these assumptions against the output of `cpupower monitor` and verify that they are true. If they are not, use `cpupower frequency-info` to check if the current constraints match what you think. And use `cpupower frequency-set` (below) to set a different governor if needed.

## Control the CPU governors and CPU frequency

An administrator can execute the `cpupower` command to set the CPU governor.

Command (set the CPU governor to `performance` mode on all CPUs):

```console
$ cpupower frequency-set -g performance
```

Since all commands of `cpupower` can be for a sub-set of CPUs, one can use `-c` here as well if that matches what is needed for more complex scenarios.

Command (Set `conservative` on the first 8 cores in a system):

```console
$ cpupower -c 0-7 frequency-set -g conservative
```

## Powertop

`powertop` supports the user in identifying reasons for unexpected high power consumption by listing reasons to wake up from low power states. The look and feel aligns with the well known `top`. `powertop` is not installed by default, before trying run `sudo apt install powertop`. This command needs elevated permissions, so run it with `sudo`.

```console
$ sudo powertop
```

It has six tabs for the various areas of interest:

- Overview - frequency and reason for activity

- Idle stats - time spent in the different idle states

- Frequency stats - current frequency per core

- Device stats - activity of devices

- Tunables - a list of system tunables related to power (ratings are to save power, you might have some `Bad` for that being considered better for performance)

- WakeUp - device wake-up status

## Further reading

- [Intel Frequency scaling](https://docs.kernel.org/admin-guide/pm/intel_uncore_frequency_scaling.html)

- [Idle states](https://docs.kernel.org/admin-guide/pm/cpuidle.html)

- [C-states](https://docs.kernel.org/admin-guide/pm/intel_idle.html)

---

> 来源：https://ubuntu.com/server/docs/explanation/performance/perf-tune-cpupower/  
> 站点：Ubuntu Server documentation（canonical/ubuntu-server-documentation）
