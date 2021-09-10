//
//  GuestCommentsDetailViewController.swift
//  proektAMU
//
//  Created by Sara Stojanoska on 9/9/21.
//  Copyright © 2021 Sara Stojanoska. All rights reserved.
//

import UIKit
import Parse

class GuestCommentsDetailViewController: UIViewController {
    
    var datum = NSDate()
    var status = String()
    var Ime = String()
    var Prezime = String()
    var komentar = String()
    var komId = String()

    
    @IBOutlet weak var Comment: UILabel!
    @IBOutlet weak var Status: UILabel!
    @IBOutlet weak var Datum: UILabel!
    @IBOutlet weak var Korisnik: UILabel!
    @IBAction func GoBack(_ sender: Any) {
        performSegue(withIdentifier: "nSeg", sender: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        Korisnik.text = Ime + " " + Prezime
        Status.text = status
        Comment.text = komentar
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm"
        let StringDate = formatter.string(from: datum as Date)
        Datum.text = StringDate
    }

}
