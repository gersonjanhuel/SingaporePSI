//
//  ViewController.swift
//  SingaporePSI
//
//  Created by Gerson Janhuel on 9/18/17.
//  Copyright © 2017 Gerson Janhuel. All rights reserved.
//

import UIKit
import GoogleMaps

class ViewController: UIViewController, GMSMapViewDelegate {
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
        self.mapView?.delegate = self
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
                    self.fadeOutLastUpdatedInfo()
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
            markerCentral.iconView = self.customMarkerView(item.psi);
            markerCentral.title = item.locationName.capitalized
            markerCentral.snippet = "PSI = \(item.psi)"
            markerCentral.map = self.mapView
        }
    }
    
    func customMarkerView(_ psi: Int) -> UIView {
        let markerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 42, height: 42))
        let pinImageView: UIImageView = UIImageView(image: UIImage(named: "marker_custom"))
        
        let label: UILabel = UILabel(frame: CGRect(x: 10, y: 7, width: 25, height: 20))
        label.text = "\(psi)"
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont(name: "Avenir-Medium", size: 18)
        label.textColor = UIColor.init(red: 78/225.0, green: 179/225.0, blue: 240/225.0, alpha: 1.0)
        
        pinImageView.addSubview(label)
        markerView.addSubview(pinImageView)
        
        return markerView
    }
    
    func fadeOutLastUpdatedInfo() {
        UIView.animate(withDuration: 1.5, delay: 4.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.viewInfoLastUpdated.alpha = 0.0
        }, completion: nil)
    }
    
    @IBAction func buttonRefreshPressed(_ sender: Any) {
        self.mapView?.clear()
        self.mapView?.animate(to: GMSCameraPosition.camera(withLatitude: 1.35735, longitude: 103.82, zoom: 10.5))
        
        //reload latest PSI data
        self.loadLatestPSI()
    }
    
    // MARK: GMSMapViewDelegate
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        self.viewInfoLastUpdated.alpha = 1.0
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        self.fadeOutLastUpdatedInfo()
    }
    
}

