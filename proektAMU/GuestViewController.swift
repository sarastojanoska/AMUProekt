//
//  GuestViewController.swift
//  
//
//  Created by Sara Stojanoska on 8/26/21.
//

import UIKit
import MapKit
import CoreLocation
import Parse

class GuestViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    var seats = [String]()
    var firstnames = [String]()
    var lastnames = [String]()
    var place = String()
    var opis = String()
    var datumi = [NSDate]()
    var lat = Double()
    var long = Double()
    var Tip = String()
    var date = NSDate()
    
    var HostessIds = [String]()
    var statuses = [String]()
    var descriptions = [String]()
    
    
    @IBOutlet weak var ChoiceLabel: UILabel!
    @IBOutlet weak var Review: UIButton!
    @IBOutlet weak var TableSeat: UIButton!
    @IBOutlet weak var BarSeat: UIButton!
    @IBOutlet weak var ReserveText: UITextView!
    @IBOutlet weak var ReservationLabel: UILabel!
    @IBOutlet weak var Mapa: MKMapView!
    @IBOutlet weak var ChooseLocLabel: UILabel!
    
    
    var manager = CLLocationManager()
    var locationChosen = Bool()
    
    @IBAction func Logout(_ sender: Any) {
        PFUser.logOut()
        navigationController?.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func RequestReservation(_ sender: Any) {
        self.performSegue(withIdentifier: "RequestReservationSegue", sender: nil)
    }
    
    @IBAction func ChooseBarSeat(_ sender: Any) {
        TableSeat.isHidden = true
        ChoiceLabel.text = "Bar"
    }
    
    @IBAction func ChooseTableSeat(_ sender: Any) {
        BarSeat.isHidden = true
        ChoiceLabel.text = "Table"
    }
    @IBAction func ReviewAvailable(_ sender: Any) {
        if !locationChosen || ReserveText.text == "" || !(ChoiceLabel.text == "Bar" || ChoiceLabel.text == "Table"){
            DisplayAlert(title: "Not enough information", msg: "Please provide all the informations")
        }
        else{
            firstnames.removeAll()
            lastnames.removeAll()
            seats.removeAll()
            
            opis = ReserveText.text!
            if self.ChoiceLabel.text == "Bar"{
                self.Tip = "Bar"
            }
            else if self.ChoiceLabel.text == "Table"{
                self.Tip = "Table"
            }
            let query = PFUser.query()
         query?.whereKey("reqSeat", equalTo: Tip)
            query?.findObjectsInBackground(block: { (object, error) in
                if error != nil{
                    print(error?.localizedDescription)
                }
                else if let hostesses = object{
                    for o in hostesses{
                        if let  hostess = o as? PFUser{
                            if let firstname = hostess["firstname"]{
                                if let lastname = hostess["lastname"]{
                                    
                                        self.firstnames.append(firstname as! String)
                                        self.lastnames.append(lastname as! String)
                                    self.seats.append(self.Tip as! String)
                                    
                                }
                            }
                        }
                    }
                }
                 self.performSegue(withIdentifier: "AvailableSeatsSeg", sender: nil)
            })
            
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AvailableSeatsSeg"{
            let destinationVC = segue.destination as! AvailableSeatsTableViewController
            destinationVC.seats = seats
            destinationVC.Iminja = firstnames
            destinationVC.Preziminja = lastnames
            destinationVC.lokacija = place
            destinationVC.opis = opis
            destinationVC.lon = long
            destinationVC.lat = lat
            destinationVC.tip = Tip
            destinationVC.date = date
        }
    }

    

    
    
    func DisplayAlert(title: String, msg: String) {
        let alertCotnroller = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alertCotnroller.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertCotnroller,animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        ChoiceLabel.isHidden = true
        
        locationChosen = false
        
        let uilpgr = UILongPressGestureRecognizer(target: self, action: #selector(longpress(gestureRecognizer:)))
        uilpgr.minimumPressDuration = 1
        Mapa.addGestureRecognizer(uilpgr)
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // print("vlaga tukaa")
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta:  0.05)
        let region = MKCoordinateRegion(center: location, span: span)
        self.Mapa.setRegion(region, animated: true)
        // print("se izvrsi neso")
    }
    
    @objc func longpress(gestureRecognizer: UIGestureRecognizer) {
        //print("Go registrira longpressot")
        print("longpress")
        if !locationChosen{
            print("stisnato ee")
            if gestureRecognizer.state == UIGestureRecognizer.State.began {
                let touchPoint = gestureRecognizer.location(in: self.Mapa)
                let newCoordinate = self.Mapa.convert(touchPoint, toCoordinateFrom: self.Mapa)
                let newLocation = CLLocation(latitude: newCoordinate.latitude, longitude: newCoordinate.longitude)
                var title = ""
                CLGeocoder().reverseGeocodeLocation(newLocation, completionHandler:  { (placemarks, error) in
                    if error != nil {
                        print(error!)
                    }else{
                        if let placemark = placemarks?[0] {
                            if placemark.subThoroughfare != nil {
                                title += placemark.subThoroughfare! + " "
                            }
                            if placemark.thoroughfare != nil {
                                title += placemark.thoroughfare!
                            }
                        }
                        if title == "" {
                            title = "Added \(NSDate())"
                        }
                        
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = newCoordinate
                        annotation.title = title
                        self.Mapa.addAnnotation(annotation)
                        self.locationChosen = true
                        print(title)
                        
                    }
                })
            }
        }
    }
}
