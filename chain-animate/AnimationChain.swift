//
//  AnimationChain.swift
//  chain-animate
//
//  Created by Silvan Dähn on 17.06.15.
//  Copyright (c) 2015 Silvan Dähn. All rights reserved.
//

import UIKit

typealias Animation = () -> Void
typealias Completion = ((Bool) -> Void)?

struct BoxedAnimation {
    let animation: Animation
    let delay: NSTimeInterval
    let completion : Completion

    init(animation: Animation, delay: NSTimeInterval, completion: Completion = nil) {
        self.animation = animation
        self.delay = delay
        self.completion = completion
    }

    func execute(duration: NSTimeInterval, _ options: UIViewAnimationOptions) {
        UIView.animateWithDuration(duration, delay: delay, options: options, animations: animation, completion: completion)
    }
}

struct AnimationChain {
    let duration: NSTimeInterval
    let options: UIViewAnimationOptions
    var animations: [BoxedAnimation]
    var currentOffset: NSTimeInterval

    init(duration: NSTimeInterval,
        options: UIViewAnimationOptions,
        animations: [BoxedAnimation],
        durations: [NSTimeInterval]? = nil,
        currentOffset : NSTimeInterval = 0) {
            self.duration = duration
            self.options = options
            self.animations = animations
            self.currentOffset = currentOffset
    }

    func thenAfter(offset: NSTimeInterval, animation: Animation) -> AnimationChain {
        let boxedFunction = BoxedAnimation(animation: animation, delay: self.currentOffset + offset)
        return AnimationChain(duration: duration, options: options, animations: animations + [boxedFunction], currentOffset: currentOffset + offset)
    }

    func completion(completion: Completion) -> AnimationChain {
        var previousAnimations = animations
        let lastAnimation = previousAnimations.removeLast()
        let boxedFunction = BoxedAnimation(animation: lastAnimation.animation, delay: lastAnimation.delay, completion: completion)
        return AnimationChain(duration: duration, options: options, animations: previousAnimations + [boxedFunction])
    }

    func animate() {
        for box in animations {
            box.execute(duration, options)
        }
    }
}

extension UIView {
    class func beginAnimationChain(duration: NSTimeInterval, delay: NSTimeInterval = 0, options: UIViewAnimationOptions = nil, animations: Animation) -> AnimationChain {
        let boxedFunction = BoxedAnimation(animation: animations, delay: delay)
        return AnimationChain(duration: duration, options: options, animations: [boxedFunction])
    }
}
