[toc]



# HTTP 请求与响应系统详解（Python实践篇）

HTTP（HyperText Transfer Protocol）是现代Web通信的基础协议，理解HTTP请求和响应是Web开发和爬虫开发的必备知识。下面我将从理论基础到Python实践，系统介绍HTTP请求和响应。

## 一、HTTP基础理论

### 1. HTTP请求组成
- **请求行**：方法(GET/POST等) + URL + HTTP版本
- **请求头**：包含客户端信息、内容类型等元数据
- **请求体**：可选，GET通常没有，POST/PUT等包含发送的数据

### 2. HTTP响应组成
- **状态行**：HTTP版本 + 状态码 + 状态文本
- **响应头**：包含服务器信息、内容类型等元数据
- **响应体**：服务器返回的实际内容（HTML/JSON/图片等）

### 3. 常见状态码
| 状态码 | 含义           | 示例                  |
| ------ | -------------- | --------------------- |
| 200    | 成功           | OK                    |
| 301    | 永久重定向     | Moved Permanently     |
| 404    | 资源不存在     | Not Found             |
| 500    | 服务器内部错误 | Internal Server Error |

## 二、Python实践：requests库详解

### 1. 发送请求基本方法

```python
import requests

# GET请求
response = requests.get('https://httpbin.org/get')

# POST请求
response = requests.post('https://httpbin.org/post', 
                        data={'key': 'value'})

# 带参数的请求
params = {'key1': 'value1', 'key2': 'value2'}
response = requests.get('https://httpbin.org/get', params=params)
```

### 2. 解析响应内容

```python
# 获取状态码
print(response.status_code)  # 200

# 获取响应头
print(response.headers)
print(response.headers['Content-Type'])  # 获取特定头

# 获取响应内容的不同形式
print(response.text)    # 文本形式
print(response.content) # 字节形式
print(response.json())  # JSON解析为字典
```

### 3. 高级请求配置

```python
# 自定义请求头
headers = {
    'User-Agent': 'Mozilla/5.0',
    'Accept': 'application/json'
}

# 带认证的请求
auth = ('username', 'password')

# 超时设置（连接超时3秒，读取超时5秒）
response = requests.get(
    'https://httpbin.org/get',
    headers=headers,
    auth=auth,
    timeout=(3, 5)
)
```

## 三、实战案例：完整HTTP交互

### 案例1：API请求与JSON处理

```python
import requests

def get_github_events():
    url = 'https://api.github.com/events'
    
    try:
        response = requests.get(url, timeout=5)
        response.raise_for_status()  # 自动检查状态码
        
        events = response.json()
        print(f"获取到 {len(events)} 个事件")
        print("最新事件:", events[0]['type'])
        
    except requests.exceptions.RequestException as e:
        print(f"请求失败: {e}")

get_github_events()
```

### 案例2：文件下载与进度显示

```python
import requests
from tqdm import tqdm  # 进度条库

def download_file(url, filename):
    # 流式下载
    response = requests.get(url, stream=True)
    total_size = int(response.headers.get('content-length', 0))
    
    with open(filename, 'wb') as file, tqdm(
        desc=filename,
        total=total_size,
        unit='iB',
        unit_scale=True,
        unit_divisor=1024,
    ) as bar:
        for data in response.iter_content(chunk_size=1024):
            size = file.write(data)
            bar.update(size)

# 下载示例图片
download_file('https://example.com/image.jpg', 'downloaded_image.jpg')
```

### 案例3：处理重定向和Cookies

```python
import requests

# 禁用重定向
response = requests.get('http://github.com', allow_redirects=False)
print(f"原始请求状态码: {response.status_code}")  # 301

# 启用重定向（默认）
response = requests.get('http://github.com')
print(f"最终请求URL: {response.url}")  # https://github.com/

# 处理Cookies
response = requests.get('https://httpbin.org/cookies/set/sessioncookie/123456789')
print("服务器设置的Cookies:", response.cookies)
```

## 四、常见问题与调试技巧

### 1. 调试请求

```python
# 打印请求详细信息
response = requests.get('https://httpbin.org/get')
print("请求头:", response.request.headers)
print("请求体:", response.request.body)
```

### 2. 处理SSL证书问题

```python
# 忽略SSL验证（不推荐生产环境使用）
response = requests.get('https://expired.badssl.com', verify=False)

# 或指定证书路径
response = requests.get('https://example.com', cert=('/path/client.cert', '/path/client.key'))
```

### 3. 处理不同编码

```python
# 手动设置编码
response = requests.get('https://example.com')
response.encoding = 'gbk'  # 对于中文网页可能需要
print(response.text)
```

## 五、最佳实践建议

1. **总是检查状态码**：使用 `response.raise_for_status()` 或手动检查
2. **设置合理超时**：避免程序挂起 `timeout=(3.05, 27)`
3. **使用会话(Session)**：复用TCP连接提高性能
   ```python
   with requests.Session() as session:
       session.get('https://example.com')
   ```
4. **处理大文件使用流式**：`stream=True` + `iter_content()`
5. **尊重robots.txt**：爬虫时检查目标网站的爬取规则

通过这个系统讲解，你应该已经掌握了HTTP请求和响应的核心概念，并能够使用Python的requests库进行各种HTTP操作。实际开发中，建议多使用交互式环境(如Jupyter Notebook)进行实验，观察不同请求的响应结果。