//
//  AdminViewController.swift
//  Register Interest
//
//  Created by Brindle A P (FCES) on 18/02/2020.
//  Copyright © 2020 Ashley Brindle. All rights reserved.
//

import UIKit
import CoreData

/* --- CUSTOM TABLE CELL ADAPTER --- */
class TableViewCellAdapter: UITableViewCell {
    /* gives the ability to display specific information
     in the layout wanted for each cell in the tableview */
    
    /* --- UI ATTRIBUTES --- */
    @IBOutlet weak var txtName: UILabel!
    @IBOutlet weak var txt_Subject: UILabel!
    
}

/* --- VIEW CONTROLLER FOR THE ADMIN VIEW --- */
class AdminViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    /* uses the UIViewController, UITableVieDataSource and
     UITableViewDelegate to manage how the data will be displayed
     and interactions */
    
    /* --- UI ATTRIBUTES --- */
    @IBOutlet weak var tableview: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.dataSource = self
        tableview.delegate = self
    }
    
    /* Runs when the view appears */
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // reloads all of the data used to construct the tableview
        tableview.reloadData()
    }
    
    /* Determines the size of the table */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // size being the amount of subjects to be displayed
        return ManageData().getAllSubjects().count
    }
    
    /* Runs when a cell is selected */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // creates data object to access the device data
        let data = ManageData()
        
        // creates a message to display when a subject is selected
        var message: String = ""
        message = message + "Name: \n" + data.getAllSubjects()[indexPath.row].Name
        message = message + "\n\nEmail: \n" + data.getAllSubjects()[indexPath.row].Email
        message = message + "\n\nDOB: \n" + data.getAllSubjects()[indexPath.row].DOB
        message = message + "\n\nSubject: \n" + data.getAllSubjects()[indexPath.row].SubjectArea
        message = message + "\n\nMarketing Updates: \n" + String(data.getAllSubjects()[indexPath.row].MarketingUpdates)
        message = message + "\n\nLocation: \n" + String(data.getAllSubjects()[indexPath.row].GpsLat)
        message = message + " " + String(data.getAllSubjects()[indexPath.row].GpsLon)
        
        // produces an alert to display all data about the selected subject
        createAlert(title: "Subject", message: message, action_title: "Dismiss")
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = ManageData()
        let cell = tableView.dequeueReusableCell(withIdentifier: "custom_cell", for: indexPath) as! TableViewCellAdapter
        cell.txtName?.text = data.getAllSubjects()[indexPath.item].Name
        cell.txt_Subject?.text = data.getAllSubjects()[indexPath.item].SubjectArea
        return cell
    }
    
    @IBAction func btnBack(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func createAlert(title: String, message: String, action_title: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: action_title, style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

    class Message : Decodable {
        var message : String = ""
    }
    
    @IBAction func btnPublish(_ sender: Any) {
        let device_data = ManageData()
        if device_data.getAllSubjects().count > 0 {
            guard let url = URL(string: "https://prod-69.westeurope.logic.azure.com:443/workflows/d2ec580e6805459893e498d43f292462/triggers/manual/paths/invoke?api-version=2016-06-01&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=zn8yq-Xe3cOCDoRWTiLwDsUDXAwdGSNzxKL5OUHJPxo") else {
                print("Bad URL")
                return
                
            }
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            do {
                var json_send = Data()
                let subjs = ManageData().getAllSubjects()
                for subject in subjs {
                    let json = try JSONEncoder().encode(subject)
                    json_send = json_send + json
                }
                
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.httpBody = json_send
                print("Uploading Data")
                
                URLSession.shared.dataTask(with: request) {
                    (data, response, error) in
                    guard let data = data else { return }
                    do {
                        let message = try JSONDecoder().decode(Message.self, from: data)
                        
                        DispatchQueue.main.async {
                            device_data.emptyData()
                            self.tableview.reloadData()
                            if message.message != "" {
                                self.createAlert(title: "Upload Successful", message: message.message, action_title: "Dismiss")
                            }
                        }
                    } catch let jsonErr {
                        print(jsonErr)
                        self.createAlert(title: "Upload Unsuccessful", message: "Please Try Again", action_title: "Dismiss")
                    }
                }.resume()
                
                
            } catch let jsonErr {
                print(jsonErr)
                self.createAlert(title: "Upload Unsuccessful", message: "Please Try Again", action_title: "Dismiss")
            }
            
        }
        
    }
    
    
    
}
