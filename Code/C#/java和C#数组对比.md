[toc]



C# 数组和 Java 数组在许多方面非常相似，但也有一些细微的差异。以下是它们在声明、初始化、操作等方面的对比。

### 1. 数组声明和初始化

#### 1.1. **声明与初始化方式**：

- **Java**:

  - Java 中，数组类型使用 `[]` 来声明。
  - 可以通过 `new` 关键字或直接初始化数组。

  **声明与初始化**：

  ```java
  int[] arr1 = new int[5];        // 使用 new 创建一个大小为 5 的整数数组
  int[] arr2 = {1, 2, 3, 4, 5};  // 直接初始化数组
  ```

- **C#**:

  - C# 中，数组类型的声明方式与 Java 类似，也是使用 `[]`，但数组的声明可以省略 `new` 关键字直接初始化。

  **声明与初始化**：

  ```csharp
  int[] arr1 = new int[5];        // 使用 new 创建一个大小为 5 的整数数组
  int[] arr2 = {1, 2, 3, 4, 5};  // 直接初始化数组
  int[] sophiaScores = new int[] { 90, 86, 87, 98, 100 };//这种也是可以的,但是`new int[]`是可以不写的
  ```

#### 1.2. **数组的大小**：

- **Java**:
  - 在创建数组时必须指定数组大小（对于静态数组）。
  - 数组大小一旦设置，无法改变（对于静态数组）。
- **C#**:
  - 与 Java 相同，C# 的静态数组大小一旦设置，无法改变。

### 2. 数组类型

- Java

  :

  - 数组是一种对象类型，数组元素存储在堆中，数组本身存储在栈中。
  - 数组的元素可以是任何类型（基本类型或对象类型）。

- C#

  :

  - C# 数组也可以包含基本数据类型或对象类型，数组本身是引用类型，存储在堆内存中。
  - 在 C# 中，数组的类型可以是单一维度（如 `int[]`）或多维（如 `int[,]`）。

### 3. 数组长度

- **Java**:

  - 数组的长度通过 `length` 属性访问，`length` 是一个常量。

  ```java
  int[] arr = {1, 2, 3, 4};
  System.out.println(arr.length); // 输出 4
  ```

- **C#**:

  - 在 C# 中，数组的长度通过 `Length` 属性访问（注意大小写）。

  ```csharp
  int[] arr = {1, 2, 3, 4};
  Console.WriteLine(arr.Length); // 输出 4
  ```

### 4. 多维数组

- **Java**:

  - Java 支持多维数组，通常是数组的数组。
  - 二维数组的声明如下：

  ```java
  int[][] matrix = new int[3][3];  // 创建 3x3 的二维数组
  matrix[0][0] = 1;
  ```

- **C#**:

  - C# 也支持多维数组，但语法稍有不同。
  - 二维数组声明如下：

  ```csharp
  int[,] matrix = new int[3, 3];  // 创建 3x3 的二维数组
  matrix[0, 0] = 1;
  ```

  - C# 还允许“锯齿数组”（Jagged Arrays），它是数组的数组，可以在每个维度使用不同的长度。与 Java 的多维数组不同，C# 的锯齿数组实际上是一个数组的数组。

  ```csharp
  int[][] jaggedArray = new int[3][];  // 创建一个包含 3 个元素的数组
  jaggedArray[0] = new int[3];  // 第一维长度为 3
  jaggedArray[1] = new int[2];  // 第二维长度为 2
  jaggedArray[2] = new int[4];  // 第三维长度为 4
  ```

### 5. 数组操作

#### 5.1. **访问数组元素**：

- **Java**:

  ```java
  int[] arr = {1, 2, 3, 4};
  System.out.println(arr[2]);  // 输出 3
  ```

- **C#**:

  ```csharp
  int[] arr = {1, 2, 3, 4};
  Console.WriteLine(arr[2]);  // 输出 3
  ```

#### 5.2. **数组遍历**：

- **Java**:

  - 使用传统的 `for` 循环：

  ```java
  for (int i = 0; i < arr.length; i++) {
      System.out.println(arr[i]);
  }
  ```

  - 使用增强型 `for` 循环（Java 中的 `foreach`）：

  ```java
  for (int num : arr) {
      System.out.println(num);
  }
  ```

- **C#**:

  - 使用传统的 `for` 循环：

  ```csharp
  for (int i = 0; i < arr.Length; i++) {
      Console.WriteLine(arr[i]);
  }
  ```

  - 使用增强型 `for` 循环（C# 中的 `foreach`）：

  ```csharp
  foreach (int num in arr) {
      Console.WriteLine(num);
  }
  ```

#### 5.3. **数组复制**：

- **Java**:

  - 使用 `System.arraycopy()` 或 `Arrays.copyOf()`：

  ```java
  int[] arrCopy = Arrays.copyOf(arr, arr.length);
  ```

- **C#**:

  - 使用 `Array.Copy()`：

  ```csharp
  int[] arrCopy = new int[arr.Length];
  Array.Copy(arr, arrCopy, arr.Length);
  ```

### 6. 数组的内存管理

- Java

  :

  - Java 数组是对象，因此它们会在堆上分配内存，并且 Java 使用垃圾回收来管理内存。

- C#

  :

  - C# 数组也是对象，它们也存储在堆中，并由垃圾回收器进行内存管理。

### 7. 数组的初始化与默认值

- **Java**:

  - 当数组被创建时，Java 会为数组中的元素分配默认值，具体如下：
    - 数字类型（如 `int`、`float` 等）初始化为 `0`。
    - 布尔类型（`boolean`）初始化为 `false`。
    - 对象类型（如 `String`）初始化为 `null`。

  ```java
  int[] arr = new int[5];
  System.out.println(arr[0]);  // 输出 0
  ```

- **C#**:

  - C# 也会为数组元素分配默认值，默认值与 Java 类似。

  ```csharp
  int[] arr = new int[5];
  Console.WriteLine(arr[0]);  // 输出 0
  ```

### 总结

| 特性             | **Java**                                              | **C#**                                                |
| ---------------- | ----------------------------------------------------- | ----------------------------------------------------- |
| **数组声明方式** | `int[] arr = new int[5];`                             | `int[] arr = new int[5];`                             |
| **数组大小**     | 不可变（一旦定义，大小固定）                          | 不可变（大小固定）                                    |
| **数组长度访问** | `arr.length`                                          | `arr.Length`                                          |
| **多维数组**     | 支持数组的数组（如 `int[][]`）                        | 支持多维数组（如 `int[,]`）及锯齿数组（`int[][]`）    |
| **数组遍历**     | 使用传统 `for` 或增强型 `for` 循环                    | 使用传统 `for` 或增强型 `foreach` 循环                |
| **默认值**       | 数字类型为 `0`，布尔类型为 `false`，引用类型为 `null` | 数字类型为 `0`，布尔类型为 `false`，引用类型为 `null` |

虽然 Java 和 C# 在数组的语法和使用上非常相似，但它们在细节上有一些不同，尤其是多维数组和数组的处理方式（如锯齿数组）。