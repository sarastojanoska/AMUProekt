//
//  RequestDetailsViewController.swift
//  proektAMU
//
//  Created by Sara Stojanoska on 8/30/21.
//  Copyright © 2021 Sara Stojanoska. All rights reserved.
//

import UIKit
import Parse

class RequestDetailsViewController: UIViewController {
    var dateReq = NSDate()
    var HostessId = String()
    var opis = String()
    var status = String()
    var tip = String()
    var dateFinished = NSDate()
    var DatumPonuda = NSDate()
    var TypeSeatRequested = String()
    var ReservatedFor = NSDate()
    
    @IBOutlet weak var Reviews: UIButton!
    @IBOutlet weak var RezerviranoNa: UILabel!
    @IBOutlet weak var DateReserved: UILabel!
    @IBOutlet weak var Status: UILabel!
    @IBOutlet weak var SedenjeP: UILabel!
    @IBOutlet weak var DatumP: UILabel!
    @IBOutlet weak var Opis: UILabel!
    @IBOutlet weak var IzborSedenje: UILabel!
    
    @IBOutlet weak var DatumBaranje: UILabel!
    @IBOutlet weak var ImePrezime: UILabel!
    @IBOutlet weak var Phone: UILabel!
    @IBOutlet weak var Email: UILabel!
    @IBOutlet weak var Accept: UIButton!
    @IBOutlet weak var Decline: UIButton!
    @IBOutlet weak var GoBack: UIButton!
    @IBOutlet weak var Komentiraj: UIButton!
    var Datumi = [NSDate]()
    var HostessIds = [String]()
    var statuses = [String]()
    var descriptions = [String]()
    
    @IBAction func LeaveComment(_ sender: Any) {
        performSegue(withIdentifier: "tablecomSeg", sender: nil)
    }
    
    @IBAction func konReviews(_ sender: Any) {
        performSegue(withIdentifier: "vidiReviewsSeg", sender: nil)
    }
    @IBAction func AcceptPressed(_ sender: Any) {
        let query = PFQuery(className: "Reservation")
        query.whereKey("from", equalTo: PFUser.current()?.objectId)
        query.whereKey("to", equalTo: HostessId)
        query.whereKey("description", equalTo: opis)
        query.whereKey("date", equalTo: dateReq)
        query.whereKey("type", equalTo: tip)
        query.findObjectsInBackground { (objects, error) in
            if error != nil{
                print(error?.localizedDescription)
            }
            else if let obj = objects {
                for o in obj {
                    o["status"] = "scheduled"
                    o.saveInBackground()
                    self.displayAlert(title: "Success", message: "The reservation is scheduled")
                }
            }
        }
    }
    @IBAction func DeclinePressed(_ sender: Any) {
        let query = PFQuery(className: "Reservation")
        query.whereKey("from", equalTo: PFUser.current()?.objectId)
        query.whereKey("to", equalTo: HostessId)
        query.whereKey("description", equalTo: opis)
        query.whereKey("date", equalTo: dateReq)
        query.whereKey("type", equalTo: tip)
        query.findObjectsInBackground { (objects, error) in
            if error != nil{
                print(error?.localizedDescription)
            }
            else if let obj = objects {
                for o in obj {
                    o["status"] = "scheduled"
                    o.deleteInBackground()
                }
            }
        }
        if status == "active"{
            displayAlert(title: "Success", message: "The request has been cancelled")
        }
        else{
            displayAlert(title: "Success", message: "The offer has been rejected")
        }
    }
    @IBAction func GoBack(_ sender: Any) {
        performSegue(withIdentifier: "backSeg", sender: nil)
    }
    
    func displayAlert(title: String, message: String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle:.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        Opis.text = opis
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "dd/MM/yyyy HH:mm"
        let stringDate = dateformatter.string(from: dateReq as Date)
        DatumBaranje.text = stringDate
        Status.text = status
        let query = PFUser.query()
        query?.whereKey("objectId", equalTo: HostessId)
        query?.findObjectsInBackground(block: { (objects, error) in
            if error != nil {
                print(error?.localizedDescription)
            }
            else if let object = objects{
                for o in object {
                    if let hostess = o as? PFUser {
                        if let firstname = hostess["firstName"]{
                            if let lastname = hostess["lastName"]{
                                if let phoneNumber = hostess["phoneNumber"]{
                                    if let tip = hostess["reqSeat"]{
                                        if let email = hostess.username{
                                            self.ImePrezime.text = (firstname as! String) + " " + (lastname as! String)
                                            self.IzborSedenje.text=(tip as! String)
                                            self.Email.text = email
                                            self.Phone.text = (phoneNumber as! String)
                                        }
                                        
                                    }
                                }
                            }
                        }
                    }
                }
            }
        })
        if status == "active"{
            Accept.isHidden = true
            Decline.setTitle("CANCEL", for: .normal)
            Decline.isHidden = false
            Komentiraj.isHidden = true
            Reviews.isHidden = true
        }
        else if status == "pending"{
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "dd/MM/yyyy HH:mm"
            let stringDate = dateformatter.string(from: DatumPonuda as Date)
            DatumP.text = stringDate
            SedenjeP.text = TypeSeatRequested
            DatumP.isHidden = false
            SedenjeP.isHidden = false
            Decline.setTitle("REJECT", for: .normal)
            Decline.isHidden = false
            DateReserved.isHidden = true
            RezerviranoNa.isHidden = true
            Komentiraj.isHidden = true
            Reviews.isHidden = true
        }
        else if status == "scheduled"{
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "dd/MM/yyyy HH:mm"
            let stringDate = dateformatter.string(from: ReservatedFor as Date)
            RezerviranoNa.text = stringDate
            DatumP.isHidden = true
            DateReserved.isHidden = false
            Accept.isHidden = true
            Decline.isHidden = true
            RezerviranoNa.isHidden = false
            Komentiraj.isHidden = true
            Reviews.isHidden = true
        }
        else if status == "done"{
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "dd/MM/yyyy HH:mm"
            let stringDate = dateformatter.string(from: dateFinished as Date)
            RezerviranoNa.text = stringDate
            Accept.isHidden = true
            Decline.isHidden = true
            DateReserved.text = "Ended on:"
            DatumP.isHidden = true
            Komentiraj.isHidden = false
            Reviews.isHidden = false
        }
    }
    

  

}
