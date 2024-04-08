[toc]



##  posh自定义:扩展或修改主题

###  refs

- 访问速度可能较慢.
  - [official build-in themes(list / snapes)](https://ohmyposh.dev/docs/themes)
  - [theme configuration settings manual](https://ohmyposh.dev/docs/configure)



### 检查预览所有内置的主题

- [Themes | Oh My Posh](https://ohmyposh.dev/docs/themes)

- 在powershell中输入` Get-PoshThemes `,posh会将所有主题输出,并且会输出主题配置文件所在目录

  - ```bash
    
    To change your theme, adjust the init script in C:\Users\cxxu\Documents\PowerShell\Microsoft.PowerShell_profile.ps1.
    Example:
      oh-my-posh init pwsh --config 'C:\Users\cxxu\AppData\Local\Programs\oh-my-posh\themes\jandedobbeleer.omp.json' | Invoke-Expression
    ```

    

### 主题配置文件所在目录

- 环境变量:`$env:POSH_THEMES_PATH`
  - 而不是`$env:Posh_Themes`

- Themes location: `$env:LOCALAPPDATA\Programs\oh-my-posh\themes`



### 基于已有的主题进行更改

- [Customize | Oh My Posh](https://ohmyposh.dev/docs/installation/customize)
- 先复制一份基本满意的主题
  - 我想使用内置的一个`iterm2`主题,然而,他的第二个字段颜色过深,我希望将其调整为亮色的
  - 复制一份改主题配置文件
  - 利用编辑器(例如vscode)将副本打开,(您可以参考官网的字段介绍,也可以凭着经验来做一些基本的颜色修改)
- 可以看到,第二个segment背景被我调为浅色,路径部分看起来更加清晰了
  - ![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/bc25d46af0e34cd7990e0505e7bedf5c.png)

### 主题配置文件预览👺(iterm2改编)



- 主题文件是json文件,例如`iterm2.omp.json`

- 以下是改编后的版本:

- ```bash
  {
    "$schema": "https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/schema.json",
    "blocks": [
      {
        "alignment": "left",
        "segments": [
          {
            "background": "#003543",
            "foreground": "#fff",
            "powerline_symbol": "\ue0b0",
            "properties": {
              "windows": "\uf179"
            },
            "style": "powerline",
            "template": " {{ if .WSL }}WSL at {{ end }}{{.Icon}}",
            "type": "os"
          },
          {
            "background": "#003543",
            "foreground": "#d2ff5e",
            "powerline_symbol": "\ue0b0",
            "style": "powerline",
            "template": "{{ .UserName }} ",
            "type": "session"
          },
          {
            "background": "#afffdd",
            "foreground": "#003544",
            "powerline_symbol": "\ue0b0",
            "properties": {
              "folder_separator_icon": "/",
              "style": "full"
            },
            "style": "powerline",
            "template": " \ue5ff {{ .Path }} ",
            "type": "path"
          },
          {
            "background": "#d2ff5e",
            "background_templates": [
              "{{ if or (.Working.Changed) (.Staging.Changed) }}#ff9248{{ end }}",
              "{{ if and (gt .Ahead 0) (gt .Behind 0) }}#f26d50{{ end }}",
              "{{ if gt .Ahead 0 }}#89d1dc{{ end }}",
              "{{ if gt .Behind 0 }}#f17c37{{ end }}"
            ],
            "foreground": "#193549",
            "powerline_symbol": "\ue0b0",
            "properties": {
              "fetch_stash_count": true,
              "fetch_status": true
            },
            "style": "powerline",
            "template": " {{ .HEAD }}{{ if .Staging.Changed }} \uf046 {{ .Staging.String }}{{ end }}{{ if and (.Working.Changed) (.Staging.Changed) }} |{{ end }}{{ if .Working.Changed }} \uf044 {{ .Working.String }}{{ end }}{{ if gt .StashCount 0 }} \ueb4b {{ .StashCount }}{{ end }} ",
            "type": "git"
          },
          {
            "background": "#33DD2D",
            "background_templates": [
              "{{ if gt .Code 0 }}#f1184c{{ end }}"
            ],
            "foreground": "#242424",
            "powerline_symbol": "\ue0b0",
            "properties": {
              "always_enabled": true
            },
            "style": "powerline",
            "template": " \uea6c ",
            "type": "status"
          }
        ],
        "type": "prompt"
      },
      {
        "alignment": "right",
        "segments": [
          {
            "background": "#f36943",
            "background_templates": [
              "{{if eq \"Charging\" .State.String}}#33DD2D{{end}}",
              "{{if eq \"Discharging\" .State.String}}#FFCD58{{end}}",
              "{{if eq \"Full\" .State.String}}#0476d0{{end}}"
            ],
            "foreground": "#242424",
            "invert_powerline": true,
            "powerline_symbol": "\ue0b2",
            "style": "powerline",
            "template": " {{ if not .Error }}{{ .Icon }}{{ .Percentage }}{{ end }}{{ .Error }}\uf295 \ueb2d ",
            "type": "battery"
          },
          {
            "foreground": "#4abc96",
            "style": "diamond",
            "template": " <#6a0f96>MEM:</> {{ round .PhysicalPercentUsed .Precision }}% ({{ (div ((sub .PhysicalTotalMemory .PhysicalFreeMemory)|float64) 1073741824.0) }}/{{ (div .PhysicalTotalMemory 1073741824.0) }}GB)",
            "type": "sysinfo"
          },
          {
            "background": "#0087D8",
            "foreground": "#003544",
            "invert_powerline": true,
            "powerline_symbol": "\ue0b2",
            "properties": {
              "display_mode": "context",
              "fetch_virtual_env": true
            },
            "style": "powerline",
            "template": " \ue235 {{ .Venv }} ",
            "type": "python"
          },
          {
            "background": "#003543",
            "foreground": "#fff",
            "invert_powerline": true,
            "powerline_symbol": "\ue0b2",
            "style": "powerline",
            "template": "<#fff> \ue641 </>{{ .CurrentDate | date .Format }} ",
            "type": "time"
          }
        ],
        "type": "prompt"
      },
      {
        "alignment": "left",
        "newline": true,
        "segments": [
          {
            "foreground": "#FFD700",
            "style": "plain",
            "template": " \u26a1 ",
            "type": "root"
          },
          {
            "foreground": "#f1184c",
            "style": "plain",
            "template": "🚀 ",
            "type": "text"
          }
        ],
        "type": "prompt"
      }
    ],
    "console_title_template": "{{ .Shell }} in {{ .Folder }}",
    "final_space": true,
    "transient_prompt": {
      "background": "transparent",
      "foreground": "#FFD700",
      "template": "{{if .Root}}\u26a1 {{end}}🚀 "
    },
    "version": 2
  }
  ```
  
  

### tips@如何确定选择想要的颜色代码

- (可选操作)可以建立一个css文件来时时预览您的颜色
- ![在这里插入图片描述](https://img-blog.csdnimg.cn/5c9a33b45d824d359dbbb4d6f1c5e6e4.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBAeHVjaGFveGluMTM3NQ==,size_20,color_FFFFFF,t_70,g_se,x_16)

### 设置@切换主题👺

#### Set-PoshPrompt函数👺

- `oh-my-posh init pwsh | Invoke-Expression`
- 可以用`-c`参数顺便指定使用的主题,例如:`oh-my-posh init pwsh -c "$env:POSH_THEMES_PATH\1_shell.omp.json" | Invoke-Expression`
- 事实上,早期的`set-poshtheme`可以方便的切换主题,现在的新版本被移除了,切换主题比较麻烦点,可以自行编写函数实现类似的效果,不知道后期会不会改回来

- powershell函数配置

  - ```powershell
    function Set-PoshPrompt
    {
        <# 
        .synopsis
        设置oh-my-posh主题,可以用 ls $env:POSH_THEMES_PATH 查看可用主题,我们只需要获取.omp.json前面部分的主题配置文件名称即可
        .example
        🚀 Set-PoshPrompt ys
        # cxxu @ cxxuwin in ~\Desktop [21:17:20]
        $ Set-PoshPrompt 1_shell
         Set-PoshPrompt iterm2
         #>
        param (
            # [Parameter(Mandatory)]
            [string]
            $Theme
        )
        oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\$Theme.omp.json" | Invoke-Expression
    }
    ```

    

### 默认主题

- Default themes[](https://ohmyposh.dev/docs/installation/windows#default-themes)

- You can find the themes in the folder indicated by the environment variable `POSH_THEMES_PATH`. 
- For example, you can use `oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\jandedobbeleer.omp.json" | Invoke-Expression` for the prompt initialization in PowerShell.

##  官方的方法

- 官网中提到,可以通过`export-poshTheme`等操作来修改,但是对于复杂的主题,导出文件内容已经和源文件(.json)发生了变化,实践过程中容易报错



## 历史命令动态补全

- [My Ultimate PowerShell prompt with Oh My Posh and the Windows Terminal - Scott Hanselman's Blog](https://www.hanselman.com/blog/my-ultimate-powershell-prompt-with-oh-my-posh-and-the-windows-terminal)

### 启用动态补全

- [Adding Predictive IntelliSense to my Windows Terminal PowerShell Prompt with PSReadline - Scott Hanselman's Blog](https://www.hanselman.com/blog/adding-predictive-intellisense-to-my-windows-terminal-powershell-prompt-with-psreadline)

  ```powershell
  Install-Module PSReadLine -AllowPrerelease -Force
  Import-Module PSReadLine
  Set-PSReadLineOption -PredictionSource History
  Set-PSReadLineOption -PredictionViewStyle ListView
  Set-PSReadLineOption -EditMode Windows
  
  
  ```

  

- ```powershell
  PS C:\Program Files (x86)\oh-my-posh> ls
  <-/10>                                                        <History(10)>
  > ls iterm*                                                       [History]
  > ls iterm                                                        [History]
  > ls $env:POSH_THEMES_PATH                                        [History]
  > ls hans*                                                        [History]
  > ls $posh_theme_home\iterm2_cxxu2.omp.json                       [History]
  > ls  $posh5_theme_home\iterm2_cxxu2.omp.json                     [History]
  > ls win*                                                         [History]
  > ls -Recurse -Directory  *power*                                 [History]
  > ls -Directory  *power* -Recurse                                 [History]
  > ls *power* -Recurse                                             [History]
  ```

  

