[toc]

## refs

- [创建我的第一个表单 - 学习 Web 开发 | MDN](https://developer.mozilla.org/zh-CN/docs/Learn_web_development/Extensions/Forms/Your_first_form)
- [如何构建 HTML 表单 - 学习 Web 开发 | MDN](https://developer.mozilla.org/zh-CN/docs/Learn_web_development/Extensions/Forms/How_to_structure_a_web_form)

## 典型表单示例

```html
<form action="/my-handling-form-page" method="post">
  <div>
    <label for="name">Name:</label>
    <input type="text" id="name" name="user_name" />
  </div>

  <div>
    <label for="mail">E-mail:</label>
    <input type="email" id="mail" name="user_email" />
  </div>

  <div>
    <label for="msg">Message:</label>
    <textarea id="msg" name="user_message"></textarea>
  </div>

  <div class="button">
    <button type="submit">Send your message</button>
  </div>
</form>

```

最外围的`form`则**定义了用户填写的数据最终被什么样的方式(`method`)传递到什么位置(页面)以执行后续处理动作(`action`)**

> 在表单中,最常见的`method`(请求方法)是`post`

在 `<form>` 元素之外也可以使用表单控件，但是如果你这样做了，那么除非使用 `form` **属性**将其与表单关联，否则该控件与任何表单都没有任何关系。

注意其中的`for,id,name`,其中for和id是对应的,`label`的`for`值和`input`的`id`匹配,提高表单的可读性,提示用户该填写什么

而`input`的`name`则用来定义键值对,用户提交的输入被`name`赋予一个名字,便于服务端使用分辨和这些数据

表单中一种常见的形式是选择题,其中的一个选项可以被典型地用如下代码描述

```html
<label for="title_1">
  <input type="radio" id="title_1" name="title" value="A" />
  Ace
</label>
```

这里`input`标签中还出现了`value`属性(这里input的`type`为`radio`,表明这个表单微件是一个选择题的选项,更具这种微件的行为,应当配值`value`取值,例子中`value="A"`表示,如果用户选择/点击了这个微件,那么这个选择题获得的值就是"A",而只有一个可点击的微件图标通常是不够的,还需要添加选项的描述,否则不同选项对于用户来说似乎没有多少差别,为了描述选项代表的含义(答案),通常使用`label`标签来表述选项的内容,这个例子中"Ace"这个字符串会提示用户,这个选项(input)对应的含义是"Ace",如果用户认为当前选择题答案是字符串"Ace",那么应该选这个选项,而发往后续处理的选项值是`value`中定义的`A`,而不是提示给用户看的"Ace",这和现实生活中的答题卡填涂选择题答案的过程是相符的)

这种选择题形式的`type="radio"`和`type='text'`相差很多，后者直接将用户填写的字符串作为value,而不需要在`input`中使用`value`指定一个要提交的值

---



## `<fieldset> `和` <legend>` 元素

- `<fieldset>` 元素是一种方便的用于创建**具有相同目的（出于样式和语义目的）**的**微件组**(set)的方式。
  - 你可以在 <fieldset> 起始标签后加上一个 `<legend>` 元素，来给 <fieldset> 做**标签**。
  - <legend> 的文本内容形式地**描述了 `<fieldset>` 里所含有微件的用途**。
    - (最典型的就是制作一个选择题的表单,一个选择题包含若干个选项,应当属于同一个题干,利用`<fieldset>`标签来描述这种成组关系)
    - 此外,还可以用来对长表单的分段,以提高表单可读性
- 许多辅助技术在使用 <legend> 元素时，会将其视为相应 <fieldset> 元素中每个控件标签的一部分。例如，Jaws 和 NVDA 等屏幕阅读器会在说出每个控件的标签之前先说出图例的内容。

### 综合示例

除了特定于 HTML 表单的结构之外，还应该记住表单同样是 HTML。这意味着你可以使用 HTML 的所有强大功能来构造一个 HTML 表单。

正如你在示例中可以看到的，通常的做法是用 `<ul>` 或 `<ol>` 列表中的 `<li>` 元素来封装标签及其微件。

`<p>` 和 `<div>` 元素**也很常用**。建议**使用列表来构建多个复选框或单选按钮**。

---



除了 `<fieldset>` 元素之外，使用 HTML 标题（如 h1、h2）和分段（如 `<section>`）来构造一个复杂的表单也是一种常见的做法。

最重要的是，要找到一种舒适的编码风格，使表单易于访问和使用。每个独立的功能部分都应包含在一个单独的 `<section>` 元素中，`<fieldset>` 元素包含单选按钮。

```html
<form>

<h1>付款表单</h1>
<p>
  必需的字段已使用 <strong><span aria-label="required">*</span></strong> 标示。
</p>

<section>
  <h2>联系人信息</h2>
  <fieldset>
    <legend>称号</legend>
    <ul>
      <li>
        <label for="title_1">
          <input type="radio" id="title_1" name="title" value="A" />
          Ace
        </label>
      </li>
      <li>
        <label for="title_2">
          <input type="radio" id="title_2" name="title" value="K" />
          King
        </label>
      </li>
      <li>
        <label for="title_3">
          <input type="radio" id="title_3" name="title" value="Q" />
          Queen
        </label>
      </li>
    </ul>
  </fieldset>
  <p>
    <label for="name">
      <span>名字：</span>
      <strong><span aria-label="必须">*</span></strong>
    </label>
    <input type="text" id="name" name="username" required />
  </p>
  <p>
    <label for="mail">
      <span>邮箱：</span>
      <strong><span aria-label="必须">*</span></strong>
    </label>
    <input type="email" id="mail" name="usermail" required />
  </p>
  <p>
    <label for="pwd">
      <span>密码：</span>
      <strong><span aria-label="必须">*</span></strong>
    </label>
    <input type="password" id="pwd" name="password" required />
  </p>
</section>

<section>
  <h2>付款信息</h2>
  <p>
    <label for="card">
      <span>信用卡类型</span>
    </label>
    <select id="card" name="usercard">
      <option value="visa">Visa</option>
      <option value="mc">Mastercard</option>
      <option value="amex">American Express</option>
    </select>
  </p>
  <p>
    <label for="number">
      <span>卡号：</span>
      <strong><span aria-label="required">*</span></strong>
    </label>
    <input type="tel" id="number" name="cardnumber" required />
  </p>
  <p>
    <label for="expiration">
      <span>到期日：</span>
      <strong><span aria-label="required">*</span></strong>
    </label>
    <input
      type="text"
      id="expiration"
      name="expiration"
      required
      placeholder="MM/YY"
      pattern="^(0[1-9]|1[0-2])\/([0-9]{2})$" />
  </p>
</section>

<section>
  <p>
    <button type="submit">验证付款请求</button>
  </p>
</section>

</form>

```

