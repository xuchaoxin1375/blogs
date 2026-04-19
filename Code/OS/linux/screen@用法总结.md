[toc]



`screen` 是 Linux 下一个非常实用的**终端多路复用器（terminal multiplexer）**，它允许你在一个终端窗口中运行多个终端会话，并且可以断开连接后重新连接回来，非常适合远程服务器操作、长时间运行任务等场景。

---

## 🧰 一、安装 screen（如未安装）

在大多数 Linux 发行版中 `screen` 默认已安装。如果没有：

### Debian/Ubuntu：
```bash
sudo apt install screen
```

### CentOS/RHEL：
```bash
sudo yum install screen
```

---

## 🔍 二、常用命令总结

### ✅ 1. 启动一个新的 screen 会话

```bash
screen
```

启动后你会进入一个新的 shell 环境，按任意键即可继续。

---

### ✅ 2. 启动带命名的 session（推荐）

```bash
screen -S mysession
```

给会话起名字方便后续管理，比如你可以命名为 `download`, `train_model` 等。

---

### ✅ 3. 查看所有正在运行的 screen 会话

```bash
screen -ls
```

输出示例：
```
There are screens on:
	1234.mysession	(Attached)
	5678.download	(Detached)
```

- **Attached**：当前连接到该会话。
- **Detached**：会话在后台运行，没有连接。

---

### ✅ 4. 恢复某个 detached 的会话

```bash
screen -r mysession
```

或使用编号：

```bash
screen -r 1234
```

---

### ✅ 5. 断开会话（保留后台运行）

在会话中按下以下组合键（默认前缀是 `Ctrl + A`）：

```
Ctrl + A   然后按 D
```

> 这样你就可以“离开”当前会话而不终止里面的程序。

---

### ✅ 6. 结束当前 screen 会话

直接在会话内输入：

```bash
exit
```

或者执行完程序自动退出后，会话也会结束。

---

### ✅ 7. 强制恢复被标记为 "Dead" 的会话

如果系统崩溃或网络中断导致某些会话状态异常，可以用：

```bash
screen -d -r mysession
```

强制断开并恢复。

---

## 📌 三、常用快捷键（前缀：`Ctrl + A`）

| 快捷键                | 功能                         |
| --------------------- | ---------------------------- |
| `Ctrl + A` 然后 `C`   | 创建一个新的窗口（tab）      |
| `Ctrl + A` 然后 `N`   | 切换到下一个窗口             |
| `Ctrl + A` 然后 `P`   | 切换到上一个窗口             |
| `Ctrl + A` 然后 `"`   | 显示窗口列表，选择切换       |
| `Ctrl + A` 然后 `0~9` | 直接跳转到第 0~9 号窗口      |
| `Ctrl + A` 然后 `D`   | 断开当前会话（后台继续运行） |
| `Ctrl + A` 然后 `K`   | 杀死当前窗口（谨慎使用）     |

---

## 🧪 四、典型使用场景

### 场景 1：运行耗时任务（如下载、训练模型）

```bash
screen -S train
python train.py
# 按 Ctrl+A+D 断开，任务仍在后台运行
```

之后可以随时恢复查看进度：

```bash
screen -r train
```

---

### 场景 2：同时运行多个任务

```bash
screen -S work
Ctrl + A C     # 创建新窗口
Ctrl + A N/P    # 在不同窗口之间切换
```

每个窗口都可以运行独立的程序。

---

## 🧠 五、高级技巧

### 自动重连脚本（避免重复 attach/detach）

```bash
screen -d -r work || screen -S work
```

如果存在名为 `work` 的会话就恢复，否则新建一个。

---

## ✅ 六、总结一句话：

> **`screen` 是 Linux 用户必备的终端工具之一，它让你可以“永不掉线”地运行和管理多个终端任务，尤其适合远程服务器操作和长时间运行的任务。**

 

## 案例

```bash
#ssh root@host "screen -dmS zw bash -c 'bash /www/wwwroot/deploy_wp_full.sh --user-dir zw; exec bash'"
ssh root@host "screen -dmS zsh bash -c '/www/wwwroot/deploy_wp_full.sh --user-dir zsh; exec bash'"
```

