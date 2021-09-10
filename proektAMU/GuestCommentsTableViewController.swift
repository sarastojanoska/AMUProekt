//
//  GuestCommentsTableViewController.swift
//  proektAMU
//
//  Created by Sara Stojanoska on 9/9/21.
//  Copyright © 2021 Sara Stojanoska. All rights reserved.
//

import UIKit
import Parse

class GuestCommentsTableViewController: UITableViewController {
    
    var datumi = [NSDate]()
    var statusi = [String]()
    var Iminja = [String]()
    var Preziminja = [String]()
    var komentari = [String]()
    var komIds = [String]()
    
    var refresher: UIRefreshControl = UIRefreshControl()

    @IBAction func GoBack(_ sender: Any) {
        performSegue(withIdentifier: "odinazadSeg", sender: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        updateTable()
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresher.addTarget(self, action: #selector(GuestCommentsTableViewController.updateTable), for: UIControl.Event.valueChanged)
        self.view.addSubview(refresher)
    }

    @objc func updateTable(){
        datumi.removeAll()
        Iminja.removeAll()
        Preziminja.removeAll()
        statusi.removeAll()
        komentari.removeAll()
        komIds.removeAll()
        
        let array = ["pozitivno", "negativno"]
        let predicate = NSPredicate(format: "status = %@ OR status = %@", argumentArray: array)
        let query = PFQuery(className: "Comment" , predicate: predicate)
        query.whereKey("to", equalTo: PFUser.current()?.objectId)
        query.addDescendingOrder("date")
        query.findObjectsInBackground { (objects, error) in
            if error != nil{
                print(error?.localizedDescription)
            }
            else if let object = objects {
                for obj in object {
                    if let date = obj["date"]{
                        if let status = obj["status"]{
                            if let kom = obj["komentar"]{
                                if let komId = obj.objectId{
                                    if let userId = obj["from"]{
                                        let userQuery = PFUser.query()
                                        userQuery?.whereKey("objectId", equalTo: userId)
                                        userQuery?.findObjectsInBackground(block: { (users, error) in
                                            if error != nil{
                                                print(error?.localizedDescription)
                                            }
                                            else if let user = users{
                                                for u in user{
                                                    if let u = u as? PFUser {
                                                        if let fname = u["firstName"]{
                                                            if let lname = u["lastName"]{
                                                                self.datumi.append(date as! NSDate)
                                                                self.statusi.append(status as! String)
                                                                self.komentari.append(kom as! String)
                                                                self.komIds.append(komId as! String)
                                                                self.Iminja.append(fname as! String)
                                                                self.Preziminja.append(lname as! String)
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                            self.refresher.endRefreshing()
                                            self.tableView.reloadData()
                                        })
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return statusi.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let StringDate = dateFormatter.string(from: self.datumi[indexPath.row] as! Date)
        cell.textLabel?.text = StringDate
        cell.detailTextLabel?.text = Iminja[indexPath.row] + " " + Preziminja[indexPath.row]
        if statusi[indexPath.row] == "pozitivno" {
            cell.backgroundColor = .green
        }
        else{
            cell.backgroundColor = .red
        }
        return cell
    }
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "comDetailSeg" {
            if let index = tableView.indexPathForSelectedRow?.row {
                let destVC = segue.destination as! GuestCommentsDetailViewController
                destVC.Ime = Iminja[index]
                destVC.Prezime = Preziminja[index]
                destVC.status = statusi[index]
                destVC.datum = datumi[index]
                destVC.komentar = komentari[index]
                destVC.komId = komIds[index]
            }
        }
    }

}
