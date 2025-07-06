[toc]



`conda config` 是 Conda 包管理器中的一个命令，用于查看和修改 Conda 的配置设置。它允许用户自定义 Conda 的行为，比如添加镜像源、设置默认环境路径、控制更新策略等。

---

## 📌 一、基本语法

```bash
conda config [选项]
```

---

## 🧩 二、常用功能与命令示例

### ✅ 查看当前配置

```bash
conda config --show
```

显示所有当前的 Conda 配置项及其值。

---

### ✅ 查看特定配置项

```bash
conda config --show channels
```

只显示 `channels` 配置项的内容。

---

### ✅ 添加/删除配置项

#### 添加镜像源（如清华源）

```bash
conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free/
conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main/
```

> 注意：有些教程会建议将 `defaults` 放在最后以避免优先级问题：
```bash
conda config --set channel_priority strict
```

---

### ✅ 删除某个配置项

```bash
conda config --remove channels 'https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main/'
```

---

### ✅ 设置默认 Python 版本

```bash
conda config --set default_python 3.9
```

新创建环境时默认使用 Python 3.9。

---

### ✅ 设置自动激活 base 环境（或关闭）

启用：

```bash
conda config --set auto_activate_base true
```

禁用：

```bash
conda config --set auto_activate_base false
```

---

### ✅ 显示所有可用配置名称

```bash
conda config --describe
```

可以查看所有可配置项及其含义。

---

## 📁 三、配置文件位置🎈

Conda 的配置保存在以下路径中（具体取决于你的系统）：

- Linux/macOS: `~/.condarc`
- Windows: `C:\Users\<用户名>\.condarc`

你可以手动编辑 `.condarc` 文件来修改配置。

---

## 🛠 四、一些推荐配置（例如国内镜像加速）

```bash
# 添加清华源
conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free/
conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main/
conda config --set channel_priority strict
```

---

## 🔚 五、重置配置

如果需要恢复默认配置：

```bash
rm ~/.condarc    # Linux/macOS
del .condarc     # Windows（在用户目录下）
```

然后重新运行 `conda` 命令时会自动生成默认配置文件。

---

## 📘 六、官方文档参考

🔗 [Conda Config 官方文档](https://docs.conda.io/projects/conda/en/latest/commands/config.html)

---



## conda配置文件内容示例



```cmd
PS> cmd
Microsoft Windows [版本 10.0.19045.4474]
(c) Microsoft Corporation。保留所有权利。

C:\Users\Administrator>where conda
C:\ProgramData\scoop\apps\miniconda3\current\Library\bin\conda.bat
C:\ProgramData\scoop\apps\miniconda3\current\Scripts\conda.exe
C:\ProgramData\scoop\apps\miniconda3\current\condabin\conda.bat

C:\Users\Administrator>conda env list

# conda environments:
#
                       C:\ProgramData\scoop\apps\miniconda3\24.9.2-0
base                 * C:\ProgramData\scoop\apps\miniconda3\current
py313                  C:\ProgramData\scoop\apps\miniconda3\current\envs\py313
                       c:\ProgramData\scoop\apps\miniconda3\24.9.2-0
```

