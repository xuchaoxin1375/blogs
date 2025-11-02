\[toc\]

## abstract

ms-edit是开源跨平台的命令行文本编辑器[microsoft/edit: We all edit.](https://github.com/microsoft/edit),特点如下:

- rust编写,启动快速,资源占用低,跨平台,安装简单

- 简单易用,支持鼠标和快捷键,操作符合直觉,如同使用记事本那样简单,对于新手服务器管理员友好

除了官方文档提供的安装方案,还有更容易执行的安装方案(虽然手动安装也不麻烦)

下面是linux系统通用的一键安装脚本(由于需要访问github,部分网络可能不能直接顺利执行成功,可以考虑镜像加速或者代理加速)

下面的脚本提供两种方案,方案1支持自动获取最新版链接,方案2可以手动指定链接,适合镜像加速后的链接

```bash
# 1 注意edit版本链接的获取方案(1.1,1.2分别为自动和手动)
## 1.1 方案1:自动获取最新版本
# 获取系统架构
arch=$(uname -m)

# 获取最新版本信息
latest_release=$(curl -s https://api.github.com/repos/microsoft/edit/releases/latest)
version=$(echo $latest_release | grep tag_name | cut -d '"' -f 4)

# 根据架构选择正确的下载链接
if [ "$arch" = "x86_64" ]; then
    download_url=$(echo $latest_release | grep browser_download_url | grep x86_64-linux-gnu | cut -d '"' -f 4)
elif [ "$arch" = "aarch64" ] || [ "$arch" = "arm64" ]; then
    download_url=$(echo $latest_release | grep browser_download_url | grep aarch64-linux-gnu | cut -d '"' -f 4)
else
    echo "不支持的架构: $arch"
    exit 1
fi

echo "检测到系统架构: $arch"
echo "下载链接: $download_url"

# 下载最新版本
curl -L $download_url -o ~/edit.tar.zst

## 1.2 方案2:根据指定链接下载指定版本

# curl -L https://github.com/microsoft/edit/releases/download/v1.2.1/edit-1.2.0-x86_64-linux-gnu.tar.zst -o ~/edit.tar.zst


# 2 解压并安装
zstd -d ~/edit.tar.zst -o ~/edit.tar
# 解压tar获得edit文件(可执行程序)
tar -xvf ~/edit*.tar -C ~

# 重命名edit为msedit #推荐,部分情况在需要,edit名字可能和已有命令冲突!
newname="msedit" # 如果不想要改动edit名字,则把msedit改回edit即可(pacman安装的ms-edit就是通过msedit调用的)
mv ~/edit ~/$newname -fv

# 如果~/.local/bin 不存在，则创建
if [ ! -d ~/.local/bin ]; then
  mkdir -p ~/.local/bin
fi
mv ~/$newname ~/.local/bin/$newname -fv

# 尝试为所有用户创建软链接(可能需要权限)
# 添加权限检查和sudo
if [ -w /usr/local/bin ]; then
    ln -s ~/.local/bin/$newname /usr/local/bin/$newname -fv
else
    echo "需要管理员权限才能创建软链接到 /usr/local/bin/"
    # 或者提示用户手动执行: sudo ln -s ~/.local/bin/$newname /usr/local/bin/$newname
fi

# 检查软件包是否安装成功,版本号打印
$newname --version
$newname -h 
```

虽然上述脚本在实际设备上测试过,但是由于软件不断更新,内容仅供参考.