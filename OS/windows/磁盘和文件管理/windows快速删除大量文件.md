[toc]



## 准备管理员权限

- 用管理员方式打开一个命令行(powershell或cmd)
- 因为有些目录需要管理员权限才能访问

## python法

- 启动python(交互模式)执行以下代码

### 代码:

```python
import shutil
path="将引号内容改为自己想要删除的目录(文件夹)"
shutil.rmtree(path) 
```



```bash
PS C:\Users\cxxu\Desktop> py
Python 3.10.5 (tags/v3.10.5:f377153, Jun  6 2022, 16:14:13) [MSC v.1929 64 bit (AMD64)] on win32
Type "help", "copyright", "credits" or "license" for more information.
>>> import shutil
>>>
>>> shutil.rmtree("D:/conda3")
```

