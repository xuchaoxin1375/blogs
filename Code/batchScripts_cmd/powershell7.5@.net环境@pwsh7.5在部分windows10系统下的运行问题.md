[toc]

#### 运行环境FAQ

相对较新的.Net 9+版本在老一些的windows10系统上(比如内核版本号:10.0.19044.1288以及之前的),由于默认启用了CET,导致编译运行失败,需要自己在项目中添加关闭CET的配置语句才能够顺利编译;不过这类问题通过搜索引擎一般都能够找到解决方法;

- [dotnet run error Assert failure(PID 28188 [0x00006e1c\], Thread: 26664 [0x6828]) in .net 9 · Issue #110000 · dotnet/runtime](https://github.com/dotnet/runtime/issues/110000)
- [.NET 9 断言失败 ·问题 #108589 ·dotnet/运行时](https://github.com/dotnet/runtime/issues/108589)

事实上,基于.net 构建的程序(比如powershell(pwsh))受.net sdk版本的影响,如果.net sdk存在兼容性问题,那么基于该.net版本构建的powershell很可能也会出现相同的问题

> 例如上述问题在`[Win 10 IoT 企业版 LTSC@21H2:10.0.19044.1288]`上,powershell7.5就可能无法顺利运行,更新系统补丁可以解决此问题`Win 10 IoT 企业版 LTSC@21H2:10.0.19044.2965]`

