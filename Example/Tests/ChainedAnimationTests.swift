import UIKit
import XCTest
@testable import ChainedAnimation

class ChainedAnimationTests: XCTestCase {

    func testBoxedAnimation() {

        let expectation = expectationWithDescription("animation closure should be called")
        var animationCalled = false
        let animation: Animation = { animationCalled = true  }
        let completion: Completion = { bool in expectation.fulfill() }
        let boxedAnimation = boxedTestAnimation(animation, completion: completion)
        boxedAnimation.execute()

        waitForExpectationsWithTimeout(1) { error in
            XCTAssert(animationCalled)
        }

        XCTAssert(boxedAnimation.duration == 0.5)
        XCTAssert(boxedAnimation.delay == 0.6)
        XCTAssert(boxedAnimation.options == .CurveEaseIn)
    }

    func testAnimationChain() {
        let animationClosure: Animation = {}
        let firstBoxedAnimation = boxedTestAnimation(animationClosure)
        let firstChain = AnimationChain(options: [.CurveEaseIn, .Autoreverse], animations: [[firstBoxedAnimation]])
        let secondChain = firstChain.thenAfterStart(1.0, animation: animationClosure)

        XCTAssert(firstChain.currentOffset == 0)
        XCTAssert(firstChain.animations.flatten().count == 1)
        XCTAssert(secondChain.currentOffset == 1.0)
        XCTAssert(secondChain.animations.flatten().count == 2)
        XCTAssert(secondChain.options == firstChain.options)

        let completionChain = secondChain.chainAfterCompletion(0.5, delay: 0, options: .CurveEaseInOut, animations: animationClosure)
        XCTAssert(completionChain.animations.flatten().count == 3)
        XCTAssert(completionChain.animations.count == 2)
        XCTAssert(completionChain.currentOffset == 0)
        XCTAssert(completionChain.options == .CurveEaseInOut)
    }

    func testAnimationCalled() {
        UIView.beginAnimationChain(0) {
            XCTAssert(true)
            }.animate()
    }

    func testCompletionCalled() {
        UIView.beginAnimationChain(2, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut) {
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

    // MARK: - Helper

    func boxedTestAnimation(animation: Animation, completion: Completion? = nil) -> BoxedAnimation {
        return BoxedAnimation(
            animation,
            duration: 0.5,
            delay: 0.6,
            options: .CurveEaseIn,
            completion: completion
        )
    }
    
}
