# CSS transition&CSS animations

## reference

- [The Main Difference Between CSS Animations & Transitions (hubspot.com)](https://blog.hubspot.com/website/css-transition-vs-animation)
- [Animatable CSS properties - CSS: Cascading Style Sheets | MDN (mozilla.org)](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_animated_properties)

## difference of transition&animation

- CSS transitions and animations are similar in many ways, but distinct in terms of how complicated transitions can be, how the CSS code interacts with JavaScript, how loops work, and the methodology that triggers the animation to play. 
- CSS transitions are generally best for **simple from-to movements**, while
-  CSS animations are for **more complex series of movements.**

- A transition ***is an animation***, just one that is performed between two distinct states - i.e. a start state and an end state. Like a drawer menu, the start state could be open and the end state could be closed, or vice versa.
- If you want to perform something that ***does not*** specifically involve a start state and an end state, or you need **more fine-grained control** over the **keyframes** in a transition, then you've got to use an animation.

> - [Transforms - Learn to Code Advanced HTML & CSS (shayhowe.com)](https://learn.shayhowe.com/advanced-html-css/css-transforms/)

## CSS Transition(过渡)

- [Using CSS transitions - CSS: Cascading Style Sheets | MDN (mozilla.org)](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Transitions/Using_CSS_transitions)

- ![image-20220621104611508](https://raw.githubusercontent.com/xuchaoxin1375/pictures/main/imagesimage-20220621104611508.png)


  *   Using CSS transitions
      *   [Which CSS properties can be transitioned?](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Transitions/Using_CSS_transitions#which_css_properties_can_be_transitioned)
      *   [Defining transitions](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Transitions/Using_CSS_transitions#defining_transitions)
      *   [Examples](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Transitions/Using_CSS_transitions#examples)
          *   [Simple example](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Transitions/Using_CSS_transitions#simple_example)
          *   [Multiple animated properties example](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Transitions/Using_CSS_transitions#multiple_animated_properties_example)
              *   [CSS Content](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Transitions/Using_CSS_transitions#css_content)
          *   [When property value lists are of different lengths](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Transitions/Using_CSS_transitions#when_property_value_lists_are_of_different_lengths)
          *   [Using transitions when highlighting menus](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Transitions/Using_CSS_transitions#using_transitions_when_highlighting_menus)
      *   [JavaScript examples](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Transitions/Using_CSS_transitions#javascript_examples)
          *   [Using transitions to make JavaScript functionality smooth](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Transitions/Using_CSS_transitions#using_transitions_to_make_javascript_functionality_smooth)
          *   [Detecting the start and completion of a transition](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Transitions/Using_CSS_transitions#detecting_the_start_and_completion_of_a_transition)
      *   [Specifications](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Transitions/Using_CSS_transitions#specifications)
      *   [See also](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Transitions/Using_CSS_transitions#see_also)

  

## CSS Animation(动画)

- **CSS animations** make it possible to animate transitions from one CSS style configuration to another. 
- Animations consist of two components, 
  - a **style** describing the CSS animation and 
  - a set of **keyframes** that indicate <u>the start and end states of the animation's style</u>, as well as possible <u>intermediate waypoints.</u>

## Using Css Transform 

1. [CSS transforms properties](chrome-extension://afoibpobokebhgfnknfndkgemglggomo/popup.html#css_transforms_properties)
2. Examples
   1. [Rotating](chrome-extension://afoibpobokebhgfnknfndkgemglggomo/popup.html#rotating)
   2. [Skewing and translating](chrome-extension://afoibpobokebhgfnknfndkgemglggomo/popup.html#skewing_and_translating)
3. 3D specific CSS properties
   1. Perspective
      1. Setting perspective
         1. [HTML](chrome-extension://afoibpobokebhgfnknfndkgemglggomo/popup.html#html)
         2. [CSS](chrome-extension://afoibpobokebhgfnknfndkgemglggomo/popup.html#css)
         3. [Result](chrome-extension://afoibpobokebhgfnknfndkgemglggomo/popup.html#result)
      2. Changing the perspective origin
         1. [HTML](chrome-extension://afoibpobokebhgfnknfndkgemglggomo/popup.html#html_2)
         2. [CSS](chrome-extension://afoibpobokebhgfnknfndkgemglggomo/popup.html#css_2)
         3. [Result](chrome-extension://afoibpobokebhgfnknfndkgemglggomo/popup.html#result_2)

### skew()

[skew() - CSS: Cascading Style Sheets | MDN (mozilla.org)](https://developer.mozilla.org/en-US/docs/web/css/transform-function/skew)

> - This transformation is a **shear mapping** ([transvection](https://en.wikipedia.org/wiki/Shear_mapping))(维基百科链接) that **distorts each point within an element** by <u>a certain angle in the horizontal and vertical directions</u>. 
>   - The effect is <u>as if you grabbed each corner of the element and pulled them</u> along **a certain angle.**
>
> - The coordinates of each point are modified by **a value proportionate to the specified angle** and **the distance to the origin.** 
>   - Thus, the **farther** from the origin a point is, <u>the greater the value added to it</u>.

- ![image-20220422195019487](https://cdn.jsdelivr.net/gh/xuchaoxin1375/pictures@main/images/image-20220422195019487.png)
- ![image-20220422195039910](https://cdn.jsdelivr.net/gh/xuchaoxin1375/pictures@main/images/image-20220422195039910.png)
- ![image-20220422195100005](https://cdn.jsdelivr.net/gh/xuchaoxin1375/pictures@main/images/image-20220422195100005.png)

### 3D

- [3D specific CSS properties](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Transforms/Using_CSS_transforms#3d_specific_css_properties)

  - Performing CSS transformations in 3D space is a bit more complex. 

  - You have to start by configuring **the 3D space** by giving it a **perspective**, then you have to configure how your **2D elements** will behave in that space.

  - [Perspective](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Transforms/Using_CSS_transforms#perspective)

  **The first element** to set is the [`perspective`](https://developer.mozilla.org/en-US/docs/Web/CSS/perspective). 

  The **perspective** is what <u>gives us the 3D impression</u>. 

  **The farther** from the viewer the elements are, **the smaller** they are.

### Setting perspective

This example shows a cube with the perspective set at different positions. How quick the cube shrinks is defined by the [`perspective`](https://developer.mozilla.org/en-US/docs/Web/CSS/perspective) property. The smaller its value is, the deeper the perspective is.