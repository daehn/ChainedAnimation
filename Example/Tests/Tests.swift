import UIKit
import XCTest
import Chain

class Tests: XCTestCase {

    func testCompletion() {
        let expectation = self.expectationWithDescription("completion closure should be called")
        var completionExecuted = false
        UIView.beginAnimationChain(0.5, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut) {
            }.completion { _ in
                expectation.fulfill()
            }.animate()
        self.waitForExpectationsWithTimeout(0.5, handler: nil)
    }

}
