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
    @IBOutlet var viewMap: UIView!
    @IBOutlet var labelLatestUpdate: UILabel!
    @IBOutlet var viewInfoLastUpdated: UIView!
    @IBOutlet var loadingIndicator: UIActivityIndicatorView!
    
    var mapView:GMSMapView?    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.showMap()
        self.loadLatestPSI()
        
        self.viewInfoLastUpdated.layer.cornerRadius = 2
        self.viewInfoLastUpdated.isHidden = true
    }
    
    func showMap() {
        GMSServices.provideAPIKey(Constants.GoogleMapAPI.key)
        
        let camera = GMSCameraPosition.camera(withLatitude: 1.35735, longitude: 103.82, zoom: 10.5) //center of singapore
        
        self.mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)        
        
        self.viewMap.addSubview(self.mapView!)
    }
    
    func loadLatestPSI() {
        self.loadingIndicator.isHidden = false
        
        PSIManager.sharedInstance.getPSI() { (dataPSI, isSuccess, message) in
            if (isSuccess) {
                self.showPSI(dataPSI)
                
                let defaults = UserDefaults.standard
                if let lastUpdatedInfo = defaults.string(forKey: Constants.DefaultsKeys.keyLastUpdatedInfo) {
                    self.labelLatestUpdate.text = lastUpdatedInfo
                    
                    self.viewInfoLastUpdated.isHidden = false
                    self.viewInfoLastUpdated.alpha = 1.0
                }
            } else {
                //request failed, should do something about it
                print("Alert this: \(message)")
            }
            
            self.loadingIndicator.isHidden = true
        }
    }
    
    func showPSI(_ PSI: [PSI]) {
        for item in PSI {
            let markerCentral = GMSMarker()
            markerCentral.position = CLLocationCoordinate2DMake(item.latitude, item.longitude)
            markerCentral.title = item.locationName.capitalized
            markerCentral.snippet = "PSI = \(item.psi)"
            markerCentral.map = self.mapView
        }
    }
    
    
}

