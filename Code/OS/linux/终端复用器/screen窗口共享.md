[toc]



# Screen 窗口共享指南

Screen 允许多个用户同时连接并查看同一个会话，这在协作调试、教学演示或团队协作时非常有用。 

## 基本共享方法

### 1. 创建可共享的会话

首先由主用户创建一个新会话：
```bash
screen -S shared_session
```

### 2. 设置多用户模式

在 screen 会话中，按 `Ctrl+a` 然后输入：
```
:multiuser on
```

### 3. 添加访问权限

仍在 screen 会话中，添加允许连接的用户：
```
:acladd username
```
(将 `username` 替换为允许连接的用户名)

### 4. 其他用户连接

其他用户可以通过以下命令连接：
```bash
screen -x username/shared_session
```

## 高级共享选项

### 1. 直接启动多用户会话

主用户可以使用以下命令直接创建多用户会话：
```bash
screen -S shared_session -multiuser
```

### 2. 查看已连接用户

在 screen 会话中，按 `Ctrl+a` 然后输入：
```
:info
```
可以查看当前连接的各个用户。

### 3. 权限控制

可以设置不同用户的权限级别：
```
:aclchg username -w "#"
```
这会移除指定用户的写权限（只读模式）

## 实用技巧

1. **分离共享会话**：所有用户都可以使用 `Ctrl+a d` 分离，不会影响其他用户

2. **同步输入**：默认情况下，所有用户的输入是同步的。要关闭同步：
   ```
   :aclchg username +w "#"
   ```

3. **解决连接问题**：如果连接失败，确保：
   - 主用户会话未加密
   - 其他用户在 `:acladd` 中被正确添加
   - 使用完整的 `username/session_name` 格式连接

## 安全注意事项

1. 共享会话会暴露终端中的所有内容，包括可能的敏感信息

2. 考虑使用 `:password` 命令设置会话密码：
   ```
   :password somepassword
   ```

3. 会话结束后，记得移除不再需要的用户权限：
   ```
   :acldel username
   ```

## 示例工作流程

1. 主用户创建会话：
   ```bash
   screen -S team_work -multiuser
   ```

2. 添加团队成员：
   ```
   :acladd alice
   :acladd bob
   ```

3. 团队成员连接：
   ```bash
   # Alice连接
   screen -x alice/team_work
   
   # Bob连接
   screen -x bob/team_work
   ```

4. 协作完成后，主用户终止会话：
   ```
   exit
   ```

 