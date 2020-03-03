//
//  Subject.swift
//  Register Interest
//
//  Created by Brindle A P (FCES) on 26/02/2020.
//  Copyright © 2020 Ashley Brindle. All rights reserved.
//

import Foundation

class Subject : Encodable {
    
    /* --- SUBJECT ATTRIBUTES --- */
    var Name: String = ""
    var Email: String = ""
    var DOB: String = ""
    var SubjectArea: String = ""
    var MarketingUpdates: Bool = false
    var GpsLat: Double = 0.0
    var GpsLon: Double = 0.0
    
    /* Constructor called when the subject is created */
    init(name: String, email: String, dob: String, subject: String, market: Bool, gpslat: Double, gpslon: Double) {
        // all of the relevant details on the subject are then saved into the object
        Name = name
        Email = email
        DOB = dob
        SubjectArea = subject
        MarketingUpdates = market
        GpsLat = gpslat
        GpsLon = gpslon
    }
}
