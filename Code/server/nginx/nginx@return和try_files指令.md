[toc]



在 Nginx 配置中，`try_files` 和 `return` 是两个非常核心的指令，但它们的**工作原理、应用场景和性能损耗**截然不同。

简单来说：**`return` 是“一刀切”的断言，而 `try_files` 是“走着瞧”的探测。**

## 核心区别对比

| **特性**          | **return 指令**                                         | **try_files 指令**                                  |
| ----------------- | ------------------------------------------------------- | --------------------------------------------------- |
| **核心定位**      | 立即中断请求，返回状态码或重定向。                      | 按顺序检查文件是否存在，实现后备（fallback）路由。  |
| **执行时机**      | 在 `rewrite` 阶段执行（非常靠前，甚至在检查文件之前）。 | 在 `content` 阶段执行（需要实际探测磁盘文件）。     |
| **磁盘 I/O 消耗** | **无**。不需要读写磁盘，性能极高。                      | **有**。每检查一个路径都需要进行磁盘 I/O 操作。     |
| **常见场景**      | HTTP 跳转 HTTPS、全局重定向、直接返回 403/404。         | 单页应用（SPA）前端路由、动静分离、文件存在性检查。 |

## 1. return 指令详解

`return` 的特点是**高效、果断**。只要 Nginx 碰到了 `return`，就会立即停止处理后续的指令，直接把结果甩给客户端。

### 语法

Nginx

```
return code [text];
return code URL;
return URL;
```

### 常见用例

- **强制跳转 HTTPS（最常用）：**

  Nginx

  ```
  server {
      listen 80;
      server_name example.com;
      return 301 https://$server_name$request_uri; 
  }
  ```

- **直接拒绝访问：**

  Nginx

  ```
  location /private/ {
      return 403; # 直接返回 403 状态码，不读磁盘
  }
  ```

## 2. try_files 指令详解

`try_files` 的特点是**温和、多变**。它会像排队一样，从左到右依次检查文件或目录是否存在，如果存在就直接返回该文件；如果都不存在，就走最后的“保底方案”。

### 语法

Nginx

```
try_files file1 file2 ... uri;
try_files file1 file2 ... =code;
```

> ⚠️ **注意：** 最后一个参数是**保底方案（Fallback）**，它可以是一个内部重定向的 URI，也可以是一个状态码（如 `=404`）。

### 常见用例

- **Vue / React 等单页应用（SPA）的前端路由（最常用）：**

  在 SPA 中，除了首页，其他路由（如 `/login`、`/dashboard`）在服务器上其实并不存在对应的真实文件。如果不配置 `try_files`，刷新页面就会报 404。

  Nginx

  ```
  location / {
      root /var/www/dist;
      index index.html;
      # 1. 尝试找请求的真实文件（如图片、JS）
      # 2. 尝试找对应的目录
      # 3. 都找不到，就重定向到 index.html，把路由交由前端 JS 处理
      try_files $uri $uri/ /index.html;
  }
  ```

- **图片伪静态或缓存检查：**

  Nginx

  ```
  location /images/ {
      # 先看有没有静态缓存，没有就丢给后端的 PHP 动态生成
      try_files $uri /resize.php?img=$uri;
  }
  ```

## 什么时候用哪个？（避坑指南）

1. **如果你想做绝对的路由跳转或状态拦截**：毫不犹豫选择 `return`。比如域名更换、全站 HTTPS、拉黑 IP。
2. **如果你在部署前端项目，发现刷新页面 404**：必须使用 `try_files`。
3. **性能考量**：不要用 `try_files` 去做大量的判断，因为每一次 `try_files` 里的路径检查都会带来一次磁盘 `stat()` 系统调用。如果列表太长，在高并发下会严重消耗服务器 I/O 性能。

