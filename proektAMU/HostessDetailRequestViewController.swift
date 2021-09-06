//
//  HostessDetailRequestViewController.swift
//  proektAMU
//
//  Created by Sara Stojanoska on 9/1/21.
//  Copyright © 2021 Sara Stojanoska. All rights reserved.
//

import UIKit
import Parse
import MapKit

class HostessDetailRequestViewController: UIViewController {
    
    var Ime = String()
    var Prezime = String()
    var datum = NSDate()
    var opis = String()
    var tip = String()
    var lokacija = String()
    var tel = String()
    var email = String()
    var lon = Double()
    var lat = Double()
    
    
    
    @IBAction func GoBack(_ sender: Any) {
        performSegue(withIdentifier: "nazadSeg", sender: nil)
    }
    @IBOutlet weak var requestDate: UILabel!
    @IBOutlet weak var Reservation: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var UserLabel: UILabel!
    @IBOutlet weak var userInfo: UILabel!
    @IBOutlet weak var TypeSeat: UITextField!
    @IBOutlet weak var DatePicker: UIDatePicker!
    
    @IBOutlet weak var Map: MKMapView!
    
    func displayAlert(title: String, message: String){
        let alertC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertC,animated: true, completion: nil)
    }
    
    @IBAction func SendOffer(_ sender: Any) {
        if TypeSeat.text == " "{
            displayAlert(title: "Invalid", message: "You must enter seat type")
        }
        else{
            let datePicked = DatePicker.date
            let typeSeat = TypeSeat.text
            let query = PFUser.query()
            query?.whereKey("firstName", equalTo: Ime)
            query?.whereKey("secondName", equalTo: Prezime)
            query?.whereKey("phoneNumber", equalTo: tel)
            query?.whereKey("username", equalTo: email)
            query?.findObjectsInBackground(block: { (users, error) in
                if error != nil {
                    print(error?.localizedDescription)
                }
                else if let user = users{
                    for u in user{
                        if let userId = u.objectId{
                            let Query = PFQuery(className: "Reservation")
                            Query.whereKey("from", equalTo: userId)
                            Query.whereKey("to", equalTo: PFUser.current()?.objectId)
                            Query.whereKey("description", equalTo: self.opis)
                            Query.whereKey("type", equalTo: self.tip)
                            Query.whereKey("date", equalTo: self.datum)
                            Query.whereKey("location", equalTo: self.lokacija)
                            Query.findObjectsInBackground(block: { (objects, error) in
                                if error != nil {
                                    print(error?.localizedDescription)
                                }
                                else if let object = objects{
                                    for obj in object {
                                        obj["status"] = "pending"
                                        obj["DateTime"] = datePicked
                                        obj["SeatRequested"] = typeSeat
                                        obj.saveInBackground()
                                    }
                                }
                            })
                        }
                    }
                }
            })
            displayAlert(title: "Successful", message: "You have sent your offer")
        }
    }
    @IBAction func DeclineOffer(_ sender: Any) {
        let query = PFUser.query()
        query?.whereKey("firstName", equalTo: Ime)
        query?.whereKey("secondName", equalTo: Prezime)
        query?.whereKey("phoneNumber", equalTo: tel)
        query?.whereKey("username", equalTo: email)
        query?.findObjectsInBackground(block: { (users, error) in
            if error != nil {
                print(error?.localizedDescription)
            }
            else if let user = users{
                for u in user{
                    if let userId = u.objectId{
                        let Query = PFQuery(className: "Reservation")
                        Query.whereKey("from", equalTo: userId)
                        Query.whereKey("to", equalTo: PFUser.current()?.objectId)
                        Query.whereKey("description", equalTo: self.opis)
                        Query.whereKey("type", equalTo: self.tip)
                        Query.whereKey("date", equalTo: self.datum)
                        Query.whereKey("location", equalTo: self.lokacija)
                        Query.findObjectsInBackground(block: { (objects, error) in
                            if error != nil {
                                print(error?.localizedDescription)
                            }
                            else if let object = objects{
                                for obj in object {
                                    obj.deleteInBackground()
                                }
                            }
                        })
                    }
                }
            }
        })
        displayAlert(title: "Successful", message: "You have declined this this request")
    
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Reservation.text = opis
        emailLabel.text = email
        phoneLabel.text = tel
        UserLabel.text = Ime + " " + Prezime
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let stringDate = dateFormatter.string(from: datum as! Date)
        requestDate.text = stringDate
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let coord = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        let region = MKCoordinateRegion(center: coord, span: span)
        self.Map.setRegion(region, animated: true)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coord
        annotation.title = lokacija
        self.Map.addAnnotation(annotation)
    }
    

   
}
