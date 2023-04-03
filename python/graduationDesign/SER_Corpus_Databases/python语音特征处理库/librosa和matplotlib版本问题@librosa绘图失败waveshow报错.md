[toc]

## librosa和matplotlib版本问题@librosa绘图失败waveshow报错

- 错误说明:试验版本:

  - librosa 0.10.0版本和matplot3.6.x

  - 一下错误来自于jupyter notebook中运行过程中发生的

  - ```bash
    ---------------------------------------------------------------------------
    AttributeError                            Traceback (most recent call last)
    File d:\condaPythonEnvs\pytorch_CCSER\lib\site-packages\matplotlib_inline\backend_inline.py:99, in show(close, block)
         96 # only call close('all') if any to close
         97 # close triggers gc.collect, which can be slow
         98 if close and Gcf.get_all_fig_managers():
    ---> 99     matplotlib.pyplot.close('all')
    
    File d:\condaPythonEnvs\pytorch_CCSER\lib\site-packages\matplotlib\_api\__init__.py:224, in caching_module_getattr..__getattr__(name)
        222 if name in props:
        223     return props[name].__get__(instance)
    --> 224 raise AttributeError(
        225     f"module {cls.__module__!r} has no attribute {name!r}")
    
    AttributeError: module 'matplotlib' has no attribute 'pyplot'
    ```

    

- 我当前使用的版本配套

  - ```cmd
    (d:\condaPythonEnvs\pytorch_CCSER) PS D:\repos\CCSER\ser_MLP> pip list |sls "librosa|matplot"
    
    librosa                      0.9.2
    matplotlib                   3.7.0
    ...
    ```

    

  - 经过试验,上述版本目前可以良好配合工作

    - ```python
      ##
      import librosa
      import librosa.display
      import matplotlib.pyplot as plt
      
      import os
      import os.path
      ##
      #假设您将librosa官方的examples仓库克隆到系统/用户环境变量`librosa_data_dir`中
      os.getcwd()
      os.chdir(os.environ['librosa_data_dir'])
      #为例方边引用音频文件,我直接定位到audio目录,然后利用os.chdir()切换工作目录,这样可以直接引用文件名来访问文件(而不是输入绝对路径)
      #不过如果只是为例简单测试,您还可以将音频文件直接放置到当前脚本文件同一个目录下,就不用设置工作目录了
      os.getcwd()
      ##
      
      # Load an audio file
      file1 = "sorohanro_-_solo-trumpet-06.ogg"
      y, sr = librosa.load(file1)
      
      # Plot the waveform
      plt.figure()
      librosa.display.waveshow(y, sr=sr)
      plt.title("Waveform of {0}".format(file1))
      plt.xlabel("Time (s)")
      plt.ylabel("Amplitude")
      plt.show()
      
      ```

- 可能的原因

  - librosa 0.10.存在bug
  - matplotlib 3.6.存在bug
  - 上述两个版本本身没问题,但是不兼容

- 我考虑将`librosa`降到`0.9.2`,同时重新安装了matplotlib(此时已经更新到了`3.7.`),在绘制波形图时已经不报错







