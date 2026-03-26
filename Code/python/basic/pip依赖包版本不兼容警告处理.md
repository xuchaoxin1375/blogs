[toc]

## abstract

```bash
/home/opcxxu/miniforge3/lib/python3.13/site-packages/requests/__init__.py:113: RequestsDependencyWarning: urllib3 (2.6.3) or chardet (7.3.0)/charset_normalizer (3.4.6) doesn't match a supported version!
  warnings.warn(
```

这个警告本质是 **依赖版本不兼容（dependency mismatch）**，来自
requests 对其底层库版本的检查。

你的环境里版本是：

| 库                 | 当前版本 | 问题                           |
| ------------------ | -------- | ------------------------------ |
| urllib3            | 2.6.3    | ❌ 超出 requests 支持范围       |
| chardet            | 7.3.0    | ❌ 过高（requests基本不再推荐） |
| charset_normalizer | 3.4.6    | ⚠️ 可能不匹配                   |

------

### 原因解释（核心机制）

requests 依赖：

- urllib3（HTTP底层实现）
- 编码检测库：
  - chardet（旧）
  - 或 charset_normalizer（新）

但 **requests 对这些库有严格版本范围限制**，否则可能出现：

- SSL错误
- 编码解析错误
- HTTP异常

------

### 推荐解决方案（现代 & 干净）

优先方案：**统一升级 requests + 依赖**

```bash
pip install -U requests urllib3 charset_normalizer
```

然后检查：

```bash
pip show requests urllib3 charset_normalizer
```

------

### 更稳定方案（推荐生产环境）

直接让 pip 自动解决依赖：

```bash
pip install -U "requests[use_chardet_on_py3]"
```

或者彻底重装：

```bash
pip uninstall requests urllib3 chardet charset_normalizer -y
pip install requests
```

👉 这样 pip 会自动安装“兼容组合”

------

### 精确版本修复（适合你当前情况）

如果你想手动控制（推荐用于conda环境）：

```bash
pip install "urllib3<2.0"
pip install "charset_normalizer<4"
```

或者（更现代一点）：

```bash
pip install "urllib3>=2.0,<2.2"
```

------

### Conda用户更优解（强烈建议）

你路径是：

```
/home/opcxxu/miniforge3/
```

说明你在用 **conda/miniforge**

👉 用 conda 修复更稳定：

```bash
conda install requests
```

或：

```bash
conda update requests
```

------

### 一句话总结

这个 warning ≠ 立刻报错，但意味着：

👉 “你的 HTTP 栈已经不安全/不稳定了”

最推荐：

```bash
pip uninstall requests urllib3 chardet charset_normalizer -y
pip install requests
```

