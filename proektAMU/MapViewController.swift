//
//  MapViewController.swift
//  proektAMU
//
//  Created by Sara Stojanoska on 9/5/21.
//  Copyright © 2021 Sara Stojanoska. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    var lat = Double()
    var long = Double()
    var lokacija = String()
    
    @IBAction func nazad(_ sender: Any) {
        performSegue(withIdentifier: "rikvercSeg", sender: nil)
    }
    @IBOutlet weak var Mapa: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta:  0.05)
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        self.Mapa.setRegion(region, animated: true)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = lokacija
        self.Mapa.addAnnotation(annotation)
    }
    

    

}
