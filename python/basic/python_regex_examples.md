[toc]



## 例

### 使用正则表达式将wikipedia的段落转为markdown文本

- 从文件中读取文本

  - ```python
    # import os
    import os.path as op
    
    
    dirName = "./"
    fileName = 'tt'
    filePath = op.join(dirName, fileName)
    if op.exists(filePath):
        print("file exist!")
    else:
        print("file does not exist!")
    print("\n"*2)
    with open(fileName, encoding="utf-8") as f:
        read_data = f.read()
    # print(read_data)
    ```

  - 用于测试程序的文本内容

    - 段落1

    ```txt
    向量(Image: {\displaystyle \mathbf {y} ={\begin{bmatrix}y_{1}&y_{2}&\cdots &y_{m}\end{bmatrix}}^{\mathsf {T}}})关于标量 x的导数可以（用分子记法）写成
    (Image: {\displaystyle {\frac {\partial \mathbf {y} }{\partial x}}={\begin{bmatrix}{\frac {\partial y_{1}}{\partial x}}\\{\frac {\partial y_{2}}{\partial x}}\\\vdots \\{\frac {\partial y_{m}}{\partial x}}\\\end{bmatrix}}})
    在向量微积分中，向量(Image: \mathbf {y})关于标量(Image: x)的导数也被称为向量(Image: \mathbf {y})的切向量，(Image: {\displaystyle {\frac {\partial \mathbf {y} }{\partial x}}})。注意这里(Image: {\displaystyle \mathbf {y} :\mathbb {R} \rightarrow \mathbb {R} ^{n}})。
    例子 简单的样例包括欧式空间中的速度向量，它是位移向量（看作关于时间的函数）的切向量。更进一步而言， 加速度是速度的切向量。
    ```

    - 段落2

    ```
    假设X是一个定义在可数样本空间S上的离散随机变量 S ⊆ R，则其概率质量函数 fX(x) 为
    (Image: f_{X}(x)={\begin{cases}\Pr(X=x),&x\in S,\\0,&x\in {\mathbb  {R}}\backslash S.\end{cases}})
    注意这在所有实数上，包括那些X不可能等于的实数值上，都定义了 fX(x)。在那些X不可能等于的实数值上， fX(x)取值为0 ( x ∈ R\S，取Pr(X = x) 为0)。
    离散随机变量概率质量函数的不连续性决定了其累积分布函数也不连续。
    ```

    

  - 任务:

    - 将`(Image: xxx  )`全部替换为`$xxx$`

  - 源文本特点:

    - 这些被替换的结构相互不嵌套
    - 需要注意`xxx`可以有多重括号
    - 为了使得转换后的markdown文本更加严格,应当将潜在的`xxx`两侧的不确定数量的空格全部移除
    - 完成这个任务可以不用正则(例如replace,trim函数搭配),此处用正则作为演示
    - 包含模式对象的`finditer`等方法,获取所有匹配的子串的**索引**

