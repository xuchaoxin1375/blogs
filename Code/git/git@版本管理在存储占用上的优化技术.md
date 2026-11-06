[toc]

系统地介绍git版本管理在存储占用等方面的机制/优化手段,哪个部分影响最大最有意义?

## 先给结论

Git 的长期存储占用，近似由这句话决定：

> **所有“仍然可达”的引用下，去重后的唯一对象，在经过 zlib、packfile、delta 压缩后的总大小，加上 LFS/子模块/worktree/索引等辅助占用。**

不是：**提交次数 × 代码库大小**

真正影响最大的通常是两件事：

1. **有没有大二进制文件或生成物进入历史**：这是数量级问题，最常把仓库从几十 MB 变成几十 GB。
2. **这些对象是否仍然“可达”**：删掉当前文件、删掉分支不等于删除历史；只要旧提交还能通过分支、tag、reflog、远端 PR、fork、备份等可达，旧大文件就可能继续保留。

对普通源码仓库，Git 内部的 **内容去重 + packfile delta 压缩** 是把 1000 次小改动压成很小增量的关键机制；但它是自动发生的，通常不需要人工调参。

工程上最有意义的优化是：**不让大对象进普通历史、及时治理误入历史的大对象、对大型仓库使用 shallow/partial clone + sparse checkout，最后才是 gc/repack 调参**。

---

## 1. Git 的逻辑存储模型：完整快照，但对象共享

Git 主要存四类对象：

- `blob`：文件内容；
- `tree`：目录项、文件名、权限；
- `commit`：指向一棵 tree、父提交、作者时间等；
- `tag`：annotated tag 对象。

每个 commit 在逻辑上确实代表一棵完整的**目录树快照**，但物理上不会把整个仓库复制 1000 份。原因是：

- 对象按内容哈希寻址；
- 相同内容只存一个对象；
- 未变化的文件、未变化的子树继续引用旧对象；
- 文件改名不会复制内容，只会产生新的 tree；
- 两个路径下内容完全相同的文件，可以共享同一个 blob；
- 多次提交改回相同内容，对应同一个 blob。

例如修改 `src/a/b.c`：

- 生成新的 `b.c` blob；
- `src/a` tree 变化；
- `src` tree 变化；
- 根 tree 变化；
- 生成新 commit。

其他上百万个未变化文件仍然复用旧对象。

---

## 2. 物理存储：loose object 与 packfile

### 2.1 Loose object

新写入对象时，Git 通常先保存成 loose object：

```text
.git/objects/ab/cdef... 
```

每个对象单独 zlib 压缩。它的缺点是：

- 每个对象有独立文件开销；
- 无法利用相似对象之间的 delta；
- 对象很多时，小文件元数据成本明显。

`git count-objects -vH` 里的 `size` 大致对应 loose object 占用量。

### 2.2 Packfile 与 delta 压缩

`git gc`、`git repack`、`git push`、`git fetch` 等会把对象打包成 packfile：

```text
.git/objects/pack/*.pack
.git/objects/pack/*.idx
```

Packfile 的关键能力：

1. **批量存储对象**；
2. **zlib 压缩；**
3. **delta 压缩**：一个对象可以表示成“复制另一个对象的某些字节 + 插入新字节 + 删除字节”。

需要特别强调：

- delta 是**字节级**的，不是按行记录的 Git diff；
- 改哪一行不重要，改动了多少、是否破坏相似性更重要；
- 相似文本文件的 1000 个版本通常能压成很小增量；
- 二进制文件如视频、图片、zip、tar.gz、数据库、可执行文件、模型权重，通常 delta 效果差，甚至接近按版本线性增长；
- 一旦 `tar.gz` 里的一个小文件变化，压缩后的整个包可能面目全非，Git 很难利用内部相似性；
- 全文格式化、换行符大规模变化、编码变化，会削弱 delta 效果；
- `pack.window` 控制找 delta 基底的搜索窗口，`pack.depth` 控制 delta 链长度；默认值通常够用，调大是 CPU/时间换一点空间。

packfile 中还有一些辅助数据：

- `.idx`：对象哈希到 pack 偏移的索引；
- `.bitmap`：clone/fetch 时加速可达性计算；
- `commit-graph`：加速提交历史遍历；
- `multi-pack-index`：多 pack 场景的性能索引。

这些主要是**性能优化**，会增加一点空间，但通常不是存储占用的主要来源。

---

