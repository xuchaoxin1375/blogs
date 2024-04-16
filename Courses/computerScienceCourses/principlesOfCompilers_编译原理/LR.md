## LR分析

### 运算符优先规约

![image-20220616083056080](https://raw.githubusercontent.com/xuchaoxin1375/pictures/main/imagesimage-20220616083056080.png)

![image-20220616083507334](https://raw.githubusercontent.com/xuchaoxin1375/pictures/main/imagesimage-20220616083507334.png)

![image-20220616083754358](https://raw.githubusercontent.com/xuchaoxin1375/pictures/main/imagesimage-20220616083754358.png)

![image-20220616085604723](https://raw.githubusercontent.com/xuchaoxin1375/pictures/main/imagesimage-20220616085604723.png)

### 算符文法

![image-20220616083927858](https://raw.githubusercontent.com/xuchaoxin1375/pictures/main/imagesimage-20220616083927858.png)

### 句柄

![image-20220616080346931](https://raw.githubusercontent.com/xuchaoxin1375/pictures/main/imagesimage-20220616080346931.png)

> - 自顶向上的分析中,采用(反向)最右推导,
> - 最左规约(规范规约)
>   - 最左规约也依赖于句柄(最左直接短语)

![image-20220616080910679](https://raw.githubusercontent.com/xuchaoxin1375/pictures/main/imagesimage-20220616080910679.png)

![image-20220616081934369](https://raw.githubusercontent.com/xuchaoxin1375/pictures/main/imagesimage-20220616081934369.png)

![image-20220616082012015](https://raw.githubusercontent.com/xuchaoxin1375/pictures/main/imagesimage-20220616082012015.png)

- 短语代表可以规约的串
- 直接短语代表可以立即规约的串
  - 特别的,在**自底向上的,从左向右**的分析过程要马上直接规约的短语

#### 规范规约

![image-20220616082300609](https://raw.githubusercontent.com/xuchaoxin1375/pictures/main/imagesimage-20220616082300609.png)

#### 规范句型

![image-20220616082507793](https://raw.githubusercontent.com/xuchaoxin1375/pictures/main/imagesimage-20220616082507793.png)



#### 规范规约&句柄

![image-20220616090028544](https://raw.githubusercontent.com/xuchaoxin1375/pictures/main/imagesimage-20220616090028544.png)



![image-20220616090416500](https://raw.githubusercontent.com/xuchaoxin1375/pictures/main/imagesimage-20220616090416500.png)



#### 移入规约

![image-20220616080210228](https://raw.githubusercontent.com/xuchaoxin1375/pictures/main/imagesimage-20220616080210228.png)

### 规范LR(1)项目

![image-20220616093357768](https://raw.githubusercontent.com/xuchaoxin1375/pictures/main/imagesimage-20220616093357768.png)