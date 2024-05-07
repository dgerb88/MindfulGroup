import XCTest
@testable import mindfulness

class MeditationSecondViewControllerTests: XCTestCase {

    var sut: MeditationSecondViewController!

    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "MeditationModal", bundle: nil)
        sut = storyboard.instantiateViewController(withIdentifier: "MeditationSecondViewController") as? MeditationSecondViewController
        sut.loadViewIfNeeded()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testViewDidLoad() {
        XCTAssertNotNil(sut.progressView)
        XCTAssertNotNil(sut.audioPlayer)
        XCTAssertEqual(sut.timeCount, 0)
        XCTAssertEqual(sut.progress, 0)
        XCTAssertEqual(sut.startTime, 0)
        XCTAssertEqual(sut.timeLabel.text, "\(sut.time ?? 0):00")
        XCTAssertEqual(sut.congratulationsLabel.alpha, 0)
    }

    func testStartProgressTimer() {
        sut.startProgressTimer()
        XCTAssertTrue(sut.hasStarted)
        XCTAssertNotNil(sut.timer)
        XCTAssertNotNil(sut.audioPlayer)
    }

    func testStopProgressTimer() {
        sut.stopProgressTimer()
        XCTAssertFalse(sut.hasStarted)
        XCTAssertNil(sut.timer)
    }

    func testPauseProgressTimer() {
        sut.pauseProgressTimer()
        XCTAssertNil(sut.timer)
    }

    func testPlaySound() {
        sut.playSound()
        XCTAssertNotNil(sut.audioPlayer)
    }

    func testSetProgressViewColor() {
        sut.environment = "Forest"
        sut.setProgressViewColor("Forest")
        XCTAssertEqual(sut.progressView.progressColor, .forestGreen)
        
        sut.environment = "Evil washing machine"
        sut.setProgressViewColor("Evil washing machine")
        XCTAssertEqual(sut.progressView.progressColor, .red)
        
        sut.environment = "Trickling water"
        sut.setProgressViewColor("Trickling water")
        XCTAssertEqual(sut.progressView.progressColor, .forestGreen)
        
        sut.environment = "Unknown"
        sut.setProgressViewColor("Unknown")
        XCTAssertEqual(sut.progressView.progressColor, .babyBlue) // Default color
    }

    func testPauseTimeButton() {
        // Test when didFinishMeditation is true
        sut.didFinishMeditation = true
        sut.pauseTimeButton(UIButton())
        XCTAssertFalse(sut.didFinishMeditation)
        XCTAssertEqual(sut.timeLabelButton.currentImage, UIImage(systemName: "pause.fill"))
        
        // Test when hasStarted is true
        sut.hasStarted = true
        sut.pauseTimeButton(UIButton())
        XCTAssertNil(sut.timer)
        XCTAssertEqual(sut.timeLabelButton.currentImage, UIImage(systemName: "play.fill"))
        
        // Test when hasStarted is false
        sut.hasStarted = false
        sut.pauseTimeButton(UIButton())
        XCTAssertNotNil(sut.timer)
        XCTAssertNotNil(sut.audioPlayer)
        XCTAssertEqual(sut.timeLabelButton.currentImage, UIImage(systemName: "pause.fill"))
    }
}
