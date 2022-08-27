# linux_tty_pts

## 概要

- [What is TTY and PTS in Linux? - CompuHoy.com](https://www.compuhoy.com/what-is-tty-and-pts-in-linux/)
- [linux - Difference between pts and tty - Unix & Linux Stack Exchange](https://unix.stackexchange.com/questions/21280/difference-between-pts-and-tty#:~:text=A tty is a native,be found in man pty .))
- A `tty` is a regular terminal device (the **console** on your server, for example).
  - A *tty* is **a native terminal device**, the backend is either **hardware or kernel emulated**.
- A *`pty`* (pseudo terminal device) is a terminal device which is <u>emulated by an other program</u>
  -  (example: `xterm`, `screen`, or `ssh` are such programs). 
  - A *pts* is the slave part of a *pty*.
- A `pts` is a psuedo terminal **slave** (an `xterm` or an `ssh` connection).

> - `man pts` has a verbose description of pseudo terminals.
> - More info can be found in `man pty`

## tty

- ```bash
  $ whatis tty
  tty (1)              - print the file name of the terminal connected to standard input
  tty (4)              - controlling terminal
  tty (1posix)         - return user's terminal name
  ```

- ```
  TTY(4)                               Linux Programmer's Manual                              TTY(4)
  
  NAME
         tty - controlling terminal
  
  DESCRIPTION
         The  file  /dev/tty  is a character file with major number 5 and minor number 0,
         usually of mode 0666 and owner.group root.tty. 
         It is a synonym for  the  controlling  terminal  of  a process, if any.
  ```
## pty

```bash
NAME
       pty - pseudoterminal interfaces
DESCRIPTION
       A  pseudoterminal (sometimes abbreviated "pty") is a pair of virtual character devices that
       provide a bidirectional communication channel. 
       One end of the channel is called  the  master; 
       the other end is called the slave.
```

### details

```bash
   The slave end of the pseudoterminal provides an interface that behaves exactly like a clas‐
   sical terminal.
   
   A process that expects to be connected to a terminal, can open  the  slave
   end  of  a  pseudoterminal  and then be driven by a program that has opened the master end.
   
   Anything that is written on the master end is provided to the process on the slave  end  as
   though  it  was  input  typed  on a terminal.
   
   For example, writing the interrupt character
   (usually control-C) to the master device would cause an interrupt  signal  (SIGINT)  to  be
   generated  for  the  foreground  process group that is connected to the slave. 
   
   Conversely,
   anything that is written to the slave end of the pseudoterminal can be read by the  process
   that is connected to the master end.

   Data  flow  between  master and slave is handled asynchronously, much like data flow with a
   physical terminal.
   
   Data written to the slave will be available at the master promptly(迅速), but
   may not be available immediately. 
   Similarly, there may be a small processing delay between
   a write to the master, and the effect being visible at the slave.

   Historically, two pseudoterminal APIs have evolved: 
   BSD and System V.  SUSv1 standardized a   pseudoterminal  API  based  on the System V API, and this API should be employed in all new programs that use pseudoterminals.

   Linux provides both BSD-style and (standardized) System V-style pseudoterminals. 
   System V-style terminals are commonly called UNIX 98 pseudoterminals on Linux systems.

   Since  kernel  2.6.4,  BSD-style  pseudoterminals are considered deprecated: support can be
   disabled when building the kernel by disabling the  CONFIG_LEGACY_PTYS  option.   
   (Starting   with  Linux  2.6.30,  that  option is disabled by default in the mainline kernel.) 
   UNIX 98   pseudoterminals should be used in new applications.
```

###  UNIX 98 pseudoterminals

​       An unused UNIX 98 pseudoterminal master is opened by calling posix_openpt(3). 

 (This  function  opens the master clone device, /dev/ptmx; see pts(4).)  

After performing any program specific initializations, changing the ownership and permissions of the slave device  using
       grantpt(3),  and unlocking the slave using unlockpt(3)), the corresponding slave device can
       be opened by passing the name returned by ptsname(3) in a call to open(2).

       The Linux kernel imposes a limit on the number of available UNIX  98  pseudoterminals. 
       In   kernels  up  to  and  including  2.6.3, this limit is configured at kernel compilation time
       (CONFIG_UNIX98_PTYS), and the permitted number of pseudoterminals can be up to 2048, with a
       default  setting  of  256.   Since  kernel  2.6.4,  the limit is dynamically adjustable via
       /proc/sys/kernel/pty/max, and a corresponding file, /proc/sys/kernel/pty/nr, indicates  how
       many  pseudoterminals  are  currently  in use.  For further details on these two files, see
       proc(5).


## pts

- ```
  
  
  
  PTS(4)                               Linux Programmer's Manual                              PTS(4)
  
  NAME
         ptmx, pts - pseudoterminal master and slave
  
  
  ```
  
-  The file /dev/ptmx is a character file with major number 5 and minor number 2,
   usually of  mode 0666 and owner.group of root.root. 

-  It is used to create a pseudoterminal master and  slave pair.  

-  When a process opens /dev/ptmx, it gets a file descriptor for a pseudoterminal master  (PTM), 
   and a pseudoterminal slave (PTS) device is created in the /dev/pts directory.

-  Each  file descriptor **obtained** by opening /dev/ptmx is an **independent** PTM with its own associated  PTS, whose path can be found by passing the file descriptor to **ptsname(3)**. 

- Before opening the **pseudoterminal slave**, you must <u>pass the master's file descriptor</u> to  grantpt(3) and unlockpt(3).  

- Once both the pseudoterminal master and slave are open, the **slave** <u>provides processes with  an interface that is identical to that of a real terminal</u>.  

- Data written to the **slave** is <u>presented on **the master file descriptor** as input</u>. 

- Data written to the **master** is presented to the **slave** as input.   

- In practice, **pseudoterminals** are used for **implementing terminal emulators** such as xterm(1), 
  -  in which data read from the pseudoterminal master is interpreted by the application i<u>n the  same way a real terminal would interpret</u> the data, 
  - and for implementing <u>remote-login programs such as sshd(8)</u>,
    -  in which data read from the pseudoterminal master is **sent across the  network to a client program** that is <u>connected to a terminal or terminal emulator.</u>  
  -  Pseudoterminals can also be used to send input to programs that normally refuse to read  input from pipes (such as su(1), and passwd(1)).

### What does pts mean in TTY?

- PTS: Stands for the **pseudo terminal slave**. 
- The difference between TTY and PTS is <u>the type of connection to the computer.</u> 
- TTY ports are <u>**direct connections**</u> to the computer s<u>uch as a keyboard/mouse or a serial connection to the device.</u>

## 相关试验

### 在pts/0的连接下创建若干进程

![image-20220428184434379](https://cdn.jsdelivr.net/gh/xuchaoxin1375/pictures@main/images/image-20220428184434379.png)

### 使用ps 命令查看(进程树)

#### 命令解释

```bash
cxxu@cxxuAli:/dev/pts$ manly ps --forest -ft

ps - report a snapshot of the current processes.
================================================

      -t ttylist
              Select by tty.  This selects the processes associated with the
              terminals given in ttylist.  Terminals (ttys, or screens for
              text output) can be specified in several forms: /dev/ttyS1,
              ttyS1, S1.  A plain "-" may be used to select processes not
              attached to any terminal.

      -f     Do full-format listing. This option can be combined with many
              other UNIX-style options to add additional columns.  It also
              causes the command arguments to be printed.  When used with -L,
              the NLWP (number of threads) and LWP (thread ID) columns will be
              added.  See the c option, the format keyword args, and the
              format keyword comm.

      --forest
              ASCII art process tree.
```



![image-20220428184539033](https://cdn.jsdelivr.net/gh/xuchaoxin1375/pictures@main/images/image-20220428184539033.png)

### 进程托孤

![img](https://cdn.jsdelivr.net/gh/xuchaoxin1375/pictures@main/images/clip_image002.jpg)



