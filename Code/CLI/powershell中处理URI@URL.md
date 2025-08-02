[toc]

## abstract

[System.Uri 类 - .NET | Microsoft Learn](https://learn.microsoft.com/zh-cn/dotnet/fundamentals/runtime-libraries/system-uri)

[URI | MDN](https://developer.mozilla.org/zh-CN/docs/Web/URI)

在 PowerShell 中处理 **URL/URI** 是非常常见的需求，尤其是在做网络请求、日志分析、自动化测试、API 调用等场景。PowerShell 提供了强大的 .NET 基础支持，结合原生命令，可以实现 **解析、构造、验证、提取、编码/解码** 等操作。

---

## ✅ 一、核心工具：`[System.Uri]` 类（.NET 原生支持）

PowerShell 可直接使用 .NET 的 `Uri` 类，这是处理 URL 的**首选方式**。

### 📌 基本用法

```powershell
$uri = [System.Uri]"https://user:pass@example.com:8443/path/to/page?query=1#section"

$uri.Scheme      # https
$uri.Host        # example.com
$uri.Port        # 8443
$uri.PathAndQuery# /path/to/page?query=1
$uri.AbsolutePath# /path/to/page
$uri.Query       # ?query=1
$uri.Fragment    # #section
$uri.UserInfo    # user:pass
$uri.Authority   # example.com:8443
```

> ⚠️ 注意：`[Uri]` 不自动添加协议，必须以 `http://` 或 `https://` 开头。

---

## ✅ 二、常见处理场景与案例

---

### ✅ 案例 1：从 URL 中提取主机名（Host）

```powershell
$url = "https://www.google.com/search?q=powershell"
$uri = [System.Uri]$url
$hostName = $uri.Host  # www.google.com
```

📌 批量处理文件中的 URL

```powershell
Get-Content urls.txt | ForEach-Object {
    $url = $_.Trim()
    if ([uri]::IsWellFormedUriString($url, 'Absolute')) {
        $uri = [System.Uri]$url
        [PSCustomObject]@{
            Original = $url
            Host     = $uri.Host
            Domain   = ($uri.Host -split '\.')[-2..-1] -join '.'  # 主域名
        }
    }
}
```

---

### ✅ 案例 2：判断是否为有效 URL

```powershell
function Test-ValidUri {
    param([string]$Url)
    [uri]::IsWellFormedUriString($Url, 'Absolute')
}

Test-ValidUri "https://google.com"    # True
Test-ValidUri "htp:/invalid"          # False
```

---

### ✅ 案例 3：自动补全协议（`http://`）

有些 URL 只写 `google.com`，需要补全：

```powershell
function ConvertTo-AbsoluteUri {
    param([string]$InputUrl)
    $url = $InputUrl.Trim()
    if (-not ($url -match '^https?://')) {
        $url = "http://$url"
    }
    if ([uri]::IsWellFormedUriString($url, 'Absolute')) {
        return [System.Uri]$url
    }
    else {
        return $null
    }
}

ConvertTo-AbsoluteUri "google.com"       # http://google.com
ConvertTo-AbsoluteUri "https://github.com" # https://github.com
```

---

### ✅ 案例 4：提取主域名（Primary Domain）

```powershell
function Get-PrimaryDomain {
    param([string]$Host)
    ($Host -split '\.')[-2..-1] -join '.'
}

Get-PrimaryDomain "sub.www.google.com"  # google.com
Get-PrimaryDomain "api.github.com"      # github.com
```

> ⚠️ 注意：对 `co.uk`、`com.cn` 等多级 TLD 不完全准确。建议使用第三方库或规则表。

---

### ✅ 案例 5：URL 编码与解码

```powershell
# 编码
[System.Web.HttpUtility]::UrlEncode("hello world+123@#$") 
# 输出: hello+world%2b123%40%23%24

# 解码
[System.Web.HttpUtility]::UrlDecode("hello+world%2b123")
# 输出: hello world+123
```

> ⚠️ 需要加载 `System.Web` 程序集（PowerShell 7+ 默认可用）

```powershell
Add-Type -AssemblyName System.Web
```

---

### ✅ 案例 6：解析 Query 参数

```powershell
function Parse-QueryString {
    param([string]$Query)  # ?name=john&age=30
    $query = $Query.TrimStart('?')
    $result = @{}
    foreach ($pair in $query -split '&') {
        if ($pair -match '(.*?)=(.*)') {
            $key = [System.Web.HttpUtility]::UrlDecode($matches[1])
            $value = [System.Web.HttpUtility]::UrlDecode($matches[2])
            $result[$key] = $value
        }
    }
    $result
}

Parse-QueryString "name=John+Doe&city=New+York"
# 输出: @{ name = "John Doe"; city = "New York" }
```

---

### ✅ 案例 7：构造 URL（拼接参数）

```powershell
function New-UriFromParts {
    param(
        [string]$Base,
        [hashtable]$QueryParams
    )
    $uriBuilder = New-Object System.UriBuilder($Base)
    $query = $QueryParams.GetEnumerator() | ForEach-Object {
        "$($_.Key)=$([System.Web.HttpUtility]::UrlEncode($_.Value))"
    } -join '&'
    $uriBuilder.Query = $query
    $uriBuilder.ToString()
}

New-UriFromParts "https://api.example.com/search" @{
    q = "power shell"
    page = 2
}
# 输出: https://api.example.com/search?q=power+shell&page=2
```

---

### ✅ 案例 8：批量测试 URL 状态码（健壮版）

```powershell
Get-Content urls.txt |
    ForEach-Object { $_.Trim() } |
    Where-Object { $_ -and (Test-ValidUri $_) } |
    ForEach-Object -Parallel {
        [System.Net.ServicePointManager]::SecurityProtocol = 'Tls12'

        $url = $_
        $uri = [System.Uri]$url
        try {
            $res = Invoke-WebRequest -Uri $url -Method HEAD -TimeoutSec 10 -ErrorAction Stop -SkipCertificateCheck
            [PSCustomObject]@{
                Url = $url
                Host = $uri.Host
                StatusCode = $res.StatusCode
                Status = "✅ OK"
                Error = $null
            }
        }
        catch {
            $code = $_.Exception.Response.StatusCode.value__ ?? $null
            [PSCustomObject]@{
                Url = $url
                Host = $uri.Host
                StatusCode = $code
                Status = if ($code) { "🔴 $code" } else { "❌ Failed" }
                Error = $_.Exception.Message
            }
        }
    } -ThrottleLimit 32 |
    Format-Table -AutoSize
```

---

## ✅ 三、实用技巧总结

| 需求                | 方法                                                    |
| ------------------- | ------------------------------------------------------- |
| 判断是否为 URL      | `[uri]::IsWellFormedUriString($url, 'Absolute')`        |
| 提取 Host           | `$uri.Host`                                             |
| 提取路径            | `$uri.AbsolutePath`                                     |
| 提取查询参数        | 手动解析或用 `HttpUtility.ParseQueryString()`           |
| URL 编码            | `[System.Web.HttpUtility]::UrlEncode()`                 |
| 忽略 HTTPS 证书错误 | `-SkipCertificateCheck`（PS 7+）                        |
| 设置 TLS            | `[Net.ServicePointManager]::SecurityProtocol = 'Tls12'` |
| 构造 URL            | `System.UriBuilder`                                     |

---

## ✅ 四、推荐封装函数（可复用）

```powershell
function ConvertTo-AbsoluteUri {
    param([string]$Url)
    $u = $Url.Trim()
    if (-not $u -match '^https?://') { $u = "http://$u" }
    if ([uri]::IsWellFormedUriString($u, 'Absolute')) {
        [System.Uri]$u
    } else {
        $null
    }
}

function Get-Domain {
    param([string]$Host)
    ($Host -split '\.')[-2..-1] -join '.'
}
```

---

## ✅ 五、注意事项

| 问题                     | 解决方案                                                     |
| ------------------------ | ------------------------------------------------------------ |
| `Invoke-WebRequest` 失败 | 检查 TLS、代理、DNS、防火墙                                  |
| `-Parallel` 中无法解析   | 每个线程内设置 `[Net.ServicePointManager]::SecurityProtocol` |
| 中文 URL 报错            | 使用 `UrlEncode`                                             |
| 企业代理                 | 设置 `[System.Net.WebRequest]::DefaultWebProxy.Credentials = [Net.CredentialCache]::DefaultCredentials` |

---

## ✅ 六、扩展建议

- 使用 `System.Web.HttpUtility.ParseQueryString()` 解析复杂 Query
- 使用正则提取特定域名（如只保留 `.com`）
- 结合 `Export-Csv` 生成报告
- 使用 `Start-Sleep` 防止请求过快被封

---

🎯 **总结**：PowerShell 处理 URL 的最佳实践是：

> **`[System.Uri]` 解析 + `HttpUtility` 编码 + `Invoke-WebRequest` 请求 + 异常捕获 + 并行处理**

---

 