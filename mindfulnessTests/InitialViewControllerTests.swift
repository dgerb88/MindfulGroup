//
//  InitialViewControllerTests.swift
//  mindfulnessTests
//
//  Created by Dax Gerber on 5/8/24.
//

import XCTest
@testable import mindfulness

class InitialViewControllerTests: XCTestCase {

    var sut: InitialViewController!

    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = storyboard.instantiateViewController(withIdentifier: "InitialViewController") as? InitialViewController
        sut.loadViewIfNeeded()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testViewDidLoad() {
        XCTAssertEqual(sut.journalOutLet.alpha, 1)
        XCTAssertEqual(sut.Hstack.alpha, 0)
        XCTAssertEqual(sut.howAreYou.alpha, 0)
    }


    func testDispatchNotification() {
        // Test dispatching of notification
        sut.dispatchNotification()
        // Check if notification with identifier "dailyReminder" is added successfully
        let expectation = XCTestExpectation(description: "Notification Dispatched")
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            for request in requests {
                if request.identifier == "dailyReminder" {
                    expectation.fulfill()
                    break
                }
            }
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func testBlurForQuoteBackground() {
        // Test if blur effect view is added to quoteLabelBackground
        XCTAssertEqual(sut.quoteLabelBackground.subviews.count, 2)
        XCTAssertTrue(sut.quoteLabelBackground.subviews.first is UIVisualEffectView)
    }

    func testSetupGradientBackground() {
        // Test if gradient layer is added to view's layer
        XCTAssertEqual(sut.view.layer.sublayers?.first, sut.gradientLayer)
        // Test gradient layer properties
        XCTAssertEqual(sut.gradientLayer.colors?.count, 2)
        XCTAssertEqual(sut.gradientLayer.locations, [0.0, 0.8, 1.0])
        XCTAssertEqual(sut.gradientLayer.startPoint, CGPoint(x: 0.5, y: 0.0))
        XCTAssertEqual(sut.gradientLayer.endPoint, CGPoint(x: 0.5, y: 1.0))
    }

    func testQuickJournalButton() {
        // Test animation when quick journal button is tapped
        sut.quickJournalButton(UIButton())
        XCTAssertEqual(sut.journalOutLet.alpha, 0)
        XCTAssertEqual(sut.Hstack.alpha, 1)
        XCTAssertEqual(sut.howAreYou.alpha, 1)
    }

    func testPrepareForSegue() {
        // Test prepare for segue when sender is DaxButton
        let segue = UIStoryboardSegue(identifier: "testSegue", source: sut, destination: MeditationSecondViewController())
        sut.prepare(for: segue, sender: sut.DaxButton)
        // Assert that time and environment are set correctly for DaxButton
        
        // Test prepare for segue when sender is meganButton
        let segue2 = UIStoryboardSegue(identifier: "testSegue", source: sut, destination: MeditationSecondViewController())
        sut.prepare(for: segue2, sender: sut.meganButton)
        // Assert that nothing happens for meganButton
        // Add assertions here if meganButton should have a specific behavior
        
    }
}

