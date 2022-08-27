## 行列式定义(公式)

$$
\\记p=\overset{n}{\underset{i=1}{Perm}}(j_i) 表示1,2,3\cdots n的(任意可能的)一个n级排列j_1j_2\cdots j_n
\\
\sum\limits_{p}表示对所有n级排列求和
\\
n阶行列式可以记作:
det(a_{ij})=
\sum\limits_{p}{(-1)}^{\tau(p)}\prod_{i=1}^{n}{a_{ij_i}}\\
其中:
\begin{cases}
\begin{aligned}
&p=\overset{n}{\underset{i=1}{Perm}}(j_i)\\
&\tau(p)表示求n级排列p的逆序数
\end{aligned}
\end{cases}
\\为了更好的区分复杂的角标\\
(元素横标和纵标可能是复杂表达式,使用逗号分隔元素a的两个下脚标)
\\
\sum\limits_{p}{(-1)}^{\tau(p)}\prod_{i=1}^{n}{a_{i,j_i}}
$$

$$
\\记p(j_i)=\overset{n}{\underset{i=1}{Perm}}(j_i) 表示1,2,3\cdots n的(任意可能的)一个n级排列j_1j_2\cdots j_n
\\
此时\sum\limits_{p}{expr}表示对所有n级排列对应的表达式expr求和
\\
n阶行列式可以记作:
det(a_{ij})=
\sum\limits_{p}{(-1)}^{\tau(p)}\prod_{i=1}^{n}{a_{ij_i}}\\
其中:
\begin{cases}
\begin{aligned}
&p=\overset{n}{\underset{i=1}{Perm}}(j_i)\\
&\tau(p)表示求n级排列p的逆序数
\end{aligned}
\end{cases}
\\为了更好的区分复杂的角标\\
(元素横标和纵标可能是复杂表达式,使用逗号分隔元素a的两个下脚标)
\\
\sum\limits_{p}{(-1)}^{\tau(p)}\prod_{i=1}^{n}{a_{i,j_i}}
$$



- 更一般的写法

$$
det(a_{ij})=\sum\limits_{p}{(-1)}^{\tau(p_i)+\tau(p_j)}\prod_{i=1}^{n}{a_{i_i,j_i}}\\
由乘法交换律可知:
\prod_{i=1}^{n}{a_{i,j_i}}=\prod_{i=1}^{n}{a_{i_i,j_i}}
\\即,无序可以转化为有序,会更好理解
$$

