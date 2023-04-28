

## pydub 报错@找不到文件

- pydub是音频处理的库

  - [jiaaro/pydub: Manipulate audio with a simple and easy high level interface (github.com)](https://github.com/jiaaro/pydub)
  - 但其本身依赖于其他软件:[getting-ffmpeg-set-up](https://github.com/jiaaro/pydub#getting-ffmpeg-set-up)
    - 这一点文档顺序做的不太好,应该放在更加醒目的位置

  - [python - Pydub (WindowsError: Error 2 The system can not find the file specified) - Stack Overflow](https://stackoverflow.com/questions/22284461/pydub-windowserror-error-2-the-system-can-not-find-the-file-specified)

- pydub 库需要安装 ffmpeg 或 avconv 依赖库来实现音频格式转换和处理。

  - 如果您使用的是 Windows 系统，可以从 https://www.gyan.dev/ffmpeg/builds/ 下载预编译好的 ffmpeg 库，并将其添加到<u>系统环境变量Path</u>中，以便 pydub 库正常工作。

- 大概率是因为缺少依赖的软件:

  - windows用户,如果安装了scoop,那么可以执行命令安装` scoop install ffmpeg`
  - 这种方法不需要手动添加到Path变量中
  - 其他平台和安装方式参考官网:[Download FFmpeg](http://www.ffmpeg.org/download.html)

- 例:将ogg转为wav

  - ```python
    import librosa
    from pydub import AudioSegment
    # 读入音频文件(假设文件在当前目录,若使用绝对路径,注意转义问题(使用r'string'是放便的))
    file1="demo1.ogg"
    audio_file = AudioSegment.from_ogg(file1)
    # 将音频转换为 wav 格式
    wav_file = 'audio_file_out.wav'
    audio_file.export(wav_file, format='wav')
    # 计算音频时长
    y, sr = librosa.load(wav_file)
    duration = librosa.get_duration(y=y, sr=sr)
    print(duration)
    ```

  

