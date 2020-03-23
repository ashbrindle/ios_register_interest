//
//  ViewController.swift
//  Register Interest
//
//  Created by Ashley Brindle on 13/02/2020.
//  Copyright © 2020 Ashley Brindle. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import CoreData
import Network


class ViewController: UIViewController, CLLocationManagerDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {

    /* --- Returns the amount of columns the picker view should show --- */    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    /* --- Returns the amount of rows in the view --- */
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        // the amount of rows would be the size of the array, to display all subject areas
        return subject_areas.count
    }
    
    /* --- Returns the title for the row --- */    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent: Int) -> String? {
        return subject_areas[row].name
    }
    
    /* --- When a row is selected, the textbox will show the correct name for the selection --- */    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        txt_subject_areas.text = subject_areas[row].name
    }
    

    /* --- The following methods manage when editing is finished for the textboxes, allowing for the keyboard to be closed on older devices --- */    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return(true)
    }
    
    /* --- GUI ATTRIBUTES --- */    
    @IBOutlet weak var txt_password: UITextField!
    @IBOutlet weak var datepicker: UIDatePicker!
    @IBOutlet weak var txt_DOB: UITextField!
    @IBOutlet weak var txt_name: UITextField!
    @IBOutlet weak var txt_email: UITextField!
    @IBOutlet weak var txt_subject_areas: UITextField!
    @IBOutlet weak var switch_marketing: UISwitch!
    @IBOutlet weak var subjectareapicker: UIPickerView!

    /* --- OTHER ATTRIBUTES --- */
    var subject_areas : Array<SubjectArea> = Array()    // holds all of the subject areas recieved from the URL
    let locationManager = CLLocationManager()   // location manager
    var long: Double?   // these are the coordinates for the users location in Longitude
    var lat: Double?    // and Latitude
    
    /* Called when the view load is successful*/
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // delegates are created for each of the editable textfields
        //  this is used for allowing the user to close the keyboard with the "Return" key
        self.txt_password.delegate = self
        self.txt_name.delegate = self
        self.txt_email.delegate = self
        
        // this method is called to grab the subject_areas from the server
        getSubjectAreas(url_string: "https://prod-42.westeurope.logic.azure.com:443/workflows/bde222cb4461471d90691324f4b6861f/triggers/manual/paths/invoke?api-version=2016-06-01&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=rPL5qFWfWLPKNk3KhRuP0fsw4ooSYczKXuNfCAtDjPA")
        
        // a setup is then started to set up the location manager for the users location and to set the default date for the date picker
        setDefaultDate()
        setupLocation()
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        
    }
    
    /* Method run when the view loads above */
    func setupLocation() {
        // these methods prompt the user to grant the application location services
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        
        // checks if the services are enabled
        if CLLocationManager.locationServicesEnabled() {
            // then a delegate is created for the location manager
            locationManager.delegate = self
            // accuracy for the location manager is then set
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            // and the location manager then starts updating the location
            locationManager.startUpdatingLocation()
        }
    }
    
    /* This method runs when the view loads above */
    func setDefaultDate() {
        // date picker is set with the mode (date)
        datepicker.datePickerMode = UIDatePicker.Mode.date
        // the date is then formatted to the correct format
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        
        // the selected date on load is then saved to the text of the txt_DOB textfield,
            // allowing for the correct date to show when the app loads
        let selectedDate = dateFormatter.string(from: datepicker.date)
        txt_DOB.text = selectedDate
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /* This method loads when the location is uploaded on the location manager */
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        
        // the Longitude and Latitude is then saved to be uploaded when needed
        self.lat = locValue.latitude
        self.long = locValue.longitude
    }
    
    /* This struct is created to allow the subjects to be decoded from JSON format on the server */
    struct SubjectArea: Decodable { var name: String }
    
    /* This method is called when the view loads above */
    func getSubjectAreas(url_string: String) {
        // a url is then created with the parameter passed in above
        guard let url = URL(string: url_string) else { return }
        // a "GET" request is then created to request data from the given source
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        
        URLSession.shared.dataTask(with: request) {
            (data, responce, error) in
            // the data is then requested and saved into this variable
            guard let data = data else { return }
            // the method will then attempt to decode the subject area JSON data recieved
            do {
                self.subject_areas = try JSONDecoder().decode([SubjectArea].self, from: data)
                
                // this is then run in async task to update the other thread
                DispatchQueue.main.async {
                    // then a delegate and datasource is saved to the pickerview
                    self.subjectareapicker.delegate = self
                    self.subjectareapicker.dataSource = self
                    // and the txt_subject_areas shows the default option for the subject picker
                    self.txt_subject_areas.text = self.subject_areas[0].name
                }
            } catch let jsonErr {
                print(jsonErr)
            }
        }.resume()
    }
    
    /* This method runs when the value on the datapicker is changed (Action method from the storyboard) */
    @IBAction func date_picker_changed(_ sender: UIDatePicker) {
        // the txt_DOB textview is then updated to show the new date
        sender.datePickerMode = UIDatePicker.Mode.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        let selectedDate = dateFormatter.string(from: sender.date)
        txt_DOB.text = selectedDate
    }
    
    /* Action method created for when the submit button is pressed */
    @IBAction func btnSubmit(_ sender: UIButton) {
        // a validation object is created, which will be used to validate some of the fields
        let validation = Validation()
        
        // a check is then made if all of the fields have the required data for a registration
        if (validation.checkDate(date: self.datepicker.date) && validation.checkEmail(txt_email: self.txt_email.text ?? "") && !(txt_name.text == "") && !(txt_email.text == "")) {
            
            // the data is then saved to the device using the method created in the "ManageData.swift" file
            ManageData().saveSubject(name: txt_name.text ?? "", email: txt_email.text ?? "", dob: txt_DOB.text ?? "", subject: txt_subject_areas.text ?? "", market: switch_marketing.isOn, gpslat: self.lat ?? 0.0, gpslon: self.long ?? 0.0)
            
            // Initial values and states of the fields are then set for the next user to register
            txt_name.text = ""
            txt_email.text = ""
            self.subjectareapicker.selectRow(0, inComponent: 0, animated: true)
            
            if subject_areas.count > 0 {
                self.txt_subject_areas.text = subject_areas[0].name
            }
            else {
                self.txt_subject_areas.text = ""
            }
            
            self.datepicker.setDate(Date(), animated: true)
            setDefaultDate()
            self.switch_marketing.setOn(true, animated: true)
            // alert is then created to notify the user
            createAlert(title: "Well Done", message: "Submission Sent Sucessfully, Thank you for Registering Your Interest", action_title: "Finish")
        }
        else {
            // if a field is incorrect the user will be prompted
            createAlert(title: "Invalid", message: "One or More of Your Entries is Invalid", action_title: "Try Again")
        }
    }
    
    /* This is called when an alert is needed in the view */
    func createAlert(title: String, message: String, action_title: String) {
        // alert is created with given parameters
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        // action added to dismiss the alert
        alert.addAction(UIAlertAction(title: action_title, style: UIAlertAction.Style.default, handler: nil))
        // the alert is then shown
        self.present(alert, animated: true, completion: nil)
    }
    
    /* This method is run when the admin button is pressed, creating a segue to another view controller */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // the segue is correct for the admin page
        if segue.identifier == "AdminButtonSegue" {
            // the application will segue if the conditions are met
            if segue.destination is AdminViewController {
                // the app will only segue if the password is correct
                if (txt_password.text != "password") {
                    createAlert(title: "Incorrect Password", message: "Password entered was incorrect", action_title: "Try Again")
                }
                else {
                    // if the password is correct the field will be cleared and application will change views
                    txt_password.text = ""
                }
              }
          }
    }
}
