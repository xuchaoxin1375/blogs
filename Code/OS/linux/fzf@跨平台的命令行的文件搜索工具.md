[toc]



## abstract

[junegunn/fzf: :cherry_blossom: A command-line fuzzy finder](https://github.com/junegunn/fzf?tab=readme-ov-file#windows-packages)



### 安装

文档中列出了各种的安装方法

对于linux/macos,安装较新版本的fzf,可以使用brew或git的方式

这里列出其中几个不需要依赖或者依赖比较容易满足的方式

### git方式

> 国内可能要用代理或者加速镜像包装一下clone链接

需要你事先安装好git,有些系统自带,有些需要自己安装(这很简单)

然后执行

```bash
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

```



### 直接下载二进制文件

> 国内可能要用代理或者加速镜像包装一下clone链接

Binary releases

- https://github.com/junegunn/fzf/releases



### brew 方式

brew下fzf时如果下不动,可以换源

[homebrew | 镜像站使用帮助 | 清华大学开源软件镜像站 | Tsinghua Open Source Mirror](https://mirrors.tuna.tsinghua.edu.cn/help/homebrew/)

```bash
# cxxu @ CxxuDesk in /mnt/c/Users/Administrator/Desktop [8:21:18]
$ brew install fzf
==> Downloading https://ghcr.io/v2/homebrew/core/fzf/manifests/0.62.0
Already downloaded: /home/cxxu/.cache/Homebrew/downloads/289172a7b90590f68bd95a3928f927a8471ce009f7e296bfad0acc770814fa19--fzf-0.62.0.bottle_manifest.json
==> Fetching dependencies for fzf: ncurses
==> Downloading https://ghcr.io/v2/homebrew/core/ncurses/manifests/6.5
Already downloaded: /home/cxxu/.cache/Homebrew/downloads/b2f8ce4e08b15832435170efd265346225ee388d5baab3d5c50e3a77c5673b5a--ncurses-6.5.bottle_manifest.json
==> Fetching ncurses
==> Downloading https://ghcr.io/v2/homebrew/core/ncurses/blobs/sha256:7c49662d0f319baec24475d38210b2f9c754b2ec1d21
Already downloaded: /home/cxxu/.cache/Homebrew/downloads/d997b5c8237c6a328f7994e79c20a06caf2547d6596a54945d6dd259761f8e8c--ncurses--6.5.x86_64_linux.bottle.tar.gz
==> Fetching fzf
==> Downloading https://ghcr.io/v2/homebrew/core/fzf/blobs/sha256:826ac62a23865713b1360a8ff63e6c3cfdb3f30f6f7d1b51
Already downloaded: /home/cxxu/.cache/Homebrew/downloads/62546504c578a762142cb475d289d97a5a4cec36229e18b6d66e8f2d3ffd46f5--fzf--0.62.0.x86_64_linux.bottle.tar.gz
==> Installing dependencies for fzf: ncurses
==> Installing fzf dependency: ncurses
==> Downloading https://ghcr.io/v2/homebrew/core/ncurses/manifests/6.5
Already downloaded: /home/cxxu/.cache/Homebrew/downloads/b2f8ce4e08b15832435170efd265346225ee388d5baab3d5c50e3a77c5673b5a--ncurses-6.5.bottle_manifest.json
==> Pouring ncurses--6.5.x86_64_linux.bottle.tar.gz
==> Downloading https://formulae.brew.sh/api/cask.jws.json
🍺  /home/linuxbrew/.linuxbrew/Cellar/ncurses/6.5: 4,037 files, 10.9MB
==> Installing fzf
==> Pouring fzf--0.62.0.x86_64_linux.bottle.tar.gz
==> Caveats
To set up shell integration, see:
  https://github.com/junegunn/fzf#setting-up-shell-integration
To use fzf in Vim, add the following line to your .vimrc:
  set rtp+=/home/linuxbrew/.linuxbrew/opt/fzf
==> Summary
🍺  /home/linuxbrew/.linuxbrew/Cellar/fzf/0.62.0: 19 files, 4.5MB
==> Running `brew cleanup fzf`...
Disable this behaviour by setting HOMEBREW_NO_INSTALL_CLEANUP.
Hide these hints with HOMEBREW_NO_ENV_HINTS (see `man brew`).
==> Caveats
==> fzf
To set up shell integration, see:
  https://github.com/junegunn/fzf#setting-up-shell-integration
To use fzf in Vim, add the following line to your .vimrc:
  set rtp+=/home/linuxbrew/.linuxbrew/opt/fzf
```

