[toc]



# C语言中的基本类型转换规律



## 实例代码

```c
#include <stdio.h>
void print_seperator(void)
{
    printf("\n------------------------\n");
}

void s2u()
{
    /* 探究无符号数和有符号数之间的转换 */
    printf("给定2个真值x,y\ny是x的强制类型转换为无符号数后的对应值");
    short x = -4321;
    unsigned short y = (unsigned short)x;
    /* 逆向转换实例 */
    unsigned short p = 65535;
    short q = (short)p;
    printf("sizeof short int:%d\n", sizeof(x));
    printf("x(%%d)=%d,y(%%u)=%u\n", x, y);
    print_seperator();

    printf("\n观察寄存器中的bit情况,一般情况下,您会发现,整形变量中的二进制串是以补码的形式存在的\n");
    printf("@@check the bits value of variable x,y in the registor\n with 16(hexadecimal form)\n");
    printf("x(%%hx)=%hx,y(%%hx)=%hx\n", x, y);
    print_seperator();
    printf("可以看到,强制转换为无符号数后得到的y,其二进制编码和有符号数x的二进制(补码)串是相同的,为了便于简写,使用16进制来标记,每个16进制数尾缀用H标识,不属于数据位!);\n x,y在计算或者以整形%d输出的时候,会转回换为真值输出:\n");
    printf("有符号数x=-4321的十六进制补码是ef1fH,(附|x|=4321的十六进制为10e1H,计算x的补码确实是ef1fH\n");
    printf("输出无符号数y的时候,就是将ef1fH按照无符号数%%d(%%u)解释方式输出(对应的无符号数y的真值为61215)\n");
    print_seperator();
    printf("强制类型转换的结果位值保持不变;仅改变了解释这些位的方式!");
    // printf("x(%%x)=%x,y(%%x)=%x\n", x, y);
    print_seperator();
    printf("x(%%u)=%u,y(%%d)=%d\n", x, y);
    printf("p(%%hx)=%hX,q(%%hx)=%hx\n", p, q);
    printf("p(%%h)=%d,q(%%h)=%hd\n", p, q);
}
void l2s()
{
    /* 探究不同字长之间的数的类型转换
    本例以int转换为short查看效果 */

    printf("给定2个真值u1,u2\n");
    int u1 = 165537, u2 = -34991;
    short v1 = (short)u1, v2 = (short)u2;
    /* 逆向转换实例 */
    printf("sizeof short int:%d\n", sizeof(u1));
    print_seperator();
    printf("u1(%%d)=%d,u1(%%d)=%d\n", u1, u2);
    printf("再以十六进制的形式输出,最高位开始的0bit默认不显示因此32bit的十六进制数未必有8个值\n");
    printf("u1(%%x)=%#x,u2(%%x)=%#x\n", u1, u2);
    print_seperator();

    printf("\n观察寄存器中的bit情况,一般情况下,您会发现,整形变量中的二进制串是以补码的形式存在的\n");
    printf("@@check the bits value of variable u1,u2 in the registor\n with 16(hexadecimal form)\n");
    printf("下面两种打印方式结果一致(可以通过输出控制符来直接截断高位字节!(只输出低位字节);此外,以十六进制输出时,可以在控制字符序列中添加一个#号,打印的时候自动添加头部的Ox(或者OX)\n");
    printf("u1(%%hx)=%hx,u2(%%hx)=%hx\n", u1, u2);
    printf("v1(%%hx)=%#hx,v2(%%hx)=%#hx\n", v1, v2);
    print_seperator();
    /* 尝试用用int 打印short的变量的补位效果 */
    printf("v1(%%hx)=%#hx,v2(%%hx)=%#hx\n", v1, v2);
    printf("v1(%%x)=%#x,v2(%%x)=%#x\n", v1, v2);
    printf("v1(%%d)=%#d,v2(%%dx)=%#d\n", v1, v2);
    print_seperator();
    // printf("x(%%u)=%u,y(%%d)=%d\n", x, y);
    // printf("p(%%hx)=%hX,q(%%hx)=%hx\n", p, q);
    // printf("p(%%h)=%d,q(%%h)=%hd\n", );
}
void s2l()
{
    /* 探究不同字长之间的数的类型转换
    本例以int转换为short查看效果 */

    printf("给定2个真值u1,u2\n");
    short u0 = 4321;
    short u1 = -4321;
    unsigned short u2 = (unsigned short)u1;
    /* 有符号数的short向int转换 */
    int v1 = (int)u1;
    /* 无符号数的short转int */
    unsigned int v2 = (unsigned int)u2;
    /* 逆向转换实例 */
    print_seperator();
    // printf("u1(%%d)=%d,u1(%%d)=%d\n", u1, u2);
    printf("再以十六进制的形式输出,最高位开始的0bit默认不显示因此32bit的十六进制数未必有8个值\n");
    printf("u0(%%hx)=%#hx,(int)u0(%%x)=%#x\n", u0, (int)u0);
    printf("u1(%%hx)=%#hx,v1(%%x)=(int)u1=%#x,u2(%%x)=%#x,v2(%%x)=(unsigned int)u2=%#x\n", u1, v1, u2, v2);
    printf("u1(%%d)=%#d,v1(%%d)=%#d,u2(%%d)=%#d,v2(%%d)=%#d\n", u1, v1, u2, v2);
    print_seperator();
}
int main(int argc, char const *argv[])
{
    printf("section1:short转unsigned short🎈🎈🎈🎈\n");
    s2u();
    printf("section2:int转short:🎈🎈🎈🎈\n");
    l2s();
    printf("section3:short转int:🎈🎈🎈🎈\n");
    s2l();
    return 0;
}

```

