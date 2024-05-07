//
//  mindfulnessTests.swift
//  mindfulnessTests
//
//  Created by Dax Gerber on 5/7/24.
//

import XCTest
@testable import mindfulness

class MeditationViewControllerTests: XCTestCase {

    var sut: MeditationViewController!

    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Meditation", bundle: nil)
        sut = storyboard.instantiateViewController(withIdentifier: "MeditationViewController") as? MeditationViewController
        sut.loadViewIfNeeded()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testTimePickerDataSource() {
        XCTAssertEqual(sut.timePicker.numberOfRows(inComponent: 0), sut.time.count)
    }

    func testTypePickerDataSource() {
        XCTAssertEqual(sut.typePicker.numberOfRows(inComponent: 0), sut.environments.count)
    }

    func testTimePickerDelegate() {
        sut.pickerView(sut.timePicker, didSelectRow: 0, inComponent: 0)
        XCTAssertEqual(sut.selectedTimeValue, 1)
    }

    func testTypePickerDelegate() {
        sut.pickerView(sut.typePicker, didSelectRow: 0, inComponent: 0)
        XCTAssertEqual(sut.selectedEnvironmentValue, "Forest")
    }

    func testSetupGradientBackground() {
        XCTAssertEqual(sut.view.layer.sublayers?.first, sut.gradientLayer)
        XCTAssertEqual(sut.gradientLayer.colors?.count, 2)
        XCTAssertEqual(sut.gradientLayer.locations, [0.0, 0.8, 1.0])
        XCTAssertEqual(sut.gradientLayer.startPoint, CGPoint(x: 0.5, y: 0.0))
        XCTAssertEqual(sut.gradientLayer.endPoint, CGPoint(x: 0.5, y: 1.0))
    }

    func testPrepareForSegue() {
        let destination = MeditationSecondViewController()
        let segue = UIStoryboardSegue(identifier: "testSegue", source: sut, destination: destination)
        sut.selectedTimeValue = 3
        sut.selectedEnvironmentValue = "Rain"
        sut.prepare(for: segue, sender: nil)
        XCTAssertEqual(destination.time, 3)
        XCTAssertEqual(destination.environment, "Rain")
    }
}

