//
//  CommentDetailsViewController.swift
//  proektAMU
//
//  Created by Sara Stojanoska on 9/8/21.
//  Copyright © 2021 Sara Stojanoska. All rights reserved.
//

import UIKit
import Parse

class CommentDetailsViewController: UIViewController {
    
    var HostessId = String()
    var status = String()
    var komentar = String()
    var date = NSDate()
    
    @IBOutlet weak var ImePrezime: UILabel!
    @IBOutlet weak var Datum: UILabel!
    @IBOutlet weak var Status: UILabel!
    @IBOutlet weak var Komentar: UILabel!
    @IBOutlet weak var Slika: UIImageView!
    var dates = [NSDate]()
    var HostessIds = [String]()
    var statuses = [String]()
    var comments = [String]()

    @IBAction func Back(_ sender: Any) {
        performSegue(withIdentifier: "nzdSeg", sender: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        Komentar.text = komentar
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "dd/MM/yyyy"
        let StringDate = dateformatter.string(from: date as! Date)
        Datum.text = StringDate
        Status.text = status
        let query = PFUser.query()
        query?.whereKey("objectId", equalTo: HostessId)
        query?.findObjectsInBackground(block: { (objects, error) in
            if error != nil{
                print(error?.localizedDescription)
            }
            else if let object = objects{
                for o in object{
                    if let host = o as? PFUser {
                        if let firstName = host["firstName"]{
                            if let lastName = host["lastName"]{
                                self.ImePrezime.text = (firstName as! String) + " " + (lastName as! String)
                            }
                        }
                    }
                }
            }
        })
    }
    

}
