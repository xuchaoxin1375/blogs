## 事件:event handler&event listener

* To react to an event, you attach an **event handler** to it.
* This is a block of code (usually a JavaScript function that you as a programmer create) that runs when the event fires.
* When such a block of code is defined to run in response to an event, we say we are  **registering an event handler** .
* Note: `Event handlers` are sometimes called`event listeners`— they are pretty much interchangeable for our purposes, `although strictly speaking, they work together`.


## [Using addEventListener()](https://developer.mozilla.org/en-US/docs/Learn/JavaScript/Building_blocks/Events#using_addeventlistener "Permalink to Using addEventListener()")

The` recommended mechanism` for adding event handlers in web pages is the [`addEventListener()`](https://developer.mozilla.org/en-US/docs/Web/API/EventTarget/addEventListener) method:


## [Event objects](https://developer.mozilla.org/en-US/docs/Learn/JavaScript/Building_blocks/Events#event_objects "Permalink to Event objects")

Sometimes, inside an event handler function, you'll see a parameter specified with a name such as `event`, `evt`, or `e`. This is called the  **event object** , and it is automatically passed to event handlers to provide extra features and information.
