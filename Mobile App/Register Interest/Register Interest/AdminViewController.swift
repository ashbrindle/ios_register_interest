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
    @IBOutlet weak var lblLoading: UILabel!
    var data_size: Int = 0
    var data_count: Int = 0

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
        return ManageData().getSubjects().count
    }
    
    /* Runs when a cell is selected */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // creates data object to access the device data
        let data = ManageData()
        
        // creates a message to display when a subject is selected
        var message: String = ""
        message = message + "Name: \n" + data.getSubjects()[indexPath.row].Name
        message = message + "\n\nEmail: \n" + data.getSubjects()[indexPath.row].Email
        message = message + "\n\nDOB: \n" + data.getSubjects()[indexPath.row].DOB
        message = message + "\n\nSubject: \n" + data.getSubjects()[indexPath.row].SubjectArea
        message = message + "\n\nMarketing Updates: \n" + String(data.getSubjects()[indexPath.row].MarketingUpdates)
        message = message + "\n\nLocation: \n" + String(data.getSubjects()[indexPath.row].GpsLat)
        message = message + " " + String(data.getSubjects()[indexPath.row].GpsLon)
        
        // produces an alert to display all data about the selected subject
        createAlert(title: "Subject", message: message, action_title: "Dismiss")
    }

    /* Called when assigning details to each cell */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = ManageData()
        // gets the cell with the identifier "custom_cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: "custom_cell", for: indexPath) as! TableViewCellAdapter
        // populates the cell with the relevant data
        cell.txtName?.text = data.getSubjects()[indexPath.item].Name
        cell.txt_Subject?.text = data.getSubjects()[indexPath.item].SubjectArea
        return cell
    }

    /* Called when the back button is pressed on the admin view */
    @IBAction func btnBack(_ sender: UIButton) {
    	// dismiss' the window and shows the form again
        dismiss(animated: true, completion: nil)
    }
    
    /* Method created to create and show an alert with the specified parameters */
    func createAlert(title: String, message: String, action_title: String) {
    	// creates the alert as an async task, so it will run on the GUI thread
        DispatchQueue.main.async {
        	// create alert with specified message
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
            // adds an action to the alert, e.g an "ok" button
            alert.addAction(UIAlertAction(title: action_title, style: UIAlertAction.Style.default, handler: nil))
            // shows the alert
            self.present(alert, animated: true, completion: nil)
        }
    }

    /* Class created to allow the return message
    from the server when the upload is successful */
    class Message : Decodable {
        var message : String = ""
    }
    
    /* Called when an individual subject is being uploaded */
    func uploadSubject(subject: Subject, device_data: ManageData) {
        // creates the URL for the upload (guard let used incase the url is invalid)
        guard let url = URL(string: "https://prod-69.westeurope.logic.azure.com:443/workflows/d2ec580e6805459893e498d43f292462/triggers/manual/paths/invoke?api-version=2016-06-01&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=zn8yq-Xe3cOCDoRWTiLwDsUDXAwdGSNzxKL5OUHJPxo") else {
            print("Bad URL")
            return
            
        }

        // sets the request method for the url, "POST" to post the data
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        do {
            // this will then encode the subject (passed into this method)
            var json_send = Data()
            json_send = try JSONEncoder().encode(subject)
            
            // specifies the content type that will be uploaded
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            // uploads the subject to the server
            request.httpBody = json_send
            print("Uploading Data")
            
            // next the data will be retrieved from the server to get a confirmation message
            URLSession.shared.dataTask(with: request) {
                (data, response, error) in

                // assigns the data to a variable
                guard let data = data else { return }
                do {
                    // decodes the recieved JSON data into a message object
                    let message = try JSONDecoder().decode(Message.self, from: data)
                    // prints the return message to state if the upload was successful or unsuccessful
                    print(message.message)
                    DispatchQueue.main.async {
                        self.data_count += 1
                        if (self.data_count == self.data_size) {
                            // an alert will then appear and state that the upload was successful
                            self.createAlert(title: "Upload Complete", message: "Upload was Successful", action_title: "Dismiss")
                            // once the upload of all the data is complete, the device will clear all of the data saved
                            device_data.clearAllSubjects()
                            // the tableview will now reload its data and display no subjects to upload
                            self.tableview.reloadData()
                            self.lblLoading.text = "Data Upload Complete"
                        }
                    }
                }
                catch let jsonErr {
                    print(jsonErr.localizedDescription)
                }
            }.resume()
            
            
        }
        catch let jsonErr {
            print(jsonErr.localizedDescription)
        }
    }

    /* Called when the publish button is pressed */
    @IBAction func btnPublish(_ sender: Any) {
        // grabs the data saved on the device
        let device_data = ManageData()
        data_size = device_data.getSubjects().count
        // checks if there are any subjects saved on the device
        if device_data.getSubjects().count > 0 {
            
            // saves the subjects to an array
            let subjs = ManageData().getSubjects()
            self.lblLoading.text = "Uploading Data..."
            // this is then used to loop through each subject and upload them individually to the server
            for subject in subjs {
                uploadSubject(subject: subject, device_data: device_data)
            }

        }
        
    }
    
    
    
}
