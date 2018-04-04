//
//  BeelineCodingChallengeUITests.swift
//  BeelineCodingChallengeUITests
//
//  Created by Arbi Derhartunian on 1/23/18.
//  Copyright © 2018 org.beelinecoding. All rights reserved.
//

import XCTest

class BeelineCodingChallengeUITests: XCTestCase {
    let app = XCUIApplication()
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testLogin() {
        
        app.buttons["Login"].tap()
        app.tables.element(boundBy: 0).tap()
    app.navigationBars["BeelineCodingChallenge.TournamentsDetailView"].buttons["Tournaments"].tap()
        app.navigationBars["Tournaments"].buttons["Logout"].tap()
        
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
}
