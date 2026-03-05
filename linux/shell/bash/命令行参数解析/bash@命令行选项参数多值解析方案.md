[toc]





## abstract

我打算编写一个部署脚本,已经设计了多个选项.

现在还想要提供一个选项支持指定多个值(比如多个包含需要待部署网站的压缩包的目录) 可以怎么设计? 

这里我们主要讨论bash的情况;

> 如果是其他shell,例如powershell,方案是比较统一的,就是使用数组的方式向一个选项传递传递多个参数(例如`get-childitem -path p1,p2`)
>
> ```powershell
>  Get-ChildItem -Path .\readme_zh.md,.\readme.md
> 
>     Directory: C:\repos\scripts
> 
> Mode                 LastWriteTime         Length Name
> ----                 -------------         ------ ----
> -a---          2025/10/12    10:20           3784 readme_zh.md
> -a---          2025/12/10    10:08            468 readme.md
> ```

我们将参考多个主流工具的设计方式,并使用bash来模仿实现这样的命令行选项参数解析.

### 模式一：重复使用同一选项

> 参考：`gcc`、`curl` 的设计方式

```bash
# 类似 curl -H "header1" -H "header2"
# 类似 gcc -I /path1 -I /path2
# 类似 docker -v /path1:/dest1 -v /path2:/dest2

./deploy.sh -d /var/packages/site1 -d /var/packages/site2 -d /home/user/builds
```

#### 实现方式：

```bash
# 用数组存储多个参数(例如将参数理解为目录)
declare -a DEPLOY_DIRS=()
while [[ $# -gt 0 ]]; do
	case "$1" in
        -d|--dir)
        	# 参数验证(至少要一个合法参数),如果-d后没有跟任何东西,或者直接跟随另一个选项(以`-`开头就认为是其他选项),就报错.
            if [[ -z "$2" || "$2" == -* ]]; then
                echo "Error: --dir requires a directory path" >&2
                exit 1
            fi
            # 验证通过则添加一次参数值到数组中保存
            DEPLOY_DIRS+=("$2")   # 每次追加到数组
            # 分析下一组参数
            shift 2 # shift 位数n取决于循环的风格,通常是1或2(省略n默认为1)
            ;;
     ...
# 对数组DEPLOY_DIRS做处理
```

> 利用`[[ ]]`,写成` if [[ -z "$2" || "$2" == -* ]];`中使用`==`进行通配测试(此时右侧`-*`不能加引号,否则变成了精准匹配),
>
> 也可以写成`if [[ -z $2 ]] || [[ $2 == -* ]];`



#### 完整案例

```bash
#!/bin/bash

# 用数组存储多个目录
declare -a DEPLOY_DIRS=()
VERBOSE=false
DRY_RUN=false
TARGET_ENV="production"

usage() {
    cat <<EOF
Usage: $(basename "$0") [OPTIONS]

网站部署脚本

Options:
  -d, --dir DIR        指定包含待部署压缩包的目录（可多次指定）
  -e, --env ENV        目标环境 (production|staging|dev)，默认: production
  -v, --verbose        显示详细输出
  -n, --dry-run        模拟运行，不实际执行
  -h, --help           显示帮助信息

Examples:
  $(basename "$0") -d /path/to/packages
  $(basename "$0") -d /path/dir1 -d /path/dir2
  $(basename "$0") --dir /path/dir1 --dir /path/dir2 --env staging

EOF
}

# ============ 参数解析 ============
while [[ $# -gt 0 ]]; do
    case "$1" in
        -d|--dir)
            if [[ -z "$2" || "$2" == -* ]]; then
                echo "Error: --dir requires a directory path" >&2
                exit 1
            fi
            DEPLOY_DIRS+=("$2")   # 每次追加到数组
            shift 2
            ;;
        -e|--env)
            TARGET_ENV="$2"
            shift 2
            ;;
        -v|--verbose)
            VERBOSE=true
            shift
            ;;
        -n|--dry-run)
            DRY_RUN=true
            shift
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        -*)
            echo "Error: Unknown option: $1" >&2
            usage
            exit 1
            ;;
        *)
            # 将无选项参数也视为目录（可选行为）
            DEPLOY_DIRS+=("$1")
            shift
            ;;
    esac
done

# ============ 验证(如果-d选项是必须指定的,则这里还要验证是否被有效地指定过) ============
if [[ ${#DEPLOY_DIRS[@]} -eq 0 ]]; then
    echo "Error: 至少需要指定一个部署目录 (-d DIR)" >&2
    usage
    exit 1
fi

# 验证所有目录是否存在
for dir in "${DEPLOY_DIRS[@]}"; do
    if [[ ! -d "$dir" ]]; then
        echo "Error: 目录不存在: $dir" >&2
        exit 1
    fi
done

# ============ 主逻辑 ============
echo "=============================="
echo "  部署配置"
echo "=============================="
echo "目标环境:  $TARGET_ENV"
echo "模拟运行:  $DRY_RUN"
echo "部署目录 (${#DEPLOY_DIRS[@]} 个):"
for dir in "${DEPLOY_DIRS[@]}"; do
    echo "  📁 $dir"
done
echo "=============================="

for dir in "${DEPLOY_DIRS[@]}"; do
    echo ""
    echo ">>> 正在处理目录: $dir"

    # 查找压缩包
    shopt -s nullglob
    archives=("$dir"/*.{tar.gz,tgz,zip,tar.bz2,tar.xz})
    shopt -u nullglob

    if [[ ${#archives[@]} -eq 0 ]]; then
        echo "  ⚠️  未找到压缩包，跳过"
        continue
    fi

    for archive in "${archives[@]}"; do
        echo "  📦 发现: $(basename "$archive")"
        if [[ "$DRY_RUN" == false ]]; then
            # 实际部署逻辑
            echo "  🚀 正在部署 $(basename "$archive") ..."
            # deploy_website "$archive" "$TARGET_ENV"
        else
            echo "  ⏭️  [模拟] 跳过实际部署"
        fi
    done
done

echo ""
echo "✅ 全部处理完成"
```

