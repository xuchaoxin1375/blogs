[toc]

# python@调用系统命令行@os.system@subprocess@标准输入输出@sys.stdin@sys.stdout@input@print

## 概要

- 在Python中，可以使用`os.system`函数来执行操作系统命令。

- 该函数接受一个字符串参数，该字符串是要执行的命令。例如，要在Windows系统中执行`dir`命令，可以使用以下代码：

  - ```python
    import os
    os.system('dir')
    ```

  - 在Linux或MacOS系统中，可以使用`ls`命令代替`dir`命令。`os.system`函数会在一个新的子进程中执行命令，并等待命令执行完成后返回。如果命令执行成功，`os.system`函数返回0，否则返回一个非零值。

- 需要注意的是，`os.system`函数的安全性不太好，因为它可以执行任意的系统命令。如果要执行的命令包含用户输入的内容，需要谨慎处理，以避免命令注入等安全问题。

- 为了提高安全性，可以使用`subprocess`**模块**来代替`os.system`函数，该模块提供了更多的选项来控制命令的执行环境和参数。例如，以下代码使用`subprocess`模块来执行`ls`命令，并获取命令输出：

  - ```python
    import subprocess
    
    result = subprocess.run(['ls', '-l'], stdout=subprocess.PIPE)
    print(result.stdout.decode('utf-8'))
    ```

  - 该代码会执行`ls -l`命令，并将输出存储在`result`变量中。

  - `subprocess.run`函数接受一个列表参数，该列表包含要执行的命令和参数。`stdout=subprocess.PIPE`参数可以将命令输出重定向到一个管道中，而`result.stdout.decode('utf-8')`可以将管道中的输出转换为字符串并打印出来。

### os.system

