[toc]

## 按进程名分组统计内存占用

### 核心思路

macOS 的 `ps` 命令提供 `RSS`（Resident Set Size，实际物理内存占用）字段，单位为 KB。通过组合 `ps + awk` 可以实现按进程名聚合求和并排序。

---

### 基础命令

查看单个程序（如 shellcheck）的所有进程内存：

```bash
ps aux | awk '/shellcheck/ && !/awk/ {sum += $6} END {print sum/1024 " MB"}'
```

但这只输出一个总数，更实用的是**一次性看所有程序的内存排名**。

---

### 按进程名分组汇总（一次看全部）

```bash
ps aux | awk 'NR>1 {mem[$11] += $6} END {for (p in mem) print mem[p]/1024, "MB", p}' \
  | sort -rn \
  | head -20
```

输出示例：

```
1024.35 MB /Applications/Google Chrome.app/.../Google Chrome
512.10 MB /Applications/Slack.app/.../Slack
128.44 MB /usr/bin/python3
 64.20 MB node
  8.31 MB shellcheck
```

> `$11` 是命令列，`$6` 是 RSS（KB）。`NR>1` 跳过表头行。

---

### 带有同名进程数统计的版本

```bash
# 按进程名统计内存占用 (从高到低排序)
# 可以设置别名:psmem_group
topmem() {
    local lines=${1:-20} # 如果没有提供参数，默认显示前 20 行
    printf "\n%-15s | %-5s | %s\n" "MEMORY (MB)" "COUNT" "PROCESS"
    printf "%-15s-|-%-5s-|-%s\n" "---------------" "-----" "-------------------------"
    ps -e -c -o rss=,command= | awk '{
        rss=$1; $1=""; sub(/^[ \t]+/, ""); 
        sum[$0]+=rss; count[$0]++
    } END {
        for (cmd in sum) 
            printf "%12.2f MB | %5d | %s\n", sum[cmd]/1024, count[cmd], cmd
    }' | sort -nr | head -n "$lines"
    echo ""
}
# 调用函数
topmem
```

用例:

```bash
(base) #( 04/12/26@ 4:18PM )( cxxu@CxxuMac ):/Users/Shared
   topmem 10

MEMORY (MB)     | COUNT | PROCESS
----------------|-------|--------------------------
     4008.62 MB |    16 | Microsoft Edge Helper (Renderer)
      776.36 MB |     5 | com.apple.WebKit.WebContent
      474.48 MB |     1 | Microsoft Edge
      364.20 MB |     1 | WeType
      353.02 MB |    10 | ThemeWidgetControlViewService
      345.62 MB |     4 | Microsoft Edge Helper
```



---

### 封装成可复用的 shell 函数

把这段逻辑放进 `~/.zshrc`，随时调用：

```bash
# 按进程名分组，按内存降序排列，默认显示前20
# 用法：
#   memtop          → 显示所有进程 top 20
#   memtop 10       → 显示 top 10
#   memtop grep     → 过滤显示包含 "grep" 的进程
memtop() {
  local filter="${1:-}"
  local lines="${2:-20}"

  ps -eo comm,rss \
    | awk 'NR>1 {mem[$1] += $2} END {for (p in mem) printf "%.2f MB\t%s\n", mem[p]/1024, p}' \
    | sort -rn \
    | grep -i "${filter}" \
    | head -n "${lines}" \
    | awk 'BEGIN{printf "%-12s %s\n", "MEMORY", "PROCESS"; print "-----------------------------"}
           {printf "%-12s %s\n", $1" "$2, $3}'
}
```

使用方式：

```bash
memtop               # 全部 top 20
memtop shellcheck    # 只看 shellcheck
memtop python 5      # 含 python 的进程，只显示 top 5
```

---

### 查看某个具体程序的进程明细 + 合计

既想看每个进程的单独占用，又想看总和：

```bash
ps -eo pid,comm,rss \
  | awk -v name="shellcheck" '
      NR>1 && $2 ~ name {
        printf "PID %-8s %-20s %.2f MB\n", $1, $2, $3/1024
        total += $3
      }
      END {
        print "-----------------------------"
        printf "Total: %.2f MB\n", total/1024
      }
  '
```

输出示例：

```
PID 8821     shellcheck           4.15 MB
PID 8823     shellcheck           4.16 MB
-----------------------------
Total: 8.31 MB
```

---

### 方案对比

| 方案                         | 适用场景       | 优点              |
| ---------------------------- | -------------- | ----------------- |
| `ps aux \| awk ...`          | 快速临时查看   | 无需安装额外工具  |
| `ps -eo comm,rss \| awk ...` | 短名分组更整洁 | 输出简洁          |
| `memtop` 函数                | 日常高频使用   | 可复用，支持过滤  |
| `htop`（F5 树状视图）        | 交互式查看     | 可视化直观        |
| `activity monitor`           | 不想敲命令时   | GUI，支持排序点击 |

---

### 关于内存数值的说明

`RSS` 是最直观的实际内存占用指标，但 macOS 中还有其他维度：

| 指标  | 含义                                     | 获取方式                  |
| ----- | ---------------------------------------- | ------------------------- |
| RSS   | 实际占用物理内存（含共享库）             | `ps -o rss`               |
| VSZ   | 虚拟内存大小，含未实际分配部分，通常虚高 | `ps -o vsz`               |
| RPRVT | 私有物理内存（最能反映"独占"内存）       | `top` 或 Activity Monitor |
| RSHRD | 共享内存                                 | Activity Monitor          |

> 日常排查用 RSS 足够。如果需要精确的"进程自身独占内存"，Activity Monitor 的 **Memory** 列（对应 RPRVT）更准确。