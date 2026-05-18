[toc]

以:[with| 复合语句 — Python 文档](https://docs.python.org/zh-cn/3/reference/compound_stmts.html#the-with-statement)的文档为例,对于`with`语句的语法结构描述:

```python
with_stmt:          "with" ( "(" with_stmt_contents ","? ")" | with_stmt_contents ) ":" suite
with_stmt_contents: with_item ("," with_item)*
with_item:          expression ["as" target]
```

这是 Python 的**形式文法（formal grammar）**片段，用 BNF（巴科斯-诺尔范式）的变体描述 `with` 语句的语法结构。

它来自 Python 语言参考文档中的 Grammar 规范。

## 逐行解读

| 产生式               | 含义                                                         |
| -------------------- | ------------------------------------------------------------ |
| `with_stmt`          | `with` 语句的完整定义：关键字 `with` 后面跟带括号或不带括号的内容，然后是 `:` 和代码块 |
| `with_stmt_contents` | 一个或多个 `with_item`，用逗号分隔                           |
| `with_item`          | 一个表达式，可选地跟 `as target`                             |

## 符号约定

| 符号          | 含义                          |
| ------------- | ----------------------------- |
| `""` 中的文本 | 字面量关键字/符号             |
| `|`           | 或（二选一）                  |
| `[]`          | 可选（零次或一次）            |
| `()` 在规则中 | 分组                          |
| `*`           | 重复零次或多次                |
| `?`           | 可选（同 `[]`，PEG 风格写法） |

## 它描述的两种合法形式

```python
# 不带括号
with expr1 as x, expr2 as y:
    ...

# 带括号（Python 3.10+，允许换行和尾逗号）
with (
    expr1 as x,
    expr2 as y,
):
    ...
```

括号形式的引入（PEP 617 新解析器带来的能力）解决了多资源 `with` 语句无法跨行书写的问题。`","?` 表示括号内允许尾随逗号（trailing comma），与函数参数、import 语句的风格一致。