- [os.system()](https://docs.python.org/3/library/os.html#os.system)

- Execute the command (a string) in a subshell. This is implemented by calling the Standard C function `system()`, and has the same limitations. Changes to [`sys.stdin`](https://docs.python.org/3/library/sys.html#sys.stdin), etc. are not reflected in the environment of the executed command. If *command* generates any output, it will be sent to the interpreter standard output stream. The C standard does not specify the meaning of the return value of the C function, so the return value of the Python function is system-dependent.

- On Unix, the return value is the exit status of the process encoded in the format specified for [`wait()`](https://docs.python.org/3/library/os.html#os.wait).

- On Windows, the return value is that returned by the system shell after running *command*. The shell is given by the Windows environment variable `COMSPEC`: it is usually **cmd.exe**, which returns the exit status of the command run; on systems using a non-native shell, consult your shell documentation.

- The [`subprocess`](https://docs.python.org/3/library/subprocess.html#module-subprocess) module provides more powerful f	acilities for spawning new processes and retrieving their results; using that module is preferable to using this function. See the [Replacing Older Functions with the subprocess Module](https://docs.python.org/3/library/subprocess.html#subprocess-replacements) section in the [`subprocess`](https://docs.python.org/3/library/subprocess.html#module-subprocess) documentation for some helpful recipes.

  On Unix, [`waitstatus_to_exitcode()`](https://docs.python.org/3/library/os.html#os.waitstatus_to_exitcode) can be used to convert the result (exit status) into an exit code. On Windows, the result is directly the exit code.

  Raises an [auditing event](https://docs.python.org/3/library/sys.html#auditing) `os.system` with argument `command`.

- `os.system`函数是Python标准库中的一个函数，用于在子shell中执行一个命令字符串。该函数会调用操作系统底层的`system()`函数来实现命令的执行，因此在不同操作系统下其行为可能有所不同。

- 在Unix系统中，`os.system`函数的返回值是被执行命令的退出状态，该退出状态被编码为`wait()`函数指定的格式。

- 在Windows系统中，`os.system`函数的返回值是由系统shell返回的，通常是`cmd.exe`，该值取决于执行的命令。

- 需要注意的是，`os.system`函数的返回值在不同操作系统下的具体含义可能不同，因此在编写跨平台脚本时需要谨慎处理。此外，`os.system`函数的安全性不太好，因为它可以执行任意的系统命令。如果要执行的命令包含用户输入的内容，需要谨慎处理，以避免命令注入等安全问题。

- 为了提高安全性和灵活性，可以使用`subprocess`模块来代替`os.system`函数。

- `subprocess`模块提供了更多的选项来控制命令的执行环境和参数，并且可以方便地获取命令的输出和错误信息。例如，以下代码使用`subprocess`模块来执行`ls`命令，并获取命令输出：

  ```python
  import subprocess
  
  result = subprocess.run(['ls', '-l'], capture_output=True, text=True)
  print(result.stdout)
  ```

  该代码会执行`ls -l`命令，并将输出存储在`result`变量中。`capture_output=True`参数可以将命令输出捕获到`result.stdout`中，而`text=True`参数可以将输出以字符串的形式返回。最终输出的是`ls -l`命令的输出。

#### demos

- 下面是一个使用`os.system()`函数的简单示例，该示例执行一个命令行命令，打印出当前目录下的所有文件和子目录：

  ```python
  import os
  
  import platform
  
  # 获取操作系统名称
  os_name = platform.system()
  # 执行命令
  
  ls="dir" if os_name=='Windows' else "ls"
  res= os.system(ls) 
  
  # 打印执行结果的状态码
  print("os.system(ls) 执行结果状态码:", res)
  res1=os.system("rasie_")
  print(res1)#执行了不存在的命令rasie_,状态码非0
  ```
  
  在这个例子中，我们首先导入了`os`模块，然后调用`os.system()`函数，将命令行命令`dir`传递给它。这个命令会在命令行中列出当前目录下的所有文件和子目录。
  
  然后，我们使用`os.system()`函数来执行这个命令，并将执行结果的状态码打印出来。在Windows系统中，如果执行成功，`dir`命令会返回0，否则会返回其他的值。我们可以通过打印状态码来判断命令是否执行成功。
  
  需要注意的是，`os.system()`函数返回的状态码是一个整数值，而不是一个字符串。如果需要将状态码转换为字符串或其他格式，需要使用相应的转换函数或方法。

#### windows命令解释器@ComSpec

- ComSpec是"Command Specification"的缩写，指的是Windows操作系统中的一个环境变量，用于指定默认的命令行解释器。
- 在Windows系统中，当需要执行一个命令行命令时，系统会首先查找ComSpec环境变量，并使用该变量指定的命令行解释器来执行命令。
- 默认情况下，ComSpec环境变量的值为`C:\Windows\System32\cmd.exe`，即Windows的标准命令提示符。但是，用户可以通过修改ComSpec环境变量的值，来使用其他的命令行解释器，例如Windows PowerShell等。
- ComSpec环境变量在Windows系统中起着重要的作用，因为许多应用程序和脚本都需要使用命令行解释器来执行操作。通过使用ComSpec环境变量，可以确保这些应用程序和脚本在任何Windows系统中都可以正常工作，而无需考虑系统中安装的命令行解释器是哪个。

### subprocess@recommended🎈

- [subprocess — Subprocess management — Python 3.11.2 documentation](https://docs.python.org/3/library/subprocess.html#module-subprocess)

- The [`subprocess`](https://docs.python.org/3/library/subprocess.html#module-subprocess) module allows you to spawn new processes, connect to their input/output/error pipes, and obtain their return codes. This module intends to replace several older modules and functions:

  ```
  os.system
  os.spawn*
  ```

- Information about how the [`subprocess`](https://docs.python.org/3/library/subprocess.html#module-subprocess) module can be used to replace these modules and functions can be found in the following sections.

#### 基本用法

- `subprocess`是Python标准库中的一个模块，提供了更高级、更安全的执行外部命令的方法，比`os.system()`函数更加灵活。`subprocess`模块可以执行命令、获取命令的输出、控制命令的输入和输出、等待命令执行完成等操作。

  下面是`subprocess`模块的一些常用函数和方法：

  - `subprocess.run(args, *, stdin=None, input=None, stdout=None, stderr=None, capture_output=False, shell=False, timeout=None, check=False, encoding=None, errors=None, env=None, cwd=None, text=None, start_new_session=False)`：执行一个命令，并等待命令执行完成。返回一个`CompletedProcess`对象，其中包含命令的执行结果。`args`参数可以是一个字符串，也可以是一个列表或元组，表示要执行的命令和参数。
  - `subprocess.Popen(args, bufsize=-1, executable=None, stdin=None, stdout=None, stderr=None, preexec_fn=None, close_fds=True, shell=False, cwd=None, env=None, universal_newlines=None, startupinfo=None, creationflags=0, restore_signals=True, start_new_session=False, pass_fds=(), *, group=None, extra_groups=None, user=None, initgroups=True)`：启动一个新的进程，并返回一个`Popen`对象，其中包含该进程的信息和控制方法。`args`参数的含义与`subprocess.run()`函数相同。
  - `subprocess.check_call(args, *, stdin=None, stdout=None, stderr=None, shell=False, timeout=None, encoding=None, errors=None, env=None, cwd=None, text=None, start_new_session=False)`：执行一个命令，并等待命令执行完成。如果命令的返回值为0，则返回None，否则会抛出`CalledProcessError`异常。`args`参数的含义与`subprocess.run()`函数相同。
  - `subprocess.check_output(args, *, stdin=None, stderr=None, shell=False, timeout=None, encoding=None, errors=None, universal_newlines=None, cwd=None, text=None, start_new_session=False)`：执行一个命令，并返回命令的输出结果。如果命令的返回值不为0，则会抛出`CalledProcessError`异常。`args`参数的含义与`subprocess.run()`函数相同。

#### demos

下面是`subprocess`模块的一些示例代码，演示了如何使用不同的函数和方法执行外部命令：

- 使用`subprocess.run()`函数执行一个简单的命令，打印当前目录的路径：

  - ```python
    import subprocess
    
    result = subprocess.run(["pwd"], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    print(result.stdout.decode("utf-8"))
    ```

  - 在这个例子中，我们调用`subprocess.run()`函数执行`pwd`命令，该命令会打印当前目录的路径。`stdout=subprocess.PIPE`参数表示我们希望获取命令的标准输出，`stderr=subprocess.PIPE`参数表示我们希望获取命令的错误输出。`result.stdout.decode("utf-8")`语句将获取到的标准输出转换为字符串，并打印出来。

- 使用`subprocess.Popen()`函数执行一个命令，并向其输入数据：

- ```python
  import subprocess
  
  # 启动一个命令行进程
  p = subprocess.Popen(["cat"], stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
  
  # 向进程输入数据
  p.stdin.write(b"hello\n")
  p.stdin.write(b"world\n")
  p.stdin.close()
  
  # 从进程读取输出
  output = p.stdout.read()
  
  # 打印输出
  print(output.decode("utf-8"))
  ```


在这个例子中，我们使用`subprocess.Popen()`函数启动了一个`cat`命令的进程，并将其标准输入和输出重定向到`stdin`和`stdout`。我们向该进程输入了两行数据，然后关闭了标准输入。最后，我们从进程的标准输出中读取数据，并将其打印出来。

1. 使用`subprocess.check_call()`函数执行一个命令，检查其返回值：

```python
import subprocess

# 执行一个命令，检查其返回值
subprocess.check_call(["ls", "-l"])
```

## 标准输入输出

- [Take input from stdin in Python - GeeksforGeeks](https://www.geeksforgeeks.org/take-input-from-stdin-in-python/)

- `stdin`和`stdout`是计算机中常见的输入输出流。在Unix和类Unix系统（如Linux）中，一切都是文件，包括标准输入、输出和错误输出。在Windows系统中，也有类似的概念，但是实现方式略有不同。

- `stdin`代表标准输入流，通常用于从控制台或者其他程序读取输入。在Python中，可以使用`sys.stdin`对象来访问标准输入流。例如，以下代码使用`sys.stdin`对象来读取用户输入的字符串：

  ```python
  import sys
  
  input_str = sys.stdin.readline()
  print(input_str)
  ```

  该代码使用`sys.stdin.readline()`函数从标准输入流中读取一行字符串，并将其存储在`input_str`变量中。然后，将该字符串输出到标准输出流中。需要注意的是，`sys.stdin`对象默认使用缓冲区，因此在读取输入之前可能需要先刷新缓冲区。

- `stdout`代表标准输出流，通常用于向控制台或者其他程序输出信息。在Python中，可以使用`print()`函数将信息输出到标准输出流中。例如，以下代码使用`print()`函数输出一行字符串到标准输出流中：

  ```python
  print('Hello, world!')
  ```

  该代码会将字符串`'Hello, world!'`输出到标准输出流中。需要注意的是，`print()`函数默认会在输出字符串末尾添加一个换行符，如果不希望添加换行符，可以使用`end`参数来指定输出末尾的字符。

  总之，`stdin`和`stdout`是计算机中常见的输入输出流，用于在程序和外界之间传递信息。在Python中，可以使用`sys.stdin`和`print()`函数来访问标准输入和输出流。

- 标准输入流（stdin）通常用于从外部环境中读取输入。例如，在命令行程序中，用户可以通过键盘向程序输入数据，这些数据就会通过标准输入流传递到程序中。标准输出流（stdout）通常用于向外部环境输出信息。例如，在命令行程序中，程序可以通过标准输出流将结果输出到控制台中，供用户查看。

  在Python中，可以使用`sys.stdin`和`sys.stdout`对象来访问标准输入输出流。`sys.stdin`对象表示标准输入流，可以通过该对象的`readline()`方法从标准输入中读取一行文本。例如，以下代码从标准输入中读取一行文本，并将其输出到标准输出中：

  ```python
  import sys
  
  input_str = sys.stdin.readline()
  sys.stdout.write(input_str)
  ```

- 该代码首先使用`sys.stdin.readline()`方法从标准输入流中读取一行文本，并将其存储在`input_str`变量中。然后，使用`sys.stdout.write()`方法将该文本输出到标准输出流中。

- 需要注意的是，在使用标准输入输出流时，需要根据具体的操作系统和环境来调整相关设置。例如，在一些特殊情况下，可能需要禁用缓冲区，以避免输出延迟。在Python中，可以使用`sys.stdout.flush()`方法来刷新标准输出流的缓冲区，以确保输出立即生效。

  总之，标准输入输出是计算机操作系统中的重要概念，用于表示程序与外部环境之间的输入输出流。在Python中，可以使用`sys.stdin`和`sys.stdout`对象来访问标准输入输出流，以实现与外部环境的交互。

### sys.stdin

- ```python
  # stdin_demo.py
  import sys
  
  for line in sys.stdin:
  	if 'q' == line.rstrip():
  		break
  	print(f'Input : {line}')
  
  print("Exit")
  
  ```

  - ```bash
    (d:\condaPythonEnvs\tf210) PS C:\Users\cxxu\ser\testers> py .\stdin_demo.py 
    1
    Input : 1
    
    2
    Input : 2
    
    q
    Exit
    ```

### input()

- ```python
  # input_demo.py
  inp = input("Type anything:")
  
  # prints inp
  print(inp)
  
  ```

  

```bash
(d:\condaPythonEnvs\tf210) PS C:\Users\cxxu\ser\testers> py .\input_demo.py
Type anything:123
123
```

### sys.stdin.input@input()

- ```python
  # stdin_readline_demo.py
  # Python program to demonstrate
  # sys.stdin.readline()
  
  
  import sys
  print("read string:")
  name = sys.stdin.readline()
  print(repr(name),type(name))
  
  #可以控制读入的字符数
  print("read 2 digit:")
  num = sys.stdin.readline(2)
  print(num,type(num))
  # 比较input()
  line=input("read by input():")
  print(repr(line),type(line))
  
  ```

- ```bash
  (d:\condaPythonEnvs\tf210) PS D:\repos\CCSER\emotion-recognition-using-speech\testers> py .\stdin_readline_demo.py
  read string:
  cxxu
  'cxxu\n' <class 'str'>
  read 2 digit:
  123
  12 <class 'str'>
  read by input():cxxu
  'cxxu' <class 'str'>
  ```

#### 交互模式

- ```python
  (d:\condaPythonEnvs\tf210) PS C:\Users\cxxu\ser\testers> py
  Python 3.9.16 (main, Mar  8 2023, 10:39:24) [MSC v.1916 64 bit (AMD64)] on win32
  Type "help", "copyright", "credits" or "license" for more information.
  >>> import sys
  >>> name = sys.stdin.readline()
  cxxu
  >>> print(name,type(name))
  cxxu
   <class 'str'>
  >>> len(name)
  5
  >>> num=sys.stdin.readline()
  123
  >>> num
  '123\n'
  >>> name=sys.stdin.readline()
  cxxu
  
  >>> name
  'cxxu\n'
  >>> print(name+"tailing")
  cxxu
  tailing
  >>> name+"tailing"       
  'cxxu\ntailing'
  ```

- 可以看到,使用`print()`打印出来的内容会将`\n`作为换行效果显示出来

#### 小结

- `input()`函数和`sys.stdin.readline()`方法都可以用于从标准输入流中读取一行文本（字符串）。在大多数情况下，这两种方法的功能是相似的，可以互相替代。

- 但是，它们还是有一些区别的：

- `input()`函数自动去除读取到的字符串中的末尾换行符，而`sys.stdin.readline()`方法不会自动去除换行符。这意味着，如果使用`sys.stdin.readline()`方法读取一行文本，需要手动去除字符串末尾的换行符。

  例如，以下代码使用`input()`函数读取一行文本，并输出该文本的长度：

  ```python
  input_str = input()
  print(len(input_str))
  ```

  该代码会从标准输入流中读取一行文本，自动去除末尾的换行符，并输出该文本的长度。

  而以下代码使用`sys.stdin.readline()`方法读取一行文本，需要手动去除字符串末尾的换行符：

  ```python
  import sys
  
  input_str = sys.stdin.readline().rstrip('\n')
  print(len(input_str))
  ```

  该代码会从标准输入流中读取一行文本，然后使用`rstrip('\n')`方法去除字符串末尾的换行符，并输出该文本的长度。

- `input()`函数会将读取到的字符串进行解析，返回一个Python对象，而`sys.stdin.readline()`方法则直接返回一个字符串。这意味着，如果需要将读取到的字符串转换为其他类型的Python对象（如整数或浮点数），则需要使用`input()`函数比较放便。

  例如，以下代码使用`input()`函数读取一个整数，并输出该整数的平方：

  ```python
  input_num = int(input())
  print(input_num ** 2)
  ```

  该代码会从标准输入流中读取一个整数，将其转换为整数类型，然后输出该整数的平方。

  而以下代码使用`sys.stdin.readline()`方法读取一个整数，并需要手动将其转换为整数类型：

  ```python
  import sys
  
  input_num = int(sys.stdin.readline().rstrip('\n'))
  print(input_num ** 2)
  ```

  该代码会从标准输入流中读取一个字符串（包括末尾的换行符），然后使用`rstrip('\n')`方法去除字符串末尾的换行符，并将其转换为整数类型，然后输出该整数的平方。

  总之，`input()`函数和`sys.stdin.readline()`方法都可以用于从标准输入流中读取一行文本，但是在使用它们时需要根据具体情况选择适合的方法，并注意它们的区别。

### sys.stdout

- ```python
  # stdin_out.py
  import sys
  
  print("使用stdin.readline()读取输入(从命令行读取输入):")
  input_str = sys.stdin.readline()
  print("<<<<<<<<<<")
  print("使用repr检查换行符等转义字符",repr(input_str))
  print("使用sys.stdout.write()将内容写出到终端:")
  sys.stdout.write(repr(input_str))#不同于print()不会追加换行
  print("<<<<<<<<<<")
  
  ```

  - ```bash
    (d:\condaPythonEnvs\tf210) PS C:\Users\cxxu\ser\testers> py .\stdin_out.py
    使用stdin.readline()读取输入(从命令行读取输入):
    123
    <<<<<<<<<<
    使用repr检查换行符等转义字符 '123\n'
    使用sys.stdout.write()将内容写出到终端:
    '123\n'<<<<<<<<<<
    ```

### sys.stdout.wirte()@print()

- `sys.stdout.write()`方法和`print()`函数都可以用于向标准输出流中输出信息。但是，它们在输出方式和输出效果上有一些区别。

  1. 输出方式：`sys.stdout.write()`方法需要手动添加换行符，而`print()`函数会在输出结束后自动添加换行符。

  例如，以下代码使用`sys.stdout.write()`方法输出一行文本，并手动添加换行符：

  ```python
  import sys
  
  sys.stdout.write('Hello, world!\n')
  ```

  该代码会向标准输出流中输出字符串`'Hello, world!'`，并手动添加一个换行符。

  而以下代码使用`print()`函数输出一行文本，无需手动添加换行符：

  ```python
  print('Hello, world!')
  ```

  该代码会向标准输出流中输出字符串`'Hello, world!'`，并自动添加一个换行符。

  1. 输出效果：`sys.stdout.write()`方法输出的文本可以与其他输出保持在同一行，而`print()`函数输出的文本会自动换行，与其他输出分开。

  例如，以下代码使用`sys.stdout.write()`方法输出两个字符串，在同一行中显示：

  ```python
  import sys
  
  sys.stdout.write('Hello, ')
  sys.stdout.write('world!\n')
  ```

  该代码会向标准输出流中输出字符串`'Hello, '`和字符串`'world!'`，并在它们之间没有换行符，输出结果为`'Hello, world!\n'`。

  而以下代码使用`print()`函数输出两个字符串，在不同行中显示：

  ```python
  print('Hello, ')
  print('world!')
  ```

  该代码会向标准输出流中输出字符串`'Hello, '`和字符串`'world!'`，并在它们之间自动添加一个换行符，输出结果为：

  ```
  Hello, 
  world!
  ```

  总之，`sys.stdout.write()`方法和`print()`函数都可以用于向标准输出流中输出信息，但是在使用它们时需要根据具体情况选择适合的方法，并注意它们的输出方式和输出效果。

### 从文件读取@fileinput

- [fileinput — Iterate over lines from multiple input streams — Python 3.11.2 documentation](https://docs.python.org/3/library/fileinput.html#module-fileinput)

#### fileinput.input()@从文件输入内容

- 如果是单个文件,可以使用`open`函数:[open()](https://docs.python.org/3/library/functions.html#open)
- 如果是多个文件,可以使用`fileinput.input`函数

- ```bash
  #构造两个简单文件:
  echo "f1 file">f1
  echo "f2 file">f2
  ```

  

- ```python
  # fileinput_demo.py
  import fileinput
  
  with fileinput.input(files=('f1', 'f2')) as f:
      # python3.10后支持encoding等参数
      for line in f:
          # process(line)
          print(line)
  
  ```

- ```bash
  (d:\condaPythonEnvs\tf210) PS C:\Users\cxxu\ser\testers> py .\fileinput_demo.py
  f1 file
  
  f2 file	
  ```

#### 命令行参数提供文件名

- ```python
  # fileinput_cli.py
  import fileinput
  import sys
  print(sys.argv)
  for f in fileinput.input():
  	print(f)
  
  ```

- ```bash
  (d:\condaPythonEnvs\tf210) PS C:\Users\cxxu\ser\testers> py .\fileinput_cli.py f1 f2
  ['.\\fileinput_cli.py', 'f1', 'f2']
  f1 file
  
  f2 file
  ```

## 小结

- 总之，虽然`os.system`函数可以方便地执行简单的命令，但在编写复杂脚本时建议使用更安全和灵活的`subprocess`模块。

  



