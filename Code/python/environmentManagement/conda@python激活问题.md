[toc]

- Warning:
  This Python interpreter is in a conda environment, but the environment has
  not been activated. 

- 这种警告通常是新建的环境缺少python

  - 通过`conda list python`来检查python版本(如果结果为空,则说明缺少python)
  - 用`conda install python=xxx`安装一个python,就可以取消掉`warning`

- ```bash
  PS C:\Users\cxxu\Desktop> python
  Python 3.9.5 (default, May 18 2021, 14:42:02) [MSC v.1916 64 bit (AMD64)] :: Anaconda, Inc. on win32
  
  Warning:
  This Python interpreter is in a conda environment, but the environment has
  not been activated.  Libraries may fail to load.  To activate this environment
  please see https://conda.io/activation
  
  Type "help", "copyright", "credits" or "license" for more information.
  ```

  