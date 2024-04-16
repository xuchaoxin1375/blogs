[toc]

# python@遍历目录内容的若干方法@[文件@目录]扫描等路径操作

## 目录扫描

### os.list

- [os.list](https://docs.python.org/3/library/os.html#os.listdir)

  - ```python
    import os
    os.listdir()
    ```

    


### os.scandir

- [os.scandir](https://docs.python.org/3/library/os.html#os.scandir)

  - ```python
    for i in os.scandir():
        if not i.name.startswith('.') and i.is_file():
            print(i.name)
    ```

    


### Path.iterdir

- [Path.iterdir()](https://docs.python.org/3/library/pathlib.html#pathlib.Path.iterdir)

  - ```python
    from pathlib import Path
    
    p = Path.cwd()
    for item in p.iterdir():
        print(item.name)
    ```


### os.walk

- [os.walk](https://docs.python.org/3/library/os.html#os.walk)

  - os.**walk**(*top*, *topdown=True*, *onerror=None*, *followlinks=False*)[¶](https://docs.python.org/zh-cn/3/library/os.html#os.walk)

    生成目录树中的文件名，方式是按上->下或下->上顺序浏览目录树。对于以 *top* 为根的目录树中的每个目录（包括 *top* 本身），它都会生成一个三元组 `(dirpath, dirnames, filenames)`。

    - *dirpath* is a string, the path to the directory. 
    - *dirnames* is a list of the names of the subdirectories in *dirpath* (including symlinks to directories, and excluding `'.'` and `'..'`). 
    - *filenames* is a list of the names of the non-directory files in *dirpath*.
    -  Note that the names in the lists contain no path components. 
    - To get a full path (which begins with *top*) to a file or directory in *dirpath*, do `os.path.join(dirpath, name)`. 
    - Whether or not the lists are sorted depends on the file system. If a file is removed from or added to the *dirpath* directory during generating the lists, whether a name for that file be included is unspecified.


#### demos

- ```mermaid
  flowchart LR
  	root_dir_str-->subdirs_list & files_list
  ```
  
  
  
- 

  ```bash
  (d:\condaPythonEnvs\tf210) PS D:\repos\CCSER\emotion-recognition-using-speech\.idea> tree_lsd
   .
  ├──  emotion-recognition-using-speech.iml
  ├──  inspectionProfiles
  │   └──  Project_Default.xml
  ├──  misc.xml
  ├──  modules.xml
  ├──  vcs.xml
  └──  workspace.xml
  ```

- ```bash
  for t in os.walk('../.idea'):
      print(t)
  ```

  - ```bash
    ('../.idea', ['inspectionProfiles'], ['emotion-recognition-using-speech.iml', 'misc.xml', 'modules.xml', 'vcs.xml', 'workspace.xml'])
    ('../.idea\\inspectionProfiles', [], ['Project_Default.xml'])
    ```

    

- ```python
  for t in os.walk(r'D:\repos\CCSER\emotion-recognition-using-speech\.idea'):
      print(t)
  ```

  - ```bash
    ('D:\\repos\\CCSER\\emotion-recognition-using-speech\\.idea', ['inspectionProfiles'], ['emotion-recognition-using-speech.iml', 'misc.xml', 'modules.xml', 'vcs.xml', 'workspace.xml'])
    ('D:\\repos\\CCSER\\emotion-recognition-using-speech\\.idea\\inspectionProfiles', [], ['Project_Default.xml'])
    ```

    

- 

  ```python
  import os
  from os.path import join, getsize
  for root, dirs, files in os.walk('python/Lib/email'):
      print(root, "consumes", end=" ")
      print(sum(getsize(join(root, name)) for name in files), end=" ")
      print("bytes in", len(files), "non-directory files")
      if 'CVS' in dirs:
          dirs.remove('CVS')  # don't visit CVS directories
  ```

  - ```bash
    . consumes 5 bytes in 1 non-directory files
    .\.git consumes 224 bytes in 4 non-directory files
    .\.git\hooks consumes 23442 bytes in 13 non-directory files
    .\.git\info consumes 240 bytes in 1 non-directory files
    .\.git\objects consumes 0 bytes in 0 non-directory files
    .\.git\objects\info consumes 0 bytes in 0 non-directory files
    .\.git\objects\pack consumes 0 bytes in 0 non-directory files
    .\.git\refs consumes 0 bytes in 0 non-directory files
    .\.git\refs\heads consumes 0 bytes in 0 non-directory files
    .\.git\refs\tags consumes 0 bytes in 0 non-directory files
    .\archive consumes 2330 bytes in 4 non-directory files
    .\CASIA_demos consumes 1866 bytes in 1 non-directory files
    .\RAVDESS_demos consumes 2820 bytes in 1 non-directory files
    ```

### glob

- [glob](https://docs.python.org/3/library/glob.html)

  - glob 模块是 Python 标准库中的一个有用的模块，它可以用来返回匹配特定模式的所有文件路径。你可以使用 glob 模块来搜索特定的文件模式，或者更有用的是，使用通配符字符来搜索文件名匹配特定模式的文件。

  - 要使用 glob 模块，首先你需要在你的 Python 脚本中导入它，然后你可以使用 glob 函数来找到匹配特定模式的所有文件。

  - 例如，下面的代码展示了如何使用 glob 函数来找到一个目录中所有以 .txt 结尾的文件：

  - ```python
    import glob
    
    # Find all .txt files in the current directory
    files = glob.glob("*.txt")
    
    # Print the list of files
    print(files)
    ```

  - glob 模块使用 Unix 风格的模式匹配规则和参数，不支持波浪号扩展，但是支持 `*，? []` 表示的字符范围。它通过结合使用 os.scandir() 和 fnmatch.fnmatch() 函数来实现匹配，而不是实际调用子shell。

  - glob 模块还提供了 [iglob](https://docs.python.org/3/library/glob.html#glob.iglob) 函数，它和 glob 函数类似，但是返回一个生成器而不是一个列表。这样可以节省内存和时间，特别是当匹配结果很多时

  - 你可以参考以下链接来了解更多关于 glob 模块的用法和示例：

    - [Python’s Glob Module: A tutorial for filename matching | Towards Data …](https://towardsdatascience.com/the-python-glob-module-47d82f4cbd2d)
    - [glob — Unix style pathname pattern expansion - Python](https://docs.python.org/3/library/glob.html)
    - [Glob in Python Explained | Built In - Medium](https://builtin.com/software-engineering-perspectives/glob-in-python)

### 递归遍历

- [Path.glob(pattern)](https://docs.python.org/3/library/pathlib.html#pathlib.Path.glob)


####  eg.搜索目录下的具有特定扩展名的文件

- ```python
  def get_audios(folder, exts,pattern="*",recursive=False,flatten=True,verbose=1):
      """
      Find files in a folder with specific extensions.
  
      Arguments:
      - folder (pathlib.Path): the folder to search for audio files
      - exts (list of str): the extensions of the audio files to look for
      - pattern (str, optional): the pattern to match for the audio files (default "*")
      - flatten (bool, optional): whether to flatten the sub-lists of audio files (default True)
      - verbose (int, optional): whether and how much to print information about the search (default 1)
  
      Returns:
      - audio_files (list of pathlib.Path): the paths to the audio files found in the folder
      """
      if recursive:
          audio_files=[list(folder.rglob(f"{pattern}{ext}")) for ext in exts]
      else:
          audio_files=[list(folder.glob(f"{pattern}{ext}")) for ext in exts]
      
      if verbose:
          print({ext:len(audios) for audios,ext in zip(audio_files,exts)})
      # audio_files=[audio for audio in category for category in audio_files]
      audio_files_flatten=[]
      if flatten:
          for category in audio_files:
              audio_files_flatten+=category
          audio_files=audio_files_flatten
          # print(f"{len(audio_files_flatten)=}")
      return audio_files
  ```

  

- [fnmatch — Unix filename pattern matching — Python documentation](https://docs.python.org/3/library/fnmatch.html#module-fnmatch)

- [Path.rglob@pathlib — Object-oriented filesystem paths — Python documentation](https://docs.python.org/3/library/pathlib.html#pathlib.Path.rglob)

## 面向对象的路径操作@[文件@目录]

-  [**PEP 428**](https://peps.python.org/pep-0428/): The pathlib module – object-oriented filesystem paths.

### 基础用法

- [basici use](https://docs.python.org/3/library/pathlib.html#basic-use)

- Importing the main class:

  ```python
  >>> from pathlib import Path
  ```

  

- Listing subdirectories:

```python
>>> p = Path('.')
>>> [x for x in p.iterdir() if x.is_dir()]
[PosixPath('.hg'), PosixPath('docs'), PosixPath('dist'),
 PosixPath('__pycache__'), PosixPath('build')]
```

- Listing Python source files in this directory tree:

```python
>>> list(p.glob('**/*.py'))
[PosixPath('test_pathlib.py'), PosixPath('setup.py'),
 PosixPath('pathlib.py'), PosixPath('docs/conf.py'),
 PosixPath('build/lib/pathlib.py')]
```

- Navigating inside a directory tree:

```python
>>> p = Path('/etc')
>>> q = p / 'init.d' / 'reboot'
>>> q
PosixPath('/etc/init.d/reboot')
>>> q.resolve()
PosixPath('/etc/rc.d/init.d/halt')
```

- Querying path properties:

```python
>>> q.exists()
True
>>> q.is_dir()
False
```

- Opening a file:

```python
>>> with q.open() as f: f.readline()
...
'#!/bin/bash\n'
```

### 常用部分

Python的`pathlib`模块提供了一种面向对象的方式来处理文件系统路径和文件。该模块中最常用的部分包括：

1. `Path`类：`pathlib`模块的核心类，用于表示文件系统路径和文件。可以使用`Path`类的实例来访问文件和目录、创建、删除、移动和重命名文件等操作。
2. 路径解析方法：`Path`类提供了一些方法，用于解析路径中的各个部分。例如，可以使用`Path.parts`属性来获取路径中的所有部分，使用`Path.name`属性来获取路径中的文件或目录名称，使用`Path.suffix`属性来获取文件扩展名等。
3. 文件和目录操作：`Path`类提供了一些方法，用于在文件系统中创建、删除、移动和重命名文件和目录。例如，可以使用`Path.mkdir()`方法创建一个新目录，使用`Path.rmdir()`方法删除一个空目录，使用`Path.rename()`方法重命名文件或目录等。
4. 文件读写操作：`Path`类还提供了一些方法，用于读取和写入文件内容。例如，可以使用`Path.read_text()`方法读取文本文件的内容，使用`Path.write_text()`方法写入文本文件的内容，使用`Path.read_bytes()`方法读取二进制文件的内容，使用`Path.write_bytes()`方法写入二进制文件的内容等。
5. 文件过滤和查找：`Path`类提供了一些方法，用于过滤和查找目录中的文件和子目录。例如，可以使用`Path.glob()`方法查找所有匹配指定模式的文件，使用`Path.iterdir()`方法遍历目录中的所有文件和子目录等。

总之，`pathlib`模块提供了一种简单、直观、面向对象的方式来处理文件路径和文件系统操作，使得Python代码可以更加易于阅读、编写和维护。

### 例

以下是一些使用`pathlib`模块的常见示例：

- 创建目录：

- ```python
  from pathlib import Path
  
  # 创建一个名为"my_folder"的目录
  folder = Path("my_folder")
  folder.mkdir()
  ```

- 解析路径为绝对路径@去相对化成分`..`和`.`

- ```python
  from pathlib import Path
  dir1=Path(".")
  dir2=Path('./results/../utils/')
  dir1.resolve(strict=True),dir2.resolve()
  ```

  - ```bash
    (WindowsPath('D:/repos/CCSER/emotion-recognition-using-speech/testers'),
     WindowsPath('D:/repos/CCSER/emotion-recognition-using-speech/testers/utils'))
    ```

    

- 列出目录中的所有文件：

- ```python
  from pathlib import Path
  
  # 列出当前目录中的所有文件
  for file in Path(".").iterdir():
      if file.is_file():
          print(file)
  ```

- 读取文本文件的内容：

- ```python
  from pathlib import Path
  
  # 读取名为"my_file.txt"的文本文件的内容
  file = Path("my_file.txt")
  content = file.read_text()
  print(content)
  ```

- 写入文本文件的内容：

- ```python
  from pathlib import Path
  
  # 写入名为"my_file.txt"的文本文件的内容
  file = Path("my_file.txt")
  file.write_text("Hello, World!")
  ```

- 查找所有匹配指定模式的文件：

- ```python
  from pathlib import Path
  
  # 查找当前目录及其子目录中所有扩展名为".txt"的文件
  for file in Path(".").glob("**/*.txt"):
      print(file)
  ```

- 总之，`pathlib`模块提供了一种简单、直观、面向对象的方式来处理文件路径和文件系统操作，使得Python代码可以更加易于阅读、编写和维护。上述示例只是其中的一部分，更多的示例可以参考Python官方文档。

## 小结

- os.listdir() 是最简单的方法，但是也是最低效的方法，因为它只返回文件名，不包含任何其他信息。如果你需要获取文件的类型或属性，你需要额外调用 os.stat() 函数，这会增加开销和时间。
- os.scandir() 是一个改进的方法，它返回一个生成器，它产生 DirEntry 对象，这些对象包含了文件名，类型和属性信息。这样就可以避免对每个文件调用 os.stat() 函数，从而提高性能和速度。os.scandir() 还可以检测符号链接，隐藏文件等。
- pathlib 模块是一个面向对象的方法，它提供了 Path 类和相关的方法，可以方便地进行路径操作和转换。Path.iterdir() 是其中一个方法，它返回一个生成器，它产生 Path 对象，这些对象也包含了文件名，类型和属性信息。Path.iterdir() 的优点是它支持面向对象的编程风格，可以方便地进行路径操作和转换。
- os.walk() 是一个递归的方法，它返回一个生成器，它产生三元组 (root, dirs, files)，其中 root 是当前遍历的目录，dirs 是 root 中的子目录列表，files 是 root 中的文件列表。这个方法可以递归地遍历整个目录树，并且可以自定义遍历顺序和策略。
- glob 模块是一个匹配的方法，它提供了 glob() 函数，它可以根据指定的通配符模式匹配文件名，并返回一个包含匹配结果的列表。这个方法可以方便地筛选出特定类型或格式的文件，并且支持多层级的匹配。

- 总之，os.scandir() 和 Path.iterdir() 都比 os.listdir() 更高效和功能强大，但是具体选择哪一个取决于你的编程习惯和需求。os.walk() 和 glob 模块则提供了更灵活和强大的遍历和匹配功能。



