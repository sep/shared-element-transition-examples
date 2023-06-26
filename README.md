## What are Shared Element Transitions?

Shared Element Transitions animate elements from one app layout to another. They help users understand how the interface changes when moving from screen to screen. These transitions can be very easy to design, prototype, and build in code.

## How to Design View Transitions

Figma’s Smart Animate feature is perfect for prototyping shared element transitions.

![Placeholder Image](https://picsum.photos/800/300)

1. Design two screens you want to transition between. Make sure the elements you want to "share" between the views have the same layer name and layer structure in both screens.
2. Add a "Navigate to" interaction between the elements
3. Set the animation to "Smart Animate"

![Placeholder Image](https://picsum.photos/800/300)

That was easy! However, this transition could be clearer. 
- The title and image move in conflicting directions, which can make the overall transition a bit confusing to follow. When all elements move in a cohesive manner, the overall "gesture" becomes clearer and easier to understand.
- There are too many moving elements. We only need to animate the important parts
- It takes too long

![Placeholder Image](https://picsum.photos/800/300)

It's important to use transitions sparingly and only when they improve the user experience. Excessive motion can make your interface harder to understand.

### Tips

- Consider creating a separate prototype specifically for demoing this transition. The layer structure and naming has to match exactly for Smart Animate to work. This can make transitions work with components, AutoLayout, and other Figma features.

## How to Build View Transitions

### On the Web

In the past, view transitions required careful planning and some tricky calculations using the ["F.L.I.P. Technique"](https://css-tricks.com/animating-layouts-with-the-flip-technique/). However, thanks to the the new [View Transitions API](https://developer.mozilla.org/en-US/docs/Web/API/View_Transitions_API), creating these transitions is much simpler. With this standardized API, we can smoothly transition between views with just a few lines of JavaScript and CSS.

First, we give unique IDs to the elements we want to transition using the CSS rule `view-transition-name`. These IDs help the browser recognize and move the elements to their desired positions during the transition, just like how matching layer names work in Figma.

Here is simplified HTML for an article preview in a list:

```html
<article>
  <!-- note that we need unique view transition names per article  -->
  <img style="view-transition-name: article-1-image;" src="..." alt="..." />
  <h2 style="view-transition-name: article-1-title;">Example Article</h2>
  <button>Read More</button>
</article>
<!-- ... -->
```

And the full article on another screen:

```html
<main>
  <img style="view-transition-name: article-1-image;" src="..." alt="..." />
  <h1 style="view-transition-name: article-1-title;">Example Article</h1>
  <!— ... —>
</main>
```

When the button is pressed, we will present the full content of the article. When we do this, we have to use a special JavaScript function that tells the browser to start a transition.

```js
document.startViewTransition(() => {
  // change the document to show the article somehow
});
```

![Placeholder Image](https://picsum.photos/800/300)

That's it! As long as the transition elements share the same unique `view-transition-name` on both screens, they will transition smoothly. It's not even necessary for the screens to have a similar structure. If desired, you can [customize the transition](https://developer.mozilla.org/en-US/docs/Web/API/View_Transitions_API#customizing_your_animations), but the default animation is suitable for many use cases.

You can use the View Transitions API today, but browser support is limtited. As of now, you can expect it to work for about [65% of your users](https://caniuse.com/?search=View%20Transition%20API). Don't let this stop you from using the API. Browsers are designed to ignore unsupported CSS rules, so including `view-transition-name` won't cause any issues. As for the JavaScript, it is simple to "mock" the API to prevent errors on older browsers.

```js
// check if the browser doesn’t support the View Transitions API
if (typeof document.startViewTransition === "undefined") {
  // add a mock function to the document object
  document.startViewTransition = function (callback) {
    // simply run the code that changes the document
    callback();
    // return a mock `ViewTransition` controller object
    return {
      finished: Promise.resolve(true),
      ready: Promise.resolve(true),
      updateCallbackDone: Promise.resolve(true),
      skipTransition: () => {},
    };
  };
}
```

View Transitions are simple, performant, and concise. They are low-risk progressive enhancements that can make your page transitions easier for your users to understand.

#### Tips

- Give transitioned images a similar aspect ratio in both views. The default animation for view transition is more of a cross-fade than a blend. Matching aspect ratios will look smoother during the transition.
- With transitioned text, consider using `width: max-content; max-width: 100%;` Depending on the transition, this can result in a smoother blend that doesn’t "squish" when animating.

### iOS and other Apple platforms

A SwiftUI View Modifier called [`matchedGeometryEffect`](https://www.hackingwithswift.com/quick-start/swiftui/how-to-synchronize-animations-from-one-view-to-another-with-matchedgeometryeffect) provides a very similar process for animating between views. It's a declarative API that is fairly flexible in terms of layout structure. However, I have found these animations require a lot of trial and error to make work correctly.

- https://www.youtube.com/watch?v=gSZMqTxAJRU
- How to
  - Add a namespace
  - Add a modifier
  - Switch the view out
- Supported on iOS 14+

### Android

- Called Shared Element Transitions
- https://developer.android.com/guide/fragments/animate

### Cross-Platform

Similar solutions are available on popular cross-platform libraries as well.

- React Native: Shared Element Transitions
- Flutter: Shared Element Transitions https://medium.com/@diegoveloper/flutter-shared-element-transitions-hero-heroes-f1a083cb123a

### View Transitions Can Be Simple

You can build these view transitions today on some platforms without too much of a hassle.
