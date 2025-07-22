[toc]



```bash
# 下载并编译安装最新版 lz4
git clone https://github.com/lz4/lz4.git  ~/lz4-build
cd ~/lz4-build

# 可选：切换版本
git checkout $(git tag -l | grep -E '^v[0-9]+' | sort -V | tail -n1)  # 最新版本

# 编译并安装
make
sudo make install

# 刷新库缓存
sudo ldconfig

# 验证
lz4 --version

# 清理（可选）
cd ..
rm -rf ~/lz4-build
```

