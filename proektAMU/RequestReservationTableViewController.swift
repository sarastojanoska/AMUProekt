//
//  RequestReservationTableViewController.swift
//  proektAMU
//
//  Created by Sara Stojanoska on 8/28/21.
//  Copyright © 2021 Sara Stojanoska. All rights reserved.
//

import UIKit
import Parse

class RequestReservationTableViewController: UITableViewController {
    
    var index = Int()
    var Datumi = [NSDate]()
    var HostessIds = [String]()
    var statuses = [String]()
    var descriptions = [String]()
    var dateRequested = [NSDate]()
    var typeSeatRequested = [String]()
    var typeSeat = [String]()
    var finishdate = [NSDate?]()
    
    var refresher: UIRefreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateTable()
       refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresher.addTarget(self, action: #selector(RequestReservationTableViewController.updateTable), for: UIControl.Event.valueChanged)
        self.view.addSubview(refresher)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return Datumi.count
    }
    
    @objc func updateTable(){
        Datumi.removeAll()
        HostessIds.removeAll()
        statuses.removeAll()
        descriptions.removeAll()
        dateRequested.removeAll()
        typeSeatRequested.removeAll()
        typeSeat.removeAll()
        finishdate.removeAll()
        
        let query = PFQuery(className: "Reservation")
        query.whereKey("from", equalTo: PFUser.current()?.objectId)
        query.addDescendingOrder("date")
        query.findObjectsInBackground { (objects, error)
            in
            if error != nil{
                print(error?.localizedDescription)
            }else if let object = objects {
                for obj in object{
                    if let datum = obj["date"]{
                        if let status = obj["status"]{
                            if let HostessId = obj["to"]{
                                if let desc = obj["description"]{
                                    if let tip = obj["type"]{
                                        self.Datumi.append(datum as! NSDate)
                                        self.HostessIds.append(HostessId as! String)
                                        self.statuses.append(status as! String)
                                        self.descriptions.append(desc as! String)
                                        self.typeSeat.append(tip as! String)
                                        if let DateTime = obj["DateTime"]{
                                            if let TypeSeatRequested = obj["SeatRequested"]{
                                                self.dateRequested.append(DateTime as! NSDate)
                                                self.typeSeatRequested.append(TypeSeatRequested as! String)
                                            }
                                        }
                                    }
                                    else{
                                        self.dateRequested.append(NSDate())
                                        
                                    }
                                    if let fDate = obj["finishDate"]{
                                        self.finishdate.append(fDate as! NSDate)
                                    }
                                    else{
                                        self.finishdate.append(nil)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            self.refresher.endRefreshing()
            self.tableView.reloadData()
            
        }
       
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        let HostessId = HostessIds[indexPath.row]
        let query = PFUser.query()
        query?.whereKey("objectId", equalTo: HostessId)
        query?.findObjectsInBackground(block: { (objects, error) in
            if error != nil {
                print(error?.localizedDescription)
            }
            else if let obj = objects{
                for o in obj{
                    if let Hostess = o as? PFUser{
                        if let firstName = Hostess["firstname"]{
                            if let lastname = Hostess["lastname"]{
                                cell.textLabel?.text = (firstName as! String) + " " + (lastname as! String)
                            }
                        }
                    }
                }
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd/MM/yyyy"
                let StringDate = dateFormatter.string(from: self.Datumi[indexPath.row] as Date)
                cell.detailTextLabel?.text = StringDate
                let status = self.statuses[indexPath.row]
                if status == "active" {
                    cell.backgroundColor = UIColor.yellow
                }
                else if status == "pending"{
                    cell.backgroundColor = UIColor.red
                }
                else if status == "scheduled"{
                    cell.backgroundColor = UIColor.blue
                }
                else if status == "done"{
                    cell.backgroundColor = UIColor.green
                }
            }
        })

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        index = (tableView.indexPathForSelectedRow?.row)!
        performSegue(withIdentifier: "RequestDetailsSeg", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "RequestDetailsSeg"{
            let destinationVC = segue.destination as! RequestDetailsViewController
            destinationVC.HostessId = HostessIds[index]
            destinationVC.opis = descriptions[index]
            destinationVC.dateReq = Datumi[index]
            destinationVC.status = statuses[index]
            destinationVC.tip = typeSeat[index]
            if statuses[index] == "pending"{
                destinationVC.DatumPonuda = dateRequested[index]
                destinationVC.TypeSeatRequested = typeSeatRequested[index]
            }
            else if statuses[index] == "scheduled"{
                destinationVC.DatumPonuda = dateRequested[index]
            }
            else if statuses[index] == "done" {
                destinationVC.dateFinished = finishdate[index]!
            }
        }
    }
}
