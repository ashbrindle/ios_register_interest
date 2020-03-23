//
//  Register_InterestUserInterfaceTests.swift
//  Register InterestUITests
//
//  Created by Remote User on 16/03/2020.
//  Copyright © 2020 Ashley Brindle. All rights reserved.
//

import Foundation
import XCTest

/* --------------------------------
 ENSURE TO RUN THE APPLICATION
 AND ENABLE LOCATION SERVICES
 BEFORE RUNNING ANY UI UNIT TESTS
 ------------------------------- */

class Register_InterestUserInterfaceTests: XCTestCase {
    
    func testSubmission() {
        
        XCUIApplication().launch()
        
        let app = XCUIApplication()
        
        let name = app.scrollViews.otherElements.textFields["Full Name"]
        name.tap()
        name.typeText("Ashley Brindle")
        
        let email = app.scrollViews.otherElements.textFields["Email Address"]
        email.tap()
        email.typeText("example@email.com")
        app/*@START_MENU_TOKEN@*/.buttons["Return"]/*[[".keyboards",".buttons[\"return\"]",".buttons[\"Return\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let elementsQuery = XCUIApplication().scrollViews.otherElements
        elementsQuery.datePickers/*@START_MENU_TOKEN@*/.pickerWheels["2020"]/*[[".pickers.pickerWheels[\"2020\"]",".pickerWheels[\"2020\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.adjust(toPickerWheelValue: "2004")
        elementsQuery.buttons["Submit"].tap()
        XCUIApplication().alerts["Well Done"].scrollViews.otherElements.buttons["Finish"].tap()
        
    }

    func testInvalidEmail() {
        XCUIApplication().launch()
        
        let app = XCUIApplication()
        let name = app.scrollViews.otherElements.textFields["Full Name"]
        name.tap()
        name.typeText("Ashley Brindle")
        
        let email = app.scrollViews.otherElements.textFields["Email Address"]
        email.tap()
        email.typeText("bademail@x.c")
        app/*@START_MENU_TOKEN@*/.buttons["Return"]/*[[".keyboards",".buttons[\"return\"]",".buttons[\"Return\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let elementsQuery = XCUIApplication().scrollViews.otherElements
        elementsQuery.datePickers/*@START_MENU_TOKEN@*/.pickerWheels["2020"]/*[[".pickers.pickerWheels[\"2020\"]",".pickerWheels[\"2020\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.adjust(toPickerWheelValue: "2004")
        elementsQuery.buttons["Submit"].tap()
        XCUIApplication().alerts["Invalid"].scrollViews.otherElements.buttons["Try Again"].tap()
    }
    
    func testInvalidDateToday() {
        XCUIApplication().launch()
        
        let app = XCUIApplication()
        let name = app.scrollViews.otherElements.textFields["Full Name"]
        name.tap()
        name.typeText("Ashley Brindle")
        
        let email = app.scrollViews.otherElements.textFields["Email Address"]
        email.tap()
        email.typeText("example@email.com")
        app/*@START_MENU_TOKEN@*/.buttons["Return"]/*[[".keyboards",".buttons[\"return\"]",".buttons[\"Return\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        let elementsQuery = XCUIApplication().scrollViews.otherElements
        elementsQuery.buttons["Submit"].tap()
        XCUIApplication().alerts["Invalid"].scrollViews.otherElements.buttons["Try Again"].tap()
        
    }
    
    func testInvalidDateYoung() {
        XCUIApplication().launch()
        
        let app = XCUIApplication()
        let name = app.scrollViews.otherElements.textFields["Full Name"]
        name.tap()
        name.typeText("Ashley Brindle")
        
        let email = app.scrollViews.otherElements.textFields["Email Address"]
        email.tap()
        email.typeText("example@email.com")
        app/*@START_MENU_TOKEN@*/.buttons["Return"]/*[[".keyboards",".buttons[\"return\"]",".buttons[\"Return\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
    
        
        let elementsQuery = app.scrollViews.otherElements
        elementsQuery.datePickers/*@START_MENU_TOKEN@*/.pickerWheels["2020"]/*[[".pickers.pickerWheels[\"2020\"]",".pickerWheels[\"2020\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.adjust(toPickerWheelValue: "2005")
        elementsQuery.buttons["Submit"].tap()
        app.alerts["Invalid"].scrollViews.otherElements.buttons["Try Again"].tap()
    }
    
    func testSuccessfulAdminLogin() {
        XCUIApplication().launch()
        
        let app = XCUIApplication()
        let scrollViewsQuery = app.scrollViews

        let elementsQuery = scrollViewsQuery.otherElements
        let password = elementsQuery.secureTextFields["Admin Password"]
        password.tap()
        password.typeText("password")
        app/*@START_MENU_TOKEN@*/.buttons["Return"]/*[[".keyboards",".buttons[\"return\"]",".buttons[\"Return\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        elementsQuery.buttons["Admin Login"].tap()
    }

    func testUnsuccessfulAdminLogin() {
        XCUIApplication().launch()
        
        let app = XCUIApplication()
        let scrollViewsQuery = app.scrollViews

        let elementsQuery = scrollViewsQuery.otherElements
        let password = elementsQuery.secureTextFields["Admin Password"]
        password.tap()
        password.typeText("incorrect password")
        app/*@START_MENU_TOKEN@*/.buttons["Return"]/*[[".keyboards",".buttons[\"return\"]",".buttons[\"Return\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        elementsQuery.buttons["Admin Login"].tap()
        XCUIApplication().alerts["Incorrect Password"].scrollViews.otherElements.buttons["Try Again"].tap()
        
    }

    func testUploadSubjects() {
        XCUIApplication().launch()
        
        let app = XCUIApplication()
        let name = app.scrollViews.otherElements.textFields["Full Name"]
        name.tap()
        name.typeText("Ashley Brindle")
        
        let email = app.scrollViews.otherElements.textFields["Email Address"]
        email.tap()
        email.typeText("example@email.com")
        app/*@START_MENU_TOKEN@*/.buttons["Return"]/*[[".keyboards",".buttons[\"return\"]",".buttons[\"Return\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let elementsQuery = XCUIApplication().scrollViews.otherElements
        elementsQuery.datePickers/*@START_MENU_TOKEN@*/.pickerWheels["2020"]/*[[".pickers.pickerWheels[\"2020\"]",".pickerWheels[\"2020\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.adjust(toPickerWheelValue: "2004")
        elementsQuery.buttons["Submit"].tap()
        
        
        let scrollViewsQuery = app.scrollViews
        let elementsQuery2 = scrollViewsQuery.otherElements
        let password = elementsQuery2.secureTextFields["Admin Password"]
        password.tap()
        password.typeText("password")
        app/*@START_MENU_TOKEN@*/.buttons["Return"]/*[[".keyboards",".buttons[\"return\"]",".buttons[\"Return\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        elementsQuery2.buttons["Admin Login"].tap()
        app/*@START_MENU_TOKEN@*/.staticTexts["Publish"]/*[[".buttons[\"Publish\"].staticTexts[\"Publish\"]",".staticTexts[\"Publish\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        sleep(3)
        app.alerts["Upload Complete"].scrollViews.otherElements.buttons["Dismiss"].tap()
    }

    func testSubjectDetails() {
        XCUIApplication().launch()
        
        let app = XCUIApplication()
        let name = app.scrollViews.otherElements.textFields["Full Name"]
        name.tap()
        name.typeText("Ashley Brindle Test")
        
        let email = app.scrollViews.otherElements.textFields["Email Address"]
        email.tap()
        email.typeText("example@email.com")
        app/*@START_MENU_TOKEN@*/.buttons["Return"]/*[[".keyboards",".buttons[\"return\"]",".buttons[\"Return\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let elementsQuery = XCUIApplication().scrollViews.otherElements
        elementsQuery.datePickers/*@START_MENU_TOKEN@*/.pickerWheels["2020"]/*[[".pickers.pickerWheels[\"2020\"]",".pickerWheels[\"2020\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.adjust(toPickerWheelValue: "2004")
        elementsQuery.buttons["Submit"].tap()
        
        
        let scrollViewsQuery = app.scrollViews
        let elementsQuery2 = scrollViewsQuery.otherElements
        let password = elementsQuery2.secureTextFields["Admin Password"]
        password.tap()
        password.typeText("password")
        app/*@START_MENU_TOKEN@*/.buttons["Return"]/*[[".keyboards",".buttons[\"return\"]",".buttons[\"Return\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        elementsQuery2.buttons["Admin Login"].tap()
        
        app.tables.staticTexts["Ashley Brindle Test"].tap()
        app.alerts["Subject"].scrollViews.otherElements.buttons["Dismiss"].tap()
    }
    
}

