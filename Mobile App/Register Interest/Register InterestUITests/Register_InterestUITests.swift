//
//  Register_InterestUITests.swift
//  Register InterestUITests
//
//  Created by Ashley Brindle on 13/02/2020.
//  Copyright © 2020 Ashley Brindle. All rights reserved.
//

import XCTest

class Register_InterestUITests: XCTestCase {
    
    func testSubmissin() {
        
        XCUIApplication().activate()
        XCUIApplication().launch()
        
        let elementsQuery = XCUIApplication()
        elementsQuery.textFields["Full Name"].tap()
        elementsQuery.textFields["Email Address"].tap()
        
        elementsQuery.datePickers/*@START_MENU_TOKEN@*/.pickerWheels["2020"]/*[[".pickers.pickerWheels[\"2020\"]",".pickerWheels[\"2020\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.swipeDown()
        elementsQuery/*@START_MENU_TOKEN@*/.pickerWheels["Accounting & Finance"]/*[[".pickers.pickerWheels[\"Accounting & Finance\"]",".pickerWheels[\"Accounting & Finance\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.swipeUp()
        elementsQuery.buttons["Submit"].tap()
    }
    
    func testFailedEmailSubmission() {
        
        XCUIApplication().activate()
        XCUIApplication().launch()
        
        let app = XCUIApplication()
        let elementsQuery = app.scrollViews.otherElements
        elementsQuery.textFields["Full Name"].tap()
        elementsQuery.textFields["Email Address"].tap()
        elementsQuery.datePickers/*@START_MENU_TOKEN@*/.pickerWheels["2020"]/*[[".pickers.pickerWheels[\"2020\"]",".pickerWheels[\"2020\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.swipeDown()
        elementsQuery.buttons["Submit"].tap()
        app.alerts["Invalid"].scrollViews.otherElements.buttons["Try Again"].tap()
    }
    
    func testFailedDateSubmissionAfter2020() {
        // tests for date after 2020 (after current year)
        
        XCUIApplication().activate()
        XCUIApplication().launch()
        
        let app = XCUIApplication()
        let elementsQuery = app.scrollViews.otherElements
        elementsQuery.textFields["Full Name"].tap()
        elementsQuery.textFields["Email Address"].tap()
        
        let pickerWheel = elementsQuery.datePickers/*@START_MENU_TOKEN@*/.pickerWheels["2020"]/*[[".pickers.pickerWheels[\"2020\"]",".pickerWheels[\"2020\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        pickerWheel/*@START_MENU_TOKEN@*/.press(forDuration: 1.0);/*[[".tap()",".press(forDuration: 1.0);"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        pickerWheel/*@START_MENU_TOKEN@*/.press(forDuration: 0.9);/*[[".tap()",".press(forDuration: 0.9);"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        elementsQuery.buttons["Submit"].tap()
        app.alerts["Invalid"].scrollViews.otherElements.buttons["Try Again"].tap()
    }
    
    func testFailedFateSubmissionBefore2020() {
        // tests for date before 2020 but under the age of 16
        
        XCUIApplication().activate()
        XCUIApplication().launch()
        
        let app = XCUIApplication()
        let elementsQuery = app.scrollViews.otherElements
        elementsQuery.textFields["Full Name"].tap()
        elementsQuery.textFields["Email Address"].tap()
        elementsQuery.datePickers/*@START_MENU_TOKEN@*/.pickerWheels["2020"]/*[[".pickers.pickerWheels[\"2020\"]",".pickerWheels[\"2020\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.swipeDown()
        elementsQuery.buttons["Submit"].tap()
        app.alerts["Invalid"].scrollViews.otherElements.buttons["Try Again"].tap()
    }
    
    func testSuccessfulAdminLogin() {
        
        XCUIApplication().activate()
        XCUIApplication().launch()
        
        let app = XCUIApplication()
        let scrollViewsQuery = app.scrollViews
        scrollViewsQuery.children(matching: .other).element(boundBy: 0).children(matching: .other).element(boundBy: 5).swipeUp()
        
        let elementsQuery = scrollViewsQuery.otherElements
        elementsQuery.secureTextFields["Admin Password"].tap()
        elementsQuery.buttons["Admin Login"].tap()
    }
    
    func testUnsuccessfulAdminLogin() {
        
        XCUIApplication().activate()
        XCUIApplication().launch()
        
        let app = XCUIApplication()
        let scrollViewsQuery = app.scrollViews
        scrollViewsQuery.children(matching: .other).element(boundBy: 0).children(matching: .other).element(boundBy: 6).swipeUp()
        
        let elementsQuery = scrollViewsQuery.otherElements
        elementsQuery.secureTextFields["Admin Password"].tap()
        elementsQuery.buttons["Admin Login"].tap()
        app.alerts["Incorrect Password"].scrollViews.otherElements.buttons["Try Again"].tap()
    }
    
    func testUploadSubjects() {
        
        XCUIApplication().activate()
        XCUIApplication().launch()
        
        let app = XCUIApplication()
        app.textFields["Full Name"].tap()
        app.textFields["Email Address"].tap()
        
        app.datePickers.pickerWheels["2020"].swipeDown()
        app/*@START_MENU_TOKEN@*/.pickerWheels["Accounting & Finance"].press(forDuration: 0.6);/*[[".pickers.pickerWheels[\"Accounting & Finance\"]",".tap()",".press(forDuration: 0.6);",".pickerWheels[\"Accounting & Finance\"]"],[[[-1,3,1],[-1,0,1]],[[-1,2],[-1,1]]],[0,0]]@END_MENU_TOKEN@*/
        app.buttons["Submit"].tap()
        
        app.alerts["Well Done"].scrollViews.otherElements.buttons["Finish"].tap()
        
        app/*@START_MENU_TOKEN@*/.scrollViews.containing(.other, identifier:"Vertical scroll bar, 2 pages")/*[[".scrollViews.containing(.other, identifier:\"Horizontal scroll bar, 1 page\")",".scrollViews.containing(.other, identifier:\"Vertical scroll bar, 2 pages\")"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.children(matching: .other).element(boundBy: 0).children(matching: .other).element(boundBy: 6).swipeUp()
        app.secureTextFields["Admin Password"].tap()
        app.buttons["Admin Login"].tap()
        app/*@START_MENU_TOKEN@*/.staticTexts["Publish"]/*[[".buttons[\"Publish\"].staticTexts[\"Publish\"]",".staticTexts[\"Publish\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.alerts["Upload Complete"].scrollViews.otherElements.buttons["Dismiss"].tap()
        
    }
    
}
