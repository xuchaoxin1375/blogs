## sed match

## linux grep/sed 匹配不起作用

- 在某些情况下,sed和grep的可能无法正常工作
- 其中,我认为最大的可能就是编码或者控制字符的问题

### 匹配异常案例

> 我在Windows端用powershell的函数创建了一个包含多个时间戳的文件

文件内容表面上看是:(cat )

```
��L82637834872061501239
L83637834872061511251
L84637834872061521729
L85637834872061531253
L86637834872061531253
L87637834872061543390
L88637834872061543390
L89637834872061553069
L90637834872061564965
L91637834872061574806
L92637834872061584797
L93637834872061595208
L94637834872061597156
L95637834872061607141
L96637834872061617478
L97637834872061627133%
```
实际内容(cat -A)确是
```
M-^?M-~L^@8^@2^@6^@3^@7^@8^@3^@4^@8^@7^@2^@0^@6^@1^@5^@0^@1^@2^@3^@9^@^M^@$
^@L^@8^@3^@6^@3^@7^@8^@3^@4^@8^@7^@2^@0^@6^@1^@5^@1^@1^@2^@5^@1^@^M^@$
^@L^@8^@4^@6^@3^@7^@8^@3^@4^@8^@7^@2^@0^@6^@1^@5^@2^@1^@7^@2^@9^@^M^@$
^@L^@8^@5^@6^@3^@7^@8^@3^@4^@8^@7^@2^@0^@6^@1^@5^@3^@1^@2^@5^@3^@^M^@$
^@L^@8^@6^@6^@3^@7^@8^@3^@4^@8^@7^@2^@0^@6^@1^@5^@3^@1^@2^@5^@3^@^M^@$
^@L^@8^@7^@6^@3^@7^@8^@3^@4^@8^@7^@2^@0^@6^@1^@5^@4^@3^@3^@9^@0^@^M^@$
^@L^@8^@8^@6^@3^@7^@8^@3^@4^@8^@7^@2^@0^@6^@1^@5^@4^@3^@3^@9^@0^@^M^@$
^@L^@8^@9^@6^@3^@7^@8^@3^@4^@8^@7^@2^@0^@6^@1^@5^@5^@3^@0^@6^@9^@^M^@$
^@L^@9^@0^@6^@3^@7^@8^@3^@4^@8^@7^@2^@0^@6^@1^@5^@6^@4^@9^@6^@5^@^M^@$
^@L^@9^@1^@6^@3^@7^@8^@3^@4^@8^@7^@2^@0^@6^@1^@5^@7^@4^@8^@0^@6^@^M^@$
^@L^@9^@2^@6^@3^@7^@8^@3^@4^@8^@7^@2^@0^@6^@1^@5^@8^@4^@7^@9^@7^@^M^@$
^@L^@9^@3^@6^@3^@7^@8^@3^@4^@8^@7^@2^@0^@6^@1^@5^@9^@5^@2^@0^@8^@^M^@$
^@L^@9^@4^@6^@3^@7^@8^@3^@4^@8^@7^@2^@0^@6^@1^@5^@9^@7^@1^@5^@6^@^M^@$
^@L^@9^@5^@6^@3^@7^@8^@3^@4^@8^@7^@2^@0^@6^@1^@6^@0^@7^@1^@4^@1^@^M^@$
^@L^@9^@6^@6^@3^@7^@8^@3^@4^@8^@7^@2^@0^@6^@1^@6^@1^@7^@4^@7^@8^@^M^@$
^@L^@9^@7^@6^@3^@7^@8^@3^@4^@8^@7^@2^@0^@6^@1^@6^@2^@7^@1^@3^@3^@%
```
### 正常内容
```
L82637834872061501239^M$
L83637834872061511251^M$
L84637834872061521729^M$
L85637834872061531253^M$
L86637834872061531253^M$
L87637834872061543390^M$
L88637834872061543390^M$
L89637834872061553069^M$
L90637834872061564965^M$
L91637834872061574806^M$
L92637834872061584797^M$
L93637834872061595208^M$
L94637834872061597156^M$
L95637834872061607141^M$
L96637834872061617478^M$
```
## 总结
* 使用linux的grep/sed的时候,当一些基本的正则匹配无法达到预期效果,可以通过`cat -A`来检查文件中的控制字符,这种异常经常发生在windows端的文件传输到linux上处理的时候;(尤其是通过windows的某些脚本生成的文本,更容易含有看不见的控制符号,从而影响sed/grep等工具的工作效果.
* 大该是因为,powershell是面向对象的shell,某些输出会出人意料
### 可能的解决办法
- 如果情况如上所述,那么可以考虑使用powershell 的cat 命令来清洗多余的控制符号(另存清洗后的文件),例如`cat file> washedVersionFile`
