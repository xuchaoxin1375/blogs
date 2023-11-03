## Json definition

## 权威定义

* [JSON](https://www.json.org/json-en.html)
* [JSON中文](https://www.json.org/json-zh.html)
* [JSON - MDN Web Docs Glossary: Definitions of Web-related terms | MDN (](https://developer.mozilla.org/en-US/docs/Glossary/JSON)[mozilla.org](http://mozilla.org)[)](https://developer.mozilla.org/en-US/docs/Glossary/JSON)
* [JSON - JavaScript | MDN (](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/JSON)[mozilla.org](http://mozilla.org)[)](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/JSON)
* [JSON - Wikipedia](https://en.wikipedia.org/wiki/JSON#Syntax)

### 其他资料

* [JSON Schema 参考书 - 云+社区 - 腾讯云 (tencent.com)](https://cloud.tencent.com/developer/article/1015768)
* [使用JSON - 学习 Web 开发 | MDN (mozilla.org)](https://developer.mozilla.org/zh-CN/docs/Learn/JavaScript/Objects/JSON#%E6%80%BB%E7%BB%93)

### json基本特点

JSON is purely a string with a specified data format — `it contains only properties, no methods.`

JSON requires double quotes to be used around strings and property names.

* Single quotes are not valid other than surrounding the entire JSON string.

Even a single misplaced comma or colon can cause a JSON file to go wrong, and not work.

* You should be careful to validate any data you are attempting to use (although computer-generated JSON is less likely to include errors, as long as the generator program is working correctly). You can validate JSON using an application like [JSONLint](https://jsonlint.com/).

JSON can actually take the form of any `data type` that is `valid for inclusion inside JSON`, not just arrays or objects.

* So for example, a single string or number would be valid JSON.(这种情况下用处不大)

Unlike in JavaScript code in which object properties may be unquoted, in JSON only quoted strings may be used as properties.

### Data types

JSON's basic data types are:

* `Number`: a signed decimal number that may contain a fractional part and may use exponential [E notation](https://en.wikipedia.org/wiki/E_notation), but cannot include non-numbers such as [NaN](https://en.wikipedia.org/wiki/NaN). The format makes no distinction between integer and floating-point. JavaScript uses a [double-precision floating-point format](https://en.wikipedia.org/wiki/Double-precision_floating-point_format) for all its numeric values (until later also supports [BigInt](https://en.wikipedia.org/wiki/Arbitrary-precision_arithmetic)[\[24\]](https://en.wikipedia.org/wiki/JSON#cite_note-24)), but other languages implementing JSON may encode numbers differently.
* [String](https://en.wikipedia.org/wiki/String_(computer_science)): a sequence of zero or more [Unicode](https://en.wikipedia.org/wiki/Unicode) characters. Strings are delimited with double-quotation marks and support a backslash [escaping](https://en.wikipedia.org/wiki/Escape_character) syntax.
* [Boolean](https://en.wikipedia.org/wiki/Boolean_datatype): either of the values `true` or `false`
* [Array](https://en.wikipedia.org/wiki/Array_data_structure): an [ordered list](https://en.wikipedia.org/wiki/List_(abstract_data_type)) of zero or more elements, each of which may be of any type. Arrays use [square bracket](https://en.wikipedia.org/wiki/Square_bracket) notation with comma-separated elements.
* [Object](https://en.wikipedia.org/wiki/Object_(computer_science)): a collection of [name–value pairs](https://en.wikipedia.org/wiki/Attribute%E2%80%93value_pair) where the names (also called keys) are strings. The current ECMA standard states: "The JSON syntax does not impose any restrictions on the strings used as names, does not require that name strings be unique, and does not assign any significance to the ordering of name/value pairs."[\[25\]](https://en.wikipedia.org/wiki/JSON#cite_note-25) Objects are delimited with [curly brackets](https://en.wikipedia.org/wiki/Braces_(punctuation)#Braces) and use commas to separate each pair, while within each pair the colon ':' character separates the key or name from its value.
* [`null`](https://en.wikipedia.org/wiki/Nullable_type): an empty value, using the word `null`
