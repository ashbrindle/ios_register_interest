//
//  AdminViewController.swift
//  Register Interest
//
//  Created by Brindle A P (FCES) on 18/02/2020.
//  Copyright © 2020 Ashley Brindle. All rights reserved.
//

import UIKit
import CoreData

class TableViewCellAdapter: UITableViewCell {
    @IBOutlet weak var txtName: UILabel!
    @IBOutlet weak var txt_Subject: UILabel!
    
}

class AdminViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    @IBOutlet weak var tableview: UITableView!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableview.dataSource = self
        tableview.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableview.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getAllSubjects().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "custom_cell", for: indexPath) as! TableViewCellAdapter
        cell.txtName?.text = getAllSubjects()[indexPath.item].Name
        cell.txt_Subject?.text = getAllSubjects()[indexPath.item].SubjectArea
        return cell
    }
    
    @IBAction func btnBack(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    class Message : Decodable {
        var message : String
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
    
    @IBAction func btnPublish(_ sender: Any) {
        guard let url = URL(string: "https://prod-69.westeurope.logic.azure.com:443/workflows/d2ec580e6805459893e498d43f292462/triggers/manual/paths/invoke?api-version=2016-06-01&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=zn8yq-Xe3cOCDoRWTiLwDsUDXAwdGSNzxKL5OUHJPxo") else {
            print("Bad URL")
            return
            
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        do {
            var json_send = Data()
            let subjs = getAllSubjects()
            for subject in subjs {
                let json = try JSONEncoder().encode(subject)
                json_send = json_send + json
            }
            
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = json_send
            print("Uploading Data")
            
            URLSession.shared.dataTask(with: request) {
                (data, responce, error) in
                guard let data = data else { return }
                do {
                    let message = try JSONDecoder().decode(Message.self, from: data)
                    print(message.message)
                    
                    DispatchQueue.main.async {
                        self.emptyData()
                        self.tableview.reloadData()
                    }
                } catch let jsonErr {
                    print(jsonErr)
                }
            }.resume()
            
            
        } catch let jsonErr {
            print(jsonErr)
        }
    }
    
}
