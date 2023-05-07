[toc]

# python对象导出@sklearn对象导出@pickle@joblib@序列化和反序列化@joblib导入失败问题.md

## pickle

- [pickle --- Python 对象序列化 — Python 文档](https://docs.python.org/zh-cn/3/library/pickle.html)

- Pickle是Python中的一个模块，用于将Python中的对象序列化为二进制流并保存到文件中，或者从文件中读取出这些二进制数据并反序列化成对象。这个过程也被称为对象的持久化。

  Pickle可以处理几乎所有Python数据类型，包括数字、字符串、列表、元组、字典、类和函数等。使用Pickle可以非常方便地将Python对象存储到文件中，以便于在以后的时间中使用。

  在使用Pickle时，通常需要先将Python对象序列化为二进制数据并写入文件中，可以使用`pickle.dump()`函数完成这个任务。读取文件中的数据并将其反序列化成Python对象，可以使用`pickle.load()`函数。

  需要注意的是，Pickle可以处理Python中的大多数对象，但并不是所有对象都可以被序列化。例如，Pickle不能序列化一些网络连接、文件句柄和进程等系统资源，也不能序列化一些Python内部对象，如函数、模块和类等。此外，在使用Pickle时，需要注意安全问题，避免不受信任的数据对系统造成风险。

  以下是一个使用Pickle存储和读取Python对象的示例代码：

  ```python
  import pickle
  
  # 定义一个 Python 对象
  data = {'a': [1, 2.0, 3, 4+6j],
          'b': ("string", u"Unicode string"),
          'c': {None, True, False}}
  
  # 将对象序列化为二进制数据并写入文件
  with open('data.pkl', 'wb') as f:
      pickle.dump(data, f)
  
  # 从文件中读取数据并反序列化成 Python 对象
  with open('data.pkl', 'rb') as f:
      data_loaded = pickle.load(f)
  
  # 打印反序列化后的 Python 对象
  print(data_loaded)
  ```

  这个示例代码中，首先定义了一个Python对象`data`，其中包含了数字、字符串、列表和字典等数据类型。然后，使用Pickle将`data`对象序列化为二进制数据并写入到文件`data.pkl`中。最后，再从`data.pkl`文件中读取数据并反序列化成Python对象`data_loaded`，并打印该对象以验证反序列化操作的正确性。

- ```bash
  [(SVC(C=10, gamma=0.001),
    {'C': 10, 'gamma': 0.001, 'kernel': 'rbf'},
    0.9381835473133618),
   (RandomForestClassifier(max_depth=7, max_features=0.5, n_estimators=40),
    {'max_depth': 7,
     'max_features': 0.5,
     'min_samples_leaf': 1,
     'min_samples_split': 2,
     'n_estimators': 40},
    0.8854018069424631),
   (GradientBoostingClassifier(learning_rate=0.3, max_depth=7, subsample=0.7),
    {'learning_rate': 0.3,
     'max_depth': 7,
     'max_features': None,
     'min_samples_leaf': 1,
     'min_samples_split': 2,
     'n_estimators': 100,
     'subsample': 0.7},
    0.9476937708036139),
   (KNeighborsClassifier(n_neighbors=3, p=1, weights='distance'),
    {'n_neighbors': 3, 'p': 1, 'weights': 'distance'},
    0.9320019020446981),
   (MLPClassifier(alpha=0.01, batch_size=512, hidden_layer_sizes=(300,),
                  learning_rate='adaptive', max_iter=400),
    {'alpha': 0.01,
     'batch_size': 512,
     'hidden_layer_sizes': (300,),
     'learning_rate': 'adaptive',
     'max_iter': 400},
    0.9358059914407989),
   (BaggingClassifier(max_features=0.5, n_estimators=50),
    {'max_features': 0.5, 'max_samples': 1.0, 'n_estimators': 50},
    0.9210651450309082)]
  ```

  

### 相关api

- [`pickle`](https://docs.python.org/zh-cn/3/library/pickle.html#module-pickle) 模块提供了以下方法，让封存过程更加方便：

- pickle.**dump**(*obj*, *file*, *protocol=None*, ***, *fix_imports=True*, *buffer_callback=None*)

  将对象 *obj* 封存以后的对象写入已打开的 [file object](https://docs.python.org/zh-cn/3/glossary.html#term-file-object) *file*。它等同于 `Pickler(file, protocol).dump(obj)`。参数 *file*、*protocol*、*fix_imports* 和 *buffer_callback* 的含义与它们在 [`Pickler`](https://docs.python.org/zh-cn/3/library/pickle.html#pickle.Pickler) 的构造函数中的含义相同。*在 3.8 版更改:* 加入了 *buffer_callback* 参数。

- pickle.**dumps**(*obj*, *protocol=None*, ***, *fix_imports=True*, *buffer_callback=None*)

  将 *obj* 封存以后的对象作为 [`bytes`](https://docs.python.org/zh-cn/3/library/stdtypes.html#bytes) 类型直接返回，而不是将其写入到文件。参数 *protocol*、*fix_imports* 和 *buffer_callback* 的含义与它们在 [`Pickler`](https://docs.python.org/zh-cn/3/library/pickle.html#pickle.Pickler) 的构造函数中的含义相同。*在 3.8 版更改:* 加入了 *buffer_callback* 参数。

- pickle.**load**(*file*, ***, *fix_imports=True*, *encoding='ASCII'*, *errors='strict'*, *buffers=None*)

  从已打开的 [file object](https://docs.python.org/zh-cn/3/glossary.html#term-file-object) *文件* 中读取封存后的对象，重建其中特定对象的层次结构并返回。它相当于 `Unpickler(file).load()`。Pickle 协议版本是自动检测出来的，所以不需要参数来指定协议。封存对象以外的其他字节将被忽略。参数 *file*、*fix_imports*、*encoding*、*errors*、*strict* 和 *buffers* 的含义与它们在 [`Unpickler`](https://docs.python.org/zh-cn/3/library/pickle.html#pickle.Unpickler) 的构造函数中的含义相同。*在 3.8 版更改:* 加入了 *buffers* 参数。

  - `file` 参数是一个打开的文件对象或类似对象，用于读取二进制数据。在 Python 中，文件对象可以通过内置的 `open()` 函数创建。`open()` 函数接受文件名和文件打开模式作为参数，并返回一个文件对象。在使用 `pickle.load()` 函数时，需要将打开的文件对象作为参数传递给该函数，以便从文件中读取序列化的二进制数据并将其反序列化为 Python 对象。

- pickle.**loads**(*data*, */*, ***, *fix_imports=True*, *encoding='ASCII'*, *errors='strict'*, *buffers=None*)

  重建并返回一个对象的封存表示形式 *data* 的对象层级结构。 *data* 必须为 [bytes-like object](https://docs.python.org/zh-cn/3/glossary.html#term-bytes-like-object)。Pickle 协议版本是自动检测出来的，所以不需要参数来指定协议。封存对象以外的其他字节将被忽略。参数 *fix_imports*, *encoding*, *errors*, *strict* 和 *buffers* 的含义与在 [`Unpickler`](https://docs.python.org/zh-cn/3/library/pickle.html#pickle.Unpickler) 构造器中的含义相同。*在 3.8 版更改:* 加入了 *buffers* 参数。

### 基本用法

- ```python
  import pickle
  
  # 定义一个Python对象
  data = {'name': 'Alice', 'age': 25, 'city': 'New York'}
  
  # 将对象序列化并保存到磁盘
  with open('data.pkl', 'wb') as f:
      pickle.dump(data, f, protocol=pickle.HIGHEST_PROTOCOL)
  
  # 从磁盘中加载序列化的数据并反序列化为Python对象
  with open('data.pkl', 'rb') as f:
      deserialized_data = pickle.load(f)
  
  # 打印反序列化后的对象
  print(deserialized_data)
  ```

  

### 包装函数

- 编写一组可以直接通过指定文件名完成导入导出pickle文件的函数

- ```python
  def load_pickle_by_name(pickle_file):
      with open(pickle_file, 'rb') as f:
          bclf=pkl.load(f)
      return bclf
  
  def dump_pickle_by_name(bclf_objs,pickle_file,tag_time=True):
      # pkl = "bclf.pkl"
      name_fields=pickle_file.split(".")[:-1]
      name="".join(name_fields)
      if tag_time:
          name+=f"@{now_utc_field_str}"
      name+=".pickle"
      with open(name,"wb") as f:
          pkl.dump(bclf_objs,f)
  ```

  

## joblib

- [Joblib: running Python functions as pipeline jobs — joblib .dev0 documentation](https://joblib.readthedocs.io/en/latest/)

- joblib的使用比pickle更加简单:

  - ```python
    from joblib import load,dump
    ```

  - 就可以直接用`load(FileName)`和`dump(FileName)`做对象的导入导出工作

### 基本用法

- ```python
  from joblib import dump, load
  
  # 定义一个Python对象
  data = {'name': 'Alice', 'age': 25, 'city': 'New York'}
  
  # 将对象序列化并保存到磁盘
  dump(data, 'data.joblib')
  
  # 从磁盘中加载序列化的数据并反序列化为Python对象
  deserialized_data = load('data.joblib')
  
  # 打印反序列化后的对象
  print(deserialized_data)
  ```

  

## 小结

- Pickle和Joblib都是Python中用于序列化（将Python对象转换为字节流）和反序列化（将字节流转换回Python对象）的库，它们的主要区别在于以下几个方面：
  1. 序列化速度：Joblib通常比Pickle更快，因为它使用了一些优化技巧，比如将对象缓存到内存中，以便下次序列化时可以更快地访问。
  2. 内存使用：Pickle通常比Joblib使用更少的内存，因为它不需要将整个对象都加载到内存中，而是可以按需读取对象的各个部分。Joblib则会在序列化过程中将整个对象都加载到内存中。
  3. 处理大型数据：对于大型数据，Joblib通常更适合，因为它可以将数据分成多个块并将它们并行处理，从而提高效率。而Pickle在处理大型数据时可能会遇到内存限制或性能瓶颈的问题。
  4. 兼容性：Pickle是Python的标准库，因此它可以与所有Python对象兼容，并且在Python中使用非常方便。而Joblib则需要安装，且在某些情况下可能无法序列化某些Python对象。
- 总之，如果你需要快速序列化小型数据并且想要使用标准库，那么Pickle是一个不错的选择。但是，如果你需要处理大型数据或想要更快的序列化速度，那么Joblib可能更适合。

## npy文件

- npy 文件是 NumPy 的二进制文件格式，用于存储 NumPy 数组对象。它是一种高效的数据存储格式，可以快速地将大型数组保存到硬盘，并在需要时快速地读取和加载数据。

  npy 文件保存的是二进制数据，因此它的存储效率比文本文件高，同时也具有更快的读写速度。与其他二进制格式相比，npy 文件具有更好的可移植性，因为它只依赖于 NumPy 库，而不依赖于特定的操作系统或硬件平台。

  可以使用 NumPy 库中的 save 和 load 函数来保存和加载 npy 文件。例如，以下代码演示了如何将一个 NumPy 数组保存为 npy 文件，并读取该文件：

  ```python
  import numpy as np
  
  # 创建 NumPy 数组
  arr = np.array([1, 2, 3, 4, 5])
  
  # 保存为 npy 文件
  np.save('my_array.npy', arr)
  
  # 从 npy 文件中加载数据
  loaded_arr = np.load('my_array.npy')
  
  # 打印加载后的数据
  print(loaded_arr)  # [1 2 3 4 5]
  ```

  在上面的代码中，我们首先创建一个 NumPy 数组 `arr`，然后使用 `np.save` 函数将其保存到名为 `'my_array.npy'` 的文件中。接着，我们使用 `np.load` 函数从文件中加载数据，并将其存储在变量 `loaded_arr` 中。最后，我们打印加载后的数据，验证它与原始数组相同。

- [numpy.lib.format — NumPy Manual](https://numpy.org/doc/stable/reference/generated/numpy.lib.format.html)

- [numpy.save — NumPy Manual](https://numpy.org/doc/stable/reference/generated/numpy.save.html)



## 对象导入问题🎈

- 以joblib的导入为例

- 通常导入失败可能和python环境有关

  - 操作系统错误(例如长时间未关机,导致系统内部出现了错误),系统更细也可能导致系统内部错误

  - 如果您使用conda管理python环境,那么conda环境由于某些操作(比如某些包的变动导致的)

  - 相关症状表现为:在环境内安装/卸载某个包会出现(以windows系统为例)

    1. 权限错误

    2. dll文件错误

    3. vscode notebook 链接kernel无法成功

    4. 二进制对象导入报错(例如joblib导入失败):

       - ```bash
         Traceback (most recent call last):
           File "<stdin>", line 1, in <module>
           File "d:\condaPythonEnvs\tf210\lib\site-packages\joblib\numpy_pickle.py", line 587, in load
             obj = _unpickle(fobj, filename, mmap_mode)
           File "d:\condaPythonEnvs\tf210\lib\site-packages\joblib\numpy_pickle.py", line 506, in _unpickle
             obj = unpickler.load()
           File "d:\condaPythonEnvs\tf210\lib\pickle.py", line 1212, in load
             dispatch[key[0]](self)
         KeyError: 0
         ```

         

- 解决办法:

  1. 重启计算机,看错误是否消失
  2. 创建一个新的conda python环境
  3. 安装python包的时候尽量选用`pip install`的方式,至少尽量不要混合使用`conda install`和`pip install`

  