- 直接运行下面代码之前,请将测试文本调整调整一下,比如将变量`test_text`改为`read_data`

  ```python
  ##
  """ 功能说明:
  由于具体文本内容的复杂性,公式中如果包含非成对的括号时,容易导致错误解析
  这种情况常见于函数取值范围/定义域,x\in[0,1),建议手动调整或者从源网页提取latex源码
  
  总的来说,本程序适合处理内联的小段公式(括号成都对的情况)
  虽然内置了集中括号替换方案,有不同的优缺点,还是建议结合手动修改
  """
  import re
  import os.path as op
  
  # dirName = "./"
  dirName = r"d:/repos/PythonLearn/scripts"#使用硬链接共享文件
  # dirName = r'd:\repos\scripts'
  fileName = 'wiki_content.md'
  filePath = op.join(dirName, fileName)
  if op.exists(filePath):
      # print("file exist!")
      pass
  else:
      print("file does not exist!🎈🎈🎈")
      with open(filePath, 'w') as f:
          print("empty file created!")
          # pass
  print("\n"*2)
  # 注意编码问题(charmap)
  file1 = "d:/repos/PythonLearn/scripts/tt"
  file2 = r"d:\repos\PythonLearn\scripts\tt"
  with open(filePath, encoding="utf-8") as f:
      read_data = f.read()
  # print(read_data)
  
  ##
  test_text_0 = r"start[edit] w(Image: f_{X}(x))x[编辑]x(Image: f_{Y}(Y))={\begin{cases}\Pr(X=x),&x\in S,\\0,&x\in {\mathbb  {R}}\backslash S.\end{cases}}  )j111"
  
  test_text2 = r"(Image: {\displaystyle {\begin{aligned}\sin x&=\sum _{n=0}^{\infty }{\frac {(-1)^{n}}{(2n+1)!}}x^{2n+1}&&=x-{\frac {x^{3}}{3!}}+{\frac {x^{5}}{5!}}-\cdots &&\forall x\\[6pt]\cos x&=\sum _{n=0}^{\infty }{\frac {(-1)^{n}}{(2n)!}}x^{2n}&&=1-{\frac {x^{2}}{2!}}+{\frac {x^{4}}{4!}}-\cdots &&\forall x\\[6pt]\tan x&=\sum _{n=1}^{\infty }{\frac {B_{2n}(-4)^{n}\left(1-4^{n}\right)}{(2n)!}}x^{2n-1}&&=x+{\frac {x^{3}}{3}}+{\frac {2x^{5}}{15}}+\cdots &&\forall x:|x|<{\frac {\pi }{2}}\\[6pt]\sec x&=\sum _{n=0}^{\infty }{\frac {(-1)^{n}E_{2n}}{(2n)!}}x^{2n}&&=1+{\frac {x^{2}}{2}}+{\frac {5x^{4}}{24}}+\cdots &&\forall x:|x|<{\frac {\pi }{2}}\\[6pt]\arcsin x&=\sum _{n=0}^{\infty }{\frac {(2n)!}{4^{n}(n!)^{2}(2n+1)}}x^{2n+1}&&=x+{\frac {x^{3}}{6}}+{\frac {3x^{5}}{40}}+\cdots &&\forall x:|x|\leq 1\\[6pt]\arccos x&={\frac {\pi }{2}}-\arcsin x\\&={\frac {\pi }{2}}-\sum _{n=0}^{\infty }{\frac {(2n)!}{4^{n}(n!)^{2}(2n+1)}}x^{2n+1}&&={\frac {\pi }{2}}-x-{\frac {x^{3}}{6}}-{\frac {3x^{5}}{40}}+\cdots &&\forall x:|x|\leq 1\\[6pt]\arctan x&=\sum _{n=0}^{\infty }{\frac {(-1)^{n}}{2n+1}}x^{2n+1}&&=x-{\frac {x^{3}}{3}}+{\frac {x^{5}}{5}}-\cdots &&\forall x:|x|\leq 1,\ x\neq \pm i\end{aligned}}})"
  
  test_text3 = r'By setting(Image: {\displaystyle t=\tan {\tfrac {1}{2}}\theta, }) all trigonometric functions of(Image: \theta) can be expressed as rational fractions of(Image: t):(Image: {\displaystyle {\begin{aligned}\sin \theta &= {\frac {2t}{1+t ^ {2}}}, \\[5mu]\cos \theta &= {\frac {1-t ^ {2}}{1+t ^ {2}}}, \\[5mu]\tan \theta &= {\frac {2t}{1-t ^ {2}}}.\end{aligned}}})'
  
  test_text = test_text3
  #调试用:设置为0表示读取外部文件的文本,设置为1表示使用上述字符串作为测试文本
  is_local = 0
  
  contents = read_data if not is_local else test_text
  # 分片策略
  indexes_token = []
  p = re.compile(r"\(Image:")
  matches = p.finditer(contents)
  # matches
  for match in matches:
      span = match.span()
      start = span[0]
      indexes_token.append(start)
  # print(indexes_token)
  seg_tuples = [i for i in indexes_token]
  refine_segs = []
  
  bl = list('([{')  # brackets_left
  br = list(')]}')  # brackets_right
  
  # def get_last_rp(s):
  #     """ get right parenthesis index """
  #     return s.rfind(')')
  
  
  def puts(s):
      print(s, end='')
  
  
  # indexes_token.insert(0,0)
  indexes_token.append(len(contents))
  indexes_seg = indexes_token
  header = contents[:indexes_token[0]]
  # puts(header)
  # out_data=header
  out_lines = []
  p1 = re.compile(r'\(Image:\s*')
  for i in range(len(indexes_seg)-1):
  
      start = indexes_seg[i]
      end = indexes_seg[i+1]
      # end_rp=s1[:end].rfind(')')+1
      end_rp = start+contents[start:end].rfind(')')
      end_rp_next = end_rp+1
      # print(start,end_rp)
      seg = contents[start:end]
      # print(seg)
      # 处理`(imag: `
      t = p1.sub(r'$', seg)
      # 处理各段最后一个右括号`)`
      # 方法1:
      # seg_rp = t[:end].rfind(')')
      # seg_rp_next=seg_rp+1
      # # print(seg_rp)
      # puts(t[:seg_rp_next]+'$'+t[seg_rp_next+1:])
      # # refine_segs.append(s1[start:end_rp])
      # 放法2:用正则方法(兼容性不足)
      # print(t)
      # p2 = re.compile(r'(.*[^\s])(\s*\))')
      # res = p2.sub(r'\1$', t)
      # 方法3:括号对数计数法
      cntl = 0
      close_rp = 0
      # print(t,"\n")
      for i in range(len(t)):
          if (t[i] == '('):
              cntl += 1
              # print(i)
          elif (t[i] == ')'):
              close_rp += 1
              # print(i)
          if close_rp == cntl+1:
              break
      # print(cntl,close_rp)
      out_line = t[:i]+'$'+t[i+1:]
      out_lines.append(out_line)
      # puts(out_lines)
  
      # puts(res)
  
      # m=p2.search(t)
      # gps=m.groups()
      # print(gps)
      # print(res)
  
  ##
  out_data = header+"".join(out_lines)
  p_edit = re.compile(r'\[((edit)|(编辑))\]')
  p_2slash = re.compile(r'(\\{2})(\[\d+\w+\])*')
  out_data = p_2slash.sub(r'\1\2'+'\n\t', out_data)
  # out_data=out_data.replace(r'\\',r"\\"+"\n\t")
  out_data = p_edit.sub(r'🎈\n', out_data)
  # out_data=out_data.replace("[edit]","\n").replace("[编辑]","\n")
  
  print(out_data)
  
  out = op.join(dirName, filePath)
  with open(out, "w", encoding="utf-8") as fout:
      fout.write(out_data)
  
  ```

