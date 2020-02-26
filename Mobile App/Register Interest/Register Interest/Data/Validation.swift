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
    
    func checkEmail(txt_email: UITextField) -> Bool {
        let regularExpressionForEmail = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let testEmail = NSPredicate(format:"SELF MATCHES %@", regularExpressionForEmail)
        return testEmail.evaluate(with: txt_email.text)
    }
    
    func checkDate(datepicker: UIDatePicker) -> Bool {
        let birthDate = datepicker.date
        let today = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: birthDate, to: today)
        let ageYears = components.year
        let user_age = "\(ageYears!)"
        
        if (Int(user_age)! < 16) {
            return false
        }
        else {
            return true
        }
    }
}
