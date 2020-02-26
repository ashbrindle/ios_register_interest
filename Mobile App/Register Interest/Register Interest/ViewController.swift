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
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return subject_areas.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent: Int) -> String? {
        return subject_areas[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        txt_subject_areas.text = subject_areas[row].name
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return(true)
    }
    
    
    @IBOutlet weak var txt_password: UITextField!
    @IBOutlet weak var datepicker: UIDatePicker!
    @IBOutlet weak var txt_DOB: UITextField!
    @IBOutlet weak var txt_name: UITextField!
    @IBOutlet weak var txt_email: UITextField!
    @IBOutlet weak var txt_subject_areas: UITextField!
    @IBOutlet weak var switch_marketing: UISwitch!
    @IBOutlet weak var subjectareapicker: UIPickerView!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var subject_areas : Array<SubjectArea> = Array()
    let locationManager = CLLocationManager()
    var long: Double?
    var lat: Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txt_password.delegate = self
        self.txt_name.delegate = self
        self.txt_email.delegate = self
        
        retrieveURL(url_string: "https://prod-42.westeurope.logic.azure.com:443/workflows/bde222cb4461471d90691324f4b6861f/triggers/manual/paths/invoke?api-version=2016-06-01&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=rPL5qFWfWLPKNk3KhRuP0fsw4ooSYczKXuNfCAtDjPA")
        setDefaultDate()
        setupLocation()
        
    }
    
    func setupLocation() {
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    func setDefaultDate() {
        datepicker.datePickerMode = UIDatePicker.Mode.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        let selectedDate = dateFormatter.string(from: datepicker.date)
        txt_DOB.text = selectedDate
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        self.lat = locValue.latitude
        self.long = locValue.longitude
    }
    
    struct SubjectArea: Decodable { var name: String }
    
    func retrieveURL(url_string: String) {
        guard let url = URL(string: url_string) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) {
            (data, responce, error) in
            guard let data = data else { return }
            do {
                self.subject_areas = try JSONDecoder().decode([SubjectArea].self, from: data)
                DispatchQueue.main.async {
                    self.subjectareapicker.delegate = self
                    self.subjectareapicker.dataSource = self
                    self.txt_subject_areas.text = self.subject_areas[0].name
                }
            } catch let jsonErr {
                print(jsonErr)
            }
        }.resume()
    }
    
    @IBAction func date_picker_changed(_ sender: UIDatePicker) {
        sender.datePickerMode = UIDatePicker.Mode.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        let selectedDate = dateFormatter.string(from: sender.date)
        txt_DOB.text = selectedDate
    }
    
    
    
    @IBAction func btnSubmit(_ sender: UIButton) {
        let validation = Validation()
        if (validation.checkDate(datepicker: self.datepicker) && validation.checkEmail(txt_email: self.txt_email) && !(txt_name.text == "") && !(txt_email.text == "")) {
            
            ManageData().insertData(name: txt_name.text ?? "", email: txt_email.text ?? "", dob: txt_DOB.text ?? "", subject: txt_subject_areas.text ?? "", market: switch_marketing.isOn, gpslat: self.lat ?? 0.0, gpslon: self.long ?? 0.0)
            
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
            
            createAlert(title: "Well Done", message: "Submission Sent Sucessfully, Thank you for Registering Your Interest", action_title: "Finish")
        }
        else {
            createAlert(title: "Invalid", message: "One or More of Your Entries is Invalid", action_title: "Try Again")
        }
    }
    
    func createAlert(title: String, message: String, action_title: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: action_title, style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
          if segue.identifier == "AdminButtonSegue" {
            if segue.destination is AdminViewController {
                if (txt_password.text != "password") {
                    createAlert(title: "Incorrect Password", message: "Password entered was incorrect", action_title: "Try Again")
                }
              }
          }
    }
}