- 替换处理结果:

  - ```text
    向量${\displaystyle \mathbf {y} ={\begin{bmatrix}y_{1}&y_{2}&\cdots &y_{m}\end{bmatrix}}^{\mathsf {T}}}$关于标量 x的导数可以（用分子记法）写成
    ${\displaystyle {\frac {\partial \mathbf {y} }{\partial x}}={\begin{bmatrix}{\frac {\partial y_{1}}{\partial x}}\\{\frac {\partial y_{2}}{\partial x}}\\\vdots \\{\frac {\partial y_{m}}{\partial x}}\\\end{bmatrix}}}$
    在向量微积分中，向量$\mathbf {y}$关于标量$x$的导数也被称为向量$\mathbf {y}$的切向量，${\displaystyle {\frac {\partial \mathbf {y} }{\partial x}}}$。注意这里${\displaystyle \mathbf {y} :\mathbb {R} \rightarrow \mathbb {R} ^{n}}$。
    例子 简单的样例包括欧式空间中的速度向量，它是位移向量（看作关于时间的函数）的切向量。更进一步而言， 加速度是速度的切向量。
    ```

- 渲染结果

  - 向量${\displaystyle \mathbf {y} ={\begin{bmatrix}y_{1}&y_{2}&\cdots &y_{m}\end{bmatrix}}^{\mathsf {T}}}$关于标量 x的导数可以（用分子记法）写成 ${\displaystyle {\frac {\partial \mathbf {y} }{\partial x}}={\begin{bmatrix}{\frac {\partial y_{1}}{\partial x}}\\{\frac {\partial y_{2}}{\partial x}}\\\vdots \\{\frac {\partial y_{m}}{\partial x}}\\\end{bmatrix}}}$ 在向量微积分中，向量$\mathbf {y}$关于标量$x$的导数也被称为向量$\mathbf {y}$的切向量，${\displaystyle {\frac {\partial \mathbf {y} }{\partial x}}}$。注意这里${\displaystyle \mathbf {y} :\mathbb {R} \rightarrow \mathbb {R} ^{n}}$。 例子 简单的样例包括欧式空间中的速度向量，它是位移向量（看作关于时间的函数）的切向量。更进一步而言， 加速度是速度的切向量。

