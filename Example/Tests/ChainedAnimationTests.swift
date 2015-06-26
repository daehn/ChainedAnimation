import UIKit
import XCTest
import ChainedAnimation

class ChainedAnimationTests: XCTestCase {

    func testAnimation() {
        let expectation = self.expectationWithDescription("animation closure should be called")
        UIView.beginAnimationChain(0.2) {
            expectation.fulfill()
            }.animate()
        self.waitForExpectationsWithTimeout(0, handler: nil)
    }

    func testCompletion() {
        let expectation = self.expectationWithDescription("completion closure should be called")
        UIView.beginAnimationChain(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut) {
            }.completion { _ in
                expectation.fulfill()
            }.animate()
        self.waitForExpectationsWithTimeout(0.2, handler: nil)
    }

    func testThenAfterCalled() {
        let expectation = self.expectationWithDescription("second animation should execute 0.1 seconds after the first")
        UIView.beginAnimationChain(0.2, delay: 0) {
            }.thenAfterStart(0.2) {
                expectation.fulfill()
            }.animate()

        self.waitForExpectationsWithTimeout(0.1, handler: nil)
    }

    func testComplexChaining() {
        let completionExpectation = self.expectationWithDescription("Animation, offset animation and completion should be called")
        var (animation, offset) = (false, false)

        UIView.beginAnimationChain(0.1, delay: 0) {
            animation = true
            }.thenAfterStart(0.1) {
                offset = true
            }.completion { _ in
                if animation && offset {
                    completionExpectation.fulfill()
                } else {
                    XCTFail("First or offset animation have not been called")
                }
            }.animate()

        self.waitForExpectationsWithTimeout(0.1, handler: nil)

    }

    func testMultipleChainings() {
        let expectation = self.expectationWithDescription("All closures should be executed")
        var (animation, firstCompletion, secondAnimation) = (false, false, false)

        UIView.beginAnimationChain(0, delay: 0) {
                animation = true
            }.completion { bool in
                firstCompletion = true
            }.chainAfterCompletion(0.1) {
                secondAnimation = true
            }.completion { bool in
                if animation && firstCompletion && secondAnimation {
                    expectation.fulfill()
                } else {
                    XCTFail("First or offset animation have not been called")
                }
            }.animate()

        self.waitForExpectationsWithTimeout(0.1, handler: nil)
    }
    
    
}