## 3. 可达性：决定历史对象是否还保留

Git 的垃圾回收不是简单看“当前工作区有没有这个文件”，而是看对象是否可达。

一个旧大文件执行了：

```bash
git rm big.bin
git commit -m "remove big file"
```

当前 HEAD 中已经没有 `big.bin`，但旧提交仍引用它。只要旧提交通过以下任一方式可达，普通 `git gc` 就不会删除它：

- 当前分支历史；
- 其他分支；
- tag；
- 远端跟踪分支；
- `stash`；
- reflog；
- notes；
- 备份仓库；
- 远端平台上的 pull request ref；
- fork 中的历史；
- 服务器缓存或其他平台的隐藏 ref。

常见现象：

- `git reset --hard`、`git commit --amend`、`git rebase` 后，旧对象可能先保留在 reflog 中；
- 默认 reflog 会保留一段时间，之后才可能被清理；
- 删除本地分支不会自动删除历史对象；
- 删除远端分支，远端服务器也未必立即 GC；
- GitHub/GitLab 等平台还可能因为 PR、fork、缓存延迟释放空间。

因此：

> **“当前删了”不等于“历史删了”；“本地删了”不等于“远端删了”；“远端 force push 了”也不一定能立刻释放托管平台空间。**

清理不可达对象通常要类似：

```bash
git reflog expire --expire=now --all
git gc --prune=now
```

但这会让误操作更难恢复，必须确认不需要旧历史。更彻底的历史重写可用：

```bash
git filter-repo --path big.bin --invert-paths
```

然后协调所有协作者重新同步，并清理远端所有相关引用。

---

## 4. `.git` 之外的占用不能忽略

`du -sh .` 看到的是整个目录，不只是 Git 历史：

| 内容                       | 说明                                                |
| -------------------------- | --------------------------------------------------- |
| 工作区                     | 当前 checkout 的一份文件                            |
| `.git/objects`             | 历史对象主体                                        |
| `.git/index`               | 暂存区/索引，超大文件数时可能不小                   |
| `.git/logs`                | reflog，本身通常不大，但会让旧对象保持可达          |
| `.git/lfs`                 | Git LFS 本地缓存，可能很大                          |
| `.git/modules`             | 子模块仓库元数据                                    |
| worktree                   | 多个工作区，共享同一个对象库，但各有 checkout/index |
| 构建产物/依赖目录/IDE 缓存 | 不属于 Git，但会让目录看起来很大                    |

LFS 要特别注意：

- Git 历史里主要存指针；
- 真正的大文件内容在 LFS 服务器和本地 `.git/lfs` 缓存；
- 它只是把大对象从普通 Git 历史迁移到另一套存储，并没有“消灭”存储；
- 可用 `GIT_LFS_SKIP_SMUDGE=1` 减少 clone 时拉取，再用 `git lfs pull --include=...` 按需取；
- 可清理本地缓存：

```bash
git lfs prune --dry-run
git lfs prune
```

子模块也有独立对象库。大量子模块、大量历史、重复 clone 也会显著增加总占用。

---

## 5. 大型仓库的 clone/fetch/checkout 优化

这些手段主要减少**本地占用、下载量和检出量**，不改变服务器上的源仓库历史。

### 5.1 Shallow clone

```bash
git clone --depth=1 --single-branch <url>
```

只取最近历史，适合 CI、构建、临时查看。  
代价是历史、blame、bisect 等能力受限。不要把它当作长期唯一副本。

### 5.2 Partial clone

```bash
git clone --filter=blob:none <url>
git clone --filter=blob:limit=1m <url>
git clone --filter=tree:0 <url>
```

按需下载对象内容，适合超大仓库和 CI。需要服务器支持 promisor/partial clone。  
它可能让某些操作联网、变慢，不适合所有离线场景。

### 5.3 Sparse checkout

```bash
git sparse-checkout init --cone
git sparse-checkout set src/app1 src/app2
```

只检出部分目录，主要减少工作区和索引内容。  
**单独使用不会自动减少完整 `.git` 对象库**；通常与 partial clone 配合。

### 5.4 LFS 按需拉取

```bash
GIT_LFS_SKIP_SMUDGE=1 git clone <url>
git lfs pull --include="assets/foo/*"
```

### 5.5 子模块浅克隆

```bash
git clone --recurse-submodules --shallow-submodules <url>
```

这些手段对大型 monorepo 的本地体验通常比调 `pack.window` 有意义得多。

---

