[toc]

## 虚拟变量@one-hot encoding

- [pandas.get_dummies — pandas 1.5.3 documentation (pydata.org)](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.get_dummies.html)

- 将分类变量转换为虚拟/指示变量。
  - 在数据分析领域，dummies通常被翻译为“虚拟变量”、“指示变量”或“哑变量”，这些术语都是比较通用的翻译。其中，虚拟变量(dummies) 是最接近原始英文含义的翻译，而指示变量和哑变量则更加抽象。因此，通常建议使用“虚拟变量”，它能够比较直观地表达出数据转换的含义
- 在数据分析中，有时需要将分类变量转换为虚拟变量或指示变量。该过程可以将具有一组可能值的单个分类变量转换为多个二元变量，每个变量代表一个可能的值。
- 例如，假设您有一个名为“颜色”的分类变量，其可能的值是“红色”、“蓝色”和“绿色”。通过将此变量转换为三个虚拟变量，“红色”对应的变量将设置为1，而其他两个变量将设置为0，以及其他两种可能的值。
- 这种转换可以使得机器学习模型可以更好地理解和利用分类变量的信息，因为它们不再被视为单个离散值。

- Converting a categorical variable into dummy/indicator variables is a common technique used in data preparation and analysis. It involves creating one or more binary (0 or 1) variables to represent each category of the original variable.

  Here's an example of how to do this in Python using pandas:

  ```python
  import pandas as pd
  
  # create a sample dataframe with a categorical variable
  df = pd.DataFrame({'fruit': ['apple', 'banana', 'orange', 'apple', 'orange']})
  
  # use get_dummies() to create dummy variables
  dummy_df = pd.get_dummies(df['fruit'], prefix='fruit')
  
  # concatenate the dummy variables with the original dataframe
  df = pd.concat([df, dummy_df], axis=1)
  
  # drop the original categorical variable
  df.drop('fruit', axis=1, inplace=True)
  
  print(df)
  ```

  Output:

  ```
    fruit_apple  fruit_banana  fruit_orange
  0            1             0             0
  1            0             1             0
  2            0             0             1
  3            1             0             0
  4            0             0             1
  ```

  In this example, the `get_dummies()` function creates three dummy variables (`fruit_apple`, `fruit_banana`, and `fruit_orange`) based on the three unique categories in the original `fruit` column. The `prefix` argument adds a prefix to the column names for easier identification. The resulting dummy variables are then concatenated with the original dataframe using `pd.concat()`, and the original categorical variable is dropped using the `drop()` method.

## demo

### demo1

- Converting a categorical variable into dummy/indicator variables is a common data preparation step in machine learning and statistical analysis. This process involves creating new binary variables, one for each possible category in the original variable. These binary variables take a value of 1 if the observation belongs to that category and 0 otherwise.

- Here's an example of how to convert a categorical variable "Color" into dummy/indicator variables:

  Original dataset:

  | ID   | Color  |
  | ---- | ------ |
  | 1    | Red    |
  | 2    | Green  |
  | 3    | Blue   |
  | 4    | Yellow |
  | 5    | Red    |

  After converting "Color" into dummy variables, the dataset would look like this:

  | ID   | Color_Red | Color_Green | Color_Blue | Color_Yellow |
  | ---- | --------- | ----------- | ---------- | ------------ |
  | 1    | 1         | 0           | 0          | 0            |
  | 2    | 0         | 1           | 0          | 0            |
  | 3    | 0         | 0           | 1          | 0            |
  | 4    | 0         | 0           | 0          | 1            |
  | 5    | 1         | 0           | 0          | 0            |

### demo2

- ```python
  import pandas as pd
  
  df = pd.DataFrame({'color': ['red', 'blue', 'green', 'red']})
  dummies = pd.get_dummies(df['color'], prefix='color')
  print(dummies)
  
  ```

  - ```
       color_blue  color_green  color_red
    0           0            0          1
    1           1            0          0
    2           0            1          0
    3           0            0          1
    ```

- ```python
  
  df_with_dummies = pd.concat([df, dummies], axis=1)
  print(df_with_dummies)
  
  ```

  - ```
       color  color_blue  color_green  color_red
    0    red           0            0          1
    1   blue           1            0          0
    2  green           0            1          0
    3    red           0            0          1
    ```

