# ChainedAnimation

[![Build Status](https://travis-ci.org/daehn/ChainedAnimation.svg?branch=master)](https://travis-ci.org/daehn/ChainedAnimation) ![Swift 3.0](https://img.shields.io/badge/Swift-3.0-orange.svg?style=flat) [![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.  

Chain multiple animations with different delays. Chained animations will be started with a delay after the last one started executing.

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
To add an offset animation, use the `-thenAfterStart:` function and append an
animation closure that will be executed as soon as the last animation started, delayed by the provided offset. Add a completion
closure to the animation chain and it will be executed when the previous animation in the chain completed.

```swift
UIView.beginAnimationChain(0.5, options: .CurveEaseInOut) {
  view.frame.origin.y = 170
}.thenAfterStart(0.1) {
  // This animation will be started 0.1 seconds
  // after the previous one started
  otherView.tranform = awesomeTransform
}.thenAfterStart(0.15) {
  // More shiny animations
}.completion { bool in
  // Do something nice on completion. Or don't.
}.animate()
```

It is also possible to add a new chain after a previous one completed.
To add a new chain call `-chainAfterCompletion:` and start adding animation blocks with their offset.

```swift
UIView.beginAnimationChain(0.33, options: .CurveEaseInOut) {
  view.frame.origin.y = 170
}.thenAfterStart(0.15) {
  // Start animations with a delayed start
}.completion { bool in
  // Do something nice on the completion of the first chain.
}.chainAfterCompletion(1.2, options: .CurveEaseIn) {
    // This animation will be started after the last
    // animation in the first chain completed
}.thenAfterStart(0.1) {
    // This animation will be started 0.1 seconds after
    // the first animation in the second chain started
}.completion { _ in
    // Do something nice on the completion of the second chain.
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
