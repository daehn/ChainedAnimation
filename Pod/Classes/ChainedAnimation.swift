//
//  ChainedAnimation.swift
//  Pods
//
//  Created by Silvan Dähn on 21.06.15.
//
//

import UIKit

public typealias Animation = () -> Void
public typealias Completion = ((Bool) -> Void)?

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

public struct AnimationChain {
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

    /**
    Appends a new animation closure to the current chain with the given offset and
    returns a new `AnimationChain` constiting of all `BoxedAnimations`.

    :param: offset    The offset of execution in seconds after the previous animation.
    :param: animation The animation that should be added with the given ofset.

    :returns: A new `AnimationChain` including the added animation.
    */

    public func thenAfter(offset: NSTimeInterval, animation: Animation) -> AnimationChain {
        let boxedFunction = BoxedAnimation(animation: animation, delay: self.currentOffset + offset)
        return AnimationChain(duration: duration, options: options, animations: animations + [boxedFunction], currentOffset: currentOffset + offset)
    }

    /**
    Appends a completion closure to the current chain and returns the
    new chain. The completion closure will be executed after the animation in the
    closure before was executed.
    
    :param: completion The closure that will be executed after the animation before completed.

    :return: A new `AnimationChain` with the added completion closure.
    **/

    public  func completion(completion: Completion) -> AnimationChain {
        var previousAnimations = animations
        let lastAnimation = previousAnimations.removeLast()
        let boxedFunction = BoxedAnimation(animation: lastAnimation.animation, delay: lastAnimation.delay, completion: completion)
        return AnimationChain(duration: duration, options: options, animations: previousAnimations + [boxedFunction])
    }


    // Starts the animation of all animations in the current chain.
    public func animate() {
        for box in animations {
            box.execute(duration, options)
        }
    }
}

extension UIView {

    /** 
    Used to start a new `AnimationChain`.
    More animations can be added by calling `-thenAfter` on the return value.
    A completion closure can be added by calling `-completion` on the return value.
    All animations will be executed after calling `-animate`.

    :param: duration The duration that will be used for all animations added to the `AnimationChain`.
    :param: delay The delay before the execution of the first animation in the chain, default to 0.
    :param: options The `UIViewAnimationOptions` that will be used for every animation in the chain, default is nil.
    :param: animations The animations that should be executed first in the chain.
    
    :return: A new `AnimationChain` with the added animation.
    **/

    public class func beginAnimationChain(duration: NSTimeInterval, delay: NSTimeInterval = 0, options: UIViewAnimationOptions = nil, animations: Animation) -> AnimationChain {
        let boxedFunction = BoxedAnimation(animation: animations, delay: delay)
        return AnimationChain(duration: duration, options: options, animations: [boxedFunction])
    }
}


