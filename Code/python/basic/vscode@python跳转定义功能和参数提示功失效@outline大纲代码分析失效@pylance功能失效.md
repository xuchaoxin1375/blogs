[toc]



### pylance报多余而不该有的错

- 方式1:重载窗口,pylance可以重新扫描新模块
- 方式2:配置extra路径
  - `python.analysis.extraPaths`
    - Used to specify extra search paths for import resolution. This replaces the old `python.autoComplete.extraPaths` setting.
    - Default value: empty array



## pylance功能失效

> 跳转到定义功能失效|跳转到模块或包不可用|api和参数提示不可用

安装pylance并启用,同时配置python语言服务器:`"python.languageServer": "Pylance"` 

检查项目根目录下的`.vscode`目录(如果有的话)中的配置文件(除了全局settings,还要检查用户级的settings,和工作区(workspace)级别的配置)

```json
{
    "python.languageServer": "Pylance" 
}
```

> 修改后可能需要重启vscode才会生效

工作区的目录搞小一点，如果子文件目录过多就不行了(pylance分析不过来)

