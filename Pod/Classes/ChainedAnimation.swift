//
//  ChainedAnimation.swift
//  Pods
//
//  Created by Silvan Dähn on 21.06.15.
//
//

import UIKit

public typealias Animation = () -> Void
public typealias Completion = (Bool -> Void)?

struct BoxedAnimation {
    let animation: Animation
    let duration: NSTimeInterval
    let delay: NSTimeInterval
    let options: UIViewAnimationOptions
    var completion : Completion

    init(_ animation: Animation, duration: NSTimeInterval, delay: NSTimeInterval, options: UIViewAnimationOptions = nil, completion: Completion = nil) {
        self.animation = animation
        self.duration = duration
        self.delay = delay
        self.options = options
        self.completion = completion
    }

    func execute() {
        UIView.animateWithDuration(duration, delay: delay, options: options, animations: animation, completion: completion)
    }
}

public struct AnimationChain {
    let options: UIViewAnimationOptions
    var animations: [[BoxedAnimation]]
    var currentOffset: NSTimeInterval

    init(options: UIViewAnimationOptions,
        animations: [[BoxedAnimation]],
        currentOffset : NSTimeInterval = 0) {
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

    public func thenAfterStart(offset: NSTimeInterval, animation: Animation) -> AnimationChain {
        var previousAnimations = animations
        var previousChain = previousAnimations.removeLast()
        let previousDuration = previousChain.last?.duration ?? 0
        var boxedFunction = BoxedAnimation(animation, duration: previousDuration, delay: self.currentOffset + offset, options: options)
        previousAnimations.append(previousChain + [boxedFunction])
        return AnimationChain(options: options, animations: previousAnimations, currentOffset: currentOffset + offset)
    }

    /**
    Appends a completion closure to the current chain and returns the
    new chain. The completion closure will be executed after the animation in the
    closure before was executed.

    :param: completion The closure that will be executed after the animation before completed.

    :return: A new `AnimationChain` with the added completion closure.
    **/

    public func completion(completion: Completion) -> AnimationChain {
        var previousAnimations = animations
        var lastChain = previousAnimations.removeLast()
        var lastAnimation = lastChain.removeLast()
        let boxedFunction = BoxedAnimation(lastAnimation.animation, duration: lastAnimation.duration, delay: lastAnimation.delay, completion: completion)
        let newChain = lastChain + [boxedFunction]
        previousAnimations.append(newChain)
        return AnimationChain(options: options, animations: previousAnimations)
    }

    public func chainAfterCompletion(duration: NSTimeInterval,
        delay: NSTimeInterval = 0,
        options: UIViewAnimationOptions = nil,
        animations newAnimations: Animation) -> AnimationChain {
            let boxedFunction = BoxedAnimation(newAnimations, duration: duration, delay: delay, options: options)
            let newChain = animations + [[boxedFunction]]
            return AnimationChain(options: options, animations: newChain)
    }

    // Starts the animation of all animations in the current chain.
    public func animate() {
        var boxedAnimationsArray: [[BoxedAnimation]] = []

        if animations.count > 1 {
            for var index = animations.count - 1; index >= 1; index-- {
                var (current, previous) = (animations[index], animations[index - 1])
                let lastBox = previous.removeLast()
                let wrappedAnimations = wrapAnimationBoxes(current, inCompletionOfBoxedAnimation: lastBox)
                previous.append(wrappedAnimations)
                boxedAnimationsArray.insert(previous, atIndex: 0)
            }
        } else {
            boxedAnimationsArray = animations
        }

        for boxedAnimations in boxedAnimationsArray {
            for animationChain in boxedAnimations {
                animationChain.execute()
            }
        }
    }

    private func wrapAnimationBoxes(var animationsToWrap: [BoxedAnimation], var inCompletionOfBoxedAnimation boxedAnimation: BoxedAnimation) -> BoxedAnimation {
        let completion = boxedAnimation.completion
        let newCompletion: Completion = { bool in
            if let completion = completion {
                completion(bool)
            }
            for box in animationsToWrap {
                box.execute()
            }
        }
        boxedAnimation.completion = newCompletion
        return boxedAnimation
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
        let boxedFunction = BoxedAnimation(animations, duration: duration, delay: delay, options: options)
        return AnimationChain(options: options, animations: [[boxedFunction]])
    }
}


