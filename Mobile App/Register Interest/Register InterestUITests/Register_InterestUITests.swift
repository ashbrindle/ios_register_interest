//
//  Register_InterestUITests.swift
//  Register InterestUITests
//
//  Created by Ashley Brindle on 13/02/2020.
//  Copyright © 2020 Ashley Brindle. All rights reserved.
//

import XCTest

class Register_InterestUITests: XCTestCase {
    
    func testSubmission() {
        
        XCUIApplication().activate()
        XCUIApplication().launch()
        
        let elementsQuery = XCUIApplication()
        elementsQuery.textFields["Full Name"].doubleTap()
        elementsQuery.textFields["Full Name"].typeText("Ashley Brindle")
        elementsQuery.textFields["Email Address"].doubleTap()
        elementsQuery.textFields["Email Address"].typeText("Ash@gmail.com")
        
        elementsQuery.datePickers/*@START_MENU_TOKEN@*/.pickerWheels["2020"]/*[[".pickers.pickerWheels[\"2020\"]",".pickerWheels[\"2020\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.swipeDown()
        elementsQuery.buttons["Submit"].tap()
    }


    func testSuccessfulAdminLogin() {

        XCUIApplication().activate()
        XCUIApplication().launch()

        let app = XCUIApplication()
        let scrollViewsQuery = app.scrollViews
        scrollViewsQuery.children(matching: .other).element(boundBy: 0).children(matching: .other).element(boundBy: 5).swipeUp()

        let elementsQuery = scrollViewsQuery.otherElements
        elementsQuery.secureTextFields["Admin Password"].doubleTap()
        elementsQuery.secureTextFields["Admin Password"].typeText("password")
        elementsQuery.buttons["Admin Login"].tap()
    }

    func testUnsuccessfulAdminLogin() {
        
        XCUIApplication().activate()
        XCUIApplication().launch()

        let app = XCUIApplication()
        let scrollViewsQuery = app.scrollViews
        scrollViewsQuery.children(matching: .other).element(boundBy: 0).children(matching: .other).element(boundBy: 5).swipeUp()

        let elementsQuery = scrollViewsQuery.otherElements
        elementsQuery.secureTextFields["Admin Password"].doubleTap()
        elementsQuery.secureTextFields["Admin Password"].typeText("wrongpassword")
        elementsQuery.buttons["Admin Login"].tap()
    }

    func testUploadSubjects() {

        XCUIApplication().activate()
        XCUIApplication().launch()

        let app = XCUIApplication()
        app.textFields["Full Name"].doubleTap()
        app.textFields["Full Name"].typeText("Ashley Brindle")
        app.textFields["Email Address"].doubleTap()
        app.textFields["Email Address"].typeText("ashemail@mail.com")

        app.datePickers.pickerWheels["2020"].swipeDown()
        app.buttons["Submit"].tap()

        if app.alerts["Well Done"].exists {
            app.alerts["Well Done"].scrollViews.otherElements.buttons["Finish"].tap()
        }

        app/*@START_MENU_TOKEN@*/.scrollViews.containing(.other, identifier:"Vertical scroll bar, 2 pages")/*[[".scrollViews.containing(.other, identifier:\"Horizontal scroll bar, 1 page\")",".scrollViews.containing(.other, identifier:\"Vertical scroll bar, 2 pages\")"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.children(matching: .other).element(boundBy: 0).children(matching: .other).element(boundBy: 6).swipeUp()
        app.secureTextFields["Admin Password"].tap()
        app.buttons["Admin Login"].doubleTap()
        app.buttons["Admin Login"].typeText("password")
        if app.staticTexts["Publish"].exists {
            app/*@START_MENU_TOKEN@*/.staticTexts["Publish"]/*[[".buttons[\"Publish\"].staticTexts[\"Publish\"]",".staticTexts[\"Publish\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        }
        if app.alerts["Upload Complete"].exists {
            app.alerts["Upload Complete"].scrollViews.otherElements.buttons["Dismiss"].tap()
        }
    }

    func testSubjectDetails() {

        XCUIApplication().activate()
        XCUIApplication().launch()

        let app = XCUIApplication()
        app.textFields["Full Name"].doubleTap()
        app.textFields["Full Name"].typeText("Ashley Brindle")
        app.textFields["Email Address"].doubleTap()
        app.textFields["Email Address"].typeText("ashemail@mail.com")

        app.datePickers/*@START_MENU_TOKEN@*/.pickerWheels["2020"]/*[[".pickers.pickerWheels[\"2020\"]",".pickerWheels[\"2020\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.swipeDown()
        app/*@START_MENU_TOKEN@*/.pickerWheels["Accounting & Finance"]/*[[".pickers.pickerWheels[\"Accounting & Finance\"]",".pickerWheels[\"Accounting & Finance\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.swipeDown()
        app.buttons["Submit"].tap()
        if app.alerts["Well Done"].exists {
            app.alerts["Well Done"].scrollViews.otherElements.buttons["Finish"].tap()
        }
        app/*@START_MENU_TOKEN@*/.scrollViews.containing(.other, identifier:"Vertical scroll bar, 2 pages")/*[[".scrollViews.containing(.other, identifier:\"Horizontal scroll bar, 1 page\")",".scrollViews.containing(.other, identifier:\"Vertical scroll bar, 2 pages\")"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.children(matching: .other).element(boundBy: 0).children(matching: .other).element(boundBy: 5).swipeUp()
        if app.staticTexts["Admin Settings Access Below"].exists {
            app.staticTexts["Admin Settings Access Below"].swipeUp()
        }
        app.secureTextFields["Admin Password"].tap()
        app.buttons["Admin Login"].tap()
        if app.alerts["Subject"].exists {
            app.alerts["Subject"].scrollViews.otherElements.buttons["Dismiss"].tap()
        }
    }
    
    func testPublish() {
        
        XCUIApplication().activate()
        XCUIApplication().launch()
        
        let app = XCUIApplication()
        let scrollViewsQuery = app.scrollViews
        let elementsQuery = scrollViewsQuery.otherElements
        elementsQuery.textFields["Full Name"].doubleTap()
        
        let aKey = app/*@START_MENU_TOKEN@*/.keys["a"]/*[[".keyboards.keys[\"a\"]",".keys[\"a\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        aKey.tap()
        aKey.tap()
        
        let sKey = app/*@START_MENU_TOKEN@*/.keys["s"]/*[[".keyboards.keys[\"s\"]",".keys[\"s\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        sKey.tap()
        sKey.tap()
        
        let hKey = app/*@START_MENU_TOKEN@*/.keys["h"]/*[[".keyboards.keys[\"h\"]",".keys[\"h\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        hKey.tap()
        hKey.tap()
        elementsQuery.textFields["Email Address"].doubleTap()
        aKey.tap()
        aKey.tap()
        aKey.tap()
        aKey.tap()
        
        let moreKey = app/*@START_MENU_TOKEN@*/.keys["more"]/*[[".keyboards",".keys[\"letters\"]",".keys[\"more\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/
        moreKey.tap()
        moreKey.tap()
        
        let key = app/*@START_MENU_TOKEN@*/.keys["@"]/*[[".keyboards.keys[\"@\"]",".keys[\"@\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        key.tap()
        key.tap()
        
        let dKey = app/*@START_MENU_TOKEN@*/.keys["d"]/*[[".keyboards.keys[\"d\"]",".keys[\"d\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        dKey.tap()
        dKey.tap()
        dKey.tap()
        dKey.tap()
        moreKey.tap()
        moreKey.tap()
        
        let moreKey2 = app/*@START_MENU_TOKEN@*/.keys["more"]/*[[".keyboards",".keys[\"numbers\"]",".keys[\"more\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/
        moreKey2.tap()
        moreKey2.tap()
        
        let cKey = app/*@START_MENU_TOKEN@*/.keys["c"]/*[[".keyboards.keys[\"c\"]",".keys[\"c\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        cKey.tap()
        cKey.tap()
        
        let oKey = app/*@START_MENU_TOKEN@*/.keys["o"]/*[[".keyboards.keys[\"o\"]",".keys[\"o\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        oKey.tap()
        oKey.tap()
        
        let mKey = app/*@START_MENU_TOKEN@*/.keys["m"]/*[[".keyboards.keys[\"m\"]",".keys[\"m\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        mKey.tap()
        mKey.tap()
        
        let datePickersQuery = elementsQuery.datePickers
        datePickersQuery/*@START_MENU_TOKEN@*/.pickerWheels["2020"]/*[[".pickers.pickerWheels[\"2020\"]",".pickerWheels[\"2020\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.swipeDown()
        datePickersQuery/*@START_MENU_TOKEN@*/.pickerWheels["1985"]/*[[".pickers.pickerWheels[\"1985\"]",".pickerWheels[\"1985\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let element = app/*@START_MENU_TOKEN@*/.scrollViews.containing(.other, identifier:"Vertical scroll bar, 2 pages")/*[[".scrollViews.containing(.other, identifier:\"Horizontal scroll bar, 1 page\")",".scrollViews.containing(.other, identifier:\"Vertical scroll bar, 2 pages\")"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.children(matching: .other).element(boundBy: 0)
        element.children(matching: .other).element(boundBy: 4).swipeUp()
        element.children(matching: .other).element(boundBy: 6).tap()
        elementsQuery.secureTextFields["Admin Password"].tap()
        
        let pKey = app/*@START_MENU_TOKEN@*/.keys["p"]/*[[".keyboards.keys[\"p\"]",".keys[\"p\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        pKey.tap()
        pKey.tap()
        aKey.tap()
        aKey.tap()
        sKey.tap()
        sKey.tap()
        sKey.tap()
        
        let wKey = app/*@START_MENU_TOKEN@*/.keys["w"]/*[[".keyboards.keys[\"w\"]",".keys[\"w\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        wKey.tap()
        wKey.tap()
        oKey.tap()
        oKey.tap()
        app/*@START_MENU_TOKEN@*/.keys["r"]/*[[".keyboards.keys[\"r\"]",".keys[\"r\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        dKey.tap()
        dKey.tap()
        scrollViewsQuery.children(matching: .other).element(boundBy: 0).children(matching: .other).element(boundBy: 6).tap()
        elementsQuery.buttons["Admin Login"].tap()
        app.buttons["Publish"].tap()
        app.alerts["Upload Complete"].scrollViews.otherElements.buttons["Dismiss"].tap()
    }
    
}
