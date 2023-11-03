[toc]

# powershell@scoop安装@scoop安装失败的解决方案

## abstract

- [ScoopInstaller/Scoop: A command-line installer for Windows. (github.com)](https://github.com/ScoopInstaller/Scoop)

## 安装scoop

- [Scoop](https://scoop.sh/)

- [ScoopInstaller/Install: 📥 Next-generation Scoop (un)installer (github.com)](https://github.com/ScoopInstaller/Install)

- 将一下的方案粘贴到powershell中执行

  - 根据网络环境的不同，选用其中一种
  - 对于代理方案,需要代理服务器,否则无效

- 一下命令行是powershell语言编写的

  

### 默认方案(无代理)

- 方案1：

  - ```powershell
    Set-ExecutionPolicy RemoteSigned -Scope CurrentUser # Optional: Needed to run a remote script the first time
    iex (new-object net.webclient).downloadstring('https://get.scoop.sh')
    ```

- 方案2:

  - ```powershell
    Set-ExecutionPolicy RemoteSigned -Scope CurrentUser # Optional: Needed to run a remote script the first time
    irm get.scoop.sh | iex
    ```


- 总结:国内用默认方式安装scoop并不容易(经常会报错)

  - ```bash
    PS C:\Users\cxxu\Desktop> iwr -useb get.scoop.sh | iex
    Invoke-WebRequest: The requested name is valid, but no data of the requested type was found.
    ```

### powershell命令详解

- The command `irm get.scoop.sh | iex` is used to install Scoop on a Windows system. Here's a breakdown of what each part of the command does:

  - `irm`: This is short for `Invoke-RestMethod`, a PowerShell cmdlet used for making HTTP requests. In this case, it's being used to download the installation script for Scoop from the URL `get.scoop.sh`.
  - `get.scoop.sh`: This is the URL where the installation script for Scoop is located.
  - `|`: This is a pipe symbol that is used to send the output of one command to another command. In this case, it's sending the output of the `irm` command (which is the installation script for Scoop) to the `iex` command.
  - `iex`: This is short for `Invoke-Expression`, another PowerShell cmdlet used for running commands or scripts as if they were typed directly into the command line. In this case, it's being used to execute the installation script for Scoop that was downloaded by the `irm` command.

  So, when you run the command `irm get.scoop.sh | iex`, it downloads the installation script for Scoop from `get.scoop.sh` using `Invoke-RestMethod` and then executes the script using `Invoke-Expression`. This will install Scoop on your Windows system.

## 使用代理加速

- 使用代理说明

  - ```
    # You can use proxies if you have network trouble in accessing GitHub, e.g.
    irm get.scoop.sh -Proxy 'http://<ip:port>' | iex
    ```

- 例子(假设自己的代理为`http://127.0.0.1:10801`)

  ```powershell
  PS C:\Users\cxxu\Desktop> irm get.scoop.sh -Proxy 'http://127.0.0.1:10801' | iex
  Initializing...
  Downloading ...
  Creating shim...
  Adding ~\scoop\shims to your path.
  Scoop was installed successfully!
  ```

- 特点:需要代理才可以使用本方案.

### 配置git

- scoop的升级等操作依赖于git,因此如果么有安装git建议提早配置一下.
- 另外注意,powershell中配置的别名不要和scoop的冲突(否则scoop执行过程中可能会报错)

### 国内方案

- [scoopInstaller: scoop国内镜像优化库，能够加速scoop安装及bucket源文件，无需用户设置代理 (gitee.com)](https://gitee.com/glsnames/scoop-installer)

## 重装scoop

- [reference link:重装scoop](https://github.com/neolee/pilot/wiki#%E5%A6%82%E4%BD%95%E9%87%8D%E8%A3%85-scoop)

## 配置scoop config

- 配置文件目录` ~/.config/scoop/config.json`

- 配置命令文档`scoop config`:

  ```bash
  PS C:\Users\cxxu\Desktop> scoop config -h
  Usage: scoop config [rm] name [value]
  
  The scoop configuration file is saved at ~/.config/scoop/config.json.
  
  To get all configuration settings:
  
      scoop config
  
  To get a configuration setting:
  
      scoop config <name>
  
  To set a configuration setting:
  
      scoop config <name> <value>
  
  To remove a configuration setting:
  
       <name>
  
  Settings
  --------
  
  use_external_7zip: $true|$false
        External 7zip (from path) will be used for archives extraction.
  
  use_lessmsi: $true|$false
        Prefer lessmsi utility over native msiexec.
  
  no_junction: $true|$false
        The 'current' version alias will not be used. Shims and shortcuts will point to specific version instead.
  
  scoop_repo: http://github.com/ScoopInstaller/Scoop
        Git repository containining scoop source code.
        This configuration is useful for custom forks.
  
  scoop_branch: master|develop
        Allow to use different branch than master.
        Could be used for testing specific functionalities before released into all users.
        If you want to receive updates earlier to test new functionalities use develop (see: 'https://github.com/ScoopInstaller/Scoop/issues/2939')
  
  proxy: [username:password@]host:port
        By default, Scoop will use the proxy settings from Internet Options, but with anonymous authentication.
  
        * To use the credentials for the current logged-in user, use 'currentuser' in place of username:password
        * To use the system proxy settings configured in Internet Options, use 'default' in place of host:port
        * An empty or unset value for proxy is equivalent to 'default' (with no username or password)
        * To bypass the system proxy and connect directly, use 'none' (with no username or password)
  
  autostash_on_conflict: $true|$false
        When a conflict is detected during updating, Scoop will auto-stash the uncommitted changes.
        (Default is $false, which will abort the update)
  
  default_architecture: 64bit|32bit|arm64
        Allow to configure preferred architecture for application installation.
        If not specified, architecture is determined by system.
  
  debug: $true|$false
        Additional and detailed output will be shown.
  
  force_update: $true|$false
        Force apps updating to bucket's version.
  
  show_update_log: $true|$false
        Do not show changed commits on 'scoop update'
  
  show_manifest: $true|$false
        Displays the manifest of every app that's about to
        be installed, then asks user if they wish to proceed.
  
  shim: kiennq|scoopcs|71
        Choose scoop shim build.
  
  root_path: $Env:UserProfile\scoop
        Path to Scoop root directory.
  
  global_path: $Env:ProgramData\scoop
        Path to Scoop root directory for global apps.
  
  cache_path:
        For downloads, defaults to 'cache' folder under Scoop root directory.
  
  gh_token:
        GitHub API token used to make authenticated requests.
        This is essential for checkver and similar functions to run without
        incurring rate limits and download from private repositories.
  
  virustotal_api_key:
        API key used for uploading/scanning files using virustotal.
        See: 'https://support.virustotal.com/hc/en-us/articles/115002088769-Please-give-me-an-API-key'
  
  cat_style:
        When set to a non-empty string, Scoop will use 'bat' to display the manifest for
        the `scoop cat` command and while doing manifest review. This requires 'bat' to be
        installed (run `scoop install bat` to install it), otherwise errors will be thrown.
        The accepted values are the same as ones passed to the --style flag of 'bat'.
  
  ignore_running_processes: $true|$false
        When set to $false (default), Scoop would stop its procedure immediately if it detects
        any target app process is running. Procedure here refers to reset/uninstall/update.
        When set to $true, Scoop only displays a warning message and continues procedure.
  
  private_hosts:
        Array of private hosts that need additional authentication.
        For example, if you want to access a private GitHub repository,
        you need to add the host to this list with 'match' and 'headers' strings.
  
  hold_update_until:
        Disable/Hold Scoop self-updates, until the specified date.
        `scoop hold scoop` will set the value to one day later.
        Should be in the format 'YYYY-MM-DD', 'YYYY/MM/DD' or any other forms that accepted by '[System.DateTime]::Parse()'.
        Ref: https://docs.microsoft.com/dotnet/api/system.datetime.parse?view=netframework-4.5#StringToParse
  
  update_nightly: $true|$false
        Nightly version is formatted as 'nightly-yyyyMMdd' and will be updated after one day if this is set to $true.
        Otherwise, nightly version will not be updated unless `--force` is used.
  
  ARIA2 configuration
  -------------------
  
  aria2-enabled: $true|$false
        Aria2c will be used for downloading of artifacts.
  
  aria2-warning-enabled: $true|$false
        Disable Aria2c warning which is shown while downloading.
  
  aria2-retry-wait: 2
        Number of seconds to wait between retries.
        See: 'https://aria2.github.io/manual/en/html/aria2c.html#cmdoption-retry-wait'
  
  aria2-split: 5
        Number of connections used for downlaod.
        See: 'https://aria2.github.io/manual/en/html/aria2c.html#cmdoption-s'
  
  aria2-max-connection-per-server: 5
        The maximum number of connections to one server for each download.
        See: 'https://aria2.github.io/manual/en/html/aria2c.html#cmdoption-x'
  
  aria2-min-split-size: 5M
        Downloaded files will be splitted by this configured size and downloaded using multiple connections.
        See: 'https://aria2.github.io/manual/en/html/aria2c.html#cmdoption-k'
  
  aria2-options:
        Array of additional aria2 options.
        See: 'https://aria2.github.io/manual/en/html/aria2c.html#options'
  ```

  

### 默认代理配置

- 如果您有代理,可以代理资源写入到配置文件,这样每次下载默认使用配置的代理

  - ```bash
    PS C:\Users\cxxu\Desktop> scoop config
    
    last_update        scoop_branch scoop_repo
    -----------        ------------ ----------
    2023/5/26 13:36:35 master       https://gitee.com/glsnames/scoop-installer
    
    PS C:\Users\cxxu\Desktop> scoop config scoop_repo
    https://gitee.com/glsnames/scoop-installer
    PS C:\Users\cxxu\Desktop> scoop config rm scoop_repo
    'scoop_repo' has been removed
    
    #配置举例(根自己的情况修改代理资源)
    PS C:\Users\cxxu\Desktop> scoop config proxy 127.0.0.1:10801
    'proxy' has been set to '127.0.0.1:10801'
    PS C:\Users\cxxu\Desktop> scoop proxy
    WARN  scoop: 'proxy' isn't a scoop command. See 'scoop help'.
    PS C:\Users\cxxu\Desktop> scoop config  proxy
    127.0.0.1:10801
    ```

    

## 使用aria2多路下载

- [ScoopInstaller/Scoop: A command-line installer for Windows. (github.com)](https://github.com/ScoopInstaller/Scoop#multi-connection-downloads-with-aria2)

  - ```bash
    scoop install aria2
    ```

- 以neovim的下载为例,在底层代理(TUN)代理下,平均速度为7MBps左右

  ```bash
  WARN  Scoop uses 'aria2c' for multi-connection downloads.
  WARN  Should it cause issues, run 'scoop config aria2-enabled false' to disable it.
  WARN  To disable this warning, run 'scoop config aria2-warning-enabled false'.
  Installing 'neovim' (0.9.0) [64bit] from main bucket
  direct: https://github.com/neovim/neovim/releases/download/v0.9.0/nvim-win64.zip
  
  Starting download with aria2 ...
  Download: [#c6bfd0 0B/0B CN:1 DL:0B]                                                       Download: Download Results:
  Download: gid   |stat|avg speed  |path/URI
  Download: ======+====+===========+=======================================================
  Download: c6bfd0|OK  |   6.9MiB/s|C:/Users/cxxu/scoop/cache/neovim#0.9.0#https_github.com_neovim_neovim_releases_download_v0.9.0_nvim-win64.zip
  Download: Status Legend:
  Download: (OK):download completed.
  Checking hash of nvim-win64.zip ... ok.
  Extracting nvim-win64.zip ... done.
  Linking ~\scoop\apps\neovim\current => ~\scoop\apps\neovim\0.9.0
  Creating shim for 'nvim'.
  Creating shim for 'nvim-qt'.
  Creating shortcut for Neovim (nvim-qt.exe)
  'neovim' (0.9.0) was installed successfully!
  'neovim' suggests installing 'extras/vcredist2022'.
  PS C:\Users\cxxu\Desktop>
  ```

- 使用aria2下载可能稳定性不如传统下载,scoop对此给出**wanring**

  

