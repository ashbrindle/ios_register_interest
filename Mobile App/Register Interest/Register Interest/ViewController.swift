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
        txt_subject.text = subject_areas[row].name
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
    @IBOutlet weak var txt_subject: UITextField!
    @IBOutlet weak var switch_marketing: UISwitch!
    @IBOutlet weak var subjectareapicker: UIPickerView!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var subjects : Array<Subject> = Array()
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
    
    func setupLocation() {
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        self.lat = locValue.latitude
        self.long = locValue.longitude
        print("location = \(locValue.latitude) \(locValue.longitude)")
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
                    self.txt_subject.text = self.subject_areas[0].name
                }
            } catch let jsonErr {
                print(jsonErr)
            }
        }.resume()
        
    }
    
    func setDefaultDate() {
        datepicker.datePickerMode = UIDatePicker.Mode.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        let selectedDate = dateFormatter.string(from: datepicker.date)
        txt_DOB.text = selectedDate
    }
    
    @IBAction func date_picker_changed(_ sender: UIDatePicker) {
        sender.datePickerMode = UIDatePicker.Mode.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        let selectedDate = dateFormatter.string(from: sender.date)
        txt_DOB.text = selectedDate
    }
    
    
    
    @IBAction func btnSubmit(_ sender: UIButton) {
        if (checkDate() && checkEmail() && !(txt_name.text == "") && !(txt_email.text == "")) {
            
            insertData(name: txt_name.text ?? "", email: txt_email.text ?? "", dob: txt_DOB.text ?? "", subject: txt_subject.text ?? "", market: switch_marketing.isOn, gpslat: self.lat ?? 0.0, gpslon: self.long ?? 0.0)
            
            txt_name.text = ""
            txt_email.text = ""
            self.subjectareapicker.selectRow(0, inComponent: 0, animated: true)
            
            self.txt_subject.text = subject_areas[0].name
            
            self.datepicker.setDate(Date(), animated: true)
            setDefaultDate()
            self.switch_marketing.setOn(true, animated: true)
            
            let alert = UIAlertController(title: "Well Done", message: "Submission Complete, Thank you for Registering Your Interest", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Finish", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
        else {
            let alert = UIAlertController(title: "Invalid", message: "One or More of Your Entries is Invalid", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    func checkEmail() -> Bool {
        let regularExpressionForEmail = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let testEmail = NSPredicate(format:"SELF MATCHES %@", regularExpressionForEmail)
        return testEmail.evaluate(with: txt_email.text)
    }
    
    func checkDate() -> Bool {
        let birthDate = self.datepicker.date
        let today = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: birthDate, to: today)
        let ageYears = components.year
        let user_age = "\(ageYears!)"
        print(user_age)
        
        if (Int(user_age)! < 16) {
            return false
        }
        else {
            return true
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
          if segue.identifier == "AdminButtonSegue" {
              if let nextViewController = segue.destination as? AdminViewController {
                if (txt_password.text == "password") {
                    nextViewController.data_set = getAllSubjects()
                }
                else {
                    let alert = UIAlertController(title: "Incorrect Password", message: "Password entered was incorrect", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
              }
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
}

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
