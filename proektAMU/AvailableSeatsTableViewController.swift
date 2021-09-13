//
//  AvailableSeatsTableViewController.swift
//  proektAMU
//
//  Created by Sara Stojanoska on 8/28/21.
//  Copyright © 2021 Sara Stojanoska. All rights reserved.
//

import UIKit
import Parse

class AvailableSeatsTableViewController: UITableViewController {
    
    var seats = [String]()
    var Iminja = [String]()
    var Preziminja = [String]()
    var opis = String()
    var lokacija = String()
    var lon = Double()
    var lat = Double()
    var tip = String()
    var date = NSDate()
    var HostessId = [String]()
    var index = Int()
    
    @IBAction func Back(_ sender: Any) {
        performSegue(withIdentifier: "ciaoAmore", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Iminja.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        HostessId.removeAll()
        let cell = tableView.dequeueReusableCell(withIdentifier: "Kelija", for: indexPath)
        cell.textLabel?.text = Iminja[indexPath.row] + " " + Preziminja[indexPath.row]
        
        let MyLoc = CLLocation(latitude: lat, longitude: lon)
        let firstname = Iminja[indexPath.row]
        let lastname = Preziminja[indexPath.row]
        let type = seats[indexPath.row]
        // Configure the cell...
        
        let HostessQuery = PFUser.query()
        HostessQuery?.whereKey("userType", equalTo: "Hostess")
        HostessQuery?.whereKey("firstName", equalTo: firstname)
        HostessQuery?.whereKey("lastName", equalTo: lastname)
        HostessQuery?.whereKey("reqSeat", equalTo: type)
        
        HostessQuery?.findObjectsInBackground(block: { (objects, error) in
            if error != nil {
                print(error?.localizedDescription)
            }
            else if let hostesses = objects {
                for object in hostesses{
                    if let hostess = object as? PFUser{
                        if let objectId = hostess.objectId{
                            if let currentLat = hostess["currentLat"]{
                                if let currentLong = hostess["currentLon"]{
                                    let HostessLocation = CLLocation(latitude: currentLat as! Double, longitude: currentLong as! Double)
                                    let distance = HostessLocation.distance(from: MyLoc) / 1000
                                    let roundedDistance = round(distance * 100) / 100
                                    cell.detailTextLabel?.text = "\(roundedDistance) km away"
                                    let query = PFQuery(className: "Reservation")
                                    query.whereKey("from", equalTo: PFUser.current()?.objectId)
                                    query.whereKey("to", equalTo: objectId)
                                    query.whereKey("status", equalTo: "active")
                                    query.findObjectsInBackground(block: { (objects, error) in
                                        if error != nil{
                                            print(error?.localizedDescription)
                                        }
                                        else if let object = objects {
                                            if object.count > 0 {
                                                cell.accessoryType = UITableViewCell.AccessoryType.checkmark
                                            }
                                        }
                                    })
                                }
                            }
                        }
                    }
                }
            }
        })
        return cell
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        index = indexPath.row
        performSegue(withIdentifier: "ReqSeatSeg", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ReqSeatSeg"{
            let destinationVC = segue .destination as! AvailableSeatRequestViewController
            destinationVC.lokacija = lokacija
            destinationVC.opis = opis
            destinationVC.lat = lat
            destinationVC.lon = lon
            destinationVC.ime = Iminja[index]
            destinationVC.prezime = Preziminja[index]
            destinationVC.Tip = seats[index]
            destinationVC.date = date
        }
    }

}
