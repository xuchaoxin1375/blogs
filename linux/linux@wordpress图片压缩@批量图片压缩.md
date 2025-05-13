[toc]

## 覆盖式压缩图片

假设你有多个 WordPress 网站，在每个站点的 `wp-content/uploads/2025/` 目录下存有大量图片，需要压缩这些图片（`.jpg` 和 `.webp`），**保持文件名不变并直接覆盖原图**。

下面我为你准备了一个**高效的、自动递归、覆盖原图的 Bash 脚本**，支持：

- 自动遍历多个站点
- 自动定位 `wp-content/uploads/2025/` 目录
- 使用 `jpegoptim` 压缩 JPG
- 使用 `cwebp` 压缩 WebP
- 覆盖原图
- 并行加速（可选）

### 必要软件安装🎈

确保安装了下面两个工具：

```bash
sudo apt update
sudo apt install jpegoptim webp
```

------



------

### 一键压缩脚本（推荐使用）

```bash
#!/bin/bash

# 定义根目录（包含多个网站）
ROOT_DIR="/var/www"   # 替换为你的站点根路径

# JPG压缩质量
JPG_QUALITY=85

# WEBP压缩质量
WEBP_QUALITY=80

# 记录压缩日志
LOG_FILE="/tmp/image_compress.log"
echo "开始压缩：$(date)" > "$LOG_FILE"

# 遍历所有 uploads/2025 目录
find "$ROOT_DIR" -type d -path "*/wp-content/uploads/2025*" | while read upload_dir; do
    echo "处理目录: $upload_dir" >> "$LOG_FILE"
    
    # 压缩JPG
    find "$upload_dir" -type f \( -iname "*.jpg" -o -iname "*.jpeg" \) | while read jpg_file; do
        jpegoptim --strip-all --max=$JPG_QUALITY "$jpg_file" >> "$LOG_FILE" 2>&1
    done

    # 压缩WEBP（覆盖原图）
    find "$upload_dir" -type f -iname "*.webp" | while read webp_file; do
        cwebp -q $WEBP_QUALITY "$webp_file" -o "$webp_file" >> "$LOG_FILE" 2>&1
    done
done

echo "全部完成：$(date)" >> "$LOG_FILE"
```

------

### 使用步骤

1. 保存为脚本文件，如 `compress_wp_images.sh`：

   ```bash
   nano compress_wp_images.sh
   ```

2. 赋予执行权限：

   ```bash
   chmod +x compress_wp_images.sh
   ```

3. 执行脚本：

   ```bash
   ./compress_wp_images.sh
   ```

------



### 并行压缩（高级优化）

如果你有**多核 CPU**，可以使用 `xargs -P` 来并行处理，加快压缩速度：

#### 并行处理 JPG（替换上面 JPG 部分）：

```bash
find "$upload_dir" -type f \( -iname "*.jpg" -o -iname "*.jpeg" \) | \
  xargs -P 4 -I{} jpegoptim --strip-all --max=$JPG_QUALITY "{}" >> "$LOG_FILE" 2>&1
```

#### 并行处理 WEBP：

```bash
find "$upload_dir" -type f -iname "*.webp" | \
  xargs -P 4 -I{} cwebp -q $WEBP_QUALITY "{}" -o "{}" >> "$LOG_FILE" 2>&1
```

`-P 4` 表示最多同时运行 4 个进程，可以根据 CPU 核心数进行调整。

------

### 示例目录结构匹配情况

假设你的站点如下：

```
/var/www/site1/wp-content/uploads/2025/
/var/www/site2/wp-content/uploads/2025/
/var/www/site3/wp-content/uploads/2025/
```

脚本会**自动处理**以上所有目录中的 `.jpg` 和 `.webp` 文件。

------

### 拓展

进一步帮你封装为系统服务（定期执行）或者加上备份原图功能