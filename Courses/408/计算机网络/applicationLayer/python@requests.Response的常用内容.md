[toc]

## abstract

Python `requests.Response` 对象深度解析

`requests.Response` 对象是 Python `requests` 库中最重要的对象之一，它封装了 HTTP 响应的所有信息。下面我将全面系统地介绍 Response 对象的常用成员和方法，并结合实际示例说明。

## 一、基础属性

### 1. 状态相关属性
```python
import requests
resp = requests.get('https://httpbin.org/get')

# 状态码 (int)
print(resp.status_code)  # 200

# 状态文本 (str)
print(resp.reason)  # 'OK'

# 是否成功 (bool)
print(resp.ok)  # True (状态码 < 400)
```

### 2. 内容相关属性
```python
# 原始字节内容 (bytes)
print(type(resp.content))  # <class 'bytes'>

# 解码后的文本内容 (str)
print(type(resp.text))  # <class 'str'>

# 自动检测的编码
print(resp.encoding)  # 'utf-8'

# 可以手动设置编码
resp.encoding = 'gbk'
```

### 3. 请求信息属性
```python
# 最终请求的URL (str)
print(resp.url)  # 考虑重定向后的最终URL

# 原始请求对象
print(resp.request.method)  # 'GET'
print(resp.request.url)  # 原始请求URL
print(resp.request.headers)  # 原始请求头
```

## 二、内容处理方法

### 1. JSON 解析
```python
# 解析JSON响应 (自动转换为Python对象)
json_data = resp.json()
print(type(json_data))  # <class 'dict'>

# 处理非JSON响应
try:
    data = resp.json()
except ValueError as e:
    print("响应不是有效的JSON:", e)
```

### 2. 二进制内容处理
```python
# 保存二进制内容到文件
with open('image.jpg', 'wb') as f:
    f.write(resp.content)

# 分块读取大文件
resp = requests.get('http://example.com/large_file', stream=True)
for chunk in resp.iter_content(chunk_size=8192):
    process(chunk)  # 处理每个数据块
```

### 3. 文本内容处理
```python
# 按行迭代文本内容
for line in resp.iter_lines():
    print(line.decode('utf-8'))

# 处理不同编码
if 'gbk' in resp.headers.get('content-type', '').lower():
    resp.encoding = 'gbk'
content = resp.text
```

## 三、头信息处理

### 1. 响应头访问
```python
# 获取所有响应头 (CaseInsensitiveDict)
headers = resp.headers
print(headers)

# 获取特定头 (不区分大小写)
content_type = resp.headers['content-type']
content_length = resp.headers.get('content-length', 0)

# 检查头是否存在
if 'X-Custom-Header' in resp.headers:
    print("自定义头存在")
```

### 2. Cookies 处理
```python
# 获取服务器设置的Cookies
print(resp.cookies)  # RequestsCookieJar 对象

# 访问特定Cookie
print(resp.cookies.get('sessionid'))

# 将Cookies用于后续请求
next_resp = requests.get('http://example.com/api', cookies=resp.cookies)
```

## 四、历史与重定向

### 1. 重定向历史
```python
# 检查是否有重定向
print(resp.history)  # 重定向响应列表

# 遍历重定向链
for prev_resp in resp.history:
    print(f"{prev_resp.status_code}: {prev_resp.url}")

# 最终URL
print(f"最终URL: {resp.url}")
```

### 2. 禁用重定向
```python
resp = requests.get('http://github.com', allow_redirects=False)
print(resp.status_code)  # 301
print(resp.headers['Location'])  # 重定向目标URL
```

## 五、高级方法与技巧

### 1. 状态检查
```python
# 自动抛出HTTP错误 (状态码 ≥ 400)
resp.raise_for_status()  # 无异常表示成功

# 等价于
if 400 <= resp.status_code < 600:
    raise requests.HTTPError(f"HTTP错误: {resp.status_code}")
```

### 2. 原始响应流
```python
resp = requests.get('https://example.com', stream=True)

# 获取原始socket响应
raw = resp.raw
print(raw.read(16))  # 读取前16字节

# 注意：使用后需要手动关闭
raw.close()
```

### 3. 响应时间测量
```python
# 获取请求耗时 (秒)
elapsed = resp.elapsed
print(f"请求耗时: {elapsed.total_seconds():.2f}秒")

# 详细时间信息
print(f"DNS查询: {elapsed.lookup_time:.2f}s")
print(f"连接时间: {elapsed.connect_time:.2f}s")
```

## 六、实际应用示例

### 示例1：API响应处理
```python
def fetch_user_data(user_id):
    url = f'https://api.example.com/users/{user_id}'
    try:
        resp = requests.get(url, timeout=5)
        resp.raise_for_status()
        
        user_data = resp.json()
        return {
            'id': user_data['id'],
            'name': user_data['name'],
            'from_cache': resp.from_cache if hasattr(resp, 'from_cache') else False
        }
    except requests.RequestException as e:
        print(f"请求失败: {e}")
        return None
```

### 示例2：文件下载器
```python
def download_file(url, save_path, chunk_size=8192):
    try:
        with requests.get(url, stream=True) as resp:
            resp.raise_for_status()
            
            with open(save_path, 'wb') as f:
                for chunk in resp.iter_content(chunk_size=chunk_size):
                    if chunk:  # 过滤keep-alive空块
                        f.write(chunk)
        return True
    except Exception as e:
        print(f"下载失败: {e}")
        return False
```

### 示例3：网页抓取框架
```python
class WebScraper:
    def __init__(self):
        self.session = requests.Session()
        self.session.headers.update({
            'User-Agent': 'Mozilla/5.0',
            'Accept-Language': 'en-US,en;q=0.9'
        })
    
    def scrape(self, url):
        try:
            resp = self.session.get(url, timeout=10)
            resp.raise_for_status()
            
            if 'text/html' in resp.headers['Content-Type']:
                return self.parse_html(resp.text)
            elif 'application/json' in resp.headers['Content-Type']:
                return resp.json()
            else:
                return resp.content
        except requests.RequestException as e:
            print(f"抓取失败: {e}")
            return None
    
    def parse_html(self, html):
        # 使用BeautifulSoup等解析HTML
        pass
```

## 七、注意事项与最佳实践

1. **资源释放**：使用 `with` 语句或手动调用 `close()`
   ```python
   with requests.get(url) as resp:
       process(resp.text)
   ```

2. **内存管理**：大文件使用 `stream=True` 和 `iter_content()`

3. **编码处理**：不要依赖自动检测，明确设置编码
   ```python
   resp.encoding = 'gbk' if 'gbk' in resp.headers.get('content-type','') else 'utf-8'
   ```

4. **性能优化**：复用Session减少TCP握手
   ```python
   session = requests.Session()
   resp1 = session.get(url1)
   resp2 = session.get(url2)
   ```

5. **错误处理**：总是检查状态码或使用 `raise_for_status()`

通过深入理解Response对象的这些成员和方法，你可以更高效地处理各种HTTP响应场景，构建健壮的Web请求应用。