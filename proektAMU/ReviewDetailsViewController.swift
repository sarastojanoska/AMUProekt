//
//  ReviewDetailsViewController.swift
//  proektAMU
//
//  Created by Sara Stojanoska on 9/10/21.
//  Copyright © 2021 Sara Stojanoska. All rights reserved.
//

import UIKit
import Parse

class ReviewDetailsViewController: UIViewController {
    
    var GuestId = String()
    var zeton = String()
    var ocenka = String()
    var date = NSDate()
    
    @IBOutlet weak var ImePrezime: UILabel!
    @IBOutlet weak var Datum: UILabel!
    @IBOutlet weak var Zeton: UILabel!
    @IBOutlet weak var Ocenka: UILabel!
    
    var dates = [NSDate]()
    var GuestIds = [String]()
    var zetoni = [String]()
    var ocenki = [String]()

    @IBAction func Back(_ sender: Any) {
        performSegue(withIdentifier: "vratiSeg", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Ocenka.text = ocenka
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "dd/MM/yyyy"
        let StringDate = dateformatter.string(from: date as! Date)
        Datum.text = StringDate
        Zeton.text = zeton
        let query = PFUser.query()
        query?.whereKey("objectId", equalTo: GuestId)
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
