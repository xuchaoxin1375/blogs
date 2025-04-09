[toc]





## 日志

- [日志常用指引 — Python 文档](https://docs.python.org/zh-cn/3/howto/logging.html)

## 案例

- ```python
  import logging
  
  # 配置日志记录器
  logging.basicConfig(filename='example.log', level=logging.DEBUG,
                      format='%(asctime)s %(levelname)s: %(message)s')
  
  def add(a, b):
      """
      Returns the sum of two numbers.
      """
      logging.debug("Adding %s and %s", a, b)
      result = a + b
      logging.debug("Result: %s", result)
      return result
  
  def multiply(a, b):
      """
      Returns the product of two numbers.
      """
      logging.debug("Multiplying %s and %s", a, b)
      result = a * b
      logging.debug("Result: %s", result)
      return result
  
  # 使用函数记录日志
  x = 2
  y = 3
  logging.info("Starting calculation with %s and %s", x, y)
  result1 = add(x, y)
  result2 = multiply(x, y)
  logging.info("Calculation finished: %s %s", result1, result2)
  ```

- 在这个例子中，我们首先使用`basicConfig`函数配置了一个日志记录器，将日志记录到文件`example.log`中，设置日志级别为`DEBUG`，并指定了日志记录的格式。

- 然后，定义了两个函数`add`和`multiply`，这些函数在执行时会记录一些调试信息。最后，我们在主程序中调用这些函数，并使用`info`级别记录了一条日志，指示程序已经开始计算。

- 同时，在当前工作目录下也会生成一个名为`example.log`的日志文件，其中包含所有的日志记录：

  ```
  2023-04-11 11:28:49,675 INFO: Starting calculation with 2 and 3
  2023-04-11 11:28:49,675 DEBUG: Adding 2 and 3
  2023-04-11 11:28:49,675 DEBUG: Result: 5
  2023-04-11 11:28:49,675 DEBUG: Multiplying 2 and 3
  2023-04-11 11:28:49,675 DEBUG: Result: 6
  2023-04-11 11:28:49,675 INFO: Calculation finished: 5 6
  
  ```

  这个例子演示了如何使用`logging`模块记录日志，以及如何配置日志记录器和指定日志级别。

