//
//  HostessReviewDetailsViewController.swift
//  proektAMU
//
//  Created by Sara Stojanoska on 9/10/21.
//  Copyright © 2021 Sara Stojanoska. All rights reserved.
//

import UIKit

class HostessReviewDetailsViewController: UIViewController {
    
    var datum = NSDate()
    var zeton = String()
    var Ime = String()
    var Prezime = String()
    var ocenka = String()
    var revId = String()
    
    @IBOutlet weak var Ocenka: UILabel!
    @IBOutlet weak var Zeton: UILabel!
    @IBOutlet weak var Datum: UILabel!
    @IBOutlet weak var Korisnik: UILabel!
    @IBAction func Back(_ sender: Any) {
        performSegue(withIdentifier: "caoSeg", sender: nil)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        Korisnik.text = Ime + " " + Prezime
        Zeton.text = zeton
        Ocenka.text = ocenka
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm"
        let StringDate = formatter.string(from: datum as Date)
        Datum.text = StringDate
    }
    

   

}
