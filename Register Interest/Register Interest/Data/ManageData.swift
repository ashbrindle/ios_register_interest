//
//  ManageData.swift
//  Register Interest
//
//  Created by Brindle A P (FCES) on 26/02/2020.
//  Copyright © 2020 Ashley Brindle. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ManageData  {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    /* This method is called when the application needs to grab the saved data on the device */
    func getSubjects() -> [Subject] {
        // used to hold the recieved subjects
        var subjects = [Subject]()
        // core data requests the data saved on the subject with the name "Subject"
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Subject")
        request.returnsObjectsAsFaults = false
        let context = appDelegate.persistentContainer.viewContext
        
        do {
            // attempts to fetch the data from the device
            let result = try context.fetch(request)
            
            for data in result as! [NSManagedObject] {
                // a loop is then run through all of the subjects on the device
                let subject = Subject.init(name: data.value(forKey: "name") as! String, email: data.value(forKey: "email") as! String, dob: data.value(forKey: "dob") as! String, subject: data.value(forKey: "subjectarea") as! String, market: data.value(forKey: "marketingupdates") as! Bool, gpslat: data.value(forKey: "gpslat") as! Double, gpslon: data.value(forKey: "gpslon") as! Double)
                //  and saves them to an array
                subjects.append(subject)
            }
        } catch {
            print("query failed")
        }
        
        // the array is then returned for the app to use
        return subjects
    }
    
    // Clears all saved data on the device
    func clearAllSubjects() {
        // requests core data with entity name "Subject"
        let request = NSFetchRequest<NSFetchRequestResult>(entityName:"Subject")
        request.returnsObjectsAsFaults = false
        let context = appDelegate.persistentContainer.viewContext
        
        // loops through all subjects and deletes them from the device
        if let result = try? context.fetch(request) {
            for obj in result {
                context.delete(obj as! NSManagedObject)
            }
            try? context.save()
        }
    }
    
    /* Saves a subject to the device using CoreData */
    func saveSubject(name: String, email: String, dob: String, subject: String, market: Bool, gpslat: Double, gpslon: Double) {
        let context = appDelegate.persistentContainer.viewContext
        
        context.perform {
            // specifies the entity being saved to
            let entity = NSEntityDescription.entity(forEntityName: "Subject", in: context)
            let newSubject = NSManagedObject(entity: entity!, insertInto: context)
            
            // each segment of data is then assigned to the entity
            newSubject.setValue(name, forKey: "name")
            newSubject.setValue(email, forKey: "email")
            newSubject.setValue(dob, forKey: "dob")
            newSubject.setValue(subject, forKey: "subjectarea")
            newSubject.setValue(market, forKey: "marketingupdates")
            newSubject.setValue(gpslat, forKey: "gpslat")
            newSubject.setValue(gpslon, forKey: "gpslon")
            
            do {
                // the data is then saved to the device
                try context.save()
            } catch {
                print("Failed to Save")
            }
            
        }
    }
    
    
}
