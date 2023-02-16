[toc]

## refs

- [str() vs repr() in Python - GeeksforGeeks](https://www.geeksforgeeks.org/str-vs-repr-in-python/)



## python命令行文档

- [3.11.1 Documentation (python.org)](https://docs.python.org/3/)

###  python --help

-  `python --help`

- ```bash
  usage: D:\Program Files\Python310\python.exe [option] ... [-c cmd | -m mod | file | -] [arg] ...
  Options and arguments (and corresponding environment variables):
  -b     : issue warnings about str(bytes_instance), str(bytearray_instance)
           and comparing bytes/bytearray with str. (-bb: issue errors)
  -B     : don't write .pyc files on import; also PYTHONDONTWRITEBYTECODE=x
  -c cmd : program passed in as string (terminates option list)
  -d     : turn on parser debugging output (for experts only, only works on
           debug builds); also PYTHONDEBUG=x
  -E     : ignore PYTHON* environment variables (such as PYTHONPATH)
  -h     : print this help message and exit (also -? or --help)
  -i     : inspect interactively after running script; forces a prompt even
           if stdin does not appear to be a terminal; also PYTHONINSPECT=x
  -I     : isolate Python from the user's environment (implies -E and -s)
  -m mod : run library module as a script (terminates option list)
  -O     : remove assert and __debug__-dependent statements; add .opt-1 before
           .pyc extension; also PYTHONOPTIMIZE=x
  -OO    : do -O changes and also discard docstrings; add .opt-2 before
           .pyc extension
  -q     : don't print version and copyright messages on interactive startup
  -s     : don't add user site directory to sys.path; also PYTHONNOUSERSITE
  -S     : don't imply 'import site' on initialization
  -u     : force the stdout and stderr streams to be unbuffered;
           this option has no effect on stdin; also PYTHONUNBUFFERED=x
  -v     : verbose (trace import statements); also PYTHONVERBOSE=x
           can be supplied multiple times to increase verbosity
  -V     : print the Python version number and exit (also --version)
           when given twice, print more information about the build
  -W arg : warning control; arg is action:message:category:module:lineno
           also PYTHONWARNINGS=arg
  -x     : skip first line of source, allowing use of non-Unix forms of #!cmd
  -X opt : set implementation-specific option. The following options are available:
           -X faulthandler: enable faulthandler
           -X showrefcount: output the total reference count and number of used
               memory blocks when the program finishes or after each statement in the
               interactive interpreter. This only works on debug builds
           -X tracemalloc: start tracing Python memory allocations using the
               tracemalloc module. By default, only the most recent frame is stored in a
               traceback of a trace. Use -X tracemalloc=NFRAME to start tracing with a
               traceback limit of NFRAME frames
           -X importtime: show how long each import takes. It shows module name,
               cumulative time (including nested imports) and self time (excluding
               nested imports). Note that its output may be broken in multi-threaded
               application. Typical usage is python3 -X importtime -c 'import asyncio'
           -X dev: enable CPython's "development mode", introducing additional runtime
               checks which are too expensive to be enabled by default. Effect of the
               developer mode:
                  * Add default warning filter, as -W default
                  * Install debug hooks on memory allocators: see the PyMem_SetupDebugHooks()
                    C function
                  * Enable the faulthandler module to dump the Python traceback on a crash
                  * Enable asyncio debug mode
                  * Set the dev_mode attribute of sys.flags to True
                  * io.IOBase destructor logs close() exceptions
           -X utf8: enable UTF-8 mode for operating system interfaces, overriding the default
               locale-aware mode. -X utf8=0 explicitly disables UTF-8 mode (even when it would
               otherwise activate automatically)
           -X pycache_prefix=PATH: enable writing .pyc files to a parallel tree rooted at the
               given directory instead of to the code tree
           -X warn_default_encoding: enable opt-in EncodingWarning for 'encoding=None'
  --check-hash-based-pycs always|default|never:
      control how Python invalidates hash-based .pyc files
  file   : program read from script file
  -      : program read from stdin (default; interactive mode if a tty)
  arg ...: arguments passed to program in sys.argv[1:]
  
  Other environment variables:
  PYTHONSTARTUP: file executed on interactive startup (no default)
  PYTHONPATH   : ';'-separated list of directories prefixed to the
                 default module search path.  The result is sys.path.
  PYTHONHOME   : alternate <prefix> directory (or <prefix>;<exec_prefix>).
                 The default module search path uses <prefix>\python{major}{minor}.
  PYTHONPLATLIBDIR : override sys.platlibdir.
  PYTHONCASEOK : ignore case in 'import' statements (Windows).
  PYTHONUTF8: if set to 1, enable the UTF-8 mode.
  PYTHONIOENCODING: Encoding[:errors] used for stdin/stdout/stderr.
  PYTHONFAULTHANDLER: dump the Python traceback on fatal errors.
  PYTHONHASHSEED: if this variable is set to 'random', a random value is used
     to seed the hashes of str and bytes objects.  It can also be set to an
     integer in the range [0,4294967295] to get hash values with a
     predictable seed.
  PYTHONMALLOC: set the Python memory allocators and/or install debug hooks
     on Python memory allocators. Use PYTHONMALLOC=debug to install debug
     hooks.
  PYTHONCOERCECLOCALE: if this variable is set to 0, it disables the locale
     coercion behavior. Use PYTHONCOERCECLOCALE=warn to request display of
     locale coercion and locale compatibility warnings on stderr.
  PYTHONBREAKPOINT: if this variable is set to 0, it disables the default
     debugger. It can be set to the callable of your debugger of choice.
  PYTHONDEVMODE: enable the development mode.
  PYTHONPYCACHEPREFIX: root directory for bytecode cache (pyc) files.
  PYTHONWARNDEFAULTENCODING: enable opt-in EncodingWarning for 'encoding=None'.
  ```

  

## python help函数

**help**(*request*)

- Invoke the built-in help system. (This function is intended for interactive use.) If no argument is given, the interactive help system starts on the interpreter console. If the argument is a string, then the string is looked up as the name of a module, function, class, method, keyword, or documentation topic, and a help page is printed on the console. If the argument is any other kind of object, a help page on the object is generated.

- Note that if a slash(/) appears in the parameter list of a function when invoking [`help()`](https://docs.python.org/3/library/functions.html#help), it means that the parameters prior to the slash are positional-only. For more info, see [the FAQ entry on positional-only parameters](https://docs.python.org/3/faq/programming.html#faq-positional-only-arguments).

- This function is added to the built-in namespace by the [`site`](https://docs.python.org/3/library/site.html#module-site) module.

### 进入帮助系统(简练的python文档系统)

- ```python
  >>> help()
  
  Welcome to Python 3.9's help utility!
  
  If this is your first time using Python, you should definitely check out
  the tutorial on the Internet at https://docs.python.org/3.9/tutorial/.
  
  Enter the name of any module, keyword, or topic to get help on writing
  Python programs and using Python modules.  To quit this help utility and
  return to the interpreter, just type "quit".
  
  To get a list of available modules, keywords, symbols, or topics, type
  "modules", "keywords", "symbols", or "topics".  Each module also comes
  with a one-line summary of what it does; to list the modules whose name
  or summary contain a given string such as "spam", type "modules spam".
  
  help>
  ```

- To get a list of available modules, keywords, symbols, or topics, type "modules", "keywords", "symbols", or "topics".  Each module also comes with a one-line summary of what it does; to list the modules whose name or summary contain a given string such as "spam", type "modules spam".

### 查阅内置模块(函数/异常/对象)

- `help("builtins")`

- 通常传入字符串给`help()`函数更有可能查询成功

- 例如`help(builtins)`会报错,但是`help("builtins")`则可以正确工作

- 或者进入帮助交互系统

  ```python
  help>  builtins
  Help on built-in module builtins:
  
  NAME
      builtins - Built-in functions, exceptions, and other objects.
  
  DESCRIPTION
      Noteworthy: None is the `nil' object; Ellipsis represents `...' in slices.
  
  CLASSES
      object
          BaseException
              Exception
                  ArithmeticError
                      FloatingPointError
                      OverflowError
                      ZeroDivisionError
                  AssertionError
                  AttributeError
                  BufferError
                  EOFError
                  ImportError
                      ModuleNotFoundError
                  LookupError
                      IndexError
                      KeyError
                  MemoryError
                  NameError
                      UnboundLocalError
                  OSError
                      BlockingIOError
                      ChildProcessError
                      ConnectionError
                          BrokenPipeError
                          ConnectionAbortedError
                          ConnectionRefusedError
                          ConnectionResetError
                      FileExistsError
                      FileNotFoundError
                      InterruptedError
                      IsADirectoryError
                      NotADirectoryError
                      PermissionError
                      ProcessLookupError
                      TimeoutError
                  ReferenceError
                  RuntimeError
                      NotImplementedError
  .....
  
  	sorted(iterable, /, *, key=None, reverse=False)
          Return a new list containing all items from the iterable in ascending order.
  
          A custom key function can be supplied to customize the sort order, and the
          reverse flag can be set to request the result in descending order.
  
      sum(iterable, /, start=0)
          Return the sum of a 'start' value (default: 0) plus an iterable of numbers
  
          When the iterable is empty, return the start value.
          This function is intended specifically for use with numeric values and may
          reject non-numeric types.
  
      vars(...)
          vars([object]) -> dictionary
  
          Without arguments, equivalent to locals().
          With an argument, equivalent to object.__dict__.
  
  DATA
      Ellipsis = Ellipsis
      False = False
      None = None
      NotImplemented = NotImplemented
      True = True
      __debug__ = True
      copyright = Copyright (c) 2001-2021 Python Software Foundati...ematisc...
      credits =     Thanks to CWI, CNRI, BeOpen.com, Zope Corpor...opment.  ...
      exit = Use exit() or Ctrl-Z plus Return to exit
      help = Type help() for interactive help, or help(object) for help abou...
      license = See https://www.python.org/psf/license/
      quit = Use quit() or Ctrl-Z plus Return to exit
  
  FILE
      (built-in)
  
  ```

### 内置类型

- ```python
  help> TYPES
  The standard type hierarchy
  ***************************
  
  Below is a list of the types that are built into Python.
  ...
  ...
   Python distinguishes between integers, floating point numbers, and
     complex numbers:
  
     "numbers.Integral"
        These represent elements from the mathematical set of integers
        (positive and negative).
  
        There are two types of integers:
  
        Integers ("int")
           These represent numbers in an unlimited range, subject to
           available (virtual) memory only.  For the purpose of shift
           and mask operations, a binary representation is assumed, and
           negative numbers are represented in a variant of 2Æs
           complement which gives the illusion of an infinite string of
           sign bits extending to the left.
  
        Booleans ("bool")
           These represent the truth values False and True.  The two
           objects representing the values "False" and "True" are the
           only Boolean objects. The Boolean type is a subtype of the
           integer type, and Boolean values behave like the values 0 and
           1, respectively, in almost all contexts, the exception being
           that when converted to a string, the strings ""False"" or
           ""True"" are returned, respectively.
  
        The rules for integer representation are intended to give the
        most meaningful interpretation of shift and mask operations
        involving negative integers.
  
     "numbers.Real" ("float")
        These represent machine-level double precision floating point
        numbers. You are at the mercy of the underlying machine
        architecture (and C or Java implementation) for the accepted
        range and handling of overflow. Python does not support single-
        precision floating point numbers; the savings in processor and
        memory usage that are usually the reason for using these are
        dwarfed by the overhead of using objects in Python, so there is
        no reason to complicate the language with two kinds of floating
        point numbers.
  
     "numbers.Complex" ("complex")
        These represent complex numbers as a pair of machine-level
        double precision floating point numbers.  The same caveats apply
        as for floating point numbers. The real and imaginary parts of a
        complex number "z" can be retrieved through the read-only
        attributes "z.real" and "z.imag".
  ....
  
  ```


### 区分大小写

- 例如

  - ```python
    help> types
    #不同于
    help> TYPES
    ```

    - ```
      
      help> types
      
      Help on module types:
      
      NAME
          types - Define names for built-in types that aren't directly accessible as a builtin.
      
      MODULE REFERENCE
          https://docs.python.org/3.10/library/types.html
      
          The following documentation is automatically generated from the Python
          source files.  It may be incomplete, incorrect or include features that
          are considered implementation detail and may vary between Python
          implementations.  When in doubt, consult the module reference at the
          location listed above.
      
      CLASSES
          builtins.object
              builtins.NoneType
              builtins.NotImplementedType
      
      ```

    - ```
      help> TYPES
      The standard type hierarchy
      ***************************
      
      Below is a list of the types that are built into Python.
      ...
      ...
      ```

      

    

### 查看可用的帮助话题

- ```python
  help> topics
  
  Here is a list of available topics.  Enter any topic name to get more help.
  
  ASSERTION           DELETION            LOOPING             SHIFTING
  ASSIGNMENT          DICTIONARIES        MAPPINGMETHODS      SLICINGS
  ATTRIBUTEMETHODS    DICTIONARYLITERALS  MAPPINGS            SPECIALATTRIBUTES
  ATTRIBUTES          DYNAMICFEATURES     METHODS             SPECIALIDENTIFIERS
  AUGMENTEDASSIGNMENT ELLIPSIS            MODULES             SPECIALMETHODS
  BASICMETHODS        EXCEPTIONS          NAMESPACES          STRINGMETHODS
  BINARY              EXECUTION           NONE                STRINGS
  BITWISE             EXPRESSIONS         NUMBERMETHODS       SUBSCRIPTS
  BOOLEAN             FLOAT               NUMBERS             TRACEBACKS
  CALLABLEMETHODS     FORMATTING          OBJECTS             TRUTHVALUE
  CALLS               FRAMEOBJECTS        OPERATORS           TUPLELITERALS
  CLASSES             FRAMES              PACKAGES            TUPLES
  CODEOBJECTS         FUNCTIONS           POWER               TYPEOBJECTS
  COMPARISON          IDENTIFIERS         PRECEDENCE          TYPES
  COMPLEX             IMPORTING           PRIVATENAMES        UNARY
  CONDITIONAL         INTEGER             RETURNING           UNICODE
  CONTEXTMANAGERS     LISTLITERALS        SCOPING
  CONVERSIONS         LISTS               SEQUENCEMETHODS
  DEBUGGING           LITERALS            SEQUENCES
  
  ```

### 可用的符号

- ```python
  help> symbols
  
  Here is a list of the punctuation symbols which Python assigns special meaning
  to. Enter any symbol to get more help.
  
  !=                  +                   <=                  __
  "                   +=                  <>                  `
  """                 ,                   ==                  b"
  %                   -                   >                   b'
  %=                  -=                  >=                  f"
  &                   .                   >>                  f'
  &=                  ...                 >>=                 j
  '                   /                   @                   r"
  '''                 //                  J                   r'
  (                   //=                 [                   u"
  )                   /=                  \                   u'
  *                   :                   ]                   |
  **                  <                   ^                   |=
  **=                 <<                  ^=                  ~
  *=                  <<=                 _
  ```

  

- ```python
  help> FUNCTIONS
  Functions
  *********
  
  Function objects are created by function definitions.  The only
  operation on a function object is to call it: "func(argument-list)".
  
  There are really two flavors of function objects: built-in functions
  and user-defined functions.  Both support the same operation (to call
  the function), but the implementation is different, hence the
  different object types.
  
  See Function definitions for more information.
  
  Related help topics: def, TYPES
  
  ```

### 可用模块

- ```python
  help> modules
  
  Please wait a moment while I gather a list of all available modules...
  
  IPython             brotli              matplotlib_inline   struct
  OpenSSL             bs4                 menuinst            subprocess
  __future__          builtins            mimetypes           sunau
  _abc                bz2                 mistune             symbol
  _aix_support        cProfile            mmap                symtable
  _argon2_cffi_bindings calendar            mmapfile            sys
  _ast                catalan             mmsystem            sysconfig
  _asyncio            certifi             modulefinder        tabnanny
  _bisect             cffi                more_itertools      tarfile
  .....
  
  ```

  

### 查看具体对象

- ```python
  >>> help(str)
  Help on class str in module builtins:
  
  class str(object)
   |  str(object='') -> str
   |  str(bytes_or_buffer[, encoding[, errors]]) -> str
   |
   |  Create a new string object from the given object. If encoding or
   |  errors is specified, then the object must expose a data buffer
   |  that will be decoded using the given encoding and error handler.
   |  Otherwise, returns the result of object.__str__() (if defined)
   |  or repr(object).
   |  encoding defaults to sys.getdefaultencoding().
   |  errors defaults to 'strict'.
   |
   |  Methods defined here:
   |
   |  __add__(self, value, /)
   |      Return self+value.
   |
   |  __contains__(self, key, /)
   |      Return key in self.
   |
  ```


### 查看指定对象函数的帮助

- 例如,字符串类型:str的startswith函数

- ```python
  
  help> str.startswith
  Help on method_descriptor in str:
  
  str.startswith = startswith(...)
      S.startswith(prefix[, start[, end]]) -> bool
  
      Return True if S starts with the specified prefix, False otherwise.
      With optional start, test S beginning at that position.
      With optional end, stop comparing S at that position.
      prefix can also be a tuple of strings to try.
  ```

  

## eval

- **eval**(*expression*, *globals=None*, *locals=None*)

- The arguments are **a string** and optional globals and locals. 

  - If provided, *globals* must be a **dictionary**.
  -  If provided, *locals* can be **any mapping objec**t.

  - The *expression* argument is parsed and evaluated as a Python expression (technically speaking, a condition list) using the *globals* and *locals* dictionaries as global and local namespace.
    -  If the *globals* dictionary is present and does not contain a value for the key `__builtins__`, a reference to the dictionary of the built-in module [`builtins`](https://docs.python.org/3/library/builtins.html#module-builtins) is inserted under that key before *expression* is parsed. 
    - That way you can control what builtins are available to the executed code by inserting your own `__builtins__` dictionary into *globals* before passing it to [`eval()`](https://docs.python.org/3/library/functions.html#eval). 
    - If the *locals* dictionary is omitted it defaults to the *globals* dictionary. If both dictionaries are omitted, the expression is executed with the *globals* and *locals* in the environment where [`eval()`](https://docs.python.org/3/library/functions.html#eval) is called. Note, *eval()* does not have access to the [nested scopes](https://docs.python.org/3/glossary.html#term-nested-scope) (non-locals) in the enclosing environment.

- The return value is the result of the evaluated expression. Syntax errors are reported as exceptions. Example:

- ```bash
  >>> x = 1
  >>> eval('x+1')
  2
  ```

- This function can also be used to <u>execute arbitrary code objects</u> (such as those created by [`compile()`](https://docs.python.org/3/library/functions.html#compile)). In this case, pass a code object instead of a string.

-  If the code object has been compiled with `'exec'` as the *mode* argument, [`eval()`](https://docs.python.org/3/library/functions.html#eval)'s return value will be `None`.

- Hints: dynamic execution of statements is supported by the [`exec()`](https://docs.python.org/3/library/functions.html#exec) function. The [`globals()`](https://docs.python.org/3/library/functions.html#globals) and [`locals()`](https://docs.python.org/3/library/functions.html#locals) functions return the current global and local dictionary, respectively, which may be useful to pass around for use by [`eval()`](https://docs.python.org/3/library/functions.html#eval) or [`exec()`](https://docs.python.org/3/library/functions.html#exec).

- If the given source is a string, then leading and trailing spaces and tabs are stripped.

- See [`ast.literal_eval()`](https://docs.python.org/3/library/ast.html#ast.literal_eval) for a function that can safely evaluate strings with expressions containing only literals.

- Raises an [auditing event](https://docs.python.org/3/library/sys.html#auditing) `exec` with the code object as the argument. Code compilation events may also be raised.

## repr

- **repr**(*object*)

- Return a **string** containing <u>a printable representation of an object.</u> 

  - ```bash
    >>> type(repr("ab"))
    <class 'str'>
    >>> repr("abc")
    "'abc'"
    >>> str("abc")
    'abc'
    >>> "abc"
    'abc'
    ```

- repr()和str()的返回结果都是字符串

  - 有时两者的结果十分相近,甚至一样

    - ```python
      >>> str(11.2)
      '11.2'
      >>> repr(11.2)
      '11.2'
      ```

  - 有时则很不相同

  - 取决于被计算的对象(类)是如何定义`__repr__`和`__str__`的.

- For many types, this function makes an attempt to return <u>a string that would yield an object with the same value when passed to [`eval()`](https://docs.python.org/3/library/functions.html#eval);</u>

  - ```python
    import datetime
    today = datetime.datetime.now()
    
    # Prints readable format for date-time object
    
    print (type(today),str(today))
    # prints the official format of date-time object
    print (repr(today))	
    er_today=eval(repr(today))
    print(type(er_today),er_today)
    ##
    # Python program to demonstrate writing of __repr__ and
    # __str__ for user defined classes
    
    # A user defined class to represent Complex numbers
    class Complex:
    	# Constructor
        def __init__(self, real, imag):
            self.real = real
            self.imag = imag
    
        # For call to repr(). Prints object's information
        def __repr__(self):
            return 'by __repr__🎈:Rational(%s, %s)' % (self.real, self.imag)	
    
        # For call to str(). Prints readable form
        def __str__(self):
            return 'by __str__:%s + i%s' % (self.real, self.imag)	
    
    
    # Driver program to test above
    t = Complex(10, 20)
    
    print (repr(t))
    print (str(t))
    
    ```

  - ```bash
    <class 'datetime.datetime'> 2023-01-16 20:26:06.361672
    datetime.datetime(2023, 1, 16, 20, 26, 6, 361672)
    <class 'datetime.datetime'> 2023-01-16 20:26:06.361672
    
    by __repr__🎈:Rational(10, 20)
    by __str__:10 + i20
    ```

    

-  otherwise, the representation is a string enclosed in angle brackets that contains the name of the type of the object together with additional information often including the name and address of the object. 

- A class can control what this function returns for its instances by defining a `__repr__()` method. If [`sys.displayhook()`](https://docs.python.org/3/library/sys.html#sys.displayhook) is not accessible, this function will raise [`RuntimeError`](https://docs.python.org/3/library/exceptions.html#RuntimeError).
# 内置函数源代码查看
##  某些内置函数无法直接通过IDE查看
只有一个函数头
![在这里插入图片描述](https://img-blog.csdnimg.cn/20210616110917525.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3h1Y2hhb3hpbjEzNzU=,size_16,color_FFFFFF,t_70)
可以去github cpython碰碰运气