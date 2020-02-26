//
//  Subject.swift
//  Register Interest
//
//  Created by Brindle A P (FCES) on 26/02/2020.
//  Copyright © 2020 Ashley Brindle. All rights reserved.
//

import Foundation

class Subject : Encodable {
    var Name: String = ""
    var Email: String = ""
    var DOB: String = ""
    var SubjectArea: String = ""
    var MarketingUpdates: Bool = false
    var GpsLat: Double = 0.0
    var GpsLon: Double = 0.0
    
    init(name: String, email: String, dob: String, subject: String, market: Bool, gpslat: Double, gpslon: Double) {
        Name = name
        Email = email
        DOB = dob
        SubjectArea = subject
        MarketingUpdates = market
        GpsLat = gpslat
        GpsLon = gpslon
    }
}
