//
//  Animator.swift
//  ChainedAnimation
//
//  Created by Silvan Dähn on 10/09/2016.
//  Copyright © 2016 Silvan Dähn. All rights reserved.
//


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
