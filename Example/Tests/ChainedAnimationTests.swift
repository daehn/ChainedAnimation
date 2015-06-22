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
            }.thenAfter(0.2) {
                expectation.fulfill()
            }.animate()

        self.waitForExpectationsWithTimeout(0.1, handler: nil)
    }

    func testComplexChaining() {
        let animationExpectation = self.expectationWithDescription("animation closure should be called")
        let thenAfterExpectation = self.expectationWithDescription("second animation closure should be called")
        let completionExpectation = self.expectationWithDescription("completion closure should be called")

        UIView.beginAnimationChain(0.3, delay: 0) {
                animationExpectation.fulfill()
            }.thenAfter(0.2) {
                thenAfterExpectation.fulfill()
            }.completion { _ in
                completionExpectation.fulfill()
            }.animate()

        self.waitForExpectationsWithTimeout(0.3, handler: nil)
    }

    func testMultipleChainings() {
        let animationExpectation = self.expectationWithDescription("animation closure should be called")
        let secondChainExpectation = self.expectationWithDescription("second animation closure should be called")
        let firstCompletionExpectation = self.expectationWithDescription("first completion closure should be called")
        let secondCompletionExpectation = self.expectationWithDescription("second completion closure should be called")

        UIView.beginAnimationChain(0.1, delay: 0) {
                animationExpectation.fulfill()
            }.completion { bool in
                XCTAssertTrue(bool)
                firstCompletionExpectation.fulfill()
            }.startNewChain(0.2) {
                secondChainExpectation.fulfill()
            }.completion { bool in
                XCTAssertTrue(bool)
                secondCompletionExpectation.fulfill()
            }.animate()

        self.waitForExpectationsWithTimeout(0.3, handler: nil)
    }

    
}
