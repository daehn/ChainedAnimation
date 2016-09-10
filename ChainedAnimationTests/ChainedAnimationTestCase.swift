//
//  ChainedAnimationBaseTest.swift
//  ChainedAnimation
//
//  Created by Silvan Dähn on 10/09/2016.
//  Copyright © 2016 Silvan Dähn. All rights reserved.
//


import XCTest
@testable import ChainedAnimation


class ChainedAnimationTestCase: XCTestCase {

    var animationProvider: MockAnimationProvider!

    override func setUp() {
        super.setUp()
        animationProvider = MockAnimationProvider()
        Animator.animationProvider = animationProvider
    }

    // MARK: - Helper

    func testConfiguration(_ animation: @escaping Animation, completion: Completion? = nil) -> AnimationConfiguration {
        return AnimationConfiguration(
            animation,
            duration: 0.5,
            delay: 0.6,
            options: .curveEaseIn,
            completion: completion
        )
    }
    
}
