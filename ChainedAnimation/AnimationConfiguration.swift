//
//  AnimationConfiguration.swift
//  ChainedAnimation
//
//  Created by Silvan Dähn on 10/09/2016.
//  Copyright © 2016 Silvan Dähn. All rights reserved.
//


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

    mutating func add(completion: @escaping Completion) {
        let currentCompletion = self.completion
        self.completion = {
            currentCompletion?($0)
            completion($0)
        }
    }
}
