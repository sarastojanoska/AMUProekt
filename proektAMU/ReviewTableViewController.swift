//
//  ReviewTableViewController.swift
//  proektAMU
//
//  Created by Sara Stojanoska on 9/9/21.
//  Copyright © 2021 Sara Stojanoska. All rights reserved.
//

import UIKit
import Parse

class ReviewTableViewController: UITableViewController {
    
    var index = Int()
    var datumi = [NSDate]()
    var GuestIds = [String]()
    var Iminja = [String]()
    var Preziminja = [String]()
    var ocenki = [String]()
    var zetoni = [String]()

    @IBAction func Back(_ sender: Any) {
        performSegue(withIdentifier: "naZSeg", sender: nil)
    }
    @IBAction func AddReview(_ sender: Any) {
        performSegue(withIdentifier: "ddReviewSeg", sender: nil)
    }
    var refresher: UIRefreshControl = UIRefreshControl()
    override func viewDidLoad() {
        super.viewDidLoad()
        updateTable()
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresher.addTarget(self, action: #selector(ReviewTableViewController.updateTable), for: UIControl.Event.valueChanged)
        self.view.addSubview(refresher)
        
    }

    @objc func updateTable(){
        datumi.removeAll()
        GuestIds.removeAll()
        zetoni.removeAll()
        Iminja.removeAll()
        Preziminja.removeAll()
        ocenki.removeAll()
        
        let query = PFQuery(className: "Review")
        query.whereKey("from", equalTo: PFUser.current()?.objectId)
        query.addDescendingOrder("date")
        query.findObjectsInBackground { (objects, error) in
            if error != nil{
                print(error?.localizedDescription)
            } else if let object = objects {
                for obj in object {
                    if let datumrev = obj["date"]{
                        if let zeton = obj["zeton"]{
                            if let guestId = obj["to"]{
                                if let ocenka = obj["ocenka"]{
                                    self.datumi.append(datumrev as! NSDate)
                                    self.GuestIds.append(guestId as! String)
                                    self.zetoni.append(zeton as! String)
                                    self.ocenki.append(ocenka as! String)
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

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return datumi.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "keLija", for: indexPath)

        let GuestId = GuestIds[indexPath.row]
        let query = PFUser.query()
        query?.whereKey("objectId", equalTo: GuestId)
        query?.findObjectsInBackground(block: { (objects, error) in
            if error != nil {
                print(error?.localizedDescription)
            }else if let obj = objects{
                for o in obj{
                    if let Guest = o as? PFUser{
                        if let firstName = Guest["firstName"]{
                            if let lastName = Guest["lastName"]{
                                cell.textLabel?.text = (firstName as! String + " " + (lastName as! String))
                            }
                        }
                    }
                }
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd/MM/yyyy"
                let StringDate = dateFormatter.string(from: self.datumi[indexPath.row] as! Date)
                cell.detailTextLabel?.text = StringDate
                let zeton = self.zetoni[indexPath.row]
                if zeton == "zelen" {
                    cell.backgroundColor = UIColor.green
                }
                else if zeton == "crven"{
                    cell.backgroundColor = UIColor.red
                }
            }
        })

        return cell
    }
    

   override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        index = (tableView.indexPathForSelectedRow?.row)!
        performSegue(withIdentifier: "konReviewSeg", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "konReviewSeg"{
            let destinationVC = segue.destination as! ReviewDetailsViewController
            destinationVC.GuestId = GuestIds[index]
            destinationVC.zeton = zetoni[index]
            destinationVC.ocenka = ocenki[index]
            destinationVC.date = datumi[index]
        }
        else if segue.identifier == "addReviewSeg"{
            let destinationVC = segue.destination as! AddReviewViewController
            destinationVC.Ime = Iminja[index]
            destinationVC.Prezime = Preziminja[index]
        }
    }

}