## 6. 常用诊断命令

看整体：

```bash
du -sh .
du -sh .git
du -sh .git/objects
du -sh .git/lfs 2>/dev/null
du -sh .git/modules 2>/dev/null
```

看 Git 对象库：

```bash
git count-objects -vH
```

它区分 loose 对象大小、pack 大小、可清理对象、垃圾等。

找历史中最大的 blob：

```bash
git rev-list --objects --all --reflog \
| git cat-file --batch-check='%(objecttype) %(objectname) %(objectsize) %(rest)' \
| awk '$1=="blob" {print $3, $2, $4}' \
| sort -nr \
| head -30
```

看不可达对象：

```bash
git fsck --full --unreachable --no-reflogs
```

看 LFS：

```bash
git lfs ls-files --size
```

看子模块、worktree：

```bash
git submodule status
git worktree list
```

---

## 7. 优化优先级：什么最值得做？

| 优先级 | 措施                                               | 对存储的影响             | 说明                                          |
| ------ | -------------------------------------------------- | ------------------------ | --------------------------------------------- |
| 最高   | 禁止构建产物、依赖目录、大二进制进普通历史         | 决定数量级               | 一个 1GB 文件出现过几次，可能超过大量源码历史 |
| 最高   | 误入历史后重写历史，并清理 refs/reflog/远端引用    | 可能释放巨量空间         | 普通 `gc` 对可达历史中的大文件无效            |
| 高     | 大文件用 LFS 或制品库                              | 把大内容迁移出普通对象库 | LFS 也有配额和本地缓存                        |
| 高     | CI/大仓库用 shallow、partial、sparse               | 降低本地/下载/检出占用   | 服务器源仓库仍可能很大                        |
| 中     | 定期 `git gc` / `git maintenance`                  | 打包、压缩、清理不可达   | 对普通文本历史收益稳定                        |
| 中     | 清理 LFS 缓存、子模块、worktree、旧 stash          | 降低辅助占用             | 容易被忽视                                    |
| 低     | 调 `pack.window`、`pack.depth`、`pack.compression` | 边际收益通常有限         | 换 CPU/时间，不适合作为首要手段               |
| 低     | 频繁 `git gc --aggressive`                         | 可能省一点 pack 空间     | 对大二进制基本无效，耗时明显                  |
| 性能向 | commit-graph、bitmap、MIDX、fsmonitor              | 主要提升速度             | 不是省空间的核心手段                          |

---

## 8. 哪个部分影响最大、最有意义？

分三个角度回答：

### 从“实际仓库体积”看

**最大变量是：可达历史中的大对象，尤其是不可压缩的二进制文件。**

例如：

- 一个 1GB 的二进制文件提交 10 个版本，可能带来约 10GB 级别的历史负担；
- 一个 5000 行、约 200KB 的脚本改 1000 次，打包后通常只是几 MB；
- 很多小源码提交加起来，通常远不如一次大文件事故严重。

### 从“Git 内部压缩效率”看

**最有意义的机制是：内容寻址去重 + packfile delta 压缩。**

它让大量相似文本版本只存为很小的增量。  
但这个机制对二进制、压缩包、加密文件、每次大幅变化的文件效果差；它也不是按代码语义工作的，而是字节级复制/插入。

### 从“团队治理和日常操作”看

**最有价值的动作顺序是：**

1. **入库策略**：`.gitignore`、禁止生成物、大文件走 LFS/制品库；
2. **历史可达性治理**：误入历史的大对象用 `git filter-repo` 等重写，并清理所有分支、tag、reflog、远端 PR/fork；
3. **按需 clone**：大型仓库用 shallow / partial / sparse / LFS lazy fetch；
4. **常规维护**：`git gc`、`git maintenance`、`git lfs prune`；
5. **最后才调 pack 参数或 `--aggressive`**。

一句话总结：

> **Git 的提交次数和普通文本修改通常不是存储问题；真正决定仓库体积的是“有没有大二进制进入历史，以及它们是否仍然可达”。Git 的 pack/delta 是普通源码历史能保持很小的核心机制，但最值得工程团队投入的优化是内容入库策略、历史治理，以及针对大型仓库的按需 clone/checkout。**

## 案例

如果某个git仓库中有一个5000行的单个脚本,每次改动不同的行,1000次提交后占用如何?

### 结论

假设这个 5000 行脚本平均每行约 40 字节，文件约 **200KB**。每次提交只改几行，1000 次后：

