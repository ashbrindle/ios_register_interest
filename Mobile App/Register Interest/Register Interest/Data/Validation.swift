//
//  Validation.swift
//  Register Interest
//
//  Created by Brindle A P (FCES) on 26/02/2020.
//  Copyright © 2020 Ashley Brindle. All rights reserved.
//

import Foundation
import UIKit

class Validation {
    
    /* Called to validate the email address */
    func checkEmail(txt_email: UITextField) -> Bool {
        // regular expression is created for email
        let regularExpressionForEmail = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        let testEmail = NSPredicate(format:"SELF MATCHES %@", regularExpressionForEmail)
        // the email is then compared against the expression and will return a Boolean
        return testEmail.evaluate(with: txt_email.text)
    }
    
    /* Called to validate the data selected (age of subject) */
    func checkDate(datepicker: UIDatePicker) -> Bool {
        // this will check the current year against the users selected age
        let birthDate = datepicker.date
        let today = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: birthDate, to: today)
        let ageYears = components.year
        let user_age = "\(ageYears!)"
        
        // if the user is under the age of 16, the user cannot register
        if (Int(user_age)! < 16) {
            return false
        }
        else {
            return true
        }
    }
}
