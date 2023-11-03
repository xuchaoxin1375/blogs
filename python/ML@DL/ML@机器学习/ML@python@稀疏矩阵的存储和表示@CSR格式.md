[toc]

# ML@python@稀疏矩阵的存储和表示@CSR格式

- [Sparse matrix - Wikipedia](https://en.wikipedia.org/wiki/Sparse_matrix#Compressed_sparse_row_(CSR,_CRS_or_Yale_format))

## CSR格式🎈

CSR是Compressed Sparse Row的缩写，是一种稀疏矩阵的压缩存储格式。稀疏矩阵是指其中大部分元素为0的矩阵。在机器学习中，由于特征维度通常很高，因此特征矩阵往往是稀疏矩阵。使用CSR格式可以节省存储空间并加快矩阵运算的速度。

在CSR格式中，矩阵被视为三个数组的组合：data、indices和indptr。

- data数组存储矩阵中**所有**非零元素的值，
- indices数组存储每个非零元素所在的**列号**
- indptr数组存储**每一行**的**第一个非零元素**在data和indices数组中的位置。

例如，对于一个3行4列的稀疏矩阵，其data、indices和indptr数组分别为：

- ```python
  from scipy.sparse import csr_matrix
  data = [1, 2, 3, 4, 5]
  indices = [0, 2, 1, 1, 2]#由于只有4列,所有indices数组中的元素在0,1,2,3中取值(这不是说元素个数不超过4)
  indptr = [0, 2, 3, 5]
  SM=csr_matrix((data, indices, indptr), shape=(3,4)).toarray()
  SM
  ```

  - ```
    array([[1, 0, 2, 0],
           [0, 3, 0, 0],
           [0, 4, 5, 0]])
    ```

### NNZ

- NNZ是n维数组中非零元素的数量，是衡量稀疏矩阵中元素数量的一个指标。在稀疏矩阵中，大部分元素的值为0，因此NNZ通常远小于矩阵的总元素数。

- NNZ可以用来衡量稀疏矩阵的稠密程度。通常情况下，NNZ与稀疏矩阵中非零元素的分布、密度以及矩阵的大小等因素有关。因为计算机存储非零元素需要占用内存空间，所以NNZ也可以用来评估稀疏矩阵的存储空间需求。

- 在机器学习中，很多算法都需要处理高维稀疏数据，例如文本分类、推荐系统等。因此，NNZ也是评估这些算法性能的一个重要指标之一。通常情况下，NNZ越小，算法处理稀疏数据的效率越高，但同时也可能会牺牲一定的精度。

  例如，对于一个3行4列的稀疏矩阵，其NNZ为5，因为矩阵中共有5个非零元素。

- NNZ:[Number of nonzero matrix elements](https://www.mathworks.com/help/matlab/ref/nnz.html)

### Coordinate list (COO)

- COO stores a list of (row, column, value) tuples. Ideally, the entries are sorted first by row index and then by column index, to improve random access times. This is another format that is good for incremental matrix construction



### Compressed sparse row (CSR, CRS or Yale format)🎈

- The compressed sparse row (CSR) or compressed row storage (CRS) or Yale format represents a matrix M by three (one-dimensional) arrays, that respectively contain nonzero values, the extents of rows, and column indices. 
- It is similar to **COO**, but compresses the row indices, hence the name. 
- This format allows **fast row access** and **matrix-vector multiplications** ($Mx$). The CSR format has been in use since at least the mid-1960s, with the first complete description appearing in 1967.

### 三个数组

- The CSR format stores a sparse $m × n$ matrix M in row form using three (one-dimensional) arrays (V, COL_INDEX, ROW_INDEX). 
  - 其中,数组V和COL_INDEX是很好理解的
  - 而ROW_INDEX数组中的值表示的是数组V或ROW_INDEX中元素的索引或者**切片**(这两个数组是对应的,编码的时候要看源矩阵M才可以确定ROW_INDEX),而不是矩阵M中的元素的行索引!(ROW_INDEX的两个相邻元素作为构成切片的一对索引值,用切片访问数组V或ROW_INDEX)
  - ROW-INDEX是为了区分哪些元素是同一行的(或者说第i行包括哪些非零元素)
- Let **NNZ** denote <u>the number of nonzero entries</u> in M.
  -  (Note that zero-based indices shall be used here.)
- The arrays V and COL_INDEX are of length NNZ, and contain the non-zero values and the column indices of those values respectively.
- The array ROW_INDEX is of length $m + 1$ and encodes the index in V and COL_INDEX where the given row **starts**. 
  - 简单说,就是如何划分数组V(和数组COL_INDEX)中哪些元素是属于同一行的
  - This is equivalent to ROW_INDEX[j] encoding <u>**the total number of nonzeros above row j**</u>. 
- The last element is NNZ , i.e., the **fictitious** index in V immediately after(紧接) the last valid index NNZ - 1. 
- CSR格式使用三个一维数组（V、COL_INDEX和ROW_INDEX）以行形式存储稀疏矩阵M。其中，V数组和COL_INDEX数组的长度均为NNZ，分别存储非零元素的值和列索引。
- ROW_INDEX数组的长度为m+1，编码了矩阵M的每一行(非零元素)在V数组和COL_INDEX数组中的开始索引。这相当于ROW_INDEX[j]编码了位于**第j行上方**的**所有非零元素的总数**。
  - ROW_INDEX最后一个元素是NNZ，即最后一个有效索引NNZ-1之后的虚构索引。需要注意的是，这里使用基于0的索引。

### 根据ROW_INDEX划分数组V或COL_INDEX

- 由于R=ROW_INDEX有m+1个元素,如果将每两个向量的元素R[i],R[i+1]作为一个切片($i=1,2,\cdots,m$),将产生m个切片
- 分别计算`ri=R[i+1]-R[i]`,其中`ri`就表示第i行有`ri`个非0元素
- 而第i行的`ri`个非0元素分别要对齐(align)到哪一列(放到哪一列),则由`c=COL_INDEX[R[i+1]:R[i]]`中的元素决定(`c`中的元素格式也是`ri`个)

### 数组名称

- scipy中V, COL_INDEX, ROW_INDEX三个数组的对应名称分别是`data,indices,indptr`

## demos in scipy

### eg

- For example, the matrix

  - $$
    {\displaystyle {\begin{pmatrix}5&0&0&0\\
    	0&8&0&0\\
    	0&0&3&0\\
    	0&6&0&0\\
    	\end{pmatrix}}}
    $$

  - 这个稀疏矩阵比较简单,它的SCR编码和COO编码恰好一致

  - 这个例子似乎看不出来CSR和COO的区别,**Don't worry about it **下一节将介绍更多例子

  - is a 4 × 4 matrix with 4 nonzero elements, hence

    - ```python
      V         = [ 5 8 3 6 ]
      COL_INDEX = [ 0 1 2 1 ]
      ROW_INDEX = [ 0 1 2 3 4 ] 
      ```

    - assuming a zero-indexed language.
    - 我查看wikipedie的这篇文章时,给出的ROW_INDEX是[0,1,2,3]这应该是错误的,长度上就不符合CSR编码特征
    - 所以我将其纠正为[0,1,2,3,4],包含m+1=5个元素

  - To extract a row, we first define:

    - ```python
      row_start = ROW_INDEX[row]
      row_end   = ROW_INDEX[row + 1]
      ```

    - ```python
      Vi=V[row_start:row_end]
      ```

  - Then we take slices from V and COL_INDEX starting at row_start and ending at row_end.

- To extract the row 1 (the second row) of this matrix we set row_start=1 and row_end=2. Then we make the slices `V[1:2] = [8]` and `COL_INDEX[1:2] = [1]`. 

  - We now know that in row 1 we have one element at column 1 with value 8.

### eg

- Another example, the matrix

- $$
  {\displaystyle {\begin{pmatrix}10&20&0&0&0&0\\
  	0&30&0&40&0&0\\
  	0&0&50&60&70&0\\
  	0&0&0&0&0&80\\
  	\end{pmatrix}}}
  $$

- is a 4 × 6 matrix (24 entries) with 8 nonzero elements, so

  ```python
  V         = [ 10 20 30 40 50 60 70 80 ]
  COL_INDEX = [  0  1  1  3  2  3  4  5 ]   
  ROW_INDEX = [  0  2  4  7  8 ]
  ```

- The whole is stored as 21 entries: 8 in V, 8 in COL_INDEX, and 5 in ROW_INDEX.
  - ROW_INDEX splits the array V into rows: (10, 20) (30, 40) (50, 60, 70) (80), indicating the index of V (and COL_INDEX) where each row starts and ends;
  - COL_INDEX aligns values in columns: (10, 20, ...) (0, 30, 0, 40, ...)(0, 0, 50, 60, 70, 0) (0, 0, 0, 0, 0, 80).

### 冗余分析

- Note that in this format, <u>**the first value of ROW_INDEX is always zero and the last is always NNZ**</u>, so they are in some sense **redundant** (although in programming languages where the array length needs to be explicitly stored, NNZ would not be redundant). 
- Nonetheless, this does avoid the need to handle an exceptional case when computing the length of each row, as it guarantees the formula ROW_INDEX[i + 1] − ROW_INDEX[i] works for any row i. 
- Moreover, the memory cost of this redundant storage is likely insignificant for a sufficiently large matrix.

### Yale sparse matrix

- The (old and new) Yale sparse matrix formats are instances of the CSR scheme. The old Yale format works exactly as described above, with three arrays; （旧和新的）Yale稀疏矩阵格式是CSR格式的一种实例。旧的Yale格式与上述描述完全相同，使用三个数组表示；新的格式将行索引和列索引合并成一个单独的数组，并将矩阵的对角线单独处理。

- the new format combines ROW_INDEX and COL_INDEX into a single array and handles the diagonal of the matrix separately.

- For logical adjacency matrices, the data array can be omitted, as the existence of an entry in the row array is sufficient to model a binary adjacency relation.

- It is likely known as the Yale format because it was proposed in the 1977 Yale Sparse Matrix Package report from Department of Computer Science at Yale University.

- 对于逻辑邻接矩阵，可以省略数据数组，因为在行数组中存在一个条目就足以表示二元邻接关系。

  Yale格式可能因为它是在耶鲁大学的计算机科学系于1977年发布的Yale稀疏矩阵包报告中提出的，而得名。

### CSR编码效益分析🎈

- 编码任意一个矩阵为CSR格式需要的存储的entries为$S=2NNT+(m+1)$

- In this case above, the CSR representation contains 13 entries, compared to 16 in the original matrix. 

  - The CSR format saves on memory only when $NNZ < (m (n − 1) − 1) / 2$.

    - $$
      S<m+n
      \\求解可得
      \\
      NNT<{\frac{1}{2}(m(n-1)-1)}
      $$

  - 只有满足上述等式的情况下,CSR

### 标准CSR编码和Scipy中的相关api

- [scipy.sparse.csr_matrix — SciPy v1.10.1 Manual](https://docs.scipy.org/doc/scipy/reference/generated/scipy.sparse.csr_matrix.html)

- csr_matrix((data, indices, indptr), [shape=(M, N)])
  - it is the standard CSR representation where :
    - 注意indices数组存储的是非零元素所在的列
  - **the column indices** for **row i** are stored in 
    - `indices[indptr[i]:indptr[i+1]]` 
  - and their corresponding values are stored in 
    - `data[indptr[i]:indptr[i+1]]`.
  -  If the shape parameter is not supplied, the matrix dimensions are inferred from the index arrays.

- ```python
  from scipy.sparse import csr_matrix
  indptr = np.array([0, 2, 3, 6])
  indices = np.array([0, 2, 2, 0, 1, 2])
  data = np.array([1, 2, 3, 4, 5, 6])
  csr_matrix((data, indices, indptr), shape=(3, 3)).toarray()
  # array([[1, 0, 2],
  #        [0, 0, 3],
  #        [4, 5, 6]])
  ```

  - 上述矩阵中,共有3行3列

  - | 第i行      | 非零元素 | 非零元素个数 | 从0开始累加各行非零元素个数 | indptr(index_column) | slice |
    | ---------- | -------- | ------------ | --------------------------- | -------------------- | ----- |
    | 0          | 1,2      | 2            | 0+2=2                       | 0                    | 0:2   |
    | 1          | 3        | 1            | 2+1=3                       | 2                    | 2:3   |
    | 2          | 4,5,6    | 3            | 3+3=6                       | 3                    | 3:6   |
    | fictitious |          |              |                             | 6                    |       |

    - indptr数组就是以0开头作为第一个元素,然后依次收集累加列[2,3,6]的元素,得到一个长度为矩阵M的行数m再+1的向量,本例中m=3,indptr=[0,2,3,6]

  - 现在,我们在第二行的位置插入一个全0向量:(只需要修改indptr数组)

    ```python
    from scipy.sparse import csr_matrix
    indptr = np.array([0, 2,2, 3, 6])
    indices = np.array([0, 2, 2, 0, 1, 2])
    data = np.array([1, 2, 3, 4, 5, 6])
    csr_matrix((data, indices, indptr), shape=(4, 3)).toarray()
    # array([[1, 0, 2],
    #        [0, 0, 0],
    #        [0, 0, 3],
    #        [4, 5, 6]])
    ```

  - 还可以通过shape参数,追加全零列,而不需要改动三个数组

    - ```python
      from scipy.sparse import csr_matrix
      indptr = np.array([0, 2,2, 3, 6])
      indices = np.array([0, 2, 2, 0, 1, 2])
      data = np.array([1, 2, 3, 4, 5, 6])
      SM=csr_matrix((data, indices, indptr), shape=(4, 5)).toarray()
      SM
      # array([[1, 0, 2, 0, 0],
      #        [0, 0, 0, 0, 0],
      #        [0, 0, 3, 0, 0],
      #        [4, 5, 6, 0, 0]])
      ```

  - 观察每行的非零元素:

    - ```python
      # 列出矩阵M每行的非零元素的列索引以及值
      for i in range(len(indptr)-1):
          r_slice=slice(indptr[i],indptr[i+1])#r_slice表示row_slice
          print(f'{str(indices[r_slice]):>10}',
                f'{r_slice}',
                f'{str(data[r_slice])}'
                )
      ```

      - ```bash
             [0 2] slice(0, 2, None) [1 2]
               [2] slice(2, 3, None) [3]
           [0 1 2] slice(3, 6, None) [4 5 6]
        ```

      - 上面的输出分为3列,第一列是第i行非零元素的索引

      - 第2列是第i行以及该行之前的非零元素,对indptr数组进行切片

      - 第3列表示第i行非零元素的取值

### 将给定矩阵编码双向转换

- 由三个数组计算出系数矩阵

  ```python
  from scipy.sparse import csr_matrix
  indptr = np.array([0, 2,2, 3, 6])
  indices = np.array([0, 2, 2, 0, 1, 2])
  data = np.array([1, 2, 3, 4, 5, 6])
  SM=csr_matrix((data, indices, indptr), shape=(4,3)).toarray()
  print(SM)
  ```

- 将给定的稀疏矩阵编码成三个数组

  ```python
  SM=csr_matrix((data, indices, indptr), shape=(4, 3)).toarray()
  res=csr_matrix(SM)
  print(res)
  print(f'{res.indices=}\n{res.indptr=}\n{res.data=}')
  
  ```

## 其他稀疏系数矩阵的编码和存储

- 可以参考wikipedia,scipy中的文档
  - [Sparse matrices (scipy.sparse) — SciPy Manual](https://docs.scipy.org/doc/scipy/reference/sparse.html)





