[toc]

## 手动下载服务器

- [Release language-server- · Exafunction/codeium (github.com)ll](https://github.com/Exafunction/codeium/releases)

### 示例

下载版本1.8.37的server

- ```powershell
  
  $vscodeExtensions="~\.vscode\extensions"
  #ls $vscodeExtensions\codeium*
  $lastVersionItem=ls $vscodeExtensions\codeium*|sort -Property Name -Descending|select -First 1
  $Name=$lastVersionItem|select Name
  $v=$Name.Name|scb -PassThru #打印最新版本并且复制版本号到剪切板,形如 `codeium.codeium-1.8.40`
  $versionNumber=("$v" -split "-")[1] #版本好字符串,形如1.8.40
  
  $release_page_uri="https://github.com/Exafunction/codeium/releases/tag/language-server-v$versionNumber"
  $uri="https://github.com/Exafunction/codeium/releases/download/language-server-v$versionNumber/language_server_windows_x64.exe.gz"
  
  $speedUri=get-speedUpUri $uri
  invoke-webrequest $speedUri
  
  ```
  
  
  
  
  
- [Release language-server-v1.8.37 · Exafunction/codeium (github.com)](https://github.com/Exafunction/codeium/releases/tag/language-server-v1.8.37)