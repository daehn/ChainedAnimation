# Chain
Chain multiple animations with different delays.

<img src="animation.gif" width="250">

Create a chained animation like this:

```swift
UIView.beginAnimationChain(0.5, options: .CurveEaseInOut) {
              view.frame.origin.y = 170
            }.thenAfter(0.1) {
              otherView.tranform = awesomeTransform
            }.thenAfter(0.15) {
              // More shiny animations
            }.completion { bool in
              // Do something nice on completion. Or don't.   
            }.animate()
```
