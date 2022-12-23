# <resolution>

参考连接:

- [像素px、分辨率、ppi、dpi、dp(dip) - 简书 (jianshu.com)](https://www.jianshu.com/p/3b612fb6d685)

屏幕尺寸（Screen Size）： 屏幕对角线的长度。iPhone5屏幕尺寸为4英寸、iPhone6屏幕尺寸为4.7英寸，指的是显示屏对角线的长度。  1 inch = 2.54cm = 25.4mm
 分辨率：屏幕上的像素总数。常用的表现形式如：1280x720, 1920x1080等。

px，pixel，像素，电子屏幕上组成一幅图画或image的基本单元。



 pt， point，点，印刷行业常用单位，等于1/72英寸。

- ppi，pixel per inch，每英寸像素数，值越高，屏幕越细腻。
- dpi， dot per inch，每英寸多少点，该值越高，则图片越细腻。
- dp，dip， Density-independent pixel，安卓开发用的长度单位。以160ppi为标准，和iPhone的scale差不多的意思。安卓用dp适配，系统会自动将dp转换为px。当屏幕像素点密度为160ppi时，1dp=1px。

#### 一，pt与px ： 1pt = (ppi / 72)px。

当图片的分辨率是72ppi（dpi）时，1pt = 1px；
 当图片的分辨率是72*2ppi（dpi）时，1pt = 2px；

#### 二，ppi与dpi：dpi=ppi

dpi最初用于衡量打印物上每英寸的点数密度，DPI值越大图片越精细。当DPI的概念用在计算机屏幕上时，就应称之为ppi。同理： PPI就是计算机屏幕上每英寸可以显示的像素点的数量。在电子屏幕显示中ppi和dpi是一样的。

#### 三，ppi计算方法

假设屏幕分辨率为W*H(px)，物理尺寸为a*b(inch)，
 则我们常说的屏幕尺寸c（如5.0英寸）其实是对角线的长度，因此

![img](https:////upload-images.jianshu.io/upload_images/3103322-1c919267f65fa11a.png?imageMogr2/auto-orient/strip|imageView2/2/w/73/format/webp)

勾股定理



则像素密度（PPI），指的是屏幕单位长度的像素数



![img](https:////upload-images.jianshu.io/upload_images/3103322-65161cf7ec95c6a2.png?imageMogr2/auto-orient/strip|imageView2/2/w/128/format/webp)

屏幕密度

由此我们推理出：



![img](https:////upload-images.jianshu.io/upload_images/3103322-b39d1048168965bf.png?imageMogr2/auto-orient/strip|imageView2/2/w/296/format/webp)

屏幕密度



因此我们可以得出PPI（ DPI）计算公式：



![img](https:////upload-images.jianshu.io/upload_images/3103322-cec5c779f3d266b4.png?imageMogr2/auto-orient/strip|imageView2/2/w/139/format/webp)

PPI（ DPI）计算公式


 eg：iphone6分辨率1334*750px，尺寸4.7英寸
 则其

![img](https:////upload-images.jianshu.io/upload_images/3103322-c80d1c5eafc135a3.png?imageMogr2/auto-orient/strip|imageView2/2/w/277/format/webp)

iphone6像素密度

#### 四，px和dp

dp，独立像素，虚拟单位，又称设备无关像素。1dp的长度相当于一个160dpi的屏幕上一个物理像素的长度。而160dpi的屏幕则是被android定义为基准的屏幕（mdpi）。在app运行的时候，android会将dp转为实际像素进行布局。转换的公式为：
 px = dp * (dpi / 160)。
 dp为安卓开发时的基本长度单位，根据不同的屏幕分辨率，与px有不同的对应关系。根据其像素密度，我们将安卓端屏幕分为以下几种规格：



![img](https:////upload-images.jianshu.io/upload_images/3103322-d7add0f6570f325d.png?imageMogr2/auto-orient/strip|imageView2/2/w/637/format/webp)

QQ20150717160404.png



1dp即为当屏幕密度值为160ppi时，1pt=1px。则，在上表中，当密度为mdpi时，1dp = 1px。 以mdpi为标准，上表中屏幕的密度值比分别为：



![img](https:////upload-images.jianshu.io/upload_images/3103322-1878e109966df8ba.png?imageMogr2/auto-orient/strip|imageView2/2/w/568/format/webp)

Untitled 2.png

即，在xhdpi的密度下，1dp=2px；在hdpi情况下，1dp=1.5px。其他类推。



作者：Ozhy1991yhzO
链接：https://www.jianshu.com/p/3b612fb6d685
来源：简书
著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。

分辨率：用于描述[媒体查询](https://developer.mozilla.org/en-US/docs/Web/CSS/Media_Queries)中的分辨率的<resolution> CSS[数据类型](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Types)表示输出设备的像素密度。

在屏幕上，单位与CSS英寸，厘米或像素有关，而与物理值无关。

## [Syntax](https://developer.mozilla.org/zh-CN/docs/Web/CSS/resolution#syntax)

<resolution>数据类型由严格为正[``](https://developer.mozilla.org/zh-CN/docs/Web/CSS/number)组成，后跟下面列出的单位之一。与所有CSS维度一样，单位字面值与数字之间没有空格。

### [单位](https://developer.mozilla.org/zh-CN/docs/Web/CSS/resolution#单位)

- `dpi`

  表示[每英寸的点数](https://en.wikipedia.org/wiki/Dots_per_inch)。屏幕通常每英寸包含72或96个点，但打印文档的dpi通常要大得多。 1英寸是2.54厘米，1dpi≈0.39dpcm。

- `dpcm`

  [每厘米上的点数](https://en.wikipedia.org/wiki/Dots_per_inch)。1英寸是2.54厘米, `1dpcm ≈ 2.54dpi`.

- `dppx`

  表示每个`px`的点数。 由于CSS px的固定比率为1:96，因此1dppx相当于96dpi。 which corresponds to the default resolution of images displayed in CSS as defined by [`image-resolution` (en-US)](https://developer.mozilla.org/en-US/docs/Web/CSS/image-resolution).

- `x`

   `dppx` 的别名

**Note:** Although the number `0` is always the same regardless of unit, the unit may not be omitted. In other words, `0` is invalid and does not represent `0dpi`, `0dpcm`, or `0dppx`.

## [Examples](https://developer.mozilla.org/zh-CN/docs/Web/CSS/resolution#examples)

### [Use in a media query](https://developer.mozilla.org/zh-CN/docs/Web/CSS/resolution#use_in_a_media_query)

```
@media print and (min-resolution: 300dpi) { ... }
```

Copy to Clipboard

### [Valid resolutions](https://developer.mozilla.org/zh-CN/docs/Web/CSS/resolution#valid_resolutions)

```
96dpi
50.82dpcm
3dppx
```

### [Invalid resolutions](https://developer.mozilla.org/zh-CN/docs/Web/CSS/resolution#invalid_resolutions)

```
72 dpi     Spaces are not allowed between the number and the unit.
ten dpi    The number must use digits only.
0          The unit is required.
```