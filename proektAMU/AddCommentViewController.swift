//
//  AddCommentViewController.swift
//  proektAMU
//
//  Created by Sara Stojanoska on 9/8/21.
//  Copyright © 2021 Sara Stojanoska. All rights reserved.
//

import UIKit
import Parse

class AddCommentViewController: UIViewController {
    
    var Ime = String()
    var Prezime = String()
    var comments = [String]()
    var dates = [NSDate]()
    var statuses = [String]()
    var HostessId = String()
    var  datePicker = NSDate()
    var izborstatus = String()
    var kom = String()
    

    @IBOutlet weak var Pozitivno: UILabel!
    @IBOutlet weak var Negativno: UILabel!
    @IBOutlet weak var PosorNeg: UISwitch!
    @IBOutlet weak var DateChosen: UILabel!
    @IBOutlet weak var Comment: UITextView!
    @IBOutlet weak var PickDate: UIDatePicker!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker = PickDate.date as NSDate
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let StringDate = formatter.string(from: datePicker as Date)
        DateChosen.text = StringDate
        if PosorNeg.isOn{
            izborstatus = "pozitivno"
        }
        else{
            izborstatus = "negativno"
        }
        kom = Comment.text
        
        let hostessQuery = PFUser.query()
        hostessQuery?.whereKey("userType", equalTo: "Hostess")
        hostessQuery?.whereKey("firstName", equalTo: Ime)
        hostessQuery?.whereKey("lastName", equalTo: Prezime)
        hostessQuery?.findObjectsInBackground(block: { (objects, error) in
            if error != nil{
                print(error?.localizedDescription)
            }
            else if let object = objects{
                for obj in object{
                    if let o = obj as? PFUser {
                        if let o = obj as? PFUser {
                            if let objectId = o.objectId {
                                self.HostessId = objectId
                            }
                        }
                    }
                }
            }
        })
    }
    @IBAction func Back(_ sender: Any) {
        performSegue(withIdentifier: "bkSeg", sender: nil)
    }
    @IBAction func SendComment(_ sender: Any) {
        if DateChosen.text != " " && Comment.text != " "{
            let comm = PFObject(className: "Comment")
            comm["from"] = PFUser.current()?.objectId
            comm["to"] = HostessId
            comm["date"] = datePicker
            comm["status"] = izborstatus
            comm["komentar"] = kom
            comm.saveInBackground { (success, error) in
                if success {
                    self.displayAlert(title: "Success", message: "Thank you for your comment")
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