### 输出结果

- 下面程序使用mingw(gcc)编译
- 直接使用powershell可能会乱码运行输出的乱码问题
  - 使用oh my posh 不会中文乱码
  - 直接powershell输出可能会乱码
  - 使用cmd运行也是可以的(无乱码)

```bash
section1:short转unsigned short🎈🎈🎈🎈
给定2个真值x,y
y是x的强制类型转换为无符号数后的对应值sizeof short int:2
x(%d)=-4321,y(%u)=61215

------------------------

观察寄存器中的bit情况,一般情况下,您会发现,整形变量中的二进制串是以补码的形式存 
在的
@@check the bits value of variable x,y in the registor
 with 16(hexadecimal form)
x(%hx)=ef1f,y(%hx)=ef1f

------------------------
可以看到,强制转换为无符号数后得到的y,其二进制编码和有符号数x的二进制(补码)串是 
相同的,为了便于简写,使用16进制来标记,每个16进制数尾缀用H标识,不属于数据位!);   
 x,y在计算或者以整形-2074805712输出的时候,会转回换为真值输出:
有符号数x=-4321的十六进制补码是ef1fH,(附|x|=4321的十六进制为10e1H,计算x的补码确
实是ef1fH
输出无符号数y的时候,就是将ef1fH按照无符号数%d(%u)解释方式输出(对应的无符号数y的
真值为61215)

------------------------
强制类型转换的结果位值保持不变;仅改变了解释这些位的方式!
------------------------
x(%u)=4294962975,y(%d)=61215
p(%hx)=FFFF,q(%hx)=ffff
p(%h)=65535,q(%h)=-1
section2:int转short:🎈🎈🎈🎈
给定2个真值u1,u2
sizeof short int:4

------------------------
u1(%d)=165537,u1(%d)=-34991
再以十六进制的形式输出,最高位开始的0bit默认不显示因此32bit的十六进制数未必有8个
值
u1(%x)=0x286a1,u2(%x)=0xffff7751

------------------------

观察寄存器中的bit情况,一般情况下,您会发现,整形变量中的二进制串是以补码的形式存 
在的
@@check the bits value of variable u1,u2 in the registor
 with 16(hexadecimal form)
下面两种打印方式结果一致(可以通过输出控制符来直接截断高位字节!(只输出低位字节);此外,以十六进制输出时,可以在控制字符序列中添加一个#号,打印的时候自动添加头部的Ox(或者OX)
u1(%hx)=86a1,u2(%hx)=7751
v1(%hx)=0x86a1,v2(%hx)=0x7751

------------------------
v1(%hx)=0x86a1,v2(%hx)=0x7751
v1(%x)=0xffff86a1,v2(%x)=0x7751
v1(%d)=-31071,v2(%dx)=30545

------------------------
section3:short转int:🎈🎈🎈🎈
给定2个真值u1,u2

------------------------
再以十六进制的形式输出,最高位开始的0bit默认不显示因此32bit的十六进制数未必有8个
值
u0(%hx)=0x10e1,(int)u0(%x)=0x10e1
u1(%hx)=0xef1f,v1(%x)=(int)u1=0xffffef1f,u2(%x)=0xef1f,v2(%x)=(unsigned int)u2=0xef1f
u1(%d)=-4321,v1(%d)=-4321,u2(%d)=61215,v2(%d)=61215

------------------------
```

### 小结

- 有符号数和无符号数的相互转换,转换前后,它们的二进制补码(记这串01串为T)都是一致的
  - 输出的数有区别,在于解释同一串二进制代码是的解释方式不同
  - 有符号数按照正常的补码解释串T,得到正确的(原本的)真值
  - 如果一无符号数来解释T,会得到其他结果
  - 有符号数和无符号数在取值范围上就不同
- 长字长类型转换为短字长类型:
  - 比如int转为short,那么机器内部的补码形式中高位字节被丢弃
- 短字长转换为长字长类型
  - 那么C语言会试图保持转换前后,数的真值不发生变化
    - 因此,对于正数或者无符号数,长字长类型的高位将用0填补(补码)
    - 对于负数,则用1来填补

