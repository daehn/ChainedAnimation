# ChainedAnimation

[![CI Status](http://img.shields.io/travis/daehn/ChainedAnimation.svg?style=flat)](https://travis-ci.org/daehn/ChainedAnimation) 
![Version](https://img.shields.io/cocoapods/v/ChainedAnimation.svg?style=flat) 
![License](https://img.shields.io/cocoapods/l/ChainedAnimation.svg?style=flat) 
![Platform](https://img.shields.io/cocoapods/p/ChainedAnimation.svg?style=flat)

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.  
Chain multiple animations with different delays.

<img src="chain-example-loop.gif" width="250">

You can create a chained animation with the `-beginAnimationChain` function on the UIView class.

```swift
UIView.beginAnimationChain(0.5) {
  view.frame.origin.y = 170
}.animate()
```

You can provide an optional delay an `UIViewAnimationOptions`.

```swift
UIView.beginAnimationChain(0.5, delay: 0.2, options: .CurveEaseInOut) {
  view.frame.origin.y = 170
}.animate()
```
To add an offset animation, use the `-thenAfter:` function and append an
animation closure that will be executed after the provided offset. Add a completion 
closure to the animation chain and it will be executed when the previous animation
in the chain completed.

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

## Installation

ChainedAnimation is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "ChainedAnimation"
```

## Author

Silvan Dähn, @silvandaehn

## License

Chain is available under the MIT license. See the LICENSE file for more info.
