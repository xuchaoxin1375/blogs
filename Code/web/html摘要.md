## html.摘要md

### [Block versus inline elements](https://developer.mozilla.org/en-US/docs/Learn/HTML/Introduction_to_HTML/Getting_started#block_versus_inline_elements)

There are two important categories of elements to know in HTML: block-level elements and inline elements.

* Block-level elements form a visible block on a page. A block-level element appears on a new line following the content that precedes it. Any content that follows a block-level element also appears on a new line. Block-level elements are usually `structural elements` on the page. For example, a block-level element might represent headings, paragraphs, lists, navigation menus, or footers.
  * A block-level element wouldn't be nested inside an inline element,
  * but it might be nested inside another block-level element.
* Inline elements are contained within block-level elements, and surround `only small parts` of the document’s content (not entire paragraphs or groupings of content).
  * An inline element will not cause a new line to appear in the document.
  * It is typically used with text, for example an [`<a>`](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/a) element creates a hyperlink, and elements such as [`<em>`](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/em) or [`<strong>`](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/strong) create emphasis.

## block html elements & block css box

* The terms _block_ and _inline_ , as used in this article, should not be confused with [the types of CSS boxes](https://developer.mozilla.org/en-US/docs/Learn/CSS/Building_blocks/The_box_model#types_of_css_boxes) that have the same names.
  * While the names correlate by default, changing the CSS display type doesn't change the category of the element,
  * and doesn't affect which elements it can contain and which elements it can be contained in.
  * One reason HTML5 dropped these terms was to prevent this rather common confusion.
  * **Note:** Find useful reference pages that include lists of block and inline elements. See [Block-level elements](https://developer.mozilla.org/en-US/docs/Web/HTML/Block-level_elements) and [Inline elements](https://developer.mozilla.org/en-US/docs/Web/HTML/Inline_elements).
    * [list of blockElements (mozilla.org)](https://developer.mozilla.org/en-US/docs/Web/HTML/Block-level_elements#elements)
    * [List of "inline" elements](https://developer.mozilla.org/en-US/docs/Web/HTML/Inline_elements#list_of_inline_elements)

### An attribute should have:

* A space between it and the element name. (For an element with more than one attribute, the attributes should be separated by spaces too.)
* The attribute name, followed by an equal sign.
* An attribute value, wrapped with opening and closing quote marks.

## \[Entity references: Including special characters in HTML\]

* [Entity references: Including special characters in HTML](https://developer.mozilla.org/en-US/docs/Learn/HTML/Introduction_to_HTML/Getting_started#entity_references_including_special_characters_in_html)
* [List of XML and HTML character entity references - Wikipedia](https://en.wikipedia.org/wiki/List_of_XML_and_HTML_character_entity_references)

## 超链接


### [Document fragments]

- [Document fragments](https://developer.mozilla.org/en-US/docs/Learn/HTML/Introduction_to_HTML/Creating_hyperlinks#document_fragments "Permalink to Document fragments")
