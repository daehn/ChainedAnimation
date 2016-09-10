//
//  MockAnimationProvider.swift
//  ChainedAnimation
//
//  Created by Silvan Dähn on 10/09/2016.
//  Copyright © 2016 Silvan Dähn. All rights reserved.
//

import Foundation
import ChainedAnimation

typealias AnimationParameters = (
    duration: TimeInterval,
    delay: TimeInterval,
    options: UIViewAnimationOptions,
    animations: Animation,
    completion: Completion?
)

class TestAnimation {
    var callCount = 0
    var closure: Animation! = nil
    
    init() {
        closure = { self.callCount += 1 }
    }
}

class TestCompletion {
    var callCount = 0
    var closure: Completion! = nil
    
    init() {
        closure = { _ in self.callCount += 1 }
    }
}

class MockAnimationProvider: AnimationProvider {
    
    var callClosure: ((AnimationParameters) -> Void)?
    var callParameters: AnimationParameters?
    var callCount = 0
    
    var callPassedInClosures = false
    
    public func animate(withDuration duration: TimeInterval, delay: TimeInterval, options: UIViewAnimationOptions, animations: @escaping Animation, completion: Completion?) {
        callCount += 1
        let parameters = (duration: duration, delay: delay, options: options, animations: animations, completion: completion)
        callParameters = parameters
        callClosure?(parameters)
        
        guard callPassedInClosures else { return }
        animations()
        completion?(true)
    }

}
