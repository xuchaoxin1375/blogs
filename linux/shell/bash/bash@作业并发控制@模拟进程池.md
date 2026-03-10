[toc]

## abstract

在 Bash 中，虽然没有原生内置的 `ProcessPool` 实现，但你可以利用 **`wait -n`** 选项结合 **循环** 轻松实现一个简化版本的“进程池”。

> 在不使用bash意外的工具的情况下,"循环+`&`后台运行作业+`wait`"组合可以控制最大并发数量,但是在进程复用方面是缺失的,这是和标准进程池模型的最大区别.
>
> 这本质上是一个 **Worker Pool / 令牌桶（Token Bucket）** 的简化实现.

尽管如此,对于简单的并发需求,这种方式足够简单有效.辅助的并发程序建议使用更结构化的语言来实现.

| 特性            | Worker Pool                  | Bash `wait -n`           |
| --------------- | ---------------------------- | ------------------------ |
| 架构            | 固定数量 worker 从队列取任务 | 按需 fork 新进程         |
| Worker 生命周期 | **长期存活**，反复处理任务   | 每个任务 fork 一个新进程 |
| 任务分发        | 通过队列（显式）             | 循环中直接启动（隐式）   |
| 开销            | 低（复用 worker）            | **高（每次 fork）**      |

这种模式的核心思想是：**限制后台任务的总数，每当一个任务完成，就立刻补充一个新的任务。**

本文假设读者对bash的函数和作业控制,进程管理有基本的了解;

------



## 相关命令和选项

### `wait`

`wait: wait [-fn] [-p var] [id ...]` (wait命令的最后可选地跟一个id列表)

主要介绍`-n`选项(`-p`选项可以将进程id赋值给指定变量名,但是其依赖于`-n`)

> If the `-n` option is supplied, waits for a single job from the list of IDs, or, 
>
> if no IDs are supplied, for the next job to complete and returns its exit status.

**动态等待 (`wait -n`)**：

- 这是 Bash 4.3+ 引入的神器。
- 与普通的 `wait`（等待所有任务）不同，`wait -n` 只要有**任意一个**后台任务结束，它就会立即返回。

在没有 `wait -n` 的年代，脚本编写者通常只能每隔 N 个任务执行一次 `wait`。那会导致“长尾效应”：如果一批任务中有一个特别慢，整个脚本都会停下来等它，而其他空闲的 CPU 核心只能闲置。**`wait -n` 实现了真正的动态流转。**

### `jobs`命令相关选项

`jobs -r` vs `jobs -p` 对比

- `-r`仅输出正在后台运行的作业
- `-p` 输出的是 **每个 job 的进程组 leader PID**，不是每个进程

```bash
# 假设运行下面的任务前,jobs输出为空
# 管道 = 一个作业包含多个进程
sleep 100 | sleep 200 | sleep 300 &
jobs -p #仅输出1行内容
```

快速对比

| 特性     | `jobs -r`                 | `jobs -p`             |
| -------- | ------------------------- | --------------------- |
| 含义     | **R**unning（仅运行中的） | **P**ID（仅显示 PID） |
| 过滤功能 | ✅ 只列出**运行中**的任务  | 列出**所有**后台任务  |
| 输出格式 | 完整 job 信息             | 仅进程号              |
| 类型     | **状态过滤器**            | **输出格式控制**      |

具体输出对比

```bash
sleep 100 &    # job 1 - 运行中
sleep 200 &    # job 2 - 运行中
# 暂停(stopped) job 1 
kill -STOP %1  
```

`jobs`（默认，全部任务，完整格式）

```
[1]+  Stopped                 sleep 100
[2]-  Running                 sleep 200 &
```

`jobs -r`（仅 Running，完整格式）

```
[2]-  Running                 sleep 200 &
```

`jobs -p`（全部任务，仅 PID）

```
12345
12346
```

`jobs -s`（仅 Stopped，完整格式）

```
[1]+  Stopped                 sleep 100
```



❗ 注意：可以组合使用

```bash
jobs -rp    # 仅运行中的任务，仅输出 PID
jobs -sp    # 仅停止的任务，仅输出 PID
```

```bash
# 示例
sleep 15 &   
sleep 20 &   
kill -STOP %1 # 停止作业1

#output
[1] 544045
[2] 544046

[1]+  Stopped                    sleep 10


# (base) cxxu@CxxuDesk 14:32:44> <~>
$ jobs -rp
544046

# (base) cxxu@CxxuDesk 14:32:47> <~>
$ jobs -sp
544045

# (base) cxxu@CxxuDesk 14:32:49> <~>
$ jobs -p
544045
544046


# (base) cxxu@CxxuDesk 14:32:52> <~>
$ jobs
[1]+  Stopped                    sleep 10
[2]-  Running                    sleep 20 &

# (base) cxxu@CxxuDesk 14:32:58> <~>
$ jobs
[1]+  Stopped                    sleep 10
[2]-  Done                       sleep 20

# (base) cxxu@CxxuDesk 14:33:22> <~>
$ jobs -s
[1]+  Stopped                    sleep 10

# (base) cxxu@CxxuDesk 14:33:31> <~>
$ jobs -sp
544045
```



---

在并发控制中的使用

计数并发数

```bash
# 常见写法：用 jobs -r 计数运行中的任务
while (( $(jobs -r | wc -l) >= MAX_JOBS )); do
    wait -n
done

# 更精确的写法：用 jobs -rp 计数（每行一个 PID，避免格式干扰）
while (( $(jobs -rp | wc -l) >= MAX_JOBS )); do
    wait -n
done
```

为什么用 `-rp` 更好？

```bash
# jobs -r 的输出可能有多行格式问题（长命令换行等）
[1]   Running    very_long_command --with-many \
                    --arguments &

# jobs -rp 输出干净，一行一个 PID
12345
12346
```





##  `&,wait`方案

我们可以通过控制后台进程（Job）的数量来实现。

基本思路:

利用一个循环遍历所有要添加到后台(进程池)中的任务;

在循环体中判断线程池任务数量(jobs数量),如果jobs数量达到或超过(即大等于)设定的最大值,则调用`wait -n`释放掉任务(等待进程池腾出合适数量的位置),再创建新的任务.

### 核心代码

```bash
MAX_JOBS=4
# 1.定义进程管理循环(离开循环后可能有后台进程尚未结束,只能确保进程(作业)数量不超过限定值,因此需要配合后面的收尾操作)
for task in "${tasks[@]}"; do
    # 当后台任务数达到上限时，等待任意一个完成
    # 如果等待一个后台任务结束后,jobs 计算得到的任务数量仍然大等于限制,则还是要继续调用wait -n阻塞,直到后台进程数降到限制以下
    while (( $(jobs -r | wc -l) >= MAX_JOBS )); do
        wait -n
    done
    
    # 启动新的后台任务
    do_something "$task" &
done

# 2.收尾操作:等待所有剩余任务完成
wait
```

### 变体写法

千万不要把计算后台线程数的算式从while中搬到外面,却忘记内部缺失重新后台任务计数,这会导致后台任务数不会更新,出现死循环!

假设我需要在循环体中打印"当前任务数",并且要求每次打印和和`while`判断时的任务数是相同的:

```bash
job_cnt=$(jobs -rp | wc -l)
while (("$job_cnt" >= JOBS)); do
	echo "当前任务数:$job_cnt"
	wait -n
	# 至少在这里要重新计算job_cnt
	job_cnt=$(jobs -rp | wc -l)
done
```

上述写法逻辑上没有问题,但是出现了明显的代码重复,很不优雅;

我们可以利用 `while` 循环的特性，将逻辑合并。这里有几种优化方案：

#### 将赋值语句放入 `while` 条件中

最简洁的方式是把赋值和判断写在一起：

> while语句: `while COMMANDS; do COMMANDS-2; done`中,第一部分的`COMMANDS`表示命令,并且允许多条命令,且其中最后一条命令的执行状态码决定是否进入循环.

```bash
# 只要任务数大于等于 JOBS，就持续等待
JOBS=2
while job_cnt=$(jobs -rp | wc -l); (( job_cnt >= JOBS )); do
    echo "当前任务数: $job_cnt"
    wait -n
done

```