- 测试2:

  - 假设X是一个定义在可数样本空间S上的离散随机变量 S ⊆ R，则其概率质量函数 fX(x) 为
    $f_{X}(x)={\begin{cases}\Pr(X=x),&x\in S,\\0,&x\in {\mathbb  {R}}\backslash S.\end{cases}}$
    注意这在所有实数上，包括那些X不可能等于的实数值上，都定义了 fX(x)。在那些X不可能等于的实数值上， fX(x)取值为0 ( x ∈ R\S，取Pr(X = x) 为0)。
    离散随机变量概率质量函数的不连续性决定了其累积分布函数也不连续。

- 说明:本程序并不完美,对于复杂情况,可能需要自行手动调整

### 使用re正则编写一个生成latex矩阵的程序

- ```python
  ## 
  import re
  import numpy as np
  from functools import reduce
  size=[5,5]
  type="pmatrix"
  s=reduce(lambda x,y:x*y,size)
  # 整形元素矩阵(arange()的参数是整数时,产生的时整形元素;参数是浮点数时,则产生浮点数矩阵)
  mat=np.arange(s).reshape(size)
  #浮点型元素的矩阵(numpy默认为浮点型)
  # mat=np.ones(size)
  mat=np.array(
      [[1,-2,-3.1],[3,5,-1],[7.2,1,-1]]
  )
  
  ## 
  begin=r"\begin{"+type+"}"
  end=r"\end{"+type+"}"
  integer=False
  # integer=True
  # print(begin,end)# (str(begin),end)
  
  #使用元素遍历的方案
  ## 
  print(begin)
  for i in mat:
      l=[str(j) for j in i]
      line="&\t".join(l)+"\t"+r"\\"
      print("\t"+line)
  print(end)
  
  
  #使用正则表达式的方案:
  ##
  latex_mat_body=[]
  print(begin)
  if(integer):
      p=re.compile(r'(\d+)(\.?)')
      for i in mat:
          # print(str(i))
          line=str(i)
          line=re.sub(r'\[|\]','',line)
          # print(type)
          latex_mat_line = p.sub(r'\t\1&', line)
          latex_mat_line = latex_mat_line[:-1]+"\t"+r"\\"
          #注意使用`r'\1'`原始字符串便于处理分组引用\1组
          print(latex_mat_line)
          # latex_mat_body.append(latex_mat_line)
          # body="\n".join(latex_mat_body)
  else:
      for i in mat:
          # p=re.compile(r'(-?\d+(\.*\d*))')
          line=str(i)
          # print(line)
          p=re.compile(r'(-?\d+\.*\d*)')
          # 去除中括号(注意`]`前潜在的空格)
          line=re.sub(r'\[|\s*\]','',line)
          # print(type)
          #注意使用`r'\1'`原始字符串便于处理分组引用\1组
          latex_mat_line = p.sub(r'\t\1&', line)
          #去掉末尾的&,防止空列产生
          latex_mat_line = latex_mat_line[:-1]+"\t"+r"\\"
          print(latex_mat_line)
  print(end)
  ##
  
  ```

  - ```tex
    \begin{pmatrix}
    	0& 	1& 	2& 	3& 	4	\\
    	5& 	6& 	7& 	8& 	9	\\	
    	10& 	11& 	12& 	13& 	14	\\
    	15& 	16& 	17& 	18& 	19	\\
    	20& 	21& 	22& 	23& 	24	\\
    \end{pmatrix}
    ```

  - ```tex
    \begin{pmatrix}
     	1.&  	-2.&  	-3.1	\\
     	3.&  	5.& 	-1.	\\
     	7.2&  	1.&  	-1.	\\
    \end{pmatrix}
    ```

    

  

