//
//  ReviewTableViewController.swift
//  proektAMU
//
//  Created by Sara Stojanoska on 9/9/21.
//  Copyright © 2021 Sara Stojanoska. All rights reserved.
//

import UIKit

class ReviewTableViewController: UITableViewController {
    
    var index = Int()
    var datumi = [NSDate]()
    var HostessIds = [String]()
    var Iminja = [String]()
    var Preziminja = [String]()
    var Komentari = [String]()
    var statusi = [String]()

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
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
