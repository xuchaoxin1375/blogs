[toc]

## abstract

在windows上我编写了一个bash脚本,通过ssh让linux服务器运行本地脚本

你可以使用 `ssh` 命令在 Linux 服务器上远程运行 Windows 本地的 Bash 脚本，有几种方式可以实现：

------

### 方式 1：通过 `cat` 传输并执行

这种方法适用于小型脚本，不需要创建远程文件。

```bash
cat local_script.sh | ssh user@remote_host 'bash -s'
```

**解释：**

- `cat local_script.sh` 读取本地脚本的内容。
- `ssh user@remote_host 'bash -s'` 让远程主机的 `bash` 解释器接收标准输入并执行。

------

### 方式 2：通过 `scp` 传输脚本然后执行

适用于较大的脚本，或需要多次执行的情况。

```bash
scp local_script.sh user@remote_host:/tmp/local_script.sh
ssh user@remote_host 'bash /tmp/local_script.sh'
```

**解释：**

- `scp` 命令将 `local_script.sh` 复制到远程 `/tmp/` 目录。
- `ssh` 命令在远程服务器上执行该脚本。

------

### 方式 3：通过 `ssh` 直接执行本地脚本

适用于不希望在远程服务器上创建文件的情况。

```bash
ssh user@remote_host 'bash -s' < local_script.sh
```

**解释：**

- `< local_script.sh` 将本地脚本的内容通过 `stdin` 传递给 `ssh` 命令。
- `bash -s` 在远程 Linux 上执行这个标准输入传来的脚本内容。

------

### 方式 4：使用 `ssh` 传递参数

如果你的脚本需要参数，可以使用这种方式。

```bash
ssh user@remote_host 'bash -s' < local_script.sh arg1 arg2
```

或者：

```bash
cat local_script.sh | ssh user@remote_host 'bash -s -- arg1 arg2'
```

**解释：**

- `bash -s -- arg1 arg2` 让 `bash` 识别参数，并正确传递给脚本。

------

### 方式 5：使用 `rsync` 传输并执行

如果脚本较大，或者你需要定期同步，可以用 `rsync` 传输。

```bash
rsync -avz local_script.sh user@remote_host:/tmp/local_script.sh
ssh user@remote_host 'bash /tmp/local_script.sh'
```

**解释：**

- `rsync` 传输文件，适用于多次运行的情况，比 `scp` 高效。

------

### 方式 6：使用 `ssh` 远程下载并执行

如果你在 Windows 机器上启用了 HTTP 服务器（如 Python 简单 HTTP 服务器），可以让 Linux 远程下载并执行。

在 Windows 本地运行：

```bash
python -m http.server 8000
```

在远程 Linux 上运行：

```bash
curl -s http://windows_host:8000/local_script.sh | bash
```

或者：

```bash
wget -qO- http://windows_host:8000/local_script.sh | bash
```

------

### 结论

| 方法                                                         | 适用场景                        |
| ------------------------------------------------------------ | ------------------------------- |
| `cat local_script.sh                                         | ssh user@remote_host 'bash -s'` |
| `scp local_script.sh user@remote_host:/tmp/ && ssh user@remote_host 'bash /tmp/local_script.sh'` | 需要多次执行                    |
| `ssh user@remote_host 'bash -s' < local_script.sh`           | 远程无存储                      |
| `ssh user@remote_host 'bash -s -- arg1 arg2' < local_script.sh` | 需要参数                        |
| `rsync -avz local_script.sh user@remote_host:/tmp/ && ssh user@remote_host 'bash /tmp/local_script.sh'` | 需要高效同步                    |
| `curl -s http://windows_host:8000/local_script.sh            | bash`                           |

如果你的脚本较长，建议使用 `scp` 或 `rsync` 传输后执行。如果只是一次性执行，可以直接用 `ssh` 传输 `stdin`。

你打算使用哪种方式？如果有具体需求，可以进一步优化。