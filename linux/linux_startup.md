## reference

* [How to automatically run program on Linux startup (simplified.guide)](https://www.simplified.guide/linux/automatically-run-program-on-startup#automatically-run-program-on-linux-startup-via-rclocal)## Automatically run program on Linux startup via rc.local

### Automatically run program on Linux startup via rc.local

---

*rc.local* is a legacy from the *System V init* system. It is the last script to be executed before proceeding to a login screen for the desktop environment or a login prompt at the terminal. It's usually a *Bash* shell script, and you can run anything from the script.

You can configure your *rc.local* script following these steps:

1. Open or create */etc/rc.local* file if it doesn't exist using your favourite editor as the *root* user.

   ```
   $ sudo vi /etc/rc.local
   ```
2. Add placeholder code into the file.

   ```
   #!/bin/bash

   exit 0
   ```

   It must start with interpreter ( */bin/bash* ) and ends with an exit code (*0* is for  *success* )
3. Add command and logics to the file as necessary.

   ```
   #!/bin/bash

   /sbin/ip addr | grep inet\ | tail -n1 | awk '{ print $2 }' > /etc/issue
   echo "" >> /etc/issue

   exit 0
   ```
4. Set the file to executable.

   ```
   $ sudo chmod a+x /etc/rc.local
   ```

   The file will be executed as the *root* user during system boot

