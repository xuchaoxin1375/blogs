[toc]

## abstract

- 不会列出空目录

这不是文件坏了，是 Git 默认把非 ASCII 路径转成八进制转义。所以你会看到：

  "nginx_conf/nginx@\345\215\225...md"

  实际文件名是：

  nginx_conf/nginx@单服务器多IP为分配给多个管理员反代方案.md

  关掉转义后就能正常显示中文：

  git config --global core.quotepath false

  只改这个仓库：

  git config core.quotepath false

  临时看一次：

  git -c core.quotepath=false status