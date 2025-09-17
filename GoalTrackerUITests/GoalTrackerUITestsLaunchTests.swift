//
//  GoalTrackerUITestsLaunchTests.swift
//  GoalTrackerUITests
//
<<<<<<< HEAD
//  Created by AJ on 2025/07/02.
=======
//  Created by AJ on 2025/04/07.
>>>>>>> a5299dab53fdf2a51098c77d51abdc51565d4484
//

import XCTest

final class GoalTrackerUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        // Insert steps here to perform after app launch but before taking a screenshot,
        // such as logging into a test account or navigating somewhere in the app

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
