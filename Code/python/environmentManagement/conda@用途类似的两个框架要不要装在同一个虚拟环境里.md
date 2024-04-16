[toc]

## ref

- [python - Can packages be shared across Anaconda environments? - Stack Overflow](https://stackoverflow.com/questions/50395044/can-packages-be-shared-across-anaconda-environments)
- [Managing environments — conda 23.1.0.post70+d88a8041e documentation](https://conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html)

## package复用(指定同版本)

- 假设您创建了两个虚拟环境A,B
- 它们分别需要安装numpy
  - 如果你希望A,B中的numpy版本一样,那么实际上只需要安装一遍
    - 比如说,A中安装完毕后,B中执行同样的安装命令,那么只需要创建硬链接,而不需要重新下载一遍同版本的numpy
  - 但是如果你希望A,B中安装的numpy版本不一样,那么就需要各自安装一遍
- 基于上述考虑,对于两个大型框架,如果它们功能相近的话,不建议安装在同一个虚拟环境中
  - 这样会使得单个环境变得不灵活(例如pycharm扫描构建或执行`updating skeleton`就会相当耗时)

### conda install 比pip install 更可能节省空间

- **Use conda environments for isolation**
  - Create a conda environment to isolate any changes pip makes.
  - Environments take up little space thanks to hard links.
  - Care should be taken to avoid running pip in the root environment.

- 值得注意的是,对于windows,硬链接是无法跨分区创建的
  - 这意味着,如果您的环境不总是创建同一个分区(比如都在C盘,或都在D盘,那么硬链接的效果就会受到影响!)
  - 不过一般用户不会去跨分区创建虚拟环境,所以一般来讲,使用conda install 是比较好的安装包的方式
  - 遗憾的是,有时候conda install找不到我们要的包,这时我们只好借助于pip install

### pytorch和tensorflow装在同一个环境里?

- 就比如`tensorflow`和`pytorch`不建议共用一个环境
  - 之前图省事,想着可以共用numpy,matplot这类的库,安装在了一起,pycharm扫描了老半天
  - 分开安装的话,也就是导出@导入依赖的事,更灵活些

### 导入依赖@导入依赖

- `pip freeze>requirements.txt`

- `pip install -r requirements.txt`

### 试验

- ```cmd
  (d:\condaPythonEnvs\test_new) PS C:\Users\cxxu\Desktop> conda install numpy
  Collecting package metadata (current_repodata.json): done
  Solving environment: done
  
  ## Package Plan ##
  
    environment location: d:\condaPythonEnvs\test_new
  
    added / updated specs:
      - numpy
  
  
  The following packages will be downloaded:
  
      package                    |            build
      ---------------------------|-----------------
      pip-23.0.1                 |  py310haa95532_0         2.8 MB  defaults
      python-3.10.9              |       h966fe2a_1        15.8 MB  defaults
      wheel-0.38.4               |  py310haa95532_0          83 KB  defaults
      ------------------------------------------------------------
                                             Total:        18.7 MB
  
  The following NEW packages will be INSTALLED:
  
    blas               anaconda/pkgs/main/win-64::blas-1.0-mkl
    bzip2              anaconda/pkgs/main/win-64::bzip2-1.0.8-he774522_0
    ca-certificates    anaconda/pkgs/main/win-64::ca-certificates-2023.01.10-haa95532_0
    certifi            anaconda/pkgs/main/win-64::certifi-2022.12.7-py310haa95532_0
    ...
    numpy              anaconda/pkgs/main/win-64::numpy-1.23.5-py310h60c9a35_0
    numpy-base         anaconda/pkgs/main/win-64::numpy-base-1.23.5-py310h04254f7_0
    openssl            anaconda/pkgs/main/win-64::openssl-1.1.1t-h2bbff1b_0
    pip                anaconda/pkgs/main/win-64::pip-23.0.1-py310haa95532_0
    python             anaconda/pkgs/main/win-64::python-3.10.9-h966fe2a_1
    ...
  ```

- `test_new`环境是我新建立虚拟环境(创建的时候没有指定任何包)

  - ```bash
    (d:\condaPythonEnvs\test_new) PS C:\Users\cxxu\Desktop> conda list
    # packages in environment at d:\condaPythonEnvs\test_new:
    #
    # Name                    Version                   Build  Channel
    (d:\condaPythonEnvs\test_new) PS C:\Users\cxxu\Desktop>
    ```

- 由于其他环境中已经安装了numpy(而且是都最新版),所以此时为这个全新的环境安装numpy(不指定版本时,就会从本地的文件导入)

- 至于其他三个包,在没有指明版本时,由于出现了比当前所有其他环境都要新的版本,因此会尝试下载最新版本:

  - ```bash
        package                    |            build
        ---------------------------|-----------------
        pip-23.0.1                 |  py310haa95532_0         2.8 MB  defaults
        python-3.10.9              |       h966fe2a_1        15.8 MB  defaults
        wheel-0.38.4               |  py310haa95532_0          83 KB  defaults
        ------------------------------------------------------------
                                               Total:        18.7 MB
    ```

  - ```bash
    (d:\condaPythonEnvs\pyside6) PS C:\Users\cxxu\Desktop> conda search pip|select -Last 3
    pip                           23.0.1 py310haa95532_0  anaconda/pkgs/main
    pip                           23.0.1  py38haa95532_0  anaconda/pkgs/main
    pip                           23.0.1  py39haa95532_0  anaconda/pkgs/main
    ```

    

  - 其他环境的`pip`版本

    - ```bash
      (d:\condaPythonEnvs\pytorch_CCSER) PS C:\Users\cxxu\Desktop> conda list |sls pip
      
      pip                       22.3.1          py310haa95532_0    defaults
      pip-search                0.0.12                   pypi_0    pypi
      ```

  

