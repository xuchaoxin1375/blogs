## jetBrain IDEA(pycharm)

- [Python | IntelliJ IDEA (jetbrains.com)](https://www.jetbrains.com/help/idea/plugin-overview.html)

## python_pep

-  [One-line Docstrings](https://peps.python.org/pep-0257/#one-line-docstrings)

  - One-liners are for really obvious cases. They should really fit on one line. For example:

    ```py
    def kos_root():
        """Return the pathname of the KOS root directory."""
        global _kos_root
        if _kos_root: return _kos_root
        ...
    ```

    Notes:

    - Triple quotes are used even though the string fits on one line. This makes it easy to later expand it.

    - The closing quotes are on the same line as the opening quotes. This looks better for one-liners.

    - There’s no blank line either before or after the docstring.

    - The docstring is a phrase ending in a period. It prescribes the function or method’s effect as a command (“Do this”, “Return that”), not as a description;

      -  e.g. don’t write “Returns the pathname …”.(这个例子中就不是以一个词组结尾的)

    - The one-line docstring should NOT be a “signature” reiterating the function/method parameters (which can be obtained by introspection). 

      - Don’t do:

      ```
      def function(a, b):
          """function(a, b) -> list"""
      ```

      - This type of docstring is only appropriate for C functions (such as built-ins), where **introspection** is not possible. 
      - However, the nature of the *return value* cannot be determined by **introspection**[^introspection], 
        - so it should be mentioned. (返回值的情况无法被推导,您需要在概述中提一下)
        - The preferred form for such a docstring would be something like:

      ```
      def function(a, b):
          """Do X and return a list."""
      ```

      (Of course “Do X” should be replaced by a useful description!)

      [^introspection]: Introspection is an ability to determine the type of an object at runtime. Everything in python is an object. Every object in Python may have attributes and methods. By using introspection, we can dynamically examine python objects.

      Code Introspection is used for examining the classes, methods, objects, modules, keywords and get information about them so that we can utilize it. 

      Introspection **reveals useful information** about your **program’s objects.**

       Python, being a dynamic, object-oriented programming language, provides tremendous introspection support. 

      Python’s support for introspection runs deep and wide throughout the language.

      .They are:
      1.**type() :** This function returns the type of an object.

      ```
      # Python program showing``# a use of type function`` ` `import` `math`` ` `# print type of math``print``(``type``(math))`` ` `# print type of 1 ``print``(``type``(``1``))`` ` `# print type of "1"``print``(``type``(``"1"``))`` ` `# print type of rk``rk ``=``[``1``, ``2``, ``3``, ``4``, ``5``, ``"radha"``]`` ` `print``(``type``(rk))``print``(``type``(rk[``1``]))``print``(``type``(rk[``5``]))
      ```

      **Output:**

      ```python
      <class 'module'>
      <class 'int'>
      <class 'str'>
      <class 'list'>
      <class 'int'>
      <class 'str'>
      ```

      .**dir() :**This function return **list of methods and attributes** <u>associated with that object</u>.

      ```
      
      # Python program showing
      # a use of dir() function
        
      import math
      rk =[1, 2, 3, 4, 5]
        
      # print methods and attributes of rk
      print(dir(rk))
      
      
      rk =(1, 2, 3, 4, 5)  
      # print methods and attributes of rk
      print(dir(rk))
      
      rk ={1, 2, 3, 4, 5}  
      print(dir(rk))
      print(dir(math))
      ```

      **Output:**

      ```python
      ['__add__', '__class__', '__contains__', '__delattr__', '__delitem__', '__dir__', '__doc__', '__eq__', '__format__', '__ge__', '__getattribute__', '__getitem__', '__gt__', '__hash__', '__iadd__', '__imul__', '__init__', '__iter__', '__le__', '__len__', '__lt__', '__mul__', '__ne__', '__new__', '__reduce__', '__reduce_ex__', '__repr__', '__reversed__', '__rmul__', '__setattr__', '__setitem__', '__sizeof__', '__str__', '__subclasshook__', 'append', 'clear', 'copy', 'count', 'extend', 'index', 'insert', 'pop', 'remove', 'reverse', 'sort']
      ['__add__', '__class__', '__contains__', '__delattr__', '__dir__', '__doc__', '__eq__', '__format__', '__ge__', '__getattribute__', '__getitem__', '__getnewargs__', '__gt__', '__hash__', '__init__', '__iter__', '__le__', '__len__', '__lt__', '__mul__', '__ne__', '__new__', '__reduce__', '__reduce_ex__', '__repr__', '__rmul__', '__setattr__', '__sizeof__', '__str__', '__subclasshook__', 'count', 'index']
      ['__doc__', '__loader__', '__name__', '__package__', '__spec__', 'acos', 'acosh',
      ```

    - .**id() :**This function returns a special id of an object.

      ```
      
      # Python program showing
      # a use of id() function
         
      import math
      a =[1, 2, 3, 4, 5]
         
      # print id of a
      print(id(a))
      b =(1, 2, 3, 4, 5)
         
      # print id of b
      print(id(b))
      c ={1, 2, 3, 4, 5}
         
      # print id of c
      print(id(c))
      print(id(math))
      ```

      **Output:**

      ```
      139787756828232
      139787757942656
      139787757391432
      139787756815768
      ```

-  [Multi-line Docstrings](https://peps.python.org/pep-0257/#multi-line-docstrings)

 It is best to list each argument on a separate line. For example:

```py
def complex(real=0.0, imag=0.0):
    """Form a complex number.

    Keyword arguments:
    real -- the real part (default 0.0)
    imag -- the imaginary part (default 0.0)
    """
    # your codes:
    if imag == 0.0 and real == 0.0:
        return complex_zero
    ......
```