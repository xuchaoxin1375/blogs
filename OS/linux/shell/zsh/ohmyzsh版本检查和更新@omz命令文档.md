[toc]

# abstract

- 前端时间 zsh+oh my zsh 命令行环境有点bug,`ctrl+c`无法结束输入,而且容易卡死,遂打算更新zsh

## 相关软件版本检查



### oh my zsh version

- `omz version`

  ```bash
  ┌─[cxxu@ubt22] - [~] - [2024-04-10 02:32:35]
  └─[1] <> omz version
  master (6dfa950)
  ```



## oh my zsh 文档

- [Home · ohmyzsh/ohmyzsh Wiki (github.com)](https://github.com/ohmyzsh/ohmyzsh/wiki)

### omz命令

```bash
┌─[cxxu@ubt22] - [~] - [2024-04-10 02:30:14]
└─[0] <> omz --help
Usage: omz <command> [options]

Available commands:

  help                Print this help message
  changelog           Print the changelog
  plugin <command>    Manage plugins
  pr     <command>    Manage Oh My Zsh Pull Requests
  reload              Reload the current zsh session
  theme  <command>    Manage themes
  update              Update Oh My Zsh
  version             Show the version
```



### oh my zsh 自动更新策略配置

- [ohmyzsh/ohmyzsh: update config](https://github.com/ohmyzsh/ohmyzsh#getting-updates)

### 立即更新oh my zsh

- 立即更新`omz update`

### 插件检查和配置

- 插件方面的命令

  ```bash
  
  ┌─[cxxu@ubt22] - [~] - [2024-04-10 02:35:17]
  └─[1] <> omz plugin
  Usage: omz plugin <command> [options]
  
  Available commands:
  
    disable <plugin> Disable plugin(s)
    enable <plugin>  Enable plugin(s)
    info <plugin>    Get information of a plugin
    list             List all available Oh My Zsh plugins
    load <plugin>    Load plugin(s)
  
  ```

- 查看所有插件

  ```
  
  ┌─[cxxu@ubt22] - [~] - [2024-04-10 02:37:52]
  └─[1] <> omz plugin list
  Custom plugins:
  example                  zsh-autosuggestions      zsh-syntax-highlighting
  
  Built-in plugins:
  1password                 adb                       ag
  aliases                   alias-finder              ansible
  ant                       apache2-macports          arcanist
  archlinux                 argocd                    asdf
  autoenv                   autojump                  autopep8
  ...
  ```

  
