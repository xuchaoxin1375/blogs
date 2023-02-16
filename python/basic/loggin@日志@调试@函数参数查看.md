[toc]

## refs

- [debugging - Python: Print a variable's name and value? - Stack Overflow](https://stackoverflow.com/questions/32000934/python-print-a-variables-name-and-value)
- [python - How to iterate over function arguments - Stack Overflow](https://stackoverflow.com/questions/2912615/how-to-iterate-over-function-arguments)
- [python - How to get method parameter names? - Stack Overflow](https://stackoverflow.com/questions/218616/how-to-get-method-parameter-names)

## inspect

- [inspect --- 检查对象 — Python 3.11.1 說明文件](https://docs.python.org/zh-tw/3/library/inspect.html)

## locals函数产看函数内部的变量

**locals**()

- Update and return a dictionary representing the current local symbol table. Free variables are returned by [`locals()`](https://docs.python.org/3/library/functions.html#locals) when it is called in function blocks, but not in class blocks. Note that at the module level, [`locals()`](https://docs.python.org/3/library/functions.html#locals) and [`globals()`](https://docs.python.org/3/library/functions.html#globals) are the same dictionary.

- Note:The contents of this dictionary should not be modified; changes may not affect the values of local and free variables used by the interpreter.

### 例(参数个数确定的情况)

- ```python
  def fun(a, b, c):
      d = locals()
      print(d)
  fun(1,2,3)
  #输出
  #{'a': 1, 'b': 2, 'c': 3}
  ```

### 参数个数不确定

- ```python
  def prt(*args,**kwargs):
      # print(args)
      qq="ttt"
      print(locals())
      # print(vars())
      for i in args:
          print(i)
         
  a=1
  b=3
  prt(a,b,test=a)
  #输出
  # {'args': (1, 3), 'kwargs': {'test': 1}, 'qq': 'ttt'}
  # 1
  # 3
  ```

  - 可见,locals可以将关键字参数提出来,但是位置参数只能够打印秩,无法捕获调用该函数时传入的变量的名字

- ```python
  def prt(*args, **kwargs):
      v=locals()
      print(v['args'])
      print(v['kwargs'])
      # for i in args:
      #     print(i)
  prt(123,a=a, b=b)
  #输出
  # (123,)
  # {'a': 1, 'b': 3}
  ```

  

### 模拟C语言的调试宏@f-string

- [f-string debugging in Python 3.8 (tirkarthi.github.io)](https://tirkarthi.github.io/programming/2019/05/08/f-string-debugging.html)

- [2. Lexical analysis — Python 3.11.1 documentation](https://docs.python.org/3/reference/lexical_analysis.html#f-strings)

  - When the equal sign `'='` is provided, the output will have the expression text, the `'='` and the evaluated value. Spaces after the opening brace `'{'`, within the expression and after the `'='` are all retained in the output. By default, the `'='` causes the [`repr()`](https://docs.python.org/3/library/functions.html#repr) of the expression to be provided, unless there is a format specified. When a format is specified it defaults to the [`str()`](https://docs.python.org/3/library/stdtypes.html#str) of the expression unless a conversion `'!r'` is declared.

- 在K&R的<<The C program language>>中提到过调试宏,可以方便我查看变量的值

- 在python中,可以用f-string的debug语法:

  - ```python
    var1="varable1"
    var2="varable2"
    
    print(f'{var1=},{var2=}')
    print(f'{var1=}\n{var2=}')
    ```

  - 结果:

    - ```text
      var1='varable1',var2='varable2'
      var1='varable1'
      var2='varable2'
      ```

    - 可见,我们不再需要重复打印变量名,输出结果自带变量值的归属

## 日志

- [日志常用指引 — Python 3.11.1 文档](https://docs.python.org/zh-cn/3/howto/logging.html)



