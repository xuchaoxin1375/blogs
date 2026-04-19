[toc]



在 Ubuntu 服务器上批量压缩 `.jpg` 和 `.webp` 图片，可以使用以下几种现代、高效的方法，推荐你使用命令行工具，它们速度快、资源占用低，且便于批处理。

------

### 常用压缩工具对比表

| 格式    | 推荐工具                 | 安装命令                                         | 优势                          |
| ------- | ------------------------ | ------------------------------------------------ | ----------------------------- |
| `.jpg`  | `jpegoptim` 或 `mozjpeg` | `sudo apt install jpegoptim` / `mozjpeg`编译安装 | 支持无损和有损压缩、批处理    |
| `.webp` | `cwebp`                  | `sudo apt install webp`                          | 支持压缩质量控制，Google 出品 |
| 通用    | `imagemagick`            | `sudo apt install imagemagick`                   | 多格式支持，功能强大但较慢    |

------

### 示例 1：压缩 JPG 图片（使用 jpegoptim）

```bash
find /your/image/path -type f -iname "*.jpg" -exec jpegoptim --strip-all --max=85 {} \;
```

#### 参数说明：

- `--strip-all`：去除所有元数据（Exif、ICC 等）
- `--max=85`：最大图像质量设置为 85（默认100，数值越低，压缩率越高）
- 可加 `--recursive` 用于递归子目录（适用于 jpegoptim 2.0+）

------

### 示例 2：压缩 WEBP 图片（使用 cwebp）

```bash
find /your/image/path -type f -iname "*.webp" -exec sh -c 'cwebp -q 80 "$1" -o "$1"' _ {} \;
```

#### 参数说明：

- `-q 80`：质量设置为 80
- `-o "$1"`：直接覆盖原图（请先备份）

> 注：`cwebp` 默认不会保留原图 metadata，如需保留可以加 `-metadata all`

------

### 示例 3：使用 ImageMagick（兼容多格式）

```bash
find /your/image/path -type f \( -iname "*.jpg" -o -iname "*.webp" \) -exec mogrify -strip -quality 85 {} \;
```

#### 参数说明：

- `mogrify`：直接覆盖源图（谨慎使用）
- `-strip`：移除所有 metadata
- `-quality 85`：设置压缩质量

------

### 示例 4：更安全的版本（生成压缩副本）

如果你不想直接覆盖原图，可以将压缩图输出到新的文件夹，例如：

```bash
mkdir -p /compressed/images
find /your/image/path -type f -iname "*.jpg" -exec sh -c 'jpegoptim --stdout --max=85 "$1" > /compressed/images/$(basename "$1")' _ {} \;
```

------

### 是否需要缩放尺寸也一起进行？

如果你还需要在压缩时统一缩小图像尺寸（比如最大宽度设为 1920px），可以这样：

```bash
find /your/image/path -type f -iname "*.jpg" -exec mogrify -resize 1920x1920\> -strip -quality 85 {} \;
```

`\>` 表示**仅当图像尺寸大于目标值时才缩小**，防止小图被拉伸。

------

