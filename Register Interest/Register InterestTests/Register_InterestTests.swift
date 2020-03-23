//
//  Register_InterestTests.swift
//  Register InterestTests
//
//  Created by Ashley Brindle on 13/02/2020.
//  Copyright © 2020 Ashley Brindle. All rights reserved.
//

import XCTest
import Foundation
@testable import Register_Interest

class Register_InterestTests: XCTestCase {
    
    func testValidEmail() {
        XCTAssertTrue(Validation().checkEmail(txt_email: "example@example.com"))
        XCTAssertTrue(Validation().checkEmail(txt_email: "example@ex.com"))
        XCTAssertTrue(Validation().checkEmail(txt_email: "ex@example.com"))
        XCTAssertTrue(Validation().checkEmail(txt_email: "exa.mple@example.com"))
        XCTAssertTrue(Validation().checkEmail(txt_email: "exa.m123@example.com"))
        XCTAssertTrue(Validation().checkEmail(txt_email: "exa123@example.com"))
    }
    
    func testInvalidEmail() {
        XCTAssertFalse(Validation().checkEmail(txt_email: "e@e.c"))
        XCTAssertFalse(Validation().checkEmail(txt_email: "1@1.2"))
        XCTAssertFalse(Validation().checkEmail(txt_email: "mail@.com"))
        XCTAssertFalse(Validation().checkEmail(txt_email: "mail@email.m"))
        XCTAssertFalse(Validation().checkEmail(txt_email: "@email.m"))
        XCTAssertFalse(Validation().checkEmail(txt_email: "mail@mail"))
        XCTAssertFalse(Validation().checkEmail(txt_email: "mail@"))
    }
    
    func testValidDate() {
        let dateF = DateFormatter()
        dateF.dateFormat = "dd/MM/yyyy"
        XCTAssertTrue(Validation().checkDate(date: dateF.date(from: "19/06/2003")!))
        XCTAssertTrue(Validation().checkDate(date: dateF.date(from: "19/06/1997")!))
    }
    
    func testInvalidDate() {
        let dateF = DateFormatter()
        dateF.dateFormat = "dd/MM/yyyy"
        XCTAssertFalse(Validation().checkDate(date: dateF.date(from: "19/06/2004")!))
        XCTAssertFalse(Validation().checkDate(date: dateF.date(from: "19/06/2012")!))
        XCTAssertFalse(Validation().checkDate(date: Date()))
    }
}
