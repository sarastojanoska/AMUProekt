//
//  ReservationDetailViewController.swift
//  proektAMU
//
//  Created by Sara Stojanoska on 9/5/21.
//  Copyright © 2021 Sara Stojanoska. All rights reserved.
//

import UIKit
import Parse

class ReservationDetailViewController: UIViewController {
    
    var datum = NSDate()
    var status = String()
    var Ime = String()
    var Prezime = String()
    var phone = String()
    var email = String()
    var tip = String()
    var lat = Double()
    var long = Double()
    var adresa = String()
    var jobId = String()
    var datePicker = NSDate()
    var DatumZavrsuvanje = NSDate()
    
    
    @IBOutlet weak var chooseDate: UILabel!
    
    @IBOutlet weak var DatePicker: UIDatePicker!
    @IBOutlet weak var Data: UILabel!
    
    @IBOutlet weak var DateFinish: UILabel!
    @IBOutlet weak var FinishedOn: UILabel!
    @IBOutlet weak var Status: UILabel!
    @IBOutlet weak var GuestInfo: UILabel!
    @IBOutlet weak var Korisnik: UILabel!
    @IBOutlet weak var Phone: UILabel!
    @IBOutlet weak var Email: UILabel!
    @IBOutlet weak var Address: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        Korisnik.text = Ime + " " + Prezime
        Status.text = status
        Phone.text = phone
        Email.text = email
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm"
        let StringDate = formatter.string(from: datum as Date)
        Address.text = adresa
        if status == "scheduled"{
            FinishedOn.isHidden = true
            DateFinish.isHidden = true
            DatePicker.datePickerMode = .date
            DatePicker.isHidden = false
            datePicker = DatePicker.date as NSDate
            
        }
        else{
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy HH:mm"
            let StringDate = formatter.string(from: datum as Date)
            FinishedOn.text = StringDate
            FinishedOn.isHidden = false
            DatePicker.isHidden = true
        }
    }
    
    @IBAction func ToMap(_ sender: Any) {
        performSegue(withIdentifier: "toMapSeg", sender: nil)
    }
    
    @IBAction func BackPressed(_ sender: Any) {
        performSegue(withIdentifier: "backkSeg", sender: nil)
    }
    @IBAction func SavePressed(_ sender: Any) {
        let query = PFQuery(className:"Reservation")
        query.whereKey("objectId" , equalTo: jobId)
        query.findObjectsInBackground { (objects, error) in
            if error != nil {
                print(error?.localizedDescription)
            }
            else if let object = objects{
                for obj in object{
                    obj["finishDate"] = self.datePicker
                    obj["status"] = "done"
                    obj.saveInBackground()
                }
            }
        }
    }
    override func prepare(for seg: UIStoryboardSegue, sender: Any?) {
        if seg.identifier == "toMapSeg"{
            let dVC = seg.destination as! MapViewController
            dVC.lat = lat
            dVC.long = long
            dVC.lokacija = adresa
        }
    }
    
}
