[toc]

## abstract

- GDB（GNU Debugger）是Linux及Unix环境中常用的程序调试工具,windows 下也有许多移植版可以用
- 即使你已经在使用集成开发环境（IDE）进行开发和调试，学习GDB命令行仍然有其独特的价值和应用场景：

  1. **深入理解程序执行**：GDB命令行提供了对程序执行流程的底层控制，帮助你更深入地理解程序的运行机制。通过手动控制每一步执行，你能够更细致地观察变量变化、函数调用、内存状态等，这对于复杂问题的排查非常有帮助。

  2. **轻量级和灵活性**：相比IDE，GDB是一个轻量级工具，尤其适合远程服务器或资源受限环境下的调试。有时，IDE可能因为兼容性、资源占用或远程访问限制而不适用，这时GDB就成为了一个强大的替代方案。

  3. **自动化和脚本编写**：GDB支持脚本编写，你可以编写脚本来自动化一些复杂的调试任务，比如批量设置断点、自动化测试场景等，这是大多数IDE难以比拟的。

  4. **性能考虑**：在某些高性能计算或嵌入式系统开发中，IDE可能由于其资源消耗较高而不适合。GDB的命令行方式则更为高效和直接。

  5. **技能扩展**：掌握GDB这样的命令行工具也是提升个人技能和适应不同开发环境的一种方式，尤其是在面试、系统编程或特定行业领域，这种能力往往被视为加分项。

  6. **应急情况处理**：在没有图形界面或IDE无法正确加载项目的情况下，GDB命令行调试能力能够让你在紧急情况下继续工作，保证项目的进度不受影响。

- 综上所述，即便经常使用IDE，学习GDB命令行仍然是值得投资的，它能增强你的调试能力，提高问题解决的效率，并在特定场景下提供不可或缺的支持。

## 调试方式

- 日志调试和GDB调试是软件开发中两种常用的调试方法，它们各有特点，适用于不同的场景和需求。
- GDB调试经常被集成到IDE中使用,通常可以在IDE看到调试对应的gdb命令,也可以混合GUI和命令行方式使用GDB

### 日志调试

日志调试是指在程序中插入日志语句（如打印变量值、状态信息、错误信息等），通过分析程序运行时产生的日志文件来诊断问题。

这种方法的优点包括：

1. **非侵入性**：不需要中断程序的正常运行，可以在生产环境中使用，对性能影响相对较小。
2. **长期跟踪**：可以记录程序长时间运行的过程，有助于发现偶现问题。
3. **跨环境**：日志可以在任何环境下生成，便于远程调试和分析。
4. **灵活性**：可以根据需要调整日志级别，控制输出信息的详细程度。

典型案例:在Android开发中经常用到日志,特别是多线程调试



缺点包括：

- 需要在代码中手动添加日志语句，可能会遗漏关键信息或增加代码维护负担。
- 分析大量日志数据可能会比较耗时和复杂。
- 对于某些类型的错误（如段错误、内存泄漏）难以直接定位。

### GDB调试

GDB（GNU Debugger）是一种强大的命令行调试工具，它允许开发者在程序运行时暂停执行、单步执行代码、查看和修改变量值、跟踪调用堆栈等。GDB调试的优点包括：

1. **交互性**：可以实时与程序交互，动态地探索和修改程序状态。
2. **精确性**：能准确地定位到代码的错误行，对于理解运行时行为非常有帮助。
3. **功能丰富**：支持断点设置、观察点（watchpoint）、单步执行、反汇编查看等多种高级调试功能。
4. **性能分析**：可以辅助进行性能瓶颈分析，比如查看函数调用时间。

缺点包括：

- 需要编译时带上-g选项，可能会增加可执行文件大小。
- 对程序运行有较大干扰，不适合在生产环境中使用。
- 学习曲线相对较陡峭，尤其是对于初学者。

## 安装GDB

- [How to Install GDB? | GDB Tutorial](https://www.gdbtutorial.com/tutorial/how-install-gdb)

- [GDB Documentation (gnu.org)](https://www.gnu.org/software/gdb/documentation/)
- [Index of /sourceware/gdb/releases/ | 清华大学开源软件镜像站 | Tsinghua Open Source Mirror](https://mirrors.tuna.tsinghua.edu.cn/sourceware/gdb/releases/)

- 在大多数Linux发行版中，你可以通过包管理器来安装GDB，例如在Debian或Ubuntu上使用：
  - `sudo apt install gdb`或`sudo apt-get install gdb`

- 在Fedora、CentOS或RHEL上使用:`sudo yum install gdb`

## 使用GDB前提

- gdb是调试二进制可执行程序的工具,通常是gcc编译出来的程序
- 并且要求gcc 带上`-g`选项,编译出来的才是方便用gdb调试的

- `gcc -g` 是GCC（GNU Compiler Collection）编译器中的一个选项，用于在编译时生成调试信息。这些调试信息对于使用GDB（GNU Debugger）或其他调试工具进行程序调试至关重要。下面是关于`-g`选项的详细说明：

  1. **生成调试信息**：`-g`选项指示GCC在编译时生成详细的调试信息，这些信息包括源代码行号、变量名、类型信息以及函数调用信息等。这些数据存储在编译后的可执行文件或库中，但不会影响程序的实际执行逻辑。

  2. **符号表**：编译器会创建一个符号表，其中记录了程序中所有定义的变量、函数名及其在可执行文件中的地址映射。这对于在调试时查找变量值和跳转到特定代码行非常重要。

  3. **源代码关联**：调试信息允许调试器展示源代码，让你能够逐行跟踪程序执行过程，设置断点，查看和修改变量值等。

  4. **优化与调试信息**：默认情况下，使用`-g`编译时，GCC会关闭编译器的优化，以保证生成的调试信息与原始源代码直接对应，避免因优化导致的代码路径难以追踪。不过，GCC也支持`-g`与优化级别（如`-O1`, `-O2`）结合使用，以在一定程度上保留调试信息的同时进行代码优化，但这可能会使调试复杂化，因为优化可能导致执行路径与源代码的直接对应关系变得模糊。

  5. **原生格式**：生成的调试信息格式通常是目标平台的“原生格式”，这意味着GDB等调试器可以直接理解和使用这些信息，无需额外转换。例如，在Linux系统上，通常使用DWARF格式。

  6. **与其他调试选项的比较**：相较于`-ggdb`，`-g`生成的信息更通用，适用于多种调试器，而`-ggdb`则专为GDB优化，可能包含一些GDB特有的调试信息。另外，与不使用`-g`编译相比，加入`-g`的程序体积通常会更大，因为包含了额外的调试数据。

  综上所述，当你计划对程序进行调试时，添加`-g`选项是非常必要的，它能显著增强调试体验，提供更详尽的程序内部视图。

## 开始使用

### 帮助文档

- 文档全部展开的话十分长,首页做了分类;不过用浏览器阅读文档会舒服点
- 更直接的是学习精华内容,暂时跳过不那么重要的内容

- ```bash
  (gdb) help
  List of classes of commands:
  
  aliases -- User-defined aliases of other commands.
  breakpoints -- Making program stop at certain points.
  data -- Examining data.
  files -- Specifying and examining files.
  internals -- Maintenance commands.
  obscure -- Obscure features.
  running -- Running the program.
  stack -- Examining the stack.
  status -- Status inquiries.
  support -- Support facilities.
  text-user-interface -- TUI is the GDB text based interface.
  tracepoints -- Tracing of program execution without stopping the program.
  user-defined -- User-defined commands.
  
  Type "help" followed by a class name for a list of commands in that class.
  Type "help all" for the list of all commands.
  Type "help" followed by command name for full documentation.
  Type "apropos word" to search for commands related to "word".
  Type "apropos -v word" for full documentation of commands related to "word".
  Command name abbreviations are allowed if unambiguous.
  ```

### 关闭启动gdb时的版权和版本声明

- 要关闭GDB启动时显示的版权、许可、配置信息等提示，你可以在启动GDB时加上`--silent`或`-q`选项。这两个选项都会让GDB以静默模式启动，跳过欢迎信息和版本详情的输出。

  - ```bash
     -q, --quiet, --silent
                         Do not print version number on startup.
    ```

    

- 例如：

  ```bash
  gdb --silent my_program
  ```

  或者

  ```bash
  gdb -q my_program
  ```

  这样，当你启动GDB时就不会看到那些标准的启动信息了，直接进入交互界面或加载程序。

## 重点内容

确实，GDB作为一款功能丰富的调试工具，涵盖了从基础到高级的各种调试功能。对于初学者或是想要高效利用GDB的人来说，掌握以下几个核心功能是把握重点的关键：

1. **基础执行控制**：
   - `run` (`r`)：启动程序。
   - `break` (`b`)：设置断点，如`break main`在`main`函数开始处设断点。
   - `continue` (`c`)：继续执行直到遇到下一个断点。
   - `step` (`s`)：步入函数内部。
   - `next` (`n`)：跳过函数内部，直接执行到下一行。
   - `finish`：执行到当前函数返回。
   - `quit` (`q`)：退出GDB。

2. **变量和表达式观察**：
   - `print` (`p`)：打印变量或表达式的值，如`print var`。
   - `whatis`：显示变量或函数的类型。
   - `watch`：设置观察点，监视表达式的值变化。
   - `info locals`：显示当前函数内的局部变量。

3. **堆栈和调用信息**：
   - `backtrace` (`bt`)：显示当前的调用堆栈。
   - `frame` (`f`)：选择堆栈帧，用于查看不同函数的上下文。

4. **断点管理**：
   - `info breakpoints`：查看所有断点信息。
   - `disable/enable breakpoint`：禁用或启用断点。
   - `condition`：为断点设置条件，如`condition 1 var > 10`使断点在条件满足时触发。

5. **程序状态和内存查看**：
   - `list` (`l`)：显示源代码。
   - `x` 或 `examine`：查看内存内容，如`x/10wx address`查看10个字的十六进制宽度内存。
   - `thread` 相关命令：在多线程程序中切换和管理线程。

6. **调试脚本和自动化**：
   - 理解GDB的命令脚本功能，虽然这不是初学者立即需要掌握的，但是知道可以通过脚本自动化调试任务是一个加分项。

把握以上这些核心功能，你就可以在大部分调试场景中得心应手。随着实践经验的积累，再逐渐深入学习更高级的特性，如进程和线程控制、远程调试、内存泄漏检测等。



## 启动GDB

1. **直接启动**：如果你要调试一个程序名为`my_program`，可以这样启动GDB：
   
   ```bash
   gdb my_program
   ```
2. **附加到已运行的进程**：如果你想要调试一个已经运行的程序，首先需要找到其进程ID（PID），然后使用`attach`命令：
   ```bash
   gdb attach <PID>
   ```



### 回车键补全命令

- 可用用tab键来补全命令或函数名字,如果不唯一,按下2次tab会列出同一个名字打头的函数列表



## 断点

### 设置断点

- **在函数名处设置断点**：

  ```gdb
  break function_name
  ```

- **在特定行设置断点**：

  ```gdb
  break filename:linenumber
  ```

- **使用正则表达式设置断点**：

  ```gdb
  rbreak regex
  ```

  例如，`rbreak test_func.*`会在所有以`test_func`开头的函数处设置断点。

- **条件断点**：在满足特定条件时暂停程序执行。

  ```gdb
  break line_number if condition
  ```



### 控制断点👺

- **列出所有断点**：`info breakpoints` 或 `i b`。

- **删除断点**：`delete breakpoint_number`，如 `delete 2`。

- **禁用/启用断点**：`disable breakpoint_number` 和 `enable breakpoint_number`。

- **临时断点**（执行一次后自动删除）：`tbreak` 或 `tb`。

- ```bash
  (gdb) i b
  Num     Type           Disp Enb Address            What
  1       breakpoint     keep y   0x000000014000147b in main at .\example.c:10
  2       breakpoint     keep y   0x0000000140001458 in print_hello at .\example.c:5
  3       breakpoint     keep y   0x0000000140001489 in main at .\example.c:12
          stop only if sum>15
  ```

- 要管理条件断点，可以使用GDB的其他命令，如`info breakpoints`来查看断点信息，包括它们的条件；`disable`和`enable`命令来禁用或启用特定编号的断点；以及`condition [breakpoint_number] [new_condition]`命令来修改现有断点的条件或清除条件。

  - 初次设置条件断点时用一般时用`if`语句
  - 而修改条件断点的条件则把`if`关键字省略掉,直接写新条件

- 如果不提供`new_condition`，则断点变为无条件断点。



## 执行和控制

### 运行程序

- **开始执行**：`run` 或 `r`，可以带上参数 `run arg1 arg2`。
- **继续执行**：当程序在断点停下时，使用 `continue` 或 `c` 继续运行。

### 执行控制

- **单步跳过函数**：`next` 或 `n`。

- **单步入函数**：`step` 或 `s`。

- 在GDB（GNU Debugger）中，`next` 和 `step` 是两个非常基础且常用的命令，用于在调试过程中控制程序的执行流程。它们的主要区别在于处理函数调用的方式：

  1. **next (n)**:
     - 当执行 `next` 命令时，GDB会执行当前行以及之后的代码直到到达下一行可执行代码。如果当前行包含一个函数调用，GDB不会进入该函数内部，而是将整个函数视为一步执行，直接跳到函数调用返回后的下一行代码。这在你对函数内部细节不感兴趣，只想快速浏览程序执行流程时非常有用。在其他一些调试器中，这个操作也被称为 "Step Over"。

  2. **step (s)**:
     - 使用 `step` 命令时，GDB同样会执行当前行的代码，但它的行为与 `next` 不同在于，如果当前行包含一个函数调用，GDB会进入该函数内部，并在函数体的第一行停下来。这样，你可以逐步跟踪函数内部的执行过程。这对于详细分析特定函数的执行路径和变量变化非常有帮助。如果不想进入某个特定函数内部，可以结合条件断点或后续的 `next` 命令使用。

- 总结来说，当你想要逐行执行代码但不想进入函数内部时，应该使用 `next`；而如果你想深入了解并逐步执行函数内部的操作，则应使用 `step`。

  

### 其他控制

- 在GDB中，除了`next`和`step`之外，还有许多其他有用的命令，帮助你在调试程序时进行更细致的控制和分析。以下是一些常用的命令及其简要说明：

  1. **break (b) / break **: 
     - 设置断点。可以在特定行号、函数名、文件和行号、条件表达式等位置设置断点。例如，`break main` 在`main`函数开始处设置断点，`break filename:linenumber` 在指定文件和行号设置断点，`break if condition` 设置条件断点。

  2. **continue (c)**:
     - 从当前位置继续执行程序，直到遇到下一个断点或程序结束。

  3. **finish**:
     - 执行到当前函数返回，然后停止。这对于快速退出当前函数并查看其返回值很有用。

  4. **until**: 
     - 执行到离开当前循环或跳转到指定位置，常用于快速跳过循环体。

  5. **list (l) / list **:
     - 显示源代码。不带参数时显示当前行周围的源代码，也可以指定文件名和行号来查看特定位置的代码。

  6. **backtrace (bt)**:
     - 显示当前的调用堆栈，包括函数调用序列和每个函数的参数、局部变量等信息，有助于理解程序的执行路径。

  7. **frame (f) / frame **:
     - 选择堆栈帧。`up` 和 `down` 可以在调用堆栈中上移或下移，改变当前上下文以查看不同函数的局部变量。

  8. **info locals**:
     - 显示当前堆栈帧中所有局部变量及其值。

  9. **set var variable = value**:
     - 修改变量的值。可以直接在调试时改变程序中的变量值，用于测试不同的执行路径。

  10. **watch expression**:
      - 设置观察点，当表达式的值改变时暂停执行。

  11. **disable/enable breakpoint **:
      - 禁用或启用指定编号的断点，便于控制哪些断点生效。

  这些命令覆盖了程序暂停、执行控制、断点管理、信息查看等多个方面，是进行高效调试的重要工具。熟练掌握它们，可以帮助你更快地定位和解决问题。

  

## 查看和监视

### 查看状态(变量等)

- 在GDB（GNU Debugger）中打印变量是调试过程中非常常用的功能。以下是一些基本的GDB命令，用于打印变量及其不同用法：

  1. **打印变量值**:
     - 基本命令 `print variable_name` 或简写 `p variable_name` 可以用来打印任何变量的值。
     - 如果你想以十六进制形式查看变量，可以使用 `print/x variable_name` 或 `p/x variable_name`。

  2. **打印指针所指向的内容**:
     - 如果变量是一个指针，你可以使用 `print *pointer_variable` 来查看指针指向的地址的内容。
     - 要以十六进制形式打印指针指向的内容，使用 `print/x *pointer_variable`。

  3. **打印全局变量**:
     - 对于全局变量，直接使用 `print global_var_name` 即可。如果是Go语言等有命名空间或包的概念，可能需要按照特定格式，如 `print package_name::global_var_name`，但根据Go的规则，所有全局变量都属于"main"包，所以通常使用 `print main.global_var_name`。

  4. **打印局部变量**:
     - GDB会在暂停执行时自动显示当前栈帧中的局部变量，你也可以使用 `info locals` 来查看。
     - 若要打印特定的局部变量，直接使用 `print local_var_name`。

  5. **持续打印变量**:
     - 在循环或需要连续观察变量变化的情况下，可以使用 `display variable_name` 命令。这样每次执行下一步命令时（如 `next` 或 `step`），GDB都会自动打印该变量的值。

  6. **打印数组和结构体**:
     - 打印数组时，GDB默认可能只会显示部分元素。你可以指定打印的元素数量，如 `print array_name@elements_count`。
     - 对于结构体，直接使用 `print struct_variable` 将会显示结构体的所有成员及其值。

  7. **打印变量地址**:
     - 使用 `print &variable_name` 可以获取变量的内存地址。


### 表达式

- 在GDB中，如果你想持续观察某个表达式的变化，而不是仅打印一次，可以使用`watch`命令。这对于调试循环、条件分支或想要监控某个复杂表达式的每次更新尤其有用。以下是基本用法：

  1. **观察表达式**:
     - 使用 `watch expression` 命令可以让GDB在每次表达式的值改变时自动停下来。例如，`watch count++` 会让程序在`count`变量每次自增前暂停执行。
     - 如果你想在表达式第一次被访问时停止，而不是每次更改时，可以使用 `rwatch expression`（读取观察点）。
     - 对于写入操作的观察，可以使用 `awatch expression`（写入观察点），它会在表达式的值被读取或修改时触发。

  2. **查看观察点列表**:
     - 使用 `info watchpoints` 命令可以列出当前设置的所有观察点及其状态。

  3. **删除观察点**:
     - 如果你不再需要某个观察点，可以使用 `delete <watchpoint_number>` 删除它。`watchpoint_number` 是通过 `info watchpoints` 命令获得的观察点编号。
     - 若要一次性删除所有观察点，可以使用 `delete` 命令不带编号。

  4. **条件观察点**:
     - 你还可以为观察点设置条件，仅当满足特定条件时才触发。语法为 `watch expression if condition`。例如，`watch count if count > 10` 将仅在`count`大于10时暂停执行。

  请注意，过度使用观察点可能导致调试过程变慢，因为每次检查都会有一定的性能开销。因此，建议仅在确实需要时设置观察点，并在问题解决后及时删除它们。

### 查看源码和反汇编

- **查看源代码**：`list` 或 `l`。
- **反汇编代码**：`disassemble` 或 `x/i $pc`。



## 退出GDB
- 使用命令 `quit` 或 `q` 退出GDB。

## 小结

- 上述只是GDB的基础使用，GDB的强大在于它丰富的命令集和高度可配置性

## 简单案例👺

- 我们通过一个简单的C语言程序示例来解释如何在GDB中设置断点。

  假设我们有一个名为`example.c`的C程序，内容如下：

  ```c
  #include <stdio.h>
  
  void print_hello() {
      printf("Hello, World!\n");
  }
  
  int main() {
      int a = 5;
      int b = 10;
      int sum = a + b;
  
      print_hello();
      printf("Sum: %d\n", sum);
  
      return 0;
  }
  ```

  我们首先编译这个程序，确保使用`-g`选项来包含调试信息：

  ```bash
  gcc -g example.c -o example
  ```

  接下来，我们使用GDB来调试这个程序：

  1. **启动GDB并加载程序**：
     打开终端，输入以下命令启动GDB并加载刚刚编译好的程序：

     ```bash
     gdb example
     ```

  2. **设置断点**：
     - **按行号设置断点**：如果你想在`main`函数的开始处设置断点，可以输入：
       
       ```gdb
       break main
       ```
       或者更具体地，如果你想在`sum`变量定义的那行设置断点，可以先使用`list`命令找到那行的行号，假设是第7行，然后输入：
       ```gdb
       break 7
       ```
     - **按函数名设置断点**：如果想在`print_hello`函数开始前中断，可以输入：
       ```gdb
       break print_hello
       ```
     - **条件断点**：假设你想在`a + b`的和大于15时才中断，可以设置条件断点：
       ```gdb
       break 7 if sum > 15
       ```

  3. **运行程序**：
     输入`run`或`r`命令开始运行程序。程序会运行直到遇到第一个断点。

  4. **查看断点信息**：
     使用`info breakpoints`或简写`i b`查看当前设置的所有断点的状态。

  5. **继续执行和单步执行**：
     - 当程序在断点处停止时，可以使用`continue`或`c`命令继续执行。
     - 使用`next`或`n`命令单步执行但不进入函数内部。
     - 使用`step`或`s`命令单步执行并进入函数内部。

  6. **查看变量值**：
     在断点处，你可以检查变量的值，例如输入`print a`或`p a`查看变量`a`的值。

  7. **禁用或删除断点**：

     - 要删除断点，先用`info breakpoints`找出断点编号，然后使用`delete <编号>`，例如`delete 1`。

       - ```
         (gdb) i b
         Num     Type           Disp Enb Address            What
         1       breakpoint     keep y   0x000000014000147b in main at .\example.c:10
         2       breakpoint     keep y   0x0000000140001458 in print_hello at .\example.c:5
         3       breakpoint     keep y   0x0000000140001489 in main at .\example.c:12
                 stop only if sum>15
         
         (gdb) delete 1
         (gdb) i b
         Num     Type           Disp Enb Address            What
         2       breakpoint     keep y   0x0000000140001458 in print_hello at .\example.c:5
         3       breakpoint     keep y   0x0000000140001489 in main at .\example.c:12
                 stop only if sum>15
         ```

     - 要禁用断点而不删除，使用`disable <编号>`；要重新启用，使用`enable <编号>`。
     
8. 修改条件断点条件
  
   - ```bash
       (gdb) condition 3  sum=15   
       (gdb) i b
       Num     Type           Disp Enb Address            What
       2       breakpoint     keep n   0x00007ff63bc61458 in print_hello at .\example.c:5
               breakpoint already hit 1 time
       3       breakpoint     keep y   0x00007ff63bc61489 in main at .\example.c:12
               stop only if sum=15
       ```
  
     
  
通过这些基本步骤，你可以在GDB中有效地设置和管理断点，从而理解程序的执行流程和状态。

## FAQ

### 无法调试问题

- 以我在windows上遇到的情况为例,个别情况下,会出现虽然编译运行都每问题,但是启动gdb调试就被卡住,也没有报错信息(比如vscode 调用gdb调试,Dev C++或小熊猫C++调用gdb调试,类似地出现了无法调试的情况)
  - 也就是说gdb的list,break,next的执行无法进行下去,在命令行中调用gdb才看到了错误输出

- 编译器或调试器直接处理中文可能会遇到问题

  ```bash
  PS C:\repos\C_CPP_ConsoleApps\cpp\C++Code> g++ .\质因数分解.cpp -o a.exe -g
  
  PS C:\repos\C_CPP_ConsoleApps\cpp\C++Code> gdb a.exe
  For help, type "help".
  Type "apropos word" to search for commands related to "word"...
  Reading symbols from a.exe...
  
  (gdb) list
  terminate called after throwing an instance of 'std::logic_error'
    what():  basic_string: construction from null is not valid
  ```

- 将中文引入c/c++代码往往不是一个好主意,但是考虑到有些用户英文水平不足,或者时为了便于国内同行交流的目的,可能会将文件名或者代码中引入中文,可能是中文字符串或中文注释

- 在经过实验,在某些语言下windows平台上没有特别处理的含中文源代码在g++编译,gdb调试时可能出现报错或者gdb无法返回结果的情况,gdb调试时(`list`命令列出的源码片段)也出现中文注释编程乱码的情况

- ```bash
  (gdb) list 34
  29          scanf("%d,%d", &a, &b); // 濡傛灉閲岄
  30
  31          // 鍔ㄦ墜鐢诲浘鏈€閲嶈;//涓嬩
  ```

- 这样的体验无疑是令人沮丧的;这也是为什么像visual studio这种大型的IDE尽管体积很大,但是因为集成了编译和调试以及项目管理的功能开箱即用,而且对编码,非英文乱码等问题处理的比较好,基本不用操心,对于初学者来说也很流行

- 在大学里,老师和同学也不太研究这些可能出现的乱码,遇到问题乱码可能还得自己想办法,要么就全跟老师同学一样配置;

- 有时可能是系统某个地方语言被修改了,比如重装了英文的系统,和中文系统的用户遇到的乱码情况就不同

- 我们可以装个虚拟机,看看是不是系统方面的语言问题;

  - 现在看来,如果里不开中文(要考虑运行别人的含有中文的程序,以及自己也会写入中文的字符串或注释),对于windows,安装中文版系统更有利于编译和调试带有中文的C++代码;当然有虚拟机也是可以的
  - 很多外国开发的软件也不会考虑中文乱码或者提供解决方案,就得自己想办法解决,运气可能加个字符编码参数就能解决,比如编译时加上`-finput-charset=UTF-8 -fexec-charset=gbk`,运气不好死活都是乱码.

- 总之,如果是纯英文工程,没有中文则是最稳妥的,几乎不可能出现乱码,









