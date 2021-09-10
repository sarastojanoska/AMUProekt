//
//  CommentsTableViewController.swift
//  proektAMU
//
//  Created by Sara Stojanoska on 9/8/21.
//  Copyright © 2021 Sara Stojanoska. All rights reserved.
//

import UIKit
import Parse

class CommentsTableViewController: UITableViewController {
    
    var index = Int()
    var datumi = [NSDate]()
    var HostessIds = [String]()
    var Iminja = [String]()
    var Preziminja = [String]()
    var Komentari = [String]()
    var statusi = [String]()
    
    @IBAction func GoBack(_ sender: Any) {
        performSegue(withIdentifier: "nazSeg", sender: nil)
    }
    @IBAction func AddComment(_ sender: Any) {
        performSegue(withIdentifier: "addComSeg", sender: nil)
    }
    
    var refresher: UIRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateTable()
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresher.addTarget(self, action: #selector(CommentsTableViewController.updateTable), for: UIControl.Event.valueChanged)
        self.view.addSubview(refresher)
    }

    @objc func updateTable(){
        datumi.removeAll()
        HostessIds.removeAll()
        statusi.removeAll()
        Iminja.removeAll()
        Preziminja.removeAll()
        Komentari.removeAll()
        
        let query = PFQuery(className: "Comment")
        query.whereKey("from", equalTo: PFUser.current()?.objectId)
        query.addDescendingOrder("date")
        query.findObjectsInBackground { (objects, error) in
            if error != nil{
                print(error?.localizedDescription)
            } else if let object = objects {
                for obj in object {
                    if let datumKom = obj["date"]{
                        if let status = obj["status"]{
                            if let hostessId = obj["to"]{
                                if let kom = obj["komentar"]{
                                    self.datumi.append(datumKom as! NSDate)
                                    self.HostessIds.append(hostessId as! String)
                                    self.statusi.append(status as! String)
                                    self.Komentari.append(kom as! String)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "mycell", for: indexPath)

        let HostessId = HostessIds[indexPath.row]
        let query = PFUser.query()
        query?.whereKey("objectId", equalTo: HostessId)
        query?.findObjectsInBackground(block: { (objects, error) in
            if error != nil {
                print(error?.localizedDescription)
            }else if let obj = objects{
                for o in obj{
                    if let Hostess = o as? PFUser{
                        if let firstName = Hostess["firstName"]{
                            if let lastName = Hostess["lastName"]{
                                cell.textLabel?.text = (firstName as! String + " " + (lastName as! String))
                            }
                        }
                    }
                }
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd/MM/yyyy"
                let StringDate = dateFormatter.string(from: self.datumi[indexPath.row] as! Date)
                cell.detailTextLabel?.text = StringDate
                let status = self.statusi[indexPath.row]
                if status == "pozitivno" {
                    cell.backgroundColor = UIColor.green
                }
                else if status == "negativno"{
                    cell.backgroundColor = UIColor.red
                }
            }
        })
        return cell
    }
 

   override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        index = (tableView.indexPathForSelectedRow?.row)!
        performSegue(withIdentifier: "comDetailSeg", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "comDetailSeg"{
            let destinationVC = segue.destination as! CommentDetailsViewController
            destinationVC.HostessId = HostessIds[index]
            destinationVC.status = statusi[index]
            destinationVC.komentar = Komentari[index]
            destinationVC.date = datumi[index]
        }
        else if segue.identifier == "addComSeg" {
            let destinationVC = segue.destination as! AddCommentViewController
            destinationVC.Ime = Iminja[index]
            destinationVC.Prezime = Preziminja[index]
        }
    }
}