---

### 模式二：逗号分隔（单选项多值）

> 参考：`find -name`、`mount -o` 的设计

```bash
./deploy.sh --dirs /path1,/path2,/path3
```

```bash
# 解析逗号分隔
--dirs)
    IFS=',' read -ra DEPLOY_DIRS <<< "$2"
    shift 2
    ;;
```

---

### 模式三：位置参数收集剩余参数

> 参考：`cp`、`mv`、`cat` 的设计

```bash
# 所有选项在前，目录在后
./deploy.sh --env production --verbose /path1 /path2 /path3

# 或者用 -- 分隔选项和参数
./deploy.sh --env production --verbose -- /path1 /path2 /path3
```

```bash
# 用 -- 显式分隔
--)
    shift
    DEPLOY_DIRS+=("$@")   # 收集所有剩余参数
    break
    ;;
*)
    DEPLOY_DIRS+=("$1")
    shift
    ;;
```

---

## 各方案对比

```
┌─────────────┬──────────────────────┬──────────┬──────────┬──────────────┐
│    方案      │     示例             │ 可读性   │ 扩展性   │  主流工具参考  │
├─────────────┼──────────────────────┼──────────┼──────────┼──────────────┤
│ 重复选项 ⭐  │ -d dir1 -d dir2      │ ★★★★★  │ ★★★★★  │ docker, gcc  │
│ 逗号分隔     │ --dirs dir1,dir2     │ ★★★☆☆  │ ★★★☆☆  │ mount -o     │
│ 位置参数     │ [opts] dir1 dir2     │ ★★★★☆  │ ★★★☆☆  │ cp, cat      │
│ -- 分隔      │ [opts] -- dir1 dir2  │ ★★★★☆  │ ★★★★☆  │ git, npm     │
└─────────────┴──────────────────────┴──────────┴──────────┴──────────────┘
```

---

## 最佳实践建议：组合使用

```bash
#!/bin/bash
# 同时支持多种输入方式，最大化灵活性

# 支持 -d 重复指定
# 支持 -- 后的位置参数
# 支持从文件读取目录列表

./deploy.sh -d /path1 -d /path2                          # 方式1: 重复选项
./deploy.sh --env staging -- /path1 /path2 /path3         # 方式2: 位置参数
./deploy.sh --dir-file dirs.txt                            # 方式3: 从文件读取
```

```bash
# 从文件读取目录列表
--dir-file)
    if [[ ! -f "$2" ]]; then
        echo "Error: 文件不存在: $2" >&2
        exit 1
    fi
    while IFS= read -r line; do
        [[ -z "$line" || "$line" == \#* ]] && continue  # 跳过空行和注释
        DEPLOY_DIRS+=("$line")
    done < "$2"
    shift 2
    ;;
```

**dirs.txt 示例：**
```text
# 网站部署目录列表
/var/packages/site-a
/var/packages/site-b
/home/deploy/builds/site-c
```

---

> **推荐选择模式一（重复选项 `-d`）**：这是最符合 Unix 哲学、用户最容易理解的方式，也是 Docker、GCC 等主流工具采用的标准做法。