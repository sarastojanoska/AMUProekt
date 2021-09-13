//
//  AddReviewViewController.swift
//  proektAMU
//
//  Created by Sara Stojanoska on 9/10/21.
//  Copyright © 2021 Sara Stojanoska. All rights reserved.
//

import UIKit
import Parse

class AddReviewViewController: UIViewController {
    
    var Ime = String()
    var Prezime = String()
    var ocenki = [String]()
    var zetoni = [String]()
    var dates = [String]()
    var GuestId = String()
    var datePicker = NSDate()
    var izborzeton = String()
    var oc = String()
    
    @IBOutlet weak var PickDate: UIDatePicker!
    @IBOutlet weak var Ocenka: UITextView!
    @IBOutlet weak var DateChosen: UILabel!
    @IBOutlet weak var Green: UILabel!
    @IBOutlet weak var Red: UILabel!
    @IBOutlet weak var RedorGreen: UISwitch!
    
    @IBAction func Back(_ sender: Any) {
        performSegue(withIdentifier: "konTabelaSeg", sender: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker = PickDate.date as NSDate
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let StringDate = formatter.string(from: datePicker as Date)
        DateChosen.text = StringDate
        if RedorGreen.isOn{
            izborzeton = "zelen"
        }
        else{
            izborzeton = "crven"
        }
        oc = Ocenka.text
        
        let guestQuery = PFUser.query()
        guestQuery?.whereKey("userType", equalTo: "Guest")
        guestQuery?.whereKey("firstName", equalTo: Ime)
        guestQuery?.whereKey("lastName", equalTo: Prezime)
        guestQuery?.findObjectsInBackground(block: { (objects, error) in
            if error != nil{
                print(error?.localizedDescription)
            }
            else if let object = objects{
                for obj in object{
                    if let o = obj as? PFUser {
                        if let o = obj as? PFUser {
                            if let objectId = o.objectId {
                                self.GuestId = objectId
                            }
                        }
                    }
                }
            }
        })
        
    }
    

    @IBAction func SendReview(_ sender: Any) {
        if DateChosen.text != " " && Ocenka.text != " "{
            let rev = PFObject(className: "Review")
            rev["from"] = PFUser.current()?.objectId
            rev["to"] = GuestId
            rev["date"] = datePicker
            rev["zeton"] = izborzeton
            rev["ocenka"] = oc
            rev.saveInBackground { (success, error) in
                if success {
                    self.displayAlert(title: "Success", message: "Thank you for your review")
                }
                else{
                    self.displayAlert(title: "Error", message: (error?.localizedDescription)!)
                }
            }
        }
        else{
            self.displayAlert(title: "Error", message: "You must provide all information")
        }
        
    }
    func displayAlert(title: String, message: String){
        let alertC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertC,animated: true, completion: nil)
    }
}
