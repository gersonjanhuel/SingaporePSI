//
//  ViewController.swift
//  SingaporePSI
//
//  Created by Gerson Janhuel on 9/18/17.
//  Copyright © 2017 Gerson Janhuel. All rights reserved.
//

import UIKit
import GoogleMaps

class ViewController: UIViewController {

    var mapView:GMSMapView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.showMap()
    }

    func showMap() {
        GMSServices.provideAPIKey(Constants.GoogleMapAPI.key)
        
        let camera = GMSCameraPosition.camera(withLatitude: 1.35735, longitude: 103.82, zoom: 10.5) //center of singapore
        
        self.mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
        
        self.view = self.mapView
    }
    
}

