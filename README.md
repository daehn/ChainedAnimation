# Chain

[![CI Status](http://img.shields.io/travis/Silvan Dähn/Chain.svg?style=flat)](https://travis-ci.org/Silvan Dähn/Chain)
[![Version](https://img.shields.io/cocoapods/v/Chain.svg?style=flat)](http://cocoapods.org/pods/Chain)
[![License](https://img.shields.io/cocoapods/l/Chain.svg?style=flat)](http://cocoapods.org/pods/Chain)
[![Platform](https://img.shields.io/cocoapods/p/Chain.svg?style=flat)](http://cocoapods.org/pods/Chain)

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.  
Chain multiple animations with different delays.

<img src="chain-example-loop.gif" width="250">

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

## Installation

Chain is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "Chain"
```

## Author

Silvan Dähn, @silvandaehn

## License

Chain is available under the MIT license. See the LICENSE file for more info.
