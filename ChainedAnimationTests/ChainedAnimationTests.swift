//
//  ChainedAnimationTests.swift
//  ChainedAnimationTests
//
//  Created by Silvan Dähn on 10/09/2016.
//  Copyright © 2016 Silvan Dähn. All rights reserved.
//

import XCTest
@testable import ChainedAnimation


class ChainedAnimationTests: ChainedAnimationTestCase {

    func testAnimationChain() {
        let animationClosure: Animation = {}
        let firstBoxedAnimation = testConfiguration(animationClosure)
        let firstChain = AnimationChain(options: [.curveEaseIn, .autoreverse], animations: [[firstBoxedAnimation]])
        let secondChain = firstChain.thenAfterStart(1.0, animation: animationClosure)

        XCTAssert(firstChain.currentOffset == 0)
        XCTAssert(firstChain.animations.joined().count == 1)
        XCTAssert(secondChain.currentOffset == 1.0)
        XCTAssert(secondChain.animations.joined().count == 2)
        XCTAssert(secondChain.options == firstChain.options)

        let completionChain = secondChain.chainAfterCompletion(0.5, delay: 0, options: .curveEaseInOut, animations: animationClosure)
        XCTAssert(completionChain.animations.joined().count == 3)
        XCTAssert(completionChain.animations.count == 2)
        XCTAssert(completionChain.currentOffset == 0)
        XCTAssert(completionChain.options == .curveEaseInOut)
    }

    func testAnimationCalled() {
        UIView.beginAnimationChain(0) {
            XCTAssert(true)
            }.animate()
    }

    func testCompletionCalled() {
        UIView.beginAnimationChain(2, delay: 0, options: UIView.AnimationOptions.curveEaseInOut) {
            }.completion { success in
                XCTAssert(success)
            }.animate()
    }

    func testThenAfterCalled() {
        UIView.beginAnimationChain(0.2, delay: 0) {
            }.thenAfterStart(0.2) {
                XCTAssert(true)
            }.animate()
    }

}
