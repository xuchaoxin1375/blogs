[toc]

## abstract

本仓库配套的代码仓库: [scripts: 实用脚本集合,改善命令行使用体验. 改善windows下的powershell(pwsh7)和*nix系统bash/zsh使用体验.](https://gitee.com/xuchaoxin1375/scripts)

部署上述代码仓库后,对于powershell7用户(跨平台shell),可以执行如下流程部署python环境:

```powershell
# 前置操作:通过scoop或者其他方式安装miniforge3
scoop install miniforge3 # 可以考虑其他方案获取miniforge3,这不是唯一方案,如果已经安装,可以跳过次步骤

# 正式操作:

# 配置miniconda的配置(包括环境存储位置和镜像源),如果下面命令配置的源不可用,可以自行编辑`~/.condarc`文件
Deploy-MiniforgeConfig -Mode conda -OverrideMode Copy

# 向shell注册conda命令,例如在powershell(pwsh)上执行:
conda init # 注意,执行完务必新开一个shell会话才能让配置生效.(不要再使用旧会话,建议关闭旧会话防止误操作)


```

在新到shell窗口中执行:

```powershell

# 创建一个conda环境并激活(例如创建一个名为main的环境)
conda create -n main python=3.14  # 可以指定python版本

# 安装uv,以便使用uv pip install 来加速pip对包的安装速度

## 可选设置pip加速(如果默认镜像源不可用或者被限流,考虑自行更改镜像url):
Deploy-PipConfig -Mirror "https://mirrors.ustc.edu.cn/pypi/simple"
## 设置uv镜像源配置(注意事项同上)
Deploy-UvConfig -Mirror "https://mirrors.ustc.edu.cn/pypi/simple"

```



## 测试和使用

激活conda环境:

```powershell
conda activate main # 具体的环境名更换为你的实际值

# 安装uv(方案二选一即可)
## 方案1:使用pip方式安装
pip install uv
## 方案2:使用conda安装
conda install uv

# 安装某个python库
uv pip install pandas #以pandas为例

```