- 这里我们首先创建了一个包含分类变量“color”的DataFrame，然后使用get_dummies()函数将其转换为虚拟变量，并设置了前缀为“color”。最后，我们将原始DataFrame与虚拟变量合并起来形成新的DataFrame，即`df_with_dummies`。

### demo3

- ```python
  import os
  #指向父目录的一个名为data的目录
  data_dir = os.path.join('..', 'data')
  
  # 将自定目录创建(指定exist_ok=True,如果要创建的目录已经存在,则跳过)
  os.makedirs(data_dir, exist_ok=True)
  
  import pandas as pd
  data_file = os.path.join('..', 'data', 'house_tiny.csv')
  with open(data_file, 'w') as f:
      f.write('NumRooms,Alley,Price\n')  # 列名
      f.write('NA,Pave,127500\n')  # 每行表示一个数据样本
      f.write('2,NA,106000\n')
      f.write('4,NA,178100\n')
      f.write('NA,NA,140000\n')
      
  data = pd.read_csv(data_file)
  print(data)
  ```

- 本例中,**对于`inputs`中的类别值或离散值，我们将“NaN”视为一个类别。**

- ```
     NumRooms Alley   Price
  0       NaN  Pave  127500
  1       2.0   NaN  106000
  2       4.0   NaN  178100
  3       NaN   NaN  140000
  ```

- ```python
  inputs, outputs = data.iloc[:, 0:2], data.iloc[:, 2]
  print(f'{data=}\n{inputs=}\n{outputs=}')
  
  ```

  - ```
    data=   
    	NumRooms Alley   Price
    0       NaN  Pave  127500
    1       2.0   NaN  106000
    2       4.0   NaN  178100
    3       NaN   NaN  140000
    inputs=
    	NumRooms Alley
    0       NaN  Pave
    1       2.0   NaN
    2       4.0   NaN
    3       NaN   NaN
    outputs=
    0    127500
    1    106000
    2    178100
    3    140000
    Name: Price, dtype: int64
    ```

#### 数值化

- 由于“巷子类型”（“Alley”）列只接受两种类型的类别值“Pave”和“NaN”，`pandas`可以自动将此列转换为两列“Alley_Pave”和“Alley_nan”。

  - 巷子类型为“Pave”的行会将“Alley_Pave”的值设置为1，“Alley_nan”的值设置为0。
  - 缺少巷子类型的行会将“Alley_Pave”和“Alley_nan”分别设置为0和1。

- ```python
  pd.get_dummies(inputs, dummy_na=True)
  ```

  - ```
       NumRooms  Alley_Pave  Alley_nan
    0       NaN           1          0
    1       2.0           0          1
    2       4.0           0          1
    3       NaN           0          1
    ```

  - 这就将Alley(包括字符型和NaN)变为Alley_Pave和Alley_nan两个都是数值类型的字段

#### 插值处理NaN数值化

- ```python
  
  mean=inputs.mean(numeric_only=True)
  
  inputs = inputs.fillna(mean)
  print(inputs)
  ```

  - ```
       NumRooms  Alley_Pave  Alley_nan
    0       3.0           1          0
    1       2.0           0          1
    2       4.0           0          1
    3       3.0           0          1
    ```

  

- ```python
  inputs = pd.get_dummies(inputs, dummy_na=True)
  print(inputs)
  ```

  - [**现在`inputs`中的所有条目都是数值类型，它们可以转换为张量格式。**]

- ```python
  inputs.values
  ```

  - ```
    array([[3., 1., 0.],
           [2., 0., 1.],
           [4., 0., 1.],
           [3., 0., 1.]])
    ```

  

#### 其他get_dummies例

- ```python
  print(pd.get_dummies(inputs))
  ```

  - ```
       NumRooms  Alley_Pave
    0       NaN           1
    1       2.0           0
    2       4.0           0
    3       NaN           0
    ```

- ```python
  pd.get_dummies(inputs["Alley"])
  ```

  - ```
       Pave
    0     1
    1     0
    2     0
    3     0
    ```

- ```python
  pd.get_dummies(inputs["Alley"],dummy_na=True)
  ```

  - ```
       Pave  NaN
    0     1    0
    1     0    1
    2     0    1
    3     0    1
    ```

- ```python
  pd.get_dummies(data['Price'])
  ```

  - ```
       106000  127500  140000  178100
    0       0       1       0       0
    1       1       0       0       0
    2       0       0       0       1
    3       0       0       1       0
    ```

    

