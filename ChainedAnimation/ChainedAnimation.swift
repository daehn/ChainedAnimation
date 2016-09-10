//
//  ChainedAnimation.swift
//  ChainedAnimation
//
//  Created by Silvan Dähn on 10/09/2016.
//  Copyright © 2016 Silvan Dähn. All rights reserved.
//


import UIKit


public typealias Animation = () -> Void
public typealias Completion = (Bool) -> Void

public protocol AnimationProvider {
    func animate(withDuration duration: TimeInterval, delay: TimeInterval, options: UIViewAnimationOptions, animations: @escaping Animation, completion: Completion?)
}


struct UIViewAnimationProvider: AnimationProvider {
    func animate(withDuration duration: TimeInterval, delay: TimeInterval, options: UIViewAnimationOptions, animations: @escaping Animation, completion: Completion?) {
        UIView.animate(
            withDuration: duration,
            delay: delay,
            options: options,
            animations: animations,
            completion: completion
        )
    }
}

struct Animator {

    static var animationProvider: AnimationProvider = UIViewAnimationProvider()
    
    static func perform(configuration: AnimationConfiguration) {
        animationProvider.animate(
            withDuration: configuration.duration,
            delay: configuration.delay,
            options: configuration.options,
            animations: configuration.animation,
            completion: configuration.completion
        )
    }

}

struct AnimationConfiguration {

    let animation: Animation
    let duration: TimeInterval
    let delay: TimeInterval
    let options: UIViewAnimationOptions
    var completion : Completion?
    
    init(_ animation: @escaping Animation, duration: TimeInterval, delay: TimeInterval, options: UIViewAnimationOptions = [], completion: Completion? = nil) {
        self.animation = animation
        self.duration = duration
        self.delay = delay
        self.options = options
        self.completion = completion
    }
    
    mutating func add(Completion completion: @escaping Completion) {
        let currentCompletion = self.completion
        self.completion = {
            currentCompletion?($0)
            completion($0)
        }
    }
}

public struct AnimationChain {
    let options: UIViewAnimationOptions
    var animations: [[AnimationConfiguration]]
    var currentOffset: TimeInterval
    
    init(options: UIViewAnimationOptions, animations: [[AnimationConfiguration]], currentOffset : TimeInterval = 0) {
        self.options = options
        self.animations = animations
        self.currentOffset = currentOffset
    }
    
    /**
     Appends a new animation closure to the current chain with the given offset and
     returns a new `AnimationChain` constiting of all `BoxedAnimations`.
     
     - parameter offset    The offset of execution in seconds after the previous animation.
     - parameter animation The animation that should be added with the given ofset.
     
     - returns A new `AnimationChain` including the added animation.
     */
    public func thenAfterStart(_ offset: TimeInterval, animation: @escaping Animation) -> AnimationChain {
        
        var previousAnimations = animations
        let previousChain = previousAnimations.removeLast()
        let previousDuration = previousChain.last?.duration ?? 0
        let previousDelay = previousChain.last?.delay ?? 0
        let boxedFunction = AnimationConfiguration(
            animation,
            duration: previousDuration,
            delay: self.currentOffset + offset + previousDelay,
            options: options
        )
        previousAnimations.append(previousChain + [boxedFunction])
        return AnimationChain(options: options, animations: previousAnimations, currentOffset: currentOffset + offset)
    }
    
    /**
     Appends a completion closure to the current chain and returns the
     new chain. The completion closure will be executed after the animation in the
     closure before was executed.
     
     - parameter completion The closure that will be executed after the animation before completed.
    
     - return A new `AnimationChain` with the added completion closure.
     **/
    public func completion(_ completion: @escaping Completion) -> AnimationChain {
        
        var previousAnimations = animations
        var lastChain = previousAnimations.removeLast()
        let lastAnimation = lastChain.removeLast()
        let boxedFunction = AnimationConfiguration(
            lastAnimation.animation,
            duration: lastAnimation.duration,
            delay: lastAnimation.delay,
            completion: completion
        )
        let newChain = lastChain + [boxedFunction]
        previousAnimations.append(newChain)
        return AnimationChain(options: options, animations: previousAnimations)
    }
    
    /**
     Starts a new animation chain after the previous one completed.
     This is useful if you want another set of sequential animations to start after a previous one.
     Each chain can have an own completion closure.
     The appended chain will start executing together with the completion closure of the previous one.
     
     - parameter duration The duration that will be used for all animations added to the `AnimationChain`.
     - parameter delay The delay before the execution of the first animation in the chain, default to 0.
     - parameter options The `UIViewAnimationOptions` that will be used for every animation in the chain, default is nil.
     - parameter animations The animations that should be executed first in the chain.

     - return A new `AnimationChain` with the new chain appended.
     **/
    public func chainAfterCompletion(
        _ duration: TimeInterval,
        delay: TimeInterval = 0,
        options: UIViewAnimationOptions = [],
        animations newAnimations: @escaping Animation
        ) -> AnimationChain {
        
        let boxedFunction = AnimationConfiguration(newAnimations, duration: duration, delay: delay, options: options)
        let newChain = animations + [[boxedFunction]]
        return AnimationChain(options: options, animations: newChain)
    }
    
    /**
     Starts the animation of all animations in the current chain.
     Calls the completion closures added to individual chains after their completion.
     **/
    public func animate() {
        
        var animationChains: [[AnimationConfiguration]] = []
        if animations.count > 1 {
            stride(from: animations.count - 1, to: 0, by: -1).forEach { index in
                var (current, previous) = (animations[index], animations[index-1])
                let lastBox = previous.removeLast()
                let wrappedAnimations = wrap(configurations: current, inCompletionOf: lastBox)
                previous.append(wrappedAnimations)
                animationChains.insert(previous, at: 0)
            }
        } else {
            animationChains = animations
        }
        
        for chain in animationChains {
            chain.forEach(Animator.perform)
        }
    }
    
    private func wrap(configurations: [AnimationConfiguration], inCompletionOf configuration: AnimationConfiguration) -> AnimationConfiguration {
        var completionConfiguration = configuration
        completionConfiguration.add { _ in
            configurations.forEach(Animator.perform)
        }

        return completionConfiguration
    }
}

extension UIView {
    
    /**
     Used to start a new `AnimationChain`.
     More animations can be added by calling `-thenAfter` on the return value.
     A completion closure can be added by calling `-completion` on the return value.
     All animations will be executed after calling `-animate`.
     
     - parameter duration The duration that will be used for all animations added to the `AnimationChain`.
     - parameter delay The delay before the execution of the first animation in the chain, default to 0.
     - parameter options The `UIViewAnimationOptions` that will be used for every animation in the chain, default is nil.
     - parameter animations The animations that should be executed first in the chain.

     - return A new `AnimationChain` with the added animation.
     **/
    public class func beginAnimationChain(
        _ duration: TimeInterval,
        delay: TimeInterval = 0,
        options: UIViewAnimationOptions = [],
        animations: @escaping Animation
        ) -> AnimationChain {
        
        let boxedFunction = AnimationConfiguration(animations, duration: duration, delay: delay, options: options)
        return AnimationChain(options: options, animations: [[boxedFunction]])
    }
}



