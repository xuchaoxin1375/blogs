
二维数组作为参数
![](https://img-blog.csdnimg.cn/20210315174023151.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3h1Y2hhb3hpbjEzNzU=,size_16,color_FFFFFF,t_70)

|  |   |  二维数组作为参数  |  ![]()**编辑**   |
| -------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |

|  |  |
| - | - |

二维数组p[3][3]的内部排列:

|  |   |   |  p[0][0]=*p[0]==**p  |    |    |
| ---------------------- | ---- | ---- |

|  | p[1][0]=*p[1]=**(p+1) | *(*(p+1)+1) |
| - | --------------------- | ------------- |

|  | p[2][0]=*p[2]=**(p+2) |  |
| - | --------------------- | - |

|  |  |  |
| - | - | - |

|  |  |
| - | - |

这里**p即为*(*p)

*(p+1)=p+1,但是*(p+1)是列指针,p+1仍然是行指针

p[1]=*(p+1),即,两者都是列指针

总结,对于二维数组

如果是带有且仅仅带有一个*或者一个[]号(二者中的一个),那么访问的是列指针(列指针指向具体的元素(即元素的地址)想要访问到元素的值,需要在加一个*或[]

如果带有两个*或两个[],乃至一个*和一个[](同时都各出现一次),那么可以访问到具体的元素

二维数组p[3][3]的内部排列:

p[0][0]=*p[0]==**p

p[1][0]=*p[1]=**(p+1)

*(*(p+1)+1)

p[2][0]=*p[2]=**(p+2)

这里**p即为*(*p)

*(p+1)=p+1,但是*(p+1)是列指针,p+1仍然是行指针

p[1]=*(p+1),即,两者都是列指针

 

总结,对于二维数组

如果是带有且仅仅带有一个*或者一个[]号(二者中的一个),那么访问的是列指针(列指针指向具体的元素(即元素的地址)想要访问到元素的值,需要在加一个*或[]

如果带有两个*或两个[],乃至一个*和一个[](同时都各出现一次),那么可以访问到具体的元素
