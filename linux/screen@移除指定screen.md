[toc]



要从 `screen` 的会话列表中移除一个不再使用的会话



---

## **1. 列出所有 screen 会话**

首先查看当前存在的会话及其状态：
```bash
screen -ls
```
输出示例：
```
There are screens on:
    12345.old_session    (Detached)
    67890.useful_session (Detached)
```

---

## **2. 终止目标会话**

### 方法一：通过会话ID或名称终止🎈

```bash
screen -XS <session_id_or_name> quit
```
选项说明

- `-S sockname   Name this session <pid>.sockname instead of <pid>.<tty>.<host>.`,即指定要被操作的screen
- `-X            Execute <cmd> as a screen command in the specified session.`

这里组合使用两个选项

#### 示例：

准确执行

```bash
screen -XS 12345.old_session quit
```
或使用会话名称：
```bash
screen -XS old_session quit
```

实操

```bash
#( 06/22/25@ 2:04AM )( root@wnx0020303 ):~
   screen -ls
There are screens on:
        1911244.zsh     (06/22/2025 01:37:22 AM)        (Detached)
        1865565.zw      (06/21/2025 03:44:09 AM)        (Attached)
        1864778.zsh     (06/21/2025 03:26:13 AM)        (Attached)
        1863026.tt      (06/21/2025 02:58:45 AM)        (Attached)
        1519748.cxxu    (06/16/2025 01:36:05 AM)        (Attached)
        1345062.clm     (06/12/2025 08:17:02 AM)        (Detached)
6 Sockets in /run/screen/S-root.
#( 06/22/25@ 2:04AM )( root@wnx0020303 ):~
   screen -XS tt quit
#( 06/22/25@ 2:04AM )( root@wnx0020303 ):~
   screen -ls
There are screens on:
        1911244.zsh     (06/22/2025 01:37:22 AM)        (Detached)
        1865565.zw      (06/21/2025 03:44:09 AM)        (Attached)
        1864778.zsh     (06/21/2025 03:26:13 AM)        (Attached)
        1519748.cxxu    (06/16/2025 01:36:05 AM)        (Attached)
        1345062.clm     (06/12/2025 08:17:02 AM)        (Detached)
```



### 方法二：手动附加后退出

1. 附加到目标会话：
   ```bash
   screen -r 12345.old_session
   ```
2. 在会话内输入 `exit` 或按 `Ctrl + d` 直接退出。

#### 示例

这里假设我有两个名为`tt`的screen,要移除其中一个

```bash
#( 06/21/25@ 2:59AM )( root@wnx0020303 ):~
   screen -ls
There are screens on:
        1863083.tt      (06/21/2025 02:59:00 AM)        (Attached)
        1863026.tt      (06/21/2025 02:58:45 AM)        (Attached)
        1519748.cxxu    (06/16/2025 01:36:05 AM)        (Attached)
        1345062.clm     (06/12/2025 08:17:02 AM)        (Detached)
4 Sockets in /run/screen/S-root.
```

进入到指定screen(`-dr`),移除当前screen

```bash
#( 06/22/25@ 1:39AM )( root@wnx0020303 ):~
   echo $STY
1863083.tt
#( 06/22/25@ 1:39AM )( root@wnx0020303 ):~
   exit
```





---

## **3. 验证是否移除**
再次检查会话列表，确认目标会话已消失：
```bash
screen -ls
```
输出应不再显示被删除的会话。

---

## **4. 清理无效的 Socket 文件（可选）**

如果会话残留文件未被自动清理，手动删除：
```bash
screen -wipe
```
这会移除所有无效的会话记录。

---

### **注意事项**
1. **权限要求**：  
   - 需拥有该会话的权限（如属于同一用户或 root）。
2. **强制终止**：  
   - 若会话卡死，可强制终止其进程：
     ```bash
     pkill -9 -t pts/X  # 替换 X 为会话的终端编号
     ```
3. **多用户场景**：  
   - 若会话被其他用户占用，需先分离：
     ```bash
     screen -d session_name
     ```

---

### **总结命令**
```bash
# 一次性强制终止会话
screen -XS <session_id_or_name> quit && screen -wipe
```

通过以上步骤，你可以彻底从 `screen` 列表中移除无用的会话。

