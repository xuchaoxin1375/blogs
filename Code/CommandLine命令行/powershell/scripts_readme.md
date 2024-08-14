[toc]



## 仓库重点:powershell

- 仓库重点是`powershell` 脚本,详情查看`PS`内部的说明文档 [PwshModuleByCxxu.md](PwshModuleByCxxu.md) 
- 适配于powershell7的模块/函数/别名集合
- 对于windows自带的powershell(v5版本),某些功能不支持
- 然而,windows之所以一直没有彻底移除掉v5版本,是有原因的
  - 某些命令行powershell7是无法执行成功的,而powershell5可以执行成功
  - 例如powershell自带的命令`New-LocalUser`,powershell7某些版本会报错,需要到powershell5.1去执行

### 测试robocopy对于硬链接的反应

