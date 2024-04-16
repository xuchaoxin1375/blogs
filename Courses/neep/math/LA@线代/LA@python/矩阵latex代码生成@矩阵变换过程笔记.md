[toc]

# 简易实现

## 导包@常量准备


```python
import re
import numpy as np
from functools import reduce
ddots = r'\ddots'
cdots = r'\cdots'
vdots = r'\vdots'
pass_strs=[cdots, vdots,ddots,""]
type = "v"+"matrix"
begin = r"\begin{"+type+"}"
end = r"\end{"+type+"}"

nrows=6
ncols=6
size = [nrows,ncols]
# s = reduce(lambda x, y: x*y, size)
s=nrows*ncols

# 整形元素矩阵(arange()的参数是整数时,产生的时整形元素;参数是浮点数时,则产生浮点数矩阵)
mat = np.arange(s).reshape(size)
# 浮点型元素的矩阵(numpy默认为浮点型)
# mat=np.ones(size)
```

## 一般数字阵🎈



```python
# for i in range(len(mat)-1):
#     mat[i+1,i]+=1
# mat[0,-1]=1
# mat=mat.astype('U7')

# dots_line=4-1
# mat[:, dots_line] = cdots
# new_parts=np.where(mat[dots_line] == cdots, "", vdots)
# mat[dots_line]=new_parts

```

```
    \begin{pmatrix}
        3&  1&  -1& 2   \\
        -5& 1&  3&  -4  \\
        2&  0&  1&  -1  \\
        1&  -5& 3&  -3  \\
    \end{pmatrix}
    
```



## 填充你的矩阵😊



```python
# mat=np.array(
#     [[1],
#      [0],
#      [0],
#      [0]
#      ]
# )
mat=np.array(
    [[3,1,-1,2],
     [-5,1,3,-4],
     [2,0,1,-1],
     [1,-5,3,-3]]
)

# mat=np.array(
#     [
#         [1,0,1],
#         [1,1,0],
#         [0,1,1],
#         # [0,0,0]
#     ]
# )

# mat = np.array([[]])
integer = False
integer = True
# print(begin,end)# (str(begin),end)


# 使用元素遍历的方案,打印矩阵(行列式的latex代码)

def print_num_matrix(mat,integer=True):
    print(begin)
    for i in mat:
        l = [
        str(j) if not integer else str(int(float(j)) if j not in pass_strs else j)
        for j in i
    ]
        line = "&\t".join(l) + "\t" + r"\\"
        print("\t" + line)
    print(end)

print_num_matrix(mat)
```

```
    \begin{vmatrix}
        3&  1&  -1& 2   \\
        -5& 1&  3&  -4  \\
        2&  0&  1&  -1  \\
        1&  -5& 3&  -3  \\
    \end{vmatrix}
    
```




```python

mat
```



```
    array([[ 3,  1, -1,  2],
           [-5,  1,  3, -4],
           [ 2,  0,  1, -1],
           [ 1, -5,  3, -3]])
```




```python
#交换某两列(0,1)
mat[:,[0,1]]=mat[:,[1,0]]
mat[1]-=mat[0]
mat[3]+=5*mat[0]
mat
```



```
    array([[ 1,  3, -1,  2],
           [ 0, -8,  4, -6],
           [ 0,  2,  1, -1],
           [ 0, 16, -2,  7]])
```




```python
mat[[1,2]]=mat[[2,1]]
print_num_matrix(mat)
```

```
    \begin{vmatrix}
        1&  3&  -1& 2   \\
        0&  2&  1&  -1  \\
        0&  -8& 4&  -6  \\
        0&  16& -2& 7   \\
    \end{vmatrix}
    
```




```python
mat[2]+=4*mat[1]
mat[3]-=8*mat[1]
mat
print_num_matrix(mat)
```

```
    \begin{vmatrix}
        1&  3&  -1& 2   \\
        0&  2&  1&  -1  \\
        0&  0&  8&  -10 \\
        0&  0&  -10&    15  \\
    \end{vmatrix}
```

​    


```python
mat=mat.astype('float64')
mat[2]/=2
mat[3]/=5
print_num_matrix(mat)
```

```
    \begin{vmatrix}
        1&  3&  -1& 2   \\
        0&  2&  1&  -1  \\
        0&  0&  4&  -5  \\
        0&  0&  -2& 3   \\
    \end{vmatrix}
```

​    


```python
mat[3]+=mat[2]/2
print_num_matrix(mat)
```

```
    \begin{vmatrix}
        1&  3&  -1& 2   \\
        0&  2&  1&  -1  \\
        0&  0&  4&  -5  \\
        0&  0&  0&  0   \\
    \end{vmatrix}
```

​    

