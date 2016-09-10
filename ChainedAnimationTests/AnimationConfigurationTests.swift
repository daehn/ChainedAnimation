//
//  AnimationConfigurationTests.swift
//  ChainedAnimation
//
//  Created by Silvan Dähn on 10/09/2016.
//  Copyright © 2016 Silvan Dähn. All rights reserved.
//


import XCTest
@testable import ChainedAnimation


class AnimationConfigurationTests: ChainedAnimationTestCase {

    func testThatItCallsTheAnimationProviderWithTheGivenParametersWhenPerformIsCalled() {
        // Given
        let sut = AnimationConfiguration(
            {},
            duration: 1.2,
            delay: 0.5,
            options: .curveEaseIn,
            completion: nil
        )

        // when
        Animator.perform(configuration: sut)

        // then
        let params = animationProvider.callParameters
        XCTAssertEqual(params?.duration, 1.2)
        XCTAssertEqual(params?.delay, 0.5)
        XCTAssertEqual(params?.options, .curveEaseIn)
    }

    func testThatItCallsTheProviderWithTheAnimationAndCompletionClosure() {
        // Given
        animationProvider.callPassedInClosures = true
        let completionExpectation = expectation(description: "Completion should be called")
        var animationCalled = false
        let animation: Animation = { animationCalled = true  }
        let completion: Completion = { _ in completionExpectation.fulfill() }
        let sut = testConfiguration(animation, completion: completion)

        // When
        Animator.perform(configuration: sut)

        // Then
        XCTAssertNotNil(animationProvider.callParameters)
        XCTAssert(animationCalled)
        waitForExpectations(timeout: 1, handler: nil)
    }

    func testThatAnAdditionalCompletionCanBeAddedToAnAnimationConfiguration() {
        // Given
        animationProvider.callPassedInClosures = true
        let animation = TestAnimation()
        let completion = TestCompletion()
        var sut = testConfiguration(animation.closure, completion: completion.closure)

        // When
        let secondCompletion = TestCompletion()
        sut.add(Completion: secondCompletion.closure)

        Animator.perform(configuration: sut)

        // Then
        XCTAssertEqual(animation.callCount, 1)
        XCTAssertEqual(completion.callCount, 1)
        XCTAssertEqual(secondCompletion.callCount, 1)
    }

    func testThatAdditionalCompletionsCanBeAddedToAnAnimationConfiguration() {
        // Given
        animationProvider.callPassedInClosures = true
        let animation = TestAnimation()
        let completion = TestCompletion()
        var sut = testConfiguration(animation.closure, completion: completion.closure)

        // When
        let secondCompletion = TestCompletion()
        let thirdCompletion = TestCompletion()
        sut.add(Completion: secondCompletion.closure)
        sut.add(Completion: thirdCompletion.closure)

        Animator.perform(configuration: sut)

        // Then
        XCTAssertEqual(animation.callCount, 1)
        XCTAssertEqual(completion.callCount, 1)
        XCTAssertEqual(secondCompletion.callCount, 1)
        XCTAssertEqual(thirdCompletion.callCount, 1)
    }
    
}