- $$
  \\
  \begin{pmatrix}
  	0& 	1& 	2& 	3& 	4	\\
  	5& 	6& 	7& 	8& 	9	\\
  	10& 	11& 	12& 	13& 	14	\\
  	15& 	16& 	17& 	18& 	19	\\
  	20& 	21& 	22& 	23& 	24	\\
  \end{pmatrix}
  \\
  \begin{pmatrix}
   	1.&  	-2.&  	-3.1	\\
   	3.&  	5.& 	-1.	\\
   	7.2&  	1.&  	-1.	\\
  \end{pmatrix}
  $$


### 使用正则将一个仅包含字符串的json转换为变量赋值语句

- ```python
  ##
  import re
  # p=re.compile(r'"(.*)"(=".*")')
  text = '"result_training": "result of model training:",'
  
  p = re.compile(r'\s*"(.+?)"(.*?:)(.*".+"),?')
  
  
  with open(file="./en.json",mode='r') as fin:
      with open(file="./en.py",mode='w') as fout:
          for line in fin:
              if line.strip() in ['{','}']:
                  continue
              res=p.sub(r"\1 = \3", line,1)
              fout.write(res)
              print(res)
  
  # print(res,"@{res}")
  #import en
  #en.result_frame
  ```

- `en.json`wen'j

  ```python
  {
      "welcome_message": "Welcome to My App!",
      "choose_emotion_config": "Please select an emotional combination for testing: recommended combinations are AS, HNS, AHNS, AHNPS. \nNote that there is a difference between 'surprise' and 'pleasantSurprise' in the SAVEE dataset, \nso the AHNPS combination is not recommended for use on SAVEE.",
      "choose_feature_config": "Please choose one or more features",
      "feature_transform_config": "feature transformer config",
      "choose_algorithm": "Choose an algorithm for testing",
      "choose_audio": "Please select an audio sample file to recognize its emotion.",
      "recognize_the_audio_emotion": "Recognize the emotion of the selected audio file.",
      "draw_diagram": "choose one diagram to draw",
      "draw_diagram_detail": "Draw the [waveform|spectrogram|Mel spectrogram] of the selected file:",
      "welcome_title": "𝒲ℯ𝓁𝒸ℴ𝓂ℯ 𝓉ℴ ℯ𝓍𝓅ℯ𝓇𝒾ℯ𝓃𝒸ℯ 𝒞𝒞𝒮ℰℛ 𝒞𝓁𝒾ℯ𝓃𝓉!",
      "result_training": "result of model training:",
      "train_result_title": "Train Result",
      "result_frame": "Emotion Of Select File(Predict Result)",
      "recognize_it": "Recognize it"
  }
  ```

  