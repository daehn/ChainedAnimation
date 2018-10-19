//
//  AnimationProvider.swift
//  ChainedAnimation
//
//  Created by Silvan Dähn on 10/09/2016.
//  Copyright © 2016 Silvan Dähn. All rights reserved.
//


public protocol AnimationProvider {

    func animate(withDuration duration: TimeInterval, delay: TimeInterval, options: UIView.AnimationOptions, animations: @escaping Animation, completion: Completion?)

}


struct UIViewAnimationProvider: AnimationProvider {

    func animate(withDuration duration: TimeInterval, delay: TimeInterval, options: UIView.AnimationOptions, animations: @escaping Animation, completion: Completion?) {
        UIView.animate(
            withDuration: duration,
            delay: delay,
            options: options,
            animations: animations,
            completion: completion
        )
    }
    
}
