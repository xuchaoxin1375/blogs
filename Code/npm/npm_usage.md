# npm/yarn的基本用法/全局卸载某个包(卸载dingtalk-design-cli)

## 基本用法

## references

- [Getting started | npm Docs (npmjs.com)](https://docs.npmjs.com/getting-started)
- [npm CLI | npm Docs (npmjs.com)](https://docs.npmjs.com/cli/v8)
- [Packages and modules | npm Docs (npmjs.com)](https://docs.npmjs.com/packages-and-modules)
- [About scopes | npm Docs (npmjs.com)](https://docs.npmjs.com/about-scopes)

- `npm -h`获取基本命令列表

- `npm -l`获取所有命令以及解释(基本解释)

  - 例如获取已经安装的包

  - ```bash
    ls              List installed packages
    
                    Usage:
                    npm ls [[<@scope>/]<pkg> ...]
    
                    Options:
                    [-a|--all] [--json] [-l|--long] [-p|--parseable] [-g|--global] [--depth <depth>]
                    [--omit <dev|optional|peer> [--omit <dev|optional|peer> ...]] [--link]
                    [--package-lock-only] [--unicode]
                    [-w|--workspace <workspace-name> [-w|--workspace <workspace-name> ...]]                    [-ws|--workspaces] [--include-workspace-root]
    
                    alias: list
    
                    Run "npm help ls" for more info
    ```

- `npm help `

  - 在线查阅文档



### 全局卸载

- `npm uninstall -g <packageName>`
  - 注意`-g`选项不可以放在packageName后面

- ` npm uninstall -g dingtalk-design-cli`



## yarn

> yarn 的本地文档就挺全的,内容分级比较简单,可以借助sls(for powershell)/grep(for linux shell)来查找关键行

- `yarn -h`

### 查看软件包

- [yarn list | Yarn 中文文档 (bootcss.com)](https://yarn.bootcss.com/docs/cli/list/)

- `yarn --list `生成报告(如果处在一个非yarn的工作目录(没有 package.json: No license field))
- `yarn list`查看报告