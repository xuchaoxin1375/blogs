[toc]

## 准备

- 在windows环境下操作,可能要代理改善下载体验

### refs

- [一键部署Google开源大模型Gemma本地大模型部署](https://www.bilibili.com/video/BV16v421r7rp/?spm_id_from=333.880.my_history.page.click)

### ollama

- [GitHub - ollama/ollama: Get up and running with Llama 2, Mistral, Gemma, and other large language models.](https://github.com/ollama/ollama)
- 安装ollama[Ollama](https://ollama.com/)
  - 可以安装许多开源大模型,例如llama2等
- 使用ollama可以一键安装的大模型列表:[library (ollama.com)](https://ollama.com/library)
  - 例如:[gemma (ollama.com)](https://ollama.com/library/gemma)

### 安装过程

- 安装完ollama,检查是否正确安装:

  - ```bash
    PS BAT [10:21:12 AM] [C:\Users\cxxu\Desktop]
    [🔋 100%] MEM:73.71% [5.79/7.85] GB |ollama --version
    ollama version is 0.1.27
    ```

    

- 开始安装模型(这里使用的电脑没有GUP太low,所以选择用cpu就可以运行的2b模型(20亿参数),对内存要求也不高,我这里只有约8GB内存)

  ```bash
  
  PS BAT [10:21:17 AM] [C:\Users\cxxu\Desktop]
  [🔋 100%] MEM:71.47% [5.61/7.85] GB |ollama run gemma:2b
  pulling manifest
  pulling c1864a5eb193...   1% ▕                                                        ▏  14 MB/1.7 GB  1.5 MB/s   18m1s
  
  PS BAT [10:28:04 AM] [C:\Users\cxxu\Desktop]
  [🔋 100%] MEM:48.33% [3.79/7.85] GB |ollama run gemma:2b
  pulling manifest
  pulling c1864a5eb193... 100% ▕████████████████████████████████████████████████████████▏ 1.7 GB
  pulling 097a36493f71... 100% ▕████████████████████████████████████████████████████████▏ 8.4 KB
  pulling 109037bec39c... 100% ▕████████████████████████████████████████████████████████▏  136 B
  pulling 22a838ceb7fb... 100% ▕████████████████████████████████████████████████████████▏   84 B
  pulling 887433b89a90... 100% ▕████████████████████████████████████████████████████████▏  483 B
  verifying sha256 digest
  writing manifest
  removing any unused layers
  success
  
  
  
  ```

  - 模型下载:我这里国内网络下载的挺快的,但是后面5%很慢,不知道为什么(有的可能会遇到下载不下来的情况,考虑切换网络环境或时间段重试,或者需要全局代理(you know))

- 简单聊两句

  - ```bash
    >>> hello!
    Hello! 👋  It's nice to hear from you. How can I help you today? 😊
    
    >>> introduce yourself please😁
    Hey there! It's great to meet you as well! I'm a language AI, and I'm here to assist you with any questions or
    tasks you may have. How can I help you today?
    >>> how do you think about google
    Google is an American multinational technology company that specializes in search engines, software, and other
    services. They are one of the most valuable companies in the world, and their search engine is the most widely
    used in the world.
    
    What do you think about Google? Is it a good company to work for? What are your thoughts on their products and
    services?
    
    >>> replay it in Chinese anagin!
    谷歌是美國著名的科技公司，致力於搜尋引擎、軟體和其他服務。他們是世界上最具價值的公司之一，他們的搜尋引擎是世界最使用的之一。
    
    你對谷歌有什麼看法？谷歌是一個好的公司嗎？你對他們的產品和服務有什麼看法？
    ```

### 2b模型的效果小结👺

- 2b模型不给力,至少中文方面是这样的,不知道7b的如何

- ```bash
  >>> 鲁迅和周树人的关系?
  鲁迅和周树人之间存在着深厚的友情和敬意之情。鲁迅是周树人 的好友和老师，两人在文学创作、政治活动和社会发展鲁迅和周 树人之间存在着深厚的友情和敬意之情。鲁迅是周树人的好友和 老师，两人在文学创作、政治活动和社会发展方面有着深远的影 响力。
  
  **鲁迅对周树人的影响:**
  
  * 鲁迅是周树人的文学老师，他对周树人的写作技巧和精神追求 给予了指导。
  
  ```
  
- 让它写一段快速排序也是错误的

  

## ollama的进一步使用

### 帮助文档

- ```bash
  PS>ollama --help
  Large language model runner
  
  Usage:
    ollama [flags]
    ollama [command]
  
  Available Commands:
    serve       Start ollama
    create      Create a model from a Modelfile
    show        Show information for a model
    run         Run a model
    pull        Pull a model from a registry
    push        Push a model to a registry
    list        List models
    cp          Copy a model
    rm          Remove a model
    help        Help about any command
  
  Flags:
    -h, --help      help for ollama
    -v, --version   Show version information
  
  Use "ollama [command] --help" for more information about a command.
  ```

### 查看ollama安装了哪些模型

- ```bash
  PS>ollama list
  NAME            ID              SIZE    MODIFIED
  gemma:2b        b50d6c999e59    1.7 GB  17 minutes ago
  ```

### 使用皮肤来使聊天更易用

- [Community Integrations](https://github.com/ollama/ollama?tab=readme-ov-file#community-integrations)

- [web&desktop](https://github.com/ollama/ollama?tab=readme-ov-file#web--desktop)
  - 例如[GitHub - ivanfioravanti/chatbot-ollama: Chatbot Ollama is an open source chat UI for Ollama.](https://github.com/ivanfioravanti/chatbot-ollama)

## 使用Chatbot UI皮肤

- 这里以chatbot为例

### 安装docker👺

- 使用docker方案安装UI:
  - 个人感觉docker desktop做的不是很完善
  - 下载最新版[Docker Desktop release notes | Docker Docs](https://docs.docker.com/desktop/release-notes/)
  - (主下载页面下载下来的反而不一定是最新版)[Docker Desktop: The #1 Containerization Tool for Developers | Docker](https://www.docker.com/products/docker-desktop/)

- 安装dockerd的过程启动安装界面比较慢,耐心等待,不要重复点击
  - docker版本更新:如果要安装新版的docker,直接安装可能会被阻止(旧版本的进程可能不容易杀死)
  - 建议更新前注销当前账户(登出windows),或者重启后安装
- 安装或更新完毕,会要求重启电脑(对于初次安装使用者,先不要重启,看下一节)

### 启动docker

- 如果安装时勾选了wsl2代替hyperv,那么重启电脑前执行`wsl --update`
- 即重启前请执行`wsl --update`,否则即便重启后也可能无法启动docker
- 执行完上述命令后重启
- 然后以管理员权限运行docker,通常来讲就可成功启动docker

### 载入和退出docker

- 进入docker和退出docker都挺耗时的,需要耐心一些(但是一般也不会超过2分钟,否则就可能是出问题了),毕竟是虚拟机操作

- ![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/a1b03933495146f88a7ffe29ca9b1a89.png)

### chatbot 网页版皮肤

- 国内直接安装是不容易下载下来(很慢),用代理的话可以快点,打断后需要重新下载一遍

  ```bash
  PS BAT [12:05:45 PM] [C:\Users\cxxu\Desktop]
  [🔋 100%] MEM:73.05% [5.73/7.85] GB |docker run -p 3000:3000 ghcr.io/ivanfioravanti/chatbot-ollama:main
  Unable to find image 'ghcr.io/ivanfioravanti/chatbot-ollama:main' locally
  main: Pulling from ivanfioravanti/chatbot-ollama
  4abcf2066143: Pull complete
  2f6d6b553e5a: Pull complete
  c6a5f30c1979: Pull complete
  0fff72987922: Pull complete
  eb03cd48595f: Pull complete
  80fa45e7c128: Pull complete
  f3a6b16fbbb9: Pull complete
  ba832799bc4f: Pull complete
  23fd0e505f52: Pull complete
  45892a5fb863: Pull complete
  e5e1e83df1a2: Pull complete
  Digest: sha256:a6bebee38b0359f092eca6cd6bf6cf49e36b9b0e4e28c8376e27d61c96a81e63
  Status: Downloaded newer image for ghcr.io/ivanfioravanti/chatbot-ollama:main
  
  > chatbot-ollama@0.1.0 start
  > next start
  
     ▲ Next.js 14.1.0
     - Local:        http://localhost:3000
  
   ✓ Ready in 1610ms
  ```

- 可能遇到的报错

  - ```bash
    PS BAT [12:05:27 PM] [C:\Users\cxxu\Desktop]
    [🔋 100%] MEM:72.28% [5.67/7.85] GB |docker run -p 3000:3000 ghcr.io/ivanfioravanti/chatbot-ollama:main
    
    Unable to find image 'ghcr.io/ivanfioravanti/chatbot-ollama:main' locally
    docker: Error response from daemon: Head "https://ghcr.io/v2/ivanfioravanti/chatbot-ollama/manifests/main": net/http: TLS handshake timeout.
    See 'docker run --help'.
    ```

  - 重试一两次即可,如果仍然不成功,可能是docker没安装好或网络不行

## 使用命令行聊天

- 比起使用皮肤聊天,命令行方式少占用点资源,会输出顺畅一些

- 使用cmd可能要比powershell好点(特别是powershell安装了皮肤,容易导致显示问题)

- 使用`ollama run gemma:2b`启动模型,需要若干秒的时间(2b模型太拉了,别较真)

- ```bash
  PS>ollama run gemma:2b
  >>> 陆地上哪种生物跑 得最快
  陆地上最大的速度是**松鼠**跑得最快，可以达到**90公里每小时**。
  
  >>> what's the fastest fish in the sea?
  最快的鱼是**热带鱼**，可以达到**60公里每小时**。
  
  >>> the area of China
  中国是世界上拥有最大生物多样性的国家，也是世界上速度最大生物的产地。
  
  **松鼠**是世界上速度最快的动物，可以达到**90公里每小时**。
  **热带鱼**是世界上速度第二快的鱼，可以达到**60公里每小时**。
  ```

  

## 小结👺

- 低配电脑还是不要本地大模型了,配置不够,对话体验相当差(慢且乱),还是老老实实用在线大模型吧
- 很离谱,下面的对话🤣

- ![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/033859c5912040a69940b0340e44ac66.png)

