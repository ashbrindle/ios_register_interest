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
    
    func getAllSubjects() -> [Subject] {
        var subjects = [Subject]()
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Subject")
        request.returnsObjectsAsFaults = false
        let context = appDelegate.persistentContainer.viewContext
        
        do {
            let result = try context.fetch(request)
            
            for data in result as! [NSManagedObject] {
                let subject = Subject.init(name: data.value(forKey: "name") as! String, email: data.value(forKey: "email") as! String, dob: data.value(forKey: "dob") as! String, subject: data.value(forKey: "subjectarea") as! String, market: data.value(forKey: "marketingupdates") as! Bool, gpslat: data.value(forKey: "gpslat") as! Double, gpslon: data.value(forKey: "gpslon") as! Double)
                subjects.append(subject)
            }
        } catch {
            print("query failed")
        }
        return subjects
    }
    
    class Message : Decodable {
        var message : String = ""
    }
    
    func emptyData() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName:"Subject")
        request.returnsObjectsAsFaults = false
        let context = appDelegate.persistentContainer.viewContext
        
        if let result = try? context.fetch(request) {
            for obj in result {
                context.delete(obj as! NSManagedObject)
            }
            try? context.save()
        }
    }
    
    func insertData(name: String, email: String, dob: String, subject: String, market: Bool, gpslat: Double, gpslon: Double) {
        let context = appDelegate.persistentContainer.viewContext
        
        context.perform {
            let entity = NSEntityDescription.entity(forEntityName: "Subject", in: context)
            let newSubject = NSManagedObject(entity: entity!, insertInto: context)
            
            newSubject.setValue(name, forKey: "name")
            newSubject.setValue(email, forKey: "email")
            newSubject.setValue(dob, forKey: "dob")
            newSubject.setValue(subject, forKey: "subjectarea")
            newSubject.setValue(market, forKey: "marketingupdates")
            newSubject.setValue(gpslat, forKey: "gpslat")
            newSubject.setValue(gpslon, forKey: "gpslon")
            
            do {
                try context.save()
            } catch {
                print("Failed to Save")
            }
            
        }
    }
    
    
}