# 使用array-to-latex库🎈
- 介绍:[array-to-latex · PyPI](https://pypi.org/project/array-to-latex/)


```python
import array_to_latex as a2l
a2l.to_ltx(mat)
```

```
    \begin{bmatrix}
      1.00 &  3.00 & -1.00 &  2.00\\
      0.00 &  2.00 &  1.00 & -1.00\\
      0.00 &  0.00 &  4.00 & -5.00\\
      0.00 &  0.00 &  0.00 &  0.50
    \end{bmatrix}
```

​    

# 其他矩阵

## 单位阵生成@对角阵🎈



```python

mat=np.identity(4)
#是否转换为整型
mat=mat.astype('int32')
# ddots="*"
# dia=[1,2,3]
#微调对角阵内容(还可以加行/列,不一定要是方阵)
# dia = [1, ddots, 1, 'k', 1, ddots, 1]
# dia = [1, ddots, 1, ddots, 1, ddots, 1]
# dia_cnt = list(range(1, len(dia)+1))
# print(np.diag(dia_cnt))
# dia_width=list(map(lambda x: format(str(x), "^8"),dia))
# mat=np.diag([1,ddots,1,'k',1,ddots,1])
# mat=np.full((4,4),format("","7"))
# mat = np.diag(dia)
#插入一列
# mat=np.insert(mat,3,[0,0,0],axis=1)
#插入一行
# mat=np.insert(mat,3,[0,0,0],axis=0)
# mat[3-1, 5-1] = "k"
# mat[3-1, 3-1] = cdots
# mat[3-1, 3-1] = vdots
mat = mat.astype('U7')
mat[2,:]=vdots
mat[:,2]=cdots
mat[2,2]=ddots

# print(mat, "\n"*3)
#
# print(begin)
# for i in mat:
#     l = [str(j) if j!=0 else " " for j in i]
#     line = "&\t".join(l)+"\t"+r"\\"
#     print("\t"+line)
# print(end)
#
print(begin)
for i in mat:
    show_zero=False
    show_zero=True
    l = [format(str(j), "^2") if j != 0 or show_zero else " " for j in i]
    line = "&".join(l)+"\t"*0+r"\\"
    print("\t"+line)
print(end)
```

## 字母阵



```python

char = r'\alpha'
m, n = 5,5
size = [m, n]
cell_gap = 8
# mat=np.arange(size[0]**2).reshape(size)
#但下标
mat = np.array([["{}{}".format("", j) for j in range(1, n+1)]
               for i in range(1, m+1)], dtype='U7')
#双下标
# mat = np.array([["{}{}".format(i, j) for j in range(1, n+1)]
#                for i in range(1, m+1)], dtype='U7')
# 这里设定矩阵元素类型为长度不超过7的字符串(设定的过短会导致长字符被截断)

dots_line=4-1
mat[:, dots_line] = cdots
##deprecated: # mat[3-1] = vdots
new_parts=np.where(mat[dots_line] == cdots, "", vdots)
mat[3-1]=new_parts
#下标字母化
mat[-1]='n'
mat[:,-1]='n'

print(mat, "\n"*3)
print(begin)
for i in mat:
    l = [format(char+'_{'+str(j)+'}', "<"+str(cell_gap)) if str(j)
         not in pass_strs else format(str(j), "<"+str(cell_gap)) for j in i]
    line = "&".join(l)+"\t"+r"\\"
    print("\t"+line)
print(end)
```

## 向量表示法@向量阵



```python

char0='A'
char = 'B'
m, n = 4,4
size = [m, n]
cell_gap = 8
# mat=np.arange(size[0]**2).reshape(size)
mat = np.array([["{}".format(i) for i in range(1, n+1)] for j in range(1,m+1)], dtype='U7')
# 这里设定矩阵元素类型为长度不超过7的字符串(设定的过短会导致长字符被截断)
mat[:, 3-1] = cdots
# mat[3-1] = vdots
# np.where(mat[3] == cdots, "", mat)
# line_k=mat[2]
# new_parts=np.where(mat[3-1] == cdots, "", vdots)
# mat[3-1]=new_parts
# print(mat,"🎈")

# mat[2,0]=vdots
mat2=np.array([["{}".format(j) for i in range(1, n+1)] for j in range(1,m+1)], dtype='U7')
print(mat,"\n","-"*20 ,"\n"*2)
print(begin)
r=0
for i in mat:
    l = [format(char0+'_{'+ mat2[r, c]+'}'+char+'_{'+mat[r, c]+'}', "<"+str(cell_gap)) if str(mat[r,c])
         not in [cdots, vdots,ddots] else format(mat[r, c], "<"+str(cell_gap)) for c in range(len(i))]
    line = "&".join(l)+"\t"+r"\\"
    r+=1
    print("\t"+line)
print(end)
```