| 状态               | 大致占用     | 说明                                          |
| ------------------ | ------------ | --------------------------------------------- |
| 逻辑上的历史内容   | 约 200MB     | 1000 个完整版本 × 200KB                       |
| 松散对象（未打包） | 约 50–70MB   | 每个版本单独 zlib 压缩，文本通常压到 1/3～1/4 |
| `git gc` 打包后    | 约 **1–3MB** | 相邻版本互为 delta，每次改动只需存很少的字节  |
| 工作区             | 200KB        | 只有最终版本一份                              |

所以真正长期占用的，通常只是 **几 MB**，而不是 200MB。

### 为什么松散状态会比较大

Git 的 blob 存的是**完整文件快照**，不是 diff。每次提交后，Git 会新增：

- 一个新的 blob：完整的 200KB 脚本，zlib 压缩后约 50–70KB；
- 若干 tree 对象：从脚本所在目录一直到根目录，每层一个，通常很小；
- 一个 commit 对象：约几百字节。

1000 次提交后，粗略是 `1000 × 50~70KB ≈ 50~70MB`。这时还没有利用版本之间的相似性。

### 为什么打包后会非常小

执行 `git gc`，或 push、fetch 传输时，Git 会生成 packfile，并对相似对象做 **delta 压缩**：

- 一部分版本作为**基底**，完整存储（压缩后约 50KB）；
- 其余版本只存成相对另一个版本的 delta，大致是“从基底某偏移复制 N 字节，插入这几个字节……”。

改几行的 delta 通常只有**几十到几百字节**。

Git 默认的 delta 链最大深度是 50（`pack.depth=50`）。粗略估算：

```text
完整基底：约 1000 / 50 ≈ 20 个 × 50KB ≈ 1MB
delta：   1000 × 约 200B             ≈ 0.2MB
commit：  1000 × 约 200B             ≈ 0.2MB
tree：    每次几个，大多也是小 delta     ≈ 很少
------------------------------------------------
合计约 1～3MB
```

实际基底数量取决于 Git 的启发式选择，往往更少，所以这只是数量级估算。

###  “每次改不同的行”影响不大

Git 的 delta 是**字节级的复制/插入**，不是按行记录 diff，也不在乎改的是哪一行。真正影响大小的是：

- **每次改动的字节量**：改 3 行和改 3000 行差别很大；
- **改动是否破坏整体相似性**：如果某次提交改了换行符（LF↔CRLF）、文件编码、全文格式化或缩进，就几乎相当于新文件。这类提交会产生较大 delta，或者新增一个完整基底。偶尔一次问题不大，但如果每次提交都发生，就会接近松散对象的规模；
- 插入或删除行导致后续内容整体偏移，**不会**让 delta 变大，因为复制指令可以引用任意偏移。

### 实际中处于哪种状态

- 1000 次提交大约产生 3000–5000 个对象，不一定触发自动 gc。自动 gc 默认在松散对象超过约 6700 个时触发，所以本地 `.git` 可能暂时停留在几十 MB 的松散状态；
- 一旦 push，远端收到的就是 pack，存储和传输都是几 MB；
- 别人 clone 时拿到的也是打包后的体积；
- 在本地手动执行 `git gc` 后，`.git` 会降到几 MB。

###  自己验证

下面的脚本会模拟“5000 行脚本，每次改一行，提交 1000 次”：

```bash
mkdir git-test && cd git-test && git init -q

for i in $(seq 1 5000); do
  echo "echo \"line $i: some typical shell script content here\""
done > script.sh
git add script.sh && git commit -qm init

for i in $(seq 1 1000); do
  n=$(( (i * 37) % 5000 + 1 ))                  # 每次改不同的行
  sed -i "${n}s/\$/ # edit $i/" script.sh       # macOS 用: sed -i '' ...
  git commit -qam "edit $i"
done

git count-objects -vH    # 看打包前：size（松散对象）
git gc -q
git count-objects -vH    # 看打包后：size-pack
```

注意：这个测试文件内容高度重复，压缩率会比真实代码高，数字会偏小。换成你自己的真实脚本，结果会更准确。

### 一句话总结

> 一个 200KB 的文本脚本改 1000 次，Git 逻辑上保存 1000 个完整版本，但打包后只占约 **几 MB**。对于这种场景，Git 几乎是最省空间的使用方式。真正需要担心的仍然是**大的、不可压缩的二进制文件**，而不是频繁修改文本。