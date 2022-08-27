## button

The [`<button>`](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/button) element also accepts a `type` attribute — this accepts one of three values: `submit`, `reset`, or `button`.

* A click on a `submit` button (the default value) sends the form's data to the web page defined by the `action` attribute of the [`<form>`](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/form) element.
* A click on a `reset` button resets all the form widgets to their default value immediately. From a UX point of view, this is considered bad practice, so you should avoid using this type of button unless you really have a good reason to include one.
* A click on a `button` button does... nothing! That sounds silly, but it's amazingly useful for building custom buttons — you can define their chosen functionality with JavaScript.
