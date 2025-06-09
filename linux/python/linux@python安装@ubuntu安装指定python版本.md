[toc]

## abstract

在 Ubuntu 上安装 Python 3.12，推荐使用 **deadsnakes PPA** 或从源码编译安装。

下面给出两种方法的详细步骤，并注明适用于 Ubuntu 20.04、22.04 及更高版本。

linux上,一般python和pip分别安装



------

### 方法一：使用 deadsnakes PPA（推荐）🎈

**适用版本**：Ubuntu 20.04+, 22.04+
 **优点**：简单、快速、自动管理依赖
 **缺点**：由第三方维护，不一定是官方最新编译优化

#### 步骤：

```bash
# 更新系统包索引
sudo apt update
sudo apt install -y software-properties-common

# 添加 deadsnakes 仓库
sudo add-apt-repository ppa:deadsnakes/ppa
sudo apt update

# 安装 Python 3.12
sudo apt install -y python3.12

# 可选：设置 python3 默认版本为 3.12（慎用）
sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.12 1

# 检查安装成功
python3.12 --version
```

------

### 方法二：从源码安装（适合编译优化、定制）

**适用版本**：任何 Ubuntu 版本
 **优点**：自己控制编译参数、最新源代码
 **缺点**：编译时间长、需手动管理依赖

#### 步骤：

```bash
# 安装依赖
sudo apt update
sudo apt install -y build-essential zlib1g-dev libncurses5-dev \
libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev \
libsqlite3-dev wget curl libbz2-dev

# 下载源码（建议从官网查最新版本）
cd /usr/src
sudo wget https://www.python.org/ftp/python/3.12.3/Python-3.12.3.tgz
sudo tar -xf Python-3.12.3.tgz
cd Python-3.12.3

# 配置构建参数，启用优化
sudo ./configure --enable-optimizations
sudo make -j$(nproc)

# 安装（推荐使用 altinstall 避免覆盖默认 python）
sudo make altinstall

# 检查版本
python3.12 --version
# 安装pip
curl -sS https://bootstrap.pypa.io/get-pip.py | sudo python3.12
python3.12 -m pip --version

```

------

### 安装后常用配置（可选）

#### pip 安装🎈

```bash
# 有些情况下 pip 需要单独安装
sudo apt install -y python3.12-venv python3.12-dev

# 手动安装 pip（如果缺失）
curl -sS https://bootstrap.pypa.io/get-pip.py | sudo python3.12
python3.12 -m pip --version
```

#### 设置默认 python 版本（不推荐覆盖系统自带）

```bash
sudo update-alternatives --install /usr/bin/python python /usr/bin/python3.12 1
sudo update-alternatives --config python
```

------

### 总结对比

| 方法           | 是否官方 | 适用场景               | 难度  | 是否推荐       |
| -------------- | -------- | ---------------------- | ----- | -------------- |
| deadsnakes PPA | 第三方   | 快速安装常用版本       | ★★☆☆☆ | ✅ 推荐         |
| 源码编译       | 官方     | 最新版本、定制编译需求 | ★★★★☆ | ⚠️ 有经验者推荐 |

------