**优点：** 逻辑紧凑，代码只出现一次计算逻辑，且完全符合 DRY (Don't Repeat Yourself) 原则。

```bash
#!/bin/bash
for i in {1..5}; do {
    task_time=$((RANDOM % 5 + 2))
    echo "start J-$i (time consumption $task_time s)"
    sleep $task_time
    echo "end J-$i (consumed $task_time s)"
} & done
# 只要任务数大于等于 JOBS，就持续等待
JOBS=2
while
    job_cnt=$(jobs -rp | wc -l)
    ((job_cnt >= JOBS))
do
    echo "当前任务数: $job_cnt"
    wait -n
done

wait
echo "所有任务结束"

```



------

#### 利用 `true` 循环 + `break`

如果你觉得把赋值塞进条件里可读性稍差，可以使用无限循环配合内部判断：

```bash
while true; do
    job_cnt=$(jobs -rp | wc -l)
    (( job_cnt < JOBS )) && break
    
    echo "当前任务数: $job_cnt"
    wait -n
done
```

**优点：** 结构非常清晰，适合以后在循环中加入更复杂的判断逻辑。

###  原理解析

- **`&` (Backgrounding)**: 相当于向线程池提交一个任务。
- **`jobs -p | wc -l`**: 查看当前正在“干活”的任务数量,基于此判断进程池是否已满。
- **`wait -n`**: 这个命令的调用方式是关键。单次调用,它不是等待*所有*任务，而是等待*最近的一个*任务结束。如果需要严格控制后台进程数量,需要将`wait -n`放到一个单独的检测进程池是否已满的循环中,称为消耗循环,每次离开消耗循环时,总是可以保证后台进程数低于限制数.新手容易在这上面犯错.
- **`wait` (无参数)**: 在循环结束后使用，确保最后几个残余任务也执行完，脚本再退出。

### kill -0

`kill -0` 是一个非常有用的技巧，它并不会真的“杀死”进程，而是用来**探测进程的存在性**。

简单来说，执行 `kill -0 $PID` 时，系统会检查：

1. 该 PID 是否存在？
2. 当前用户是否有权限向该 PID 发送信号？

####  返回值（Exit Status）

这是该命令的核心用法，通常配合 `$?` 使用：

- **退出码为 0**：进程存在，且你有权访问。
- **退出码为 1**：进程存在，但你权限不足（例如尝试探测 root 进程）。
- **非 0 值（通常是 1 或其他）**：进程不存在。

------

#### 脚本中的实战用

在自动化脚本中，这通常用于监控后台任务或防止脚本重复启动。

场景 A：检查后台进程是否还在运行

```bash
# 启动一个后台任务
./backup.sh &
PID=$!

# 稍后检查它是否还在干活
if kill -0 $PID 2>/dev/null; then
    echo "进程 $PID 仍在运行中..."
else
    echo "进程 $PID 已结束或已崩溃。"
fi
```

> **注意**：`2>/dev/null` 是为了隐藏进程不存在时系统弹出的错误提示。

场景 B：等待进程结束（轮询）

如果你不想用 `wait`（因为它会阻塞当前 shell），可以用循环：

```bash
while kill -0 $PID 2>/dev/null; do
    echo "等待进程结束..."
    sleep 2
done
echo "进程已退出，继续下一步操作。"
```

------

3. 技术细节

- **无副作用**：它不会向目标进程发送任何实际信号（如 `SIGTERM` 或 `SIGKILL`），所以目标进程完全察觉不到被探测了。
- **僵尸进程（Zombie）**：如果进程已经结束但变成了“僵尸进程”，`kill -0` 依然会返回 **0**，因为该 PID 在进程表中尚未被回收。
- **权限限制**：如果你是普通用户，探测 root 用户的进程可能会返回权限错误，但这依然能证明该 PID 确实存在。



## 后台作业PID管理和统计

在控制并发数量的情况下,正确地统计失败/成功任务的示例;

### 推荐方案

> 用到`wait -n`,需要bash 4.3+的版本;
>
> 初学者可以先参考后面关于"统计任务执行状态"的基础案例;

```bash
#!/bin/bash

PIDS=()
TASKS_COUNT=6
MAX_CONCURRENT=2
TIME_LIMIT=2 #任务时间模拟(负数表示随机时间,范围不超过指定数)
SUCCESS=0
FAILED=0
FAILED_TASKS=()
declare -A PID_TASK_MAP # PID -> 任务名 的映射
# tasks=($(seq 1 "$tasks_count"))
mapfile -t tasks < <(seq 1 "$TASKS_COUNT")
# ===定义函数
log() {
    echo -e "[$(date +%T)] $*"
}
run_task() {
    local i="$1"
    log "开始执行任务 $i"

    # 模拟任务，部分会失败
    if [[ $TIME_LIMIT =~ ^- ]]; then
        time_limit=${TIME_LIMIT#-}
        time_consumption=$((RANDOM % time_limit + 1))
    else
        time_limit=$TIME_LIMIT
        time_consumption=$time_limit
    fi
    log "\tTask $i started(time consumption: $time_consumption s)"
    sleep "$time_consumption"
    if ((i % 3 == 0)); then
        exit 1 # 模拟失败
    fi
    exit 0
}
# 统计后台任务状态
# Global:
#    FAILED,SUCCESS,FAILED_TASKS,PID_TASK_MAP
# Arguments:
# 	$1 pid
# 	$2 exit_code
count_status() {
    pid="$1"
    exit_code="$2"
    # echo "进程 $pid (tid: ${PID_TASK_MAP[$pid]} )退出,exit_code=$exit_code"
    # return $exit_code
    if [[ $exit_code -ne 0 ]]; then
        ((FAILED++))
        FAILED_TASKS+=("${PID_TASK_MAP[$pid]}")
        status="FAIL"
    else
        ((SUCCESS++))
        status="SUCCESS"
    fi
    log "进程 $pid (tid: ${PID_TASK_MAP[$pid]} ) 结束,status=$status"
}
# ====开始
start_time=$(date +%s)

for task_id in "${tasks[@]}"; do
    # 控制并发数
    while
        # jobs_count="${#PIDS[@]}"
        jobs_count="$(jobs -rp | wc -l)"
        (("$jobs_count" >= MAX_CONCURRENT))
    do
        # 等待任意一个子进程结束,轮询策略;(扫描一遍进程ip数组,需要设置每次轮序的时间间隔,看哪个进程结束)
        # log "进程数量[$jobs_count]达到上限,等待任意一个完成"
        log "当前任务数达到$jobs_count ;逐个释放..."
        wait -n

    done

    run_task "$task_id" &
    pid=$!
    PIDS+=("$pid")
    PID_TASK_MAP[$pid]="$task_id"
done

log "=====等待剩余任务(所有任务已经创建完毕)"
declare -p PIDS
# declare -p PID_TASK_MAP
for pid in "${PIDS[@]}"; do
    wait "$pid"
    exit_code=$?
    count_status "$pid" "$exit_code"
done

log "================================"
log "Total: ${#tasks[@]}, FAILed: $FAILED"
log "SUCCESS_a: $((${#tasks[@]} - FAILED)),SUCCESS_b: $SUCCESS"
log "failed tasks(ids): ${FAILED_TASKS[*]}"
log "所有任务处理完毕。耗时约: $(($(date +%s) - start_time))秒"
echo "===运行参数说明:"
echo "MAX_CONCURRENT: $MAX_CONCURRENT"
echo "TASKS_COUNT: $TASKS_COUNT"
echo "TIME_LIMIT: $TIME_LIMIT (如果是负数表示随机范围)"

```

### 关于kill -0判断后台作业

**`kill -0 "$pid" 2>/dev/null`** 

`kill -0` 并不真的杀死进程，它只是发送一个“0 号信号”来检测进程是否存在以及当前用户是否有权向其发送信号。

- 如果进程**存在**，返回值为 0（成功）；
- 如果进程**已结束**，返回值为非 0（失败）。

这个方案可以判断活跃进程

对于后台已经结束但是没未被wait的进程,此kill方法不能区分出是否已经被wait过;

考虑到同一个pid被反复wait是可以的,所以一般我们用遍历pids数组对其中的pid逐个wait过去来检查任务是否成功即可(无论其中的pid是否是第一次wait;)

### 统计任务执行状态

通常我们对一批任务的执行结果感兴趣;

例如统计失败的任务以便排查原因或者稍后需要重试;

对于串行任务,统计的思路任务十分简单,而且可以很准确;

对于并发任务,如果要统计失败任务数量,需要选择合适的方案才能正确统计

关键在于**捕获每个后台任务的退出码**。考虑以下方案:

#### `wait <PID>` 逐个获取退出码

先观察下面的不带并发数控制的版本(简单版),其通过收集后台进程的pid(通过`$i`获取),保存到数组;

在每个任务后台创建完成时立即获取其进程id并保存到进程数组中;

当所有后台任务创建(发射)完成,就可以遍历收集到的后台进程pid数组;依次调用`wait <pid>`来获取每个后台进程的退出状态码来统计失败(成功)任务数量;

> 不需要`wait -n`就可以完成此实验;但是不具备并发数量控制的功能;

```bash
#!/bin/bash

pids=()
tasks_count=10
success=0
failed=0
failed_tasks=()
run_task() {
    local i="$1"
    # 模拟任务，部分会失败
    time_consumption=$((RANDOM % 3 + 1))
    echo -e "\tTask $i started(time consumption: $time_consumption s)"
    sleep "$time_consumption"
    if ((i % 3 == 0)); then
        exit 1 # 模拟失败
    fi
    exit 0
}
export -f task
# 启动后台任务
for i in $(seq 1 $tasks_count); do
    (
        run_task "$i"
    ) &
    pids+=("$!:$i") # 记录 PID 和任务标识
    echo "Task$i(PID=$!)"
done
echo

jobs  | nl
# 逐个等待并检查退出码(统计失败任务)
for entry in "${pids[@]}"; do
    pid="${entry%%:*}"
    task_id="${entry##*:}"

    wait "$pid"
    exit_code=$?

    if [[ $exit_code -ne 0 ]]; then
        ((failed++))
        failed_tasks+=("$task_id")
        echo "Task $task_id (PID=$pid) FAILED with exit code $exit_code"
    else
        ((success++))
        echo "Task $task_id (PID=$pid) SUCCESS"
    fi
done

echo "================================"
echo "Total failed: $failed"
echo "Total success: $success"
echo "Failed tasks: ${failed_tasks[*]}"

```

如果要引入并发控制,那么情况会复杂一些:

#### 其他方案:带并发控制下的失败统计

##### 兼容性方案(轮询)

> 不是很优雅,但是可以不用`wait -n,-p`

```bash
#!/bin/bash

pids=()
tasks_count=10
success=0
failed=0
failed_tasks=()
log() {
    echo -e "[$(date +%T)] $*"
}
run_task() {
    local i="$1"
    log "开始执行任务 $i"

    # 模拟任务，部分会失败
    time_consumption=$((RANDOM % 3 + 1))
    log "\tTask $i started(time consumption: $time_consumption s)"
    sleep "$time_consumption"
    if ((i % 3 == 0)); then
        exit 1 # 模拟失败
    fi
    exit 0
}


MAX_CONCURRENT=4
pids=()
declare -A pid_task_map # PID -> 任务名 的映射
failed=0
failed_tasks=()
# tasks=($(seq 1 "$tasks_count"))
mapfile -t tasks < <(seq 1 "$tasks_count")
for task_id in "${tasks[@]}"; do
    # 控制并发数
    while
        jobs_count="${#pids[@]}"
        (("$jobs_count" >= MAX_CONCURRENT))
    do
        # 等待任意一个子进程结束,轮询策略;(扫描一遍进程ip数组,需要设置每次轮序的时间间隔,看哪个进程结束)
        # log "进程数量[$jobs_count]达到上限,等待任意一个完成"
        for i in "${!pids[@]}"; do
            pid="${pids[$i]}"
            # 使用kill -0 检测进程是否结束,返回0表示进程存在,返回1表示进程不存在(结束了)
            if ! kill -0 "$pid" 2> /dev/null; then
                log "任务 ${pid_task_map[$pid]}(pid: $pid)已完成"
                wait "$pid"
                exit_code=$?
                if [[ $exit_code -ne 0 ]]; then
                    ((failed++))
                    failed_tasks+=("${pid_task_map[$pid]}")
                else
                    ((success++))
                fi
                unset "pids[$i]"
                unset "pid_task_map[$pid]"
            # else # 为了输出简洁,这里不打印此分支(可以作为verbose或debug模式打印调试)
            #     echo -n -e "\r\t尚未有后台进程退出,继续轮询..."
            fi
        done
        pids=("${pids[@]}") # 重建数组索引
        # 轮询间隔休眠,避免CPU占用过高
        sleep 0.5
    done

    run_task "$task_id" &
    pid=$!
    pids+=("$pid")
    pid_task_map[$pid]="$task_id"
done

# 等待剩余任务
for pid in "${pids[@]}"; do
    wait "$pid"
    exit_code=$?
    if [[ $exit_code -ne 0 ]]; then
        ((failed++))
        failed_tasks+=("${pid_task_map[$pid]}")
    else
        ((success++))
    fi
done

log "================================"
log "Total: ${#tasks[@]}, Failed: $failed"
log "Success_a: $((${#tasks[@]} - failed)),Success_b: $success"
log "Failed tasks(ids): ${failed_tasks[*]}"

```

##### wait -n -p方案

相比于最开始的方案(仅用到wait中的`-n`);

如果版本高于`5.1`,`wait -p`可用,可以及时观察到被wait的进程id;

借助于`-p`选项,可以及时清理掉已经被wait过的进程pid(尽管这不是必须的.)

```bash
#!/bin/bash
# bash 5.1+ 版本可用(wait -p)
PIDS=()
TASKS_COUNT=6
MAX_CONCURRENT=2
TIME_LIMIT=2 #任务时间模拟(负数表示随机时间,范围不超过指定数)
SUCCESS=0
FAILED=0
FAILED_TASKS=()
declare -A PID_TASK_MAP # PID -> 任务名 的映射
# tasks=($(seq 1 "$tasks_count"))
mapfile -t tasks < <(seq 1 "$TASKS_COUNT")
# ===定义函数
log() {
    echo -e "[$(date +%T)] $*"
}
run_task() {
    local i="$1"
    log "开始执行任务 $i"

    # 模拟任务，部分会失败
    if [[ $TIME_LIMIT =~ ^- ]]; then
        time_limit=${TIME_LIMIT#-}
        time_consumption=$((RANDOM % time_limit + 1))
    else
        time_limit=$TIME_LIMIT
        time_consumption=$time_limit
    fi
    log "\tTask $i started(time consumption: $time_consumption s)"
    sleep "$time_consumption"
    if ((i % 3 == 0)); then
        exit 1 # 模拟失败
    fi
    exit 0
}
# 统计后台任务状态
# Global:
#    FAILED,SUCCESS,FAILED_TASKS,PID_TASK_MAP
# Arguments:
# 	$1 pid
# 	$2 exit_code
count_status() {
    pid="$1"
    exit_code="$2"
    echo "进程 $pid 退出,exit_code=$exit_code"
    # return $exit_code
    if [[ $exit_code -ne 0 ]]; then
        ((FAILED++))
        FAILED_TASKS+=("${PID_TASK_MAP[$pid]}")
        status="FAIL"
    else
        ((SUCCESS++))
        status="SUCCESS"
    fi
    log "进程 $pid 结束,status=$status"
}
# ====开始
start_time=$(date +%s)

for task_id in "${tasks[@]}"; do
    # 控制并发数
    while
        jobs_count="${#PIDS[@]}"
        (("$jobs_count" >= MAX_CONCURRENT))
    do
        # 等待任意一个子进程结束,轮询策略;(扫描一遍进程ip数组,需要设置每次轮序的时间间隔,看哪个进程结束)
        # log "进程数量[$jobs_count]达到上限,等待任意一个完成"
        log "当前任务数达到$jobs_count ;逐个释放..."
        wait -n -p pid
        exit_code=$?
        count_status "$pid" "$exit_code"
        # 从pids数组中移除已完成的任务pid
        # for p in "${pids[@]}";do
        # log "移除$pid 前:${pids[*]}"
        for i in "${!PIDS[@]}"; do
            if [[ "${PIDS[$i]}" -eq "$pid" ]]; then
                log "\t移除此pid=$pid"
                unset "PIDS[$i]"
                break
            fi
        done
        # log "移除$pid 之后:${pids[*]}"
    done

    run_task "$task_id" &
    pid=$!
    PIDS+=("$pid")
    PID_TASK_MAP[$pid]="$task_id"
done

log "=====等待剩余任务"
for pid in "${PIDS[@]}"; do
    wait "$pid"
    exit_code=$?
    count_status "$pid" "$exit_code"
done

log "================================"
log "Total: ${#tasks[@]}, FAILed: $FAILED"
log "SUCCESS_a: $((${#tasks[@]} - FAILED)),SUCCESS_b: $SUCCESS"
log "FAILed tasks(ids): ${FAILED_TASKS[*]}"
log "所有任务处理完毕。耗时约: $(($(date +%s) - start_time))秒"
echo "===运行参数说明:"
echo "MAX_CONCURRENT: $MAX_CONCURRENT"
echo "TASKS_COUNT: $TASKS_COUNT"
echo "TIME_LIMIT: $TIME_LIMIT (如果是负数表示随机范围)"

```

这里使用`wait -n`来控制并发;并且利用`-p`选项(需要bash 5.1+版本才可用)获取每次wait到的进程pid;

> 这个例子中仍然使用`jobs_count="${#pids[@]}"`来判断代表后台尚未被wait的进程(尽管可能已经结束了)
>
> 如果判断依据这么写,那么这个方案里,`wait -p`很重要;
>
> 如果使用`jobs -rp|wc -l`来判断当时后台正在运行的任务,也是可以的;

注意,在我们的模拟试验设计中,可以把任务的执行耗时设计的一样,比如4个进程都耗时m秒时间,那么某次`wait -n`调用时可能已经有多个后台任务都已经结束了,那么`wait -n`会处理最先结束的那一个任务返回状态;这种情况下`wait -n`可以快速返回,几乎不阻塞;从而可以快速将近的进程添加到后台运行;

模组参数下的运行结果示例:

```
===运行参数说明:
MAX_CONCURRENT: 2
TASKS_COUNT: 6
TIME_LIMIT: 2 (如果是负数表示随机范围)
[09:08:18] ================================
[09:08:18] Total: 6, FAILed: 2
[09:08:18] SUCCESS_a: 4,SUCCESS_b: 4
[09:08:18] failed tasks(ids): 3 6
[09:08:18] 所有任务处理完毕。耗时约: 6秒
```



#### 用临时文件记录失败

```bash
fail_dir=$(mktemp -d)
trap 'rm -rf "$fail_dir"' EXIT

for archive in "${ARCHIVE_DIR}"/*.tar.gz; do
    [ -f "$archive" ] || continue

    while (( $(jobs -rp | wc -l) >= MAX_JOBS )); do
        wait -n 2>/dev/null || true
    done

    (
        deploy_site "$archive" || touch "${fail_dir}/$(basename "$archive")"
    ) &
done

wait

failures=$(find "$fail_dir" -type f | wc -l)
echo "全部完成，失败: ${failures} 个"
```



### 常见的错误写法

对于初学者,可能会写出如下形式的代码

这种实现的最大问题是`wait -n`的时机安排不妥当,其和任务添加绑定在了一起,也就是说,一个新的后台任务被创建后才可能运行一次`wait -n`,又由于`jobs`命令查询后台任务的实现问题,可能会出现同时运行的任务数量超过限制.

总之,这种方式是很不可靠的写法.

```bash
#!/bin/bash
# 不可靠写法
MAX_JOBS=3  # 线程池大小（同时运行的最大任务数）

# 模拟一组任务
tasks=("Task_1" "Task_2" "Task_3" "Task_4" "Task_5" "Task_6")

for task in "${tasks[@]}"; do
    # a. 在后台运行任务
    ( your_task ) &

    # b. 检查当前后台任务数
    # jobs -p 会列出所有后台任务的 PID
    # 当后台任务数量达到最大限制时，调用 wait -n
    if [[ $(jobs -rp | wc -l) -ge $MAX_JOBS ]]; then
        # wait -n 会阻塞，直到“任意一个”后台任务结束
        wait -n
    fi
done

# 3. 最后等待所有剩余任务完成
wait
echo "所有任务处理完毕。"
```



这里的情况是:任务是逐个添加的(有严格的创建顺序,但是启动顺序是不保证的)

> 上述代码中循环体分为了2块(a,b);两者的顺序可以对调,可以先检查后台任务数是否已满,如果已满,则等待某个后台任务结束,再创建新任务

此外,进程池中的任务的完成和退出实际上不依赖于`wait -n`命令,`wait`命令只是用来阻塞添加后台任务的添加防止同时运行过多的任务(超过进程数限制)

关键在于判断进程池是否已满的方式以及选用的方式,阻塞新任务添加的代码是否可靠;

在上面的方案中,进程池(后台作业)情况通过`jobs -p`获取,可以通过表达式`$(jobs -p | wc -l)`计算当时的后台进程数量;

- 我们假设`jobs -p`能足够快(及时)且准确地反映后台的进程(尚未结束退出的进程),那么应该能够借助`jobs -p`观察到后台任务数总是不超过指定的限制数量.
- 另一个相反的假设是`jobs -p`不能够在每次调用`wait -n`命令等到某个进程结束后准确反映尚未结束任务的数量(也就是说`wait -n`结束后释放的那个后台任务并没有从`jobs -p`的列表中移除;如果是这样,可能导致我们观察代码运行过程中出现一些出乎意料的现象,比如`jobs -p `在某一时刻观察到数量超过限制大小的进程ID.

那么根据我们的代码,先判断后台进程数达到限制后,才会执行`wait -n`等待某个后台任务结束(阻塞)后就会紧接着添加新的后台任务(添加新任务前不再次使用`jobs -p`检查后台任务数量是否达到限制,直接添加任务,就有可能导致后续使用`jobs -p`观察到任务数量超过限制).

#### 脚本开头

先定义环境准备部分.

```bash
#!/bin/bash
# bash_processpool_demo.sh
# 这个脚本演示了如何使用bash的后台任务和wait命令来实现一个简单的进程池机制，以控制同时运行的任务数量。
# 脚本命令行参数:(简单起见,且为了突出脚本主题,这里仅设置少量位置参数)

# Arguments:
#   $1 - MAX_JOBS 线程池大小（同时运行的最大任务数）
#   $2 - TIME_LIMIT 模拟任务执行时间的范围(默认11),效果
#   $3 - TASKS_COUNT 模拟任务数量(默认6)

export MAX_JOBS="${1:-3}"    # 线程池大小（同时运行的最大任务数）
export TIME_LIMIT="${2:-11}" #模拟任务执行时间的范围(默认11),效果是随机生成1到TIME_LIMIT之间的整数作为任务执行时间
export TASKS_COUNT="${3:-6}" # 模拟任务数量(默认6)
# 模拟一组任务(实际任务可能是从文件读取或者扫描目录、数据库或其他来源获取的任务列表)
# tasks=("Task_1" "Task_2" "Task_3" "Task_4" "Task_5" "Task_6")
# tasks=($(seq -f "T%g" 1 "$TASKS_COUNT"))
mapfile -t tasks < <(seq -f "Task_%g" 1 "$TASKS_COUNT")
# 定义一个日志函数，输出带有时间戳的日志信息，参数是日志内容
log() {
    local msg="$1"
    echo "[$(date +%T.%3N)] $msg"
}
loge() {
    local msg="$1"
    echo -e "[$(date +%T.%3N)] $msg" >&2
}
# 定义一个模拟的函数来执行任务(让代码结构更清晰),后台任务结束时输出更加紧凑，传入任务时间和任务名称
# Global:
#   MAX_JOBS 线程池大小
#   TIME_LIMIT 模拟耗时任务到最大时间
# Arguments:
#   $1 - task 任务名称
#   $2 - time_limit
task_func() {
    local task="$1"
    local time_limit="${2:-$TIME_LIMIT}"

    log "[开始] $task"
    # 如果时间是-开头,则表示要取固定值,否则表示随机范围最大值生成一个时间
    if [[ $time_limit =~ ^- ]]; then
        task_time=${time_limit#-} # 去掉开头的'-'符号
    else
        task_time=$((RANDOM % "$time_limit" + 1)) # 模拟任务执行时间(1-5秒)
    fi
    loge "\t\t正在执行 $task / $MAX_JOBS, 预计耗时: ${task_time}s"
    sleep "$task_time" # 模拟耗时操作(随机睡眠5秒以内的时间)
    # demo_job $task_time "$task/$MAX_JOBS" # 这里调用一个模拟的函数来执行任务，传入任务时间和任务名称
    log "[完成] $task"
}
# 开始时间
start_time=$(date +%s)
log "===进程池模拟模拟程序开始[线程池大小: $MAX_JOBS]==="
if [[ $TIME_LIMIT =~ ^- ]]; then
    log "任务执行时间固定为: ${TIME_LIMIT#-}秒"
else
    log "任务执行时间随机生成，范围是: 1-${TIME_LIMIT}秒"
fi


```

下面是主体部分,给出两个版本

#### 单层循环版

```bash
# 不可靠单层循环控制最大并发数
for task in "${tasks[@]}"; do
    #  在后台运行任务
    # log "计算jobs前等待一小段时间让jobs命令能够准确反映出后台任务数量的变化"
    # sleep 1

    jbs=$(jobs -rp)
    current_job_num=$(printf "%s " "$jbs" | wc -w)
    loge "\t当前后台任务数: $current_job_num @[${jbs//$'\n'/ }]"
	# 当后台任务数量达到最大限制时，只调用 `wait -n`,而不再检查`jobs -rp`进程数量是否降低到限制数以下
    if [[ $current_job_num -ge $MAX_JOBS ]]; then
        log "进程池已满($MAX_JOBS);阻塞直到任意一个后台任务结束(释放出一个空位),然后继续循环创建新的后台任务."
        wait -n -p completed_pid
        # loge "\t后台任务[PID=$completed_pid]已完成."
        jbs=$(jobs -rp)
        loge "\t(wait -n [PID=$completed_pid]已完成.,当前后台任务数: $(jobs -rp | wc -l)) @[${jbs//$'\n'/ }]"
    fi
    # 进程池未满,创建新的后台任务
    log "添加: $task 到进程池中"
    (task_func "$task" "$TIME_LIMIT") &


done
# 离开循环后,所有后台任务都已经创建完毕,但是可能还有一些任务在运行中,所以需要等待它们全部完成.
#  最后等待所有剩余任务完成
wait
log "所有任务处理完毕。耗时约: $(($(date +%s) - start_time))秒"
```

使用()子shell创建后台任务

`jobs -rp` 会列出所有运行中的后台任务的 PID,通过`wc -l` 计算当前后台任务数量(一行一个PID).

> 对于`jbs=$(jobs -rp)`,注意`echo |wc -l` 结果是1,因为echo换行符的缘故(即便没有后台进程,计算结果至少为1);
>
> 但如果使用`echo -n` ,在有后台任务是计算结果又会缺少1.
>
> 直接用`$(jobs -rp|wc -l)`结果是正确的,或者考虑使用`printf "%s " "$jbs" |wc -w` 计算任务数

如果在添加新任务到进程池前严格要求进程池(后台)任务数量小于最大限制,则可能导致部分任务不执行(没有机会被创建并添加到进程池中);

```bash
if [[  $current_job_num -lt $MAX_JOBS ]]; then
    (task_func "$task" "$TIME_LIMIT") &
fi
```

这应该是`jobs`检查后台任务有延迟的原因(某个后台任务结束后,`jobs`命令未必能够立即准确反映出后台任务的变化.)

#### 二重循环版

```bash
# 可以正确控制最大并发数的版本
for task in "${tasks[@]}"; do

    jbs=$(jobs -p)
    current_job_num=$(printf "%s " "$jbs" | wc -w)
    loge "\t当前后台任务数: $current_job_num @[${jbs//$'\n'/ }]"
    while [[ $current_job_num -ge $MAX_JOBS ]]; do

        log "进程池已满($MAX_JOBS);阻塞直到任意一个后台任务结束(释放出一个空位),然后继续循环创建新的后台任务."
        wait -n -p completed_pid
        # loge "\t后台任务[PID=$completed_pid]已完成."
        jbs=$(jobs -p)
        loge "\t(wait -n [PID=$completed_pid]已完成,当前后台任务数: $(jobs -p | wc -l)) @[${jbs//$'\n'/ }]"

        jbs=$(jobs -p)
        current_job_num=$(printf "%s " "$jbs" | wc -w)
        loge "\t当前后台任务数: $current_job_num @[${jbs//$'\n'/ }]"
    done
    # 进程池未满,创建新的后台任务
    log "添加: $task 到进程池中"
    (task_func "$task" "$TIME_LIMIT") &

done
# 离开循环后,所有后台任务都已经创建完毕,但是可能还有一些任务在运行中,所以需要等待它们全部完成.
#  最后等待所有剩余任务完成
wait
log "所有任务处理完毕。耗时约: $(($(date +%s) - start_time))秒"

```

### 用例

将脚本开头和二重循环两节的片段拼接放到同一个脚本文件中(例如`bash_processpool_demo.sh`)中

> 可选的指定脚本位置参数:
>
> 第一个指定进程池中允许的最大进程数量,第二个指定每个任务的耗时(有随机范围和固定相同两个模式),第三个是模拟的任务数量

```bash
$ bash bash_processpool_demo.sh 2 -3 6
[15:58:53.564] ===进程池模拟模拟程序开始[线程池大小: 2]===
[15:58:53.566] 任务执行时间固定为: 3秒
[15:58:53.570]  当前后台任务数: 0 @[]
[15:58:53.571] 添加: Task_1 到进程池中
[15:58:53.572] [开始] Task_1
[15:58:53.573]          正在执行 Task_1 / 2, 预计耗时: 3s
[15:58:53.574]  当前后台任务数: 1 @[544800]
[15:58:53.575] 添加: Task_2 到进程池中
[15:58:53.576] [开始] Task_2
[15:58:53.577]          正在执行 Task_2 / 2, 预计耗时: 3s
[15:58:53.578]  当前后台任务数: 2 @[544800 544810]
[15:58:53.579] 进程池已满(2);阻塞直到任意一个后台任务结束(释放出一个空位),然后继续循环创建新的后台任务.
[15:58:56.580] [完成] Task_1
[15:58:56.582] [完成] Task_2
[15:58:56.587]  (wait -n [PID=544800]已完成,当前后台任务数: 1) @[544810]
[15:58:56.591]  当前后台任务数: 1 @[544810]
[15:58:56.592] 添加: Task_3 到进程池中
[15:58:56.593] [开始] Task_3
[15:58:56.596]          正在执行 Task_3 / 2, 预计耗时: 3s
[15:58:56.599]  当前后台任务数: 1 @[544833]
[15:58:56.600] 添加: Task_4 到进程池中
[15:58:56.601] [开始] Task_4
[15:58:56.603]          正在执行 Task_4 / 2, 预计耗时: 3s
[15:58:56.604]  当前后台任务数: 2 @[544833 544843]
[15:58:56.605] 进程池已满(2);阻塞直到任意一个后台任务结束(释放出一个空位),然后继续循环创建新的后台任务.
[15:58:56.611]  (wait -n [PID=544810]已完成,当前后台任务数: 2) @[544833 544843]
[15:58:56.616]  当前后台任务数: 2 @[544833 544843]
[15:58:56.617] 进程池已满(2);阻塞直到任意一个后台任务结束(释放出一个空位),然后继续循环创建新的后台任务.
[15:58:59.607] [完成] Task_3
[15:58:59.609] [完成] Task_4
[15:58:59.614]  (wait -n [PID=544833]已完成,当前后台任务数: 1) @[544843]
[15:58:59.618]  当前后台任务数: 1 @[544843]
[15:58:59.620] 添加: Task_5 到进程池中
[15:58:59.621] [开始] Task_5
[15:58:59.623]          正在执行 Task_5 / 2, 预计耗时: 3s
[15:58:59.623]  当前后台任务数: 1 @[544877]
[15:58:59.625] 添加: Task_6 到进程池中
[15:58:59.626] [开始] Task_6
[15:58:59.628]          正在执行 Task_6 / 2, 预计耗时: 3s
[15:59:02.631] [完成] Task_5
[15:59:02.636] [完成] Task_6
[15:59:02.643] 所有任务处理完毕。耗时约: 9秒
```

可以看到,如果是每次最多运行2个任务,每个任务耗时3秒钟,总共6个任务的情况下,最快也要9秒(分3批运行,每批3秒钟,总共9秒钟)

在每个任务运行时间相同的情况下(虽然实际任务中几乎不会这样,但是演示代码中可能这么做,并且可以对比出一些写法效果上的不同)

总之,根据`jobs -rp`查询结果(进程数量是否达到限制),如果达到限制就调用`wait -n`(但是调用多少次取决于调用完观察进程数是否降低到限制值以下,否则就得继续调用)

## 分批执行

相比于模拟进程池,分批执行是一种更简单的并发方案(并发程度比进程池低,但是最大并发数量是很容易控制的,批次之间是有序的;)

> 兼容不带有`-n`选项的bash版本;

```bash
count=0
CONCURRENCY=5
for db in $databases; do
    (
        res=$(mysql -u root -p"$key" -N -s -D "$db" -e "$SQL")
        echo "$db, $res"
    ) &
    
    ((count++)) #持续累加计数(被添加到后台的任务数,无论是否已经完成;)
    # 计数的任务每达到 CONCURRENCY 个进程(使用取模来实现判断)就等待一轮
    if (( count % CONCURRENCY == 0 )); then
        wait # 无参数wait会等待所有后台进程返回后继续
    fi
done
wait
```



## **命名管道（FIFO）** 队列方案

FIFO（First In First Out）即**命名管道**，是一种特殊的文件类型，用于进程间通信（IPC,Inter-Process Communication）。

与匿名管道的区别

| 特性 | 匿名管道 `|` | 命名管道 (FIFO) |
|------|-------------|----------------|
| 文件系统中可见 | 否 | ✅ 有路径名 |
| 仅限父子/兄弟进程 | 是 | 任意进程可用 |
| 生命周期 | 随进程结束 | 持久存在（需手动删除） |
| 创建方式 | `cmd1 | cmd2` | `mkfifo` |

```bash
┌─────────────────────────────────────────────────────────────────┐
│           令牌桶模型     vs    Worker 队列模型 (本文)  
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  令牌桶:                          Worker 队列:                   │
│  ┌──────┐                         ┌──────┐                      │
│  │ FIFO │ ← 存放令牌(空行)         │ FIFO │ ← 存放任务数据       │
│  └──┬───┘                         └──┬───┘                      │
│     │                                │                          │
│  主进程循环:                       Worker 进程:                   │
│    read (取令牌)                     while read (取任务)          │
│    fork 子进程                       执行任务                     │
│    子进程完成→归还令牌               回到 while 等下一个           │
│                                                                 │
│  • 每个任务 fork 新进程              • Worker 进程复用，不反复 fork│
│  • FIFO 做"信号量"                  • FIFO 做"消息队列"          │
│  • 子进程数动态变化                  • Worker 数始终固定           │
│  • 实现简单                         • 更接近真实线程池             │
│  • 适合简单并发控制                  • 适合长期运行的服务           │
└─────────────────────────────────────────────────────────────────┘

```

### 令牌模式实现进程并发控制

下面根据令牌模式实现进程并发控制.

此模式没有复用worker进程, 每个任务都是 fork 一个新进程，用完就销毁。令牌只控制了并发数量，并没有复用进程。

```
┌─────────────────────────────────────────────────┐
│                    FIFO 管道                      │
│  ┌─────┬─────┬─────┬─────┬─────┐               │
│  │ 令牌 │ 令牌 │ 令牌 │ 令牌 │ 令牌 │  ← 初始放入N个令牌│
│  └─────┴─────┴─────┴─────┴─────┘               │
│     ↑                    │                       │
│     │                    ↓                       │
│  任务完成              取走令牌                    │
│  归还令牌              启动任务                    │
│     ↑                    │                       │
│     │    ┌──────────┐    │                       │
│     └────│ 后台进程  │←───┘                       │
│          └──────────┘                            │
└─────────────────────────────────────────────────┘

没有令牌 → read 阻塞等待 → 控制并发数
```

通过**fifo**文件实现真正的 Worker Pool,启动指定数量的worker.

```bash
#!/bin/bash

# ============================================
# FIFO 进程池演示
# ============================================

# ---------- 配置 ----------
MAX_JOBS=3          # 进程池大小（最大并发数）
TASKS_COUNT=6        # 总任务数
# 定义一个日志函数，输出带有时间戳的日志信息，参数是日志内容
log() {
    local msg="$1"
    echo -e "[$(date +%T.%3N)] $msg"
}

# ---------- 模拟任务 ----------
do_task() {
    local id=$1
    local duration=$(( RANDOM % 11 + 1 ))   # 随机 1~11 秒
    log "任务 $id 开始（将耗时 ${duration}s）"
    sleep "$duration"
    log "任务 $id 完成"
}
# 开始时间
start_time=$(date +%s)
log "===进程池模拟模拟程序开始[线程池大小: $MAX_JOBS]==="

# ========== 第一步：创建 FIFO ==========
FIFO="/tmp/pool_fifo_$$"          # $$ 是当前脚本PID，避免冲突
mkfifo "$FIFO"                     # 创建命名管道

# 关键技巧：用文件描述符 6 绑定 FIFO
# 这样 FIFO 就不会因为没有写入端而让 read 收到 EOF
exec 6<>"$FIFO"                    # 以读写方式打开fifo文件，绑定到 fd 6

# ========== 第二步：放入令牌 ==========
# 往管道里写入 MAX_JOBS 个令牌（每个令牌就是一个空行）
for (( i = 0; i < MAX_JOBS; i++ )); do
    echo ""                        # 写一个空行作为"令牌"
done >&6                           # 写入 fd 6（即 FIFO）

# ========== 第三步：循环提交任务 ==========
for (( task_id = 1; task_id <= TASKS_COUNT; task_id++ )); do

    # 【取令牌】read -u 命令从 FIFO 读走一行
    #   - 有令牌 → 立即通过
    #   - 没令牌 → 阻塞等待（自动限流！）

    read -r -u 6

    # 启动后台任务
    {
        do_task "$task_id"

        # 【还令牌】任务完成后，写回一个令牌
        echo "" >&6
    } &

done

# ========== 第四步：等待所有任务结束 ==========
wait

# ========== 清理 ==========
exec 6>&-                          # 关闭 fd 6
rm -f "$FIFO"                      # 删除 FIFO 文件

log "======== 所有任务完成 ========"
log "所有任务处理完毕。耗时约: $(($(date +%s) - start_time))秒"

```

------

| 要点                    | 说明                                         |
| ----------------------- | -------------------------------------------- |
| `mkfifo`                | 创建命名管道文件                             |
| `exec 6<>"$FIFO"`       | **读写模式**打开，防止 read 遇到 EOF         |
| `echo >&6`              | 写入令牌（放回池中）                         |
| `read -u 6`             | 读取令牌（从池中取出），**无令牌时自动阻塞** |
| `{ 任务; echo >&6; } &` | 后台执行，**完成后归还令牌**                 |
| `wait`                  | 等待所有后台进程结束                         |

| 对比项            | `{ } &`                              | `( ) &`                      |
| ----------------- | ------------------------------------ | ---------------------------- |
| 执行方式          | 继承当前 shell 的 fd                 | 创建一个**新的子 shell**     |
| **fd 6 是否可用** | ✅ 直接继承，**天然可用**             | ⚠️ 继承副本，通常也能用       |
| 开销              | 轻（直接 fork）                      | 略重（fork + 新 shell 环境） |
| 变量修改          | 不影响父 shell（因为 `&` 已经 fork） | 不影响父 shell               |
| 实际表现          | 几乎相同                             | 几乎相同                     |

### 复用工作进程的进程池

仅作演示,bash 实现work pool 的方式不够简洁,建议使用其他高级脚本语言实现复杂需求.

```bash
#!/bin/bash

# ============================================
# FIFO 进程池演示
# ============================================

# ---------- 配置 ----------
MAX_JOBS=3          # 进程池大小（最大并发数）
TASKS_COUNT=6        # 总任务数
# 定义一个日志函数，输出带有时间戳的日志信息，参数是日志内容
log() {
    local msg="$1"
    echo "[$(date +%T.%3N)] $msg"
}


# 开始时间
start_time=$(date +%s)
log "===进程池模拟模拟程序开始[线程池大小: $MAX_JOBS]==="
#!/bin/bash

TASK_FIFO="/tmp/task_fifo_$$"
mkfifo "$TASK_FIFO"

# ========== 工作进程（常驻，循环取任务） ==========
worker() {
    local wid=$1
    while true; do
        # 从任务队列读取一行（阻塞等待）
        local task
        read -r task
        
        # 收到退出信号
        [[ "$task" == "EXIT" ]] && break

        # 执行任务
        local duration=$(( RANDOM % 11 + 1 ))
        log "Worker-$wid 执行任务: $task（${duration}s）"
        sleep "$duration"
        log "Worker-$wid 完成任务: $task"
    done
}

# ========== 启动固定数量的 Worker ==========
for (( i = 1; i <= MAX_JOBS; i++ )); do
    worker "$i" < "$TASK_FIFO" &       # 所有worker从同一个FIFO读
    WORKER_PIDS+=($!)
done

# ========== 提交任务（写入 FIFO） ==========
{
    for task_id in $(seq 1 $TASKS_COUNT); do
        echo "T-$task_id"
    done

    # 发送退出信号（每个worker一个）
    for (( i = 0; i < MAX_JOBS; i++ )); do
        echo "EXIT"
    done
} > "$TASK_FIFO"

# ========== 等待所有 Worker 退出 ==========
wait "${WORKER_PIDS[@]}"

rm -f "$TASK_FIFO"

log "======== 所有任务完成 ========"
log "所有任务处理完毕。耗时约: $(($(date +%s) - start_time))秒"

```

暴露更多细节的版本

```bash
#!/bin/bash

# ============================================
# FIFO 进程池演示
# ============================================

# ---------- 配置(可通过脚本位置参数传递来覆盖默认值) ----------
MAX_JOBS=${1:-3}    # 进程池大小（最大并发数）
TIME_LIMIT=${2:-11} # 任务执行时间限制(如果是-开头,则表示每个任务运行相同的取固定值时间)
TASKS_COUNT=${3:-6} # 总任务数
# 定义一个日志函数，输出带有时间戳的日志信息，参数是日志内容
log() {
    local msg="$1"
    echo "[$(date +%T.%3N)] $msg"
}
loge() {
    local msg="$1"
    echo -e "[$(date +%T.%3N)] $msg" >&2
}
# ---------- 模拟任务 ----------
do_task() {
    local id=$1
    local time_limit=${2:-$TIME_LIMIT}

    local duration
    if [[ $time_limit =~ ^- ]]; then
        duration=${time_limit#-} # 去掉开头的'-'符号
    else
        duration=$((RANDOM % "$time_limit" + 1)) # 模拟任务执行时间(1-5秒)
    fi
    # local duration=3   # 固定某个秒数
    log "Task-($id) 开始（将耗时 ${duration}s）"
    sleep "$duration"
    log "Task-($id) 完成"
}
# 开始时间
start_time=$(date +%s)
log "===进程池模拟模拟程序开始[线程池大小: $MAX_JOBS,任务数量为: $TASKS_COUNT]==="
if [[ $TIME_LIMIT =~ ^- ]]; then
    log "任务执行时间固定为: ${TIME_LIMIT#-}秒"
else
    log "任务执行时间随机生成，范围是: 1-${TIME_LIMIT}秒"
fi

TASK_FIFO="/tmp/task_fifo_$$_$(date +%s)" # 任务队列的FIFO文件路径，使用PID和时间戳确保唯一
mkfifo "$TASK_FIFO"

# ========== 工作进程（常驻，循环取任务） ==========
# 通过标注重定向标准输入到此worker函数,让内部的read命令读取任务参数;
# 参考调用方式: worker < TASK_FIFO &
worker() {
    local wid=$1
    # workern内部维护一个while循环,让worker可以重复利用,直到接收到退出信号为止.
    while true; do
        # 从任务队列读取一行（阻塞等待）
        local task
        read -r task

        # 收到退出信号

        [[ "$task" == "EXIT" ]] && log "[worker-$wid] 收到退出信号" && break

        log "Worker-$wid 执行任务"
        # 执行任务
        do_task "$task" "$duration"
        # sleep 3
        log "Worker-$wid 任务完成"
    done
}

# ========== 启动固定数量的 Worker ==========
for ((i = 1; i <= MAX_JOBS; i++)); do
    log "启动worker进程: $i"
    worker "$i" < "$TASK_FIFO" & # 所有worker从同一个FIFO读
    WORKER_PIDS+=($!)
done

# ========== 提交任务（写入 FIFO） ==========
{
    # 提交任务,将任务参数(简单假设为任务名) 写入FIFO
    for task_id in $(seq 1 $TASKS_COUNT); do
        echo "T-$task_id"
    done

    # 提示语句重定向到stderr,以免被worker进程从FIFO读到当成任务参数
    log "worker进程创建完毕" 1>&2
    # 发送退出信号（每个worker一个）
    for ((i = 0; i < MAX_JOBS; i++)); do
        echo "EXIT"
    done
    # 可以考虑追加一个退出信号防止部分进程接收不到EXIT信号停不下来.
    # echo "EXIT" 
    log "所有任务提交完毕" 1>&2
} > "$TASK_FIFO"

# ========== 等待所有 Worker 退出 ==========
wait "${WORKER_PIDS[@]}"

rm -f "$TASK_FIFO"

log "======== 所有任务完成 ========"
log "所有任务处理完毕。耗时约: $(($(date +%s) - start_time))秒"

```

如果脚本修改不当运行后可能出现死循环或进程没有被清理,可以考虑用如下命令清理

> 这里假设脚本名称包含`bash_processpool_fifo`

```bash
# 检查
pgrep -fl  bash_processpool_fifo
# 清理
pkill -f  bash_processpool_fifo
```

或者自行添加`trap`指令执行一些必要的处理.

#### 运行结果示例

```
$ bash bash_processpool_fifo.sh 2 -3 6
[09:53:20.763] ===进程池模拟模拟程序开始[线程池大小: 2,任务数量为: 6]===
[09:53:20.765] 任务执行时间固定为: 3秒
[09:53:20.770] 启动worker进程: 1
[09:53:20.772] 启动worker进程: 2
[09:53:20.775] worker进程创建完毕
[09:53:20.775] Worker-2 执行任务
[09:53:20.775] Worker-1 执行任务
[09:53:20.777] 所有任务提交完毕
[09:53:20.777] Task-(T-1) 开始（将耗时 3s）
[09:53:20.777] Task-(T-2) 开始（将耗时 3s）
[09:53:23.787] Task-(T-2) 完成
[09:53:23.787] Task-(T-1) 完成
[09:53:23.792] Worker-1 任务完成
[09:53:23.792] Worker-2 任务完成
[09:53:23.799] Worker-1 执行任务
[09:53:23.800] Worker-2 执行任务
[09:53:23.804] Task-(T-3) 开始（将耗时 3s）
[09:53:23.804] Task-(T-4) 开始（将耗时 3s）
[09:53:26.812] Task-(T-4) 完成
[09:53:26.813] Task-(T-3) 完成
[09:53:26.815] Worker-2 任务完成
[09:53:26.816] Worker-1 任务完成
[09:53:26.818] Worker-2 执行任务
[09:53:26.818] Worker-1 执行任务
[09:53:26.820] Task-(T-5) 开始（将耗时 3s）
[09:53:26.822] Task-(T-6) 开始（将耗时 3s）
[09:53:29.829] Task-(T-5) 完成
[09:53:29.829] Task-(T-6) 完成
[09:53:29.831] Worker-2 任务完成
[09:53:29.832] Worker-1 任务完成
[09:53:29.834] [worker-2] 收到退出信号
[09:53:29.834] [worker-1] 收到退出信号
[09:53:29.838] ======== 所有任务完成 ========
[09:53:29.842] 所有任务处理完毕。耗时约: 9秒
```

后台任务耗时随机化示例:

```bash
$ bash bash_processpool_fifo.sh 2 5 3
[09:55:37.844] ===进程池模拟模拟程序开始[线程池大小: 2,任务数量为: 3]===
[09:55:37.847] 任务执行时间随机生成，范围是: 1-5秒
[09:55:37.853] 启动worker进程: 1
[09:55:37.854] 启动worker进程: 2
[09:55:37.856] worker进程创建完毕
[09:55:37.856] Worker-2 执行任务
[09:55:37.856] Worker-1 执行任务
[09:55:37.857] 所有任务提交完毕
[09:55:37.857] Task-(T-1) 开始（将耗时 5s）
[09:55:37.858] Task-(T-2) 开始（将耗时 4s）
[09:55:41.860] Task-(T-2) 完成
[09:55:41.861] Worker-1 任务完成
[09:55:41.862] Worker-1 执行任务
[09:55:41.863] Task-(T-3) 开始（将耗时 4s）
[09:55:42.864] Task-(T-1) 完成
[09:55:42.872] Worker-2 任务完成
[09:55:42.877] [worker-2] 收到退出信号
[09:55:45.872] Task-(T-3) 完成
[09:55:45.876] Worker-1 任务完成
[09:55:45.879] [worker-1] 收到退出信号
[09:55:45.886] ======== 所有任务完成 ========
[09:55:45.891] 所有任务处理完毕。耗时约: 8秒
```



#### 任务提交的方式

在提交任务这一块,另一种写法(不推荐):

> 下面的提交任务的代码片段写法似乎便于添加提示性语句,但是也存在问题

```bash
{
    for task_id in $(seq 1 $TASKS_COUNT); do
        echo "T-$task_id" >> "$TASK_FIFO"
    done

    # 发送退出信号（每个worker一个）
    for (( i = 0; i < MAX_JOBS; i++ )); do
        echo "EXIT" >> "$TASK_FIFO"
    done
}
```



|               | `>> FIFO`（逐行）        | `> FIFO`（整体） |
| ------------- | ------------------------ | ---------------- |
| 打开/关闭次数 | N 次                     | 1 次             |
| EOF 风险      | ⚠️ **每次关闭都可能触发** | ✅ 全部写完才关闭 |
| 性能          | 差                       | 好               |
| `>>` 追加语义 | 对 FIFO 无意义           | —                |
| 可靠性        | ❌ Worker 可能意外退出    | ✅ 稳定           |



### 两种FIFO使用方式对比

**令牌方式**本质是一个***并发限流器***，不是真正的进程池。

但在 Bash 脚本的场景下，fork 开销相对于任务本身（网络请求、文件处理等）通常***微不足道***，所以令牌方式已经**完全够用**。

真正需要进程复用的高性能场景，应该用 Python/Go/C 等语言来实现。

|                 | 令牌方式（伪进程池） | 真正的进程池       |
| --------------- | -------------------- | ------------------ |
| **进程复用**    | ❌ 每任务一个新进程   | ✅ Worker 常驻复用  |
| **fork 次数**   | 等于任务数（10次）   | 等于池大小（3次）  |
| **实现复杂度**  | ⭐ 简单               | ⭐⭐ 稍复杂          |
| **适用场景**    | 任务少、不在乎开销   | 任务多、追求效率   |
| **并发控制**    | ✅ 有                 | ✅ 有               |
| **Bash 实用性** | ✅ 够用了             | 过度设计，意义不大 |

##  借助bash外的工具控制并发

### `xargs` 和 `GNU Parallel`

如果你追求生产环境的稳定性，手动写 `wait -n` 可能比较繁琐。

可以考虑`xargs,parallel`甚至使用python.

#### 方法 A：使用 `xargs -P` (最简单)

`xargs` 的 `-P` 参数代表 **Max Processes**（最大进程数）。

```Bash
# 将任务列表传给 xargs，同时开启 4 个进程执行
printf "%s\n" {1..10} | xargs -I {} -P 4 bash -c "echo 正在处理 {}; sleep 2"
```

#### 方法 B：使用 `GNU Parallel` (功能最强)

这是 Linux 下处理并发任务的“神兵利器”，能自动处理负载均衡和日志合并。

```Bash
# 同时运行 4 个作业
parallel -j 4 "echo 任务 {}; sleep 2" ::: {1..10}
```

------

### 总结与对比

| **方法**           | **复杂度** | **推荐场景**                                 |
| ------------------ | ---------- | -------------------------------------------- |
| **`wait -n` 脚本** | 中等       | 纯 Bash 环境，无需安装额外工具时。           |
| **`xargs -P`**     | 简单       | 简单的命令并行，对输出顺序要求不高。         |
| **`GNU Parallel`** | 略高       | 大规模生产任务，需要复杂参数传递和日志管理。 |

### 批量解压场景下的并发方案选择

如果不额外安装parallel的情况下,对比`wait -n` vs `xargs -P`在批量解压文件的场景下的选择

**对于批量解压网站压缩包这个场景，`xargs -P` 更合适。**

理由很简单：你的任务模式是"对一批文件执行相同操作"，这正是 `xargs -P` 的设计初衷。

| 维度               | `wait -n`                 | `xargs -P`                               |
| ------------------ | ------------------------- | ---------------------------------------- |
| **并发控制**       | 需要自己写循环计数逻辑    | `-P N` 一个参数搞定                      |
| **代码复杂度**     | 较高（需手动管理 PID 池） | 低（一行命令）                           |
| **错误处理**       | 可以逐个捕获退出码        | 只知道"有失败"，不易定位哪个             |
| **调用 bash 函数** | ✅ 天然支持                | ⚠️ 需要 `export -f` 导出函数              |
| **适合场景**       | 任务间有依赖、需精细控制  | 批量同构任务（你的场景）                 |
| **Bash 版本要求**  | 4.3+（`wait -n`）         | 对bash版本无特殊要求但是依赖 `findutils` |

参考代码

```bash
#!/bin/bash
set -euo pipefail

DEPLOY_DIR="/var/www"
ARCHIVE_DIR="/opt/packages"
CONCURRENT=4    # 并发数

deploy_site() {
    local archive="$1"
    local name
    name=$(basename "$archive" .tar.gz)
    local target="${DEPLOY_DIR}/${name}"

    echo "[$(date '+%H:%M:%S')] 开始部署: ${name}"

    mkdir -p "$target"

    if tar -xzf "$archive" -C "$target" 2>/dev/null; then
        echo "[$(date '+%H:%M:%S')] ✅ 成功: ${name}"
    else
        echo "[$(date '+%H:%M:%S')] ❌ 失败: ${name}" >&2
        return 1
    fi
}

# 关键：导出函数和变量，让 xargs 启动的子 shell 能访问
export -f deploy_site
export DEPLOY_DIR

# 核心就这一行
find "$ARCHIVE_DIR" -name '*.tar.gz' -print0 \
    | xargs -0 -P "$CONCURRENT" -I {} bash -c 'deploy_site "$@"' _ {}

echo "全部部署完成"
```

