[toc]

## 手动下载服务器

- [Release language-server- · Exafunction/codeium (github.com)ll](https://github.com/Exafunction/codeium/releases)

### 示例

下载版本1.8.37的server

- ```powershell
  $version="1.8.37"
  $release_page_uri="https://github.com/Exafunction/codeium/releases/tag/language-server-v$version"
  $uri="https://github.com/Exafunction/codeium/releases/download/language-server-$version/language_server_windows_x64.exe.gz"
  get-speedUpUri $uri
  
  ```

  

- [Release language-server-v1.8.37 · Exafunction/codeium (github.com)](https://github.com/Exafunction/codeium/releases/tag/language-server-v1.8.37)