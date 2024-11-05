[toc]



是的，`gcc`（GNU Compiler Collection）不仅可以编译 C 代码，还可以编译 C++ 代码。尽管 `gcc` 通常与 C 语言编译相关联，但它其实支持多种编程语言，包括 C++。不过，编译 C++ 代码时，建议使用 `g++`，这是 `gcc` 专门为 C++ 语言设计的编译器，尽量避免一些潜在的问题。

### 使用 gcc 编译 C++ 代码

1. **直接使用 `gcc`**：
   如果你坚持使用 `gcc` 编译 C++ 代码，可以通过指定 C++ 源文件的扩展名（通常是 `.cpp`），`gcc` 会自动识别为 C++ 代码并按 C++ 标准进行编译。

   ```bash
   gcc my_program.cpp -o my_program
   ```

   这种方法是可行的，但可能需要手动链接 C++ 标准库。

2. **指定编译选项 `-lstdc++`**：
   有时候直接使用 `gcc` 编译 C++ 代码时会遇到链接错误。这是因为 `gcc` 默认不链接 C++ 标准库。可以通过 `-lstdc++` 选项显式地链接 C++ 标准库：

   ```bash
   gcc my_program.cpp -o my_program -lstdc++
   ```

3. **指定 C++ 标准**：
   使用 `gcc` 编译 C++ 代码时，还可以用 `-std=c++XX` 选项指定 C++ 标准版本，例如 C++11、C++14、C++17、C++20 等：

   ```bash
   gcc my_program.cpp -o my_program -std=c++17 -lstdc++
   ```

   其中 `-std=c++17` 指定使用 C++17 标准。

### 中文环境下使用gcc编译c++

- 建议增加编码选项

  ```bash
  gcc my_program.cpp -o my_program -std=c++17 -lstdc++ -finput-charset=UTF-8 -fexec-charset=gbk
  ```

例如

```bash
 gcc .\helloworld.c -o a.exe -lstdc++ -finput-charset=UTF-8 -fexec-charset=gbk
```

```bash
gcc .\helloworld你好世界.cpp -o a.exe -lstdc++ -finput-charset=UTF-8 -fexec-charset=gbk 
```



### 更推荐使用 g++ 编译 C++ 代码

尽管 `gcc` 可以编译 C++ 代码，但 **使用 `g++` 更推荐**，因为 `g++` 会自动链接 C++ 标准库，并且在处理 C++ 代码时更加友好。

使用 `g++` 的编译命令如下：

```bash
g++ my_program.cpp -o my_program
```

- **自动链接 C++ 标准库**：使用 `g++` 时，不需要手动添加 `-lstdc++` 选项，`g++` 会自动链接 C++ 标准库。
- **支持不同的 C++ 标准**：同样可以通过 `-std=c++XX` 选项指定 C++ 标准：

  ```bash
  g++ my_program.cpp -o my_program -std=c++17
  ```

### 总结

- `gcc` 可以编译 C++ 代码，但通常需要手动链接 C++ 标准库 `-lstdc++`。
- `g++` 是专门为 C++ 设计的，建议优先使用 `g++`，因为它自动处理了 C++ 标准库链接，使用更加简便。

**建议**：如果编译的是 C++ 代码，尽量使用 `g++` 而不是 `gcc`。