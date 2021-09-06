//
//  AvailableSeatRequestViewController.swift
//  proektAMU
//
//  Created by Sara Stojanoska on 8/28/21.
//  Copyright © 2021 Sara Stojanoska. All rights reserved.
//

import UIKit
import Parse

class AvailableSeatRequestViewController: UIViewController {
    
    var dates = [NSDate]()
    var HostessId = String()
    var opis = String()
    var lokacija = String()
    var lon = Double()
    var lat = Double()
    var ime = String()
    var prezime = String()
    var Tip = String()
    var date = NSDate()

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var onLabel: UILabel!
    @IBOutlet weak var TypeSeatLabel: UILabel!
    @IBOutlet weak var Label: UILabel!
    @IBOutlet weak var Image: UIImageView!
    @IBOutlet weak var SearchButton: UIBarButtonItem!
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBAction func GoBack(_ sender: Any) {
        self.performSegue(withIdentifier: "BackSeg", sender: nil)
    }
    @IBAction func SearchButton(_ sender: Any) {
        let request = PFObject(className: "Reservation")
        request["from"] = PFUser.current()?.objectId
        request["to"] = HostessId
        
        request["date"] = NSDate()
        request["status"] = "active"
        request["description"] = opis
        request["type"] = Tip
        request["location"] = lokacija
        request["lon"] = lon
        request["lat"] = lat
        request.saveInBackground { (success, error) in
            if success{
                self.displayAlert(title: "Success", message: "Make a request")
            }
            else{
                self.displayAlert(title: "Error", message: (error?.localizedDescription)!)
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        TypeSeatLabel.text == Tip
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let stringDate = dateFormatter.string(from: date as Date)
        dateLabel.text = stringDate
        
        fetchData()
        
        let hostessQuery = PFUser.query()
        hostessQuery?.whereKey("userType", equalTo: "Hostess")
        hostessQuery?.whereKey("firstName", equalTo: ime)
        hostessQuery?.whereKey("lastName", equalTo: prezime)
        hostessQuery?.whereKey("reqSeat", equalTo: Tip)
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
    func displayAlert(title: String, message: String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    func fetchData(){
        self.dates.removeAll()
        let hostessQuery = PFUser.query()
        hostessQuery?.whereKey("userType", equalTo: "Hostess")
        hostessQuery?.whereKey("firstName", equalTo: ime)
        hostessQuery?.whereKey("lastName", equalTo: prezime)
        hostessQuery?.whereKey("reqSeat", equalTo: Tip)
        hostessQuery?.findObjectsInBackground(block: { (objects, error) in
            if error != nil{
                print(error?.localizedDescription)
            }
            else if let object = objects {
                for obj in object {
                    if let o = obj as? PFUser {
                        if let objectId = o.objectId{
                            let query = PFQuery(className: "Reservation")
                            query.whereKey("to", equalTo: objectId)
                            query.whereKey("status", equalTo: "done")
                            query.findObjectsInBackground(block: { (reservations, error) in
                                if error != nil{
                                    print(error?.localizedDescription)
                                }
                                else if let reservations = reservations{
                                    for reservation in reservations {
                                        if let datum = reservation["finishDate"]{
                                            self.dates.append(datum as! NSDate)
                                        }
                                    }
                                }
                            })
                            
                        }
                    }
                }
            }
        })
    }

    
}
