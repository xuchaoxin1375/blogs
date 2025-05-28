[toc]



在 Linux 上配置 `PYTHONPATH` 环境变量，可以让 Python 在导入模块时额外查找你指定的路径。以下是针对 **Bash** 和 **Zsh** 的配置方法。

---

## ✅ 一、临时设置（当前终端会话有效）

```bash
export PYTHONPATH=/your/custom/path:$PYTHONPATH
```

这个方式只对当前终端窗口/会话有效，关闭终端后失效。

---

## ✅ 二、永久设置（推荐）🎈

### 1. Bash 用户

编辑你的 Bash 配置文件：

```bash
nano ~/.bashrc
```

在文件末尾添加：

```bash
export PYTHONPATH="/your/custom/path:$PYTHONPATH"
```

> 例如:` export PYTHONPATH="/repos/scripts/wp/woocommerce/woo_df:$PYTHONPATH"  `

保存并退出，然后应用更改：

```bash
source ~/.bashrc
```

---

### 2. Zsh 用户

编辑你的 Zsh 配置文件：

```bash
nano ~/.zshrc
```

在文件末尾添加：

```bash
export PYTHONPATH="/your/custom/path:$PYTHONPATH"
```

保存并退出，然后应用更改：

```bash
source ~/.zshrc
```

---

### 使用重定向的方式添加

例如:

对于bash

```ini
echo 'export PYTHONPATH="/repos/scripts/wp/woocommerce/woo_df:$PYTHONPATH"' >> ~/.bashrc
```

对于zsh

```ini
echo 'export PYTHONPATH="/repos/scripts/wp/woocommerce/woo_df:$PYTHONPATH"' >> ~/.zshrc
```



## ✅ 三、验证是否生效

运行以下命令查看是否设置成功：

```bash
echo $PYTHONPATH
```

你应该能看到你添加的路径。

也可以使用 Python 查看当前搜索路径：

```bash
python3 -c "import sys; print(sys.path)"
```

你会看到 `/your/custom/path` 出现在输出中。

```bash
#( 05/27/25@ 9:49AM )( root@wnx0020303 ):~
   python3 -c "import sys; print(sys.path)"
['', '/repos/scripts/wp/woocommerce/woo_df', '/usr/lib/python312.zip', '/usr/lib/python3.12', '/usr/lib/python3.12/lib-dynload', '/usr/local/lib/python3.12/dist-packages', '/usr/lib/python3/dist-packages']
```



---

## 🧠 小贴士

- 可以添加多个路径，用冒号 `:` 分隔：

```bash
export PYTHONPATH="/path1:/path2:$PYTHONPATH"
```

## 系统级配置🎈

- 如果你想让所有用户都能使用这个环境变量，可以修改系统级配置文件如 `/etc/profile` 或 `/etc/environment`（需管理员权限）。

- 例如添加一条记录:(多个取值用`:`划分)

  ```ini
  PYTHONPATH="/repos/scripts/wp/woocommerce/woo_df"
  ```

  

---

