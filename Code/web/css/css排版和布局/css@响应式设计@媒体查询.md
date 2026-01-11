[toc]



## 媒体查询

[媒体查询入门指南 - 学习 Web 开发 | MDN](https://developer.mozilla.org/zh-CN/docs/Learn_web_development/Core/CSS_layout/Media_queries)

CSS 媒体查询（Media Queries）是响应式网页设计的核心技术之一，它允许开发者根据设备的特性（如屏幕宽度、高度、分辨率等）应用不同的样式规则。通过媒体查询，您可以为不同设备（如手机、平板、桌面电脑）提供优化的用户体验。

以下是一个完整的 CSS 媒体查询教程，涵盖基本概念、语法、用法和实际示例。

---

## **1. 什么是 CSS 媒体查询？**
媒体查询是一种 CSS 技术，用于检测设备的特性，并根据这些特性应用不同的样式。最常见的用途是根据屏幕宽度调整布局，使网站在不同设备上都能良好显示。

---

## **2. 基本语法**
媒体查询的基本语法如下：
```css
@media media-type and (media-feature) {
    /* 样式规则 */
}
```

### **组成部分**

1. **`@media`**: 声明这是一个媒体查询。
2. **`media-type`**（可选）: 指定媒体类型，例如 `all`（所有设备）、`screen`（屏幕）、`print`（打印）。
3. **`media-feature`**: 定义条件，例如屏幕宽度、高度、分辨率等。
4. **样式规则**: 当条件满足时，应用的 CSS 样式。

---

## **3. 常见媒体特性**
以下是常用的媒体特性及其含义：

| 特性           | 描述                                                      |
| -------------- | --------------------------------------------------------- |
| `width`        | 视口宽度（包括滚动条）。                                  |
| `min-width`    | 最小视口宽度（常用于定义断点）。                          |
| `max-width`    | 最大视口宽度（常用于定义断点）。                          |
| `height`       | 视口高度。                                                |
| `min-height`   | 最小视口高度。                                            |
| `max-height`   | 最大视口高度。                                            |
| `orientation`  | 设备方向，值为 `portrait`（纵向）或 `landscape`（横向）。 |
| `resolution`   | 设备分辨率（DPI 或 DPCM），例如 `192dpi`。                |
| `aspect-ratio` | 视口宽高比（宽度/高度）。                                 |
| `hover`        | 检测设备是否支持悬停（鼠标悬停）。                        |

---

## **4. 示例：基于屏幕宽度的样式调整**
以下是一个典型的响应式设计示例，使用媒体查询根据屏幕宽度调整布局：

```css
/* 默认样式：适用于小屏幕 */
body {
    font-size: 16px;
    background-color: lightblue;
}

.container {
    width: 100%;
    padding: 10px;
}

/* 针对中等屏幕（宽度 ≥ 768px） */
@media screen and (min-width: 768px) {
    body {
        background-color: lightgreen;
    }

    .container {
        width: 75%;
        margin: 0 auto; /* 居中 */
    }
}

/* 针对大屏幕（宽度 ≥ 1200px） */
@media screen and (min-width: 1200px) {
    body {
        background-color: lightcoral;
    }

    .container {
        width: 60%;
    }
}
```

---

## **5. 使用逻辑运算符**
媒体查询支持逻辑运算符（`and`、`not`、`only` 和逗号分隔的列表），以组合多个条件。

### **示例 1: 使用 `and` 组合条件**
```css
@media screen and (min-width: 768px) and (max-width: 1024px) {
    body {
        background-color: lightyellow;
    }
}
```
解释：当屏幕宽度在 768px 到 1024px 之间时，背景颜色变为浅黄色。

### **示例 2: 使用逗号分隔多个条件**
```css
@media screen and (min-width: 1200px), print {
    body {
        font-size: 20px;
    }
}
```
解释：当屏幕宽度 ≥ 1200px 或处于打印模式时，字体大小设置为 20px。

---

## **6. 常见断点**
以下是一些常见的响应式设计断点，用于适配不同设备：

| 设备类型         | 断点范围       | 示例媒体查询                                                 |
| ---------------- | -------------- | ------------------------------------------------------------ |
| 手机（小屏幕）   | ≤ 767px        | `@media screen and (max-width: 767px)`                       |
| 平板（中等屏幕） | 768px - 1024px | `@media screen and (min-width: 768px) and (max-width: 1024px)` |
| 桌面（大屏幕）   | ≥ 1025px       | `@media screen and (min-width: 1025px)`                      |
| 超大屏幕         | ≥ 1200px       | `@media screen and (min-width: 1200px)`                      |

---

## **7. 高级用法**

### **7.1. 检测设备方向**
```css
/* 纵向模式 */
@media screen and (orientation: portrait) {
    body {
        background-color: lightpink;
    }
}

/* 横向模式 */
@media screen and (orientation: landscape) {
    body {
        background-color: lightgray;
    }
}
```

### **7.2. 检测分辨率**
```css
/* 高分辨率屏幕（如 Retina 显示器） */
@media screen and (-webkit-min-device-pixel-ratio: 2),
       screen and (min-resolution: 192dpi) {
    body {
        background-image: url('high-res-image.jpg');
    }
}
```

### **7.3. 检测是否支持悬停**
```css
/* 支持悬停的设备 */
@media (hover: hover) {
    a:hover {
        color: red;
    }
}

/* 不支持悬停的设备 */
@media (hover: none) {
    a {
        color: blue;
    }
}
```

---

## **8. 实际案例：响应式导航栏**
以下是一个响应式导航栏示例，使用媒体查询实现不同屏幕下的布局调整：

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>响应式导航栏</title>
    <style>
        /* 默认样式 */
        nav {
            display: flex;
            justify-content: space-between;
            background-color: #333;
            padding: 10px;
        }

        nav a {
            color: white;
            text-decoration: none;
            margin: 0 10px;
        }

        /* 小屏幕：隐藏导航链接，改为汉堡菜单 */
        @media screen and (max-width: 768px) {
            nav {
                flex-direction: column;
                align-items: center;
            }

            nav a {
                display: none; /* 隐藏链接 */
            }

            nav button {
                display: block;
                background-color: #555;
                color: white;
                border: none;
                padding: 10px;
                cursor: pointer;
            }
        }
    </style>
</head>
<body>
    <nav>
        <a href="#">首页</a>
        <a href="#">产品</a>
        <a href="#">关于我们</a>
        <button>菜单</button>
    </nav>
</body>
</html>
```

---

## **9. 注意事项**
1. **使用 `meta` 标签**:
   在 HTML 文件的 `<head>` 中添加以下代码，确保页面在移动设备上正确缩放：
   ```html
   <meta name="viewport" content="width=device-width, initial-scale=1.0">
   ```

2. **避免过度复杂**:
   媒体查询应尽量简洁，避免过多嵌套或复杂的条件。

3. **测试多设备**:
   使用浏览器的开发者工具或真实设备测试样式效果。

---

## **10. 总结**
CSS 媒体查询是实现响应式设计的关键技术，通过灵活运用媒体类型和特性，您可以为不同设备提供最佳的用户体验。掌握基本语法和常见断点后，您可以轻松创建适应各种屏幕的网站。

如果您有任何问题或需要进一步的帮助，请随时提问！



## 案例

### 例1

```css
@media (min-width: 922px) {
    .site-content .ast-container {
        display: flex;
        flex-direction: column;
    }
}
```

这段代码是一个 **媒体查询**（Media Query），它的作用是根据特定的屏幕条件（例如宽度、高度、分辨率等）应用不同的样式规则。

#### 1. `@media` 媒体查询

- `@media` 是 CSS 中用于定义媒体查询的关键字。
- 它允许你根据设备的特性（如屏幕宽度、高度、方向等）来应用不同的样式。
- 在这里，`(min-width: 922px)` 表示当屏幕的宽度 **大于或等于 922 像素** 时，应用括号内的样式规则。

#### 2. 选择器：`.site-content .ast-container`

- `.site-content .ast-container` 是一个后代选择器，表示选择所有在 `.site-content` 元素内部的 `.ast-container` 元素。
- 这个选择器的目标是针对页面中特定的容器元素。

#### 3. 样式规则

- `display: flex;`
  - 将 `.ast-container` 设置为弹性盒子布局（Flexbox）。
  - 弹性盒子是一种强大的布局模型，用于创建灵活且响应式的布局。
- `flex-direction: column;`
  - 指定弹性盒子的主轴方向为纵向（从上到下）。
  - 默认情况下，Flexbox 的主轴方向是横向（`row`），但在这里被改成了纵向。



