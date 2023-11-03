[toc]

## 字符实体大全参考ref

- [HTML Standard (whatwg.org)](https://html.spec.whatwg.org/multipage/named-characters.html#named-character-references)

- [Entity - 术语表 | MDN (mozilla.org)](https://developer.mozilla.org/zh-CN/docs/Glossary/Entity)

### 部分表格预览

- | `nbsp;`   | U+000A0         | 空格 |
  | --------- | --------------- | ---- |
  | `nbump;`  | U+0224E U+00338 | ≎̸    |
  | `nbumpe;` | U+0224F U+00338 | ≏̸    |
  | `ncap;`   | U+02A43         | ⩃    |
  | `Ncaron;` | U+00147         | Ň    |
  | `ncaron;` | U+00148         | ň    |
  | `Ncedil;` | U+00145         | Ņ    |
  | `ncedil;` | U+00146         |      |

## 渲染失败案例

- html_看似相同且正确的两段代码却无法渲染出一致的结果:空格问题(肉眼无法直接看出来错误的代码问题)/标签渲染不出来的可能原因/回调事件没有相应

##  这种由于ascii=160的空格可能引起渲染失败:

- 某些编辑器会显示出ascii=32和ascii=160的空格的区别
- 这种一般是复制代码可能造成混入&nbsp 空格的问题
- ![在这里插入图片描述](https://img-blog.csdnimg.cn/20210404113253452.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3h1Y2hhb3hpbjEzNzU=,size_16,color_FFFFFF,t_70)

##  可能导致标签渲染不出来的原因

不经常写前端的话,容易忘记某些细节,比如标签内的属性之间用的时空格来分割,如果使用了都好`,`之类的分隔符,就会导致渲染不出来
```html
 <!-- import vue cdn: -->
<script src="https://unpkg.com/vue@next"></script>
 <form @submit.prevent="insert">
            <input type="text" v-model="name">
            <input type="text" v-model.number="price">
            <button>add</button>
</form>
```
##  回调函数没有响应
- 不同于静态语言,js+html 经常对于标识符的不对应的检查能力较弱,这也是我们需要首先排查的地方,特别时函数签名和函数调用