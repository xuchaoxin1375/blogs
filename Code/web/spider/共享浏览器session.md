[toc]



## abstract

在同一个网站爬取多个页面时，**共享浏览器上下文（Context）** 是提高效率的关键。

[Spiders sessions - Scrapling](https://scrapling.readthedocs.io/en/latest/spiders/sessions.html)

### 1. 核心观点：共享数据不仅靠谱，而且是推荐做法

- **为什么靠谱：** Cloudflare 的验证（如 Turnstile）通常会在通过后向浏览器写入特定的 **Cookie** 或 **Session Storage**。只要这些凭证有效，后续请求同域名的页面时，服务器会识别出该“人”已验证通过，从而直接跳过验证，大大减少等待时间。
- **效率提升：** 避免了每次请求都要启动新浏览器、加载 JS、执行挑战逻辑的开销。

------

### 2. 解决方案 A：在同一个 Python 进程内共享（推荐）

如果您可以在一个脚本中处理这些 URL，应该使用 `StealthySession`。它会自动维护浏览器上下文和 Cookie。

```python
from scrapling.fetchers import StealthySession

urls = [
    "https://www.lascoautoparts.com/oem-parts/ford-oil-filter-4h2z6731aa",
    "https://www.lascoautoparts.com/oem-parts/ford-air-filter-pr3z9601b"
]

# 使用 session 模式，浏览器和 cookie 会被复用
with StealthySession(solve_cloudflare=True, headless=True) as session:
    for url in urls:
        # 第一次请求可能会触发 CF 验证
        # 第二次及以后的请求会携带第一次获取的 Cookie，通常能秒过
        page = session.fetch(url)
        print(f"URL: {url}, Title: {page.css('title::text').get()}")
```

------

### 3. 解决方案 B：跨进程/不同时间的痕迹保留（持久化）

如果您的使用场景受限，必须**启动不同的 Python 进程**，或者希望在关闭脚本后再启动时依然能保留验证状态，需要使用 **`user_data_dir`（用户数据目录）**。

#### 原理：

`user_data_dir` 会将浏览器的所有痕迹（Cookie、Local Storage、Cache、IndexedDB）保存到磁盘上的文件夹中。

只要多个进程指向同一个文件夹（注意并发冲突），或者同一个进程多次运行指向该文件夹，验证状态就能延续。

#### 代码实现：



```python
import os
from scrapling.fetchers import StealthySession

# 定义一个本地文件夹路径用于存放浏览器数据
# 这样即便 Python 程序结束，下次运行依然能读取到之前的验证状态
my_browser_data = os.path.abspath("./my_scraping_profile")

with StealthySession(
    solve_cloudflare=True, 
    headless=True,
    user_data_dir=my_browser_data  # 关键参数：持久化存储路径
) as session:
    page = session.fetch("https://www.lascoautoparts.com/oem-parts/ford-oil-filter-4h2z6731aa")
    # ... 处理逻辑 ...
```

------

### 4. 针对不同进程调用的技术细节

如果您是**并发/并行**运行多个进程：

- **警告：** 浏览器通常不支持多个进程**同时**读写同一个 `user_data_dir` 文件夹。如果进程 A 正在使用该目录，进程 B 启动时可能会报错（文件锁定）。
- **折中方案：**
  1. **顺序执行：** 进程 A 运行 -> 验证 -> 写入磁盘 -> 退出；进程 B 启动 -> 读取磁盘 -> 跳过验证。
  2. **Cookie 导出：** 在进程 A 中通过 `session.context.cookies()` 获取 Cookie 并保存到 Redis 或数据库中，进程 B 启动后通过 `session.set_cookies()` 注入。

### 5. 关于 Camoufox 的补充建议

您提到的文档涉及了 Camoufox。Camoufox 是 Scrapling 曾经使用的核心（现在默认改用 `patchright`），它在防指纹方面非常强大。

- 如果您手动配置 Camoufox 引擎，务必在 `launch_persistent_context` 中传入相同的 `user_data_dir`。
- **Camoufox 的优势：** 它会模拟真实的硬件指纹（如 Canvas、WebGL、声卡等）。如果 Cloudflare 检测到您的指纹一直在变（即使 Cookie 对了），也可能再次触发验证。使用 `user_data_dir` 可以锁定这一套指纹，让请求看起来更像同一个真实用户的行为。

### 总结建议：

1. **优先**尝试 `StealthySession` 并在单个进程内循环处理。
2. 如果必须跨进程，给 `StealthySession` 传入 `user_data_dir` 参数，指向一个固定的本地文件夹。
3. 确保 `solve_cloudflare=True` 且 `timeout` 至少设置在 60000 (60秒) 以上，给初次通过挑战留够时间。