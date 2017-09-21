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
    @IBOutlet var viewModalContainer: UIView!
    @IBOutlet var buttonCloseModal: UIButton!
    
    var mapView: GMSMapView?
    var viewModal: ModalView!
    
    var latestPSI: [PSI] = []
    var latestUpdate: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.showMap()
        self.loadLatestPSI()
        
        self.viewInfoLastUpdated.isHidden = true
        self.viewModalContainer.isHidden = true
        self.buttonCloseModal.isHidden = true
        
        self.viewInfoLastUpdated.layer.cornerRadius = 5
    }
    
    func showMap() {
        GMSServices.provideAPIKey(Constants.GoogleMapAPI.key)
        
        let camera = GMSCameraPosition.camera(withLatitude: 1.35735, longitude: 103.82, zoom: 10.5) //center of singapore
        
        self.mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
        self.mapView?.delegate = self
        self.viewMap.addSubview(self.mapView!)
    }
    
    func loadLatestPSI() {
        LoadingIndicatorView.shared.showLoading(self.view)
        
        PSIManager.sharedInstance.getPSI() { (dataPSI, isSuccess, message) in
            if (isSuccess) {
                self.showPSI(dataPSI)
                
                let defaults = UserDefaults.standard
                if let lastUpdatedInfo = defaults.string(forKey: Constants.DefaultsKeys.keyLastUpdatedInfo) {
                    self.labelLatestUpdate.text = lastUpdatedInfo
                    self.viewInfoLastUpdated.isHidden = false
                    self.fadeOutLastUpdatedInfo()
                }
            } else {
                //request failed
                let alert = UIAlertController(title: "Upsss!", message: message, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            
            LoadingIndicatorView.shared.hideLoading()
        }
    }
    
    func showPSI(_ PSI: [PSI]) {
        for item in PSI {
            let markerCentral = GMSMarker()
            markerCentral.position = CLLocationCoordinate2DMake(item.latitude, item.longitude)
            markerCentral.iconView = MarkerView.shared.customMarkerViewWithPSI(item.psi)
            markerCentral.title = item.locationName.capitalized
            markerCentral.snippet = "PSI = \(item.psi)"
            markerCentral.map = self.mapView
        }
        
        self.latestPSI = PSI
    }
    
    func fadeOutLastUpdatedInfo() {
        self.viewInfoLastUpdated.alpha = 1.0
        UIView.animate(withDuration: 1.5, delay: 4.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.viewInfoLastUpdated.alpha = 0.0
        }, completion: nil)
    }
    
    @IBAction func buttonRefreshPressed(_ sender: Any) {
        self.mapView?.clear()
        self.mapView?.animate(to: GMSCameraPosition.camera(withLatitude: 1.35735, longitude: 103.82, zoom: 10.5))
        
        self.loadLatestPSI()
    }
    
    @IBAction func buttonShowListPressed(_ sender: Any) {
        self.viewModal = ModalView.instanceFromNib() as? ModalView
        self.viewModalContainer.isHidden = false
        self.viewModalContainer.addSubview(self.viewModal)
        
        self.viewModal.showModalWithDataPSI(self.latestPSI, lastUpdatedInfo: self.labelLatestUpdate.text!, frame: self.view.frame) {
            self.buttonCloseModal.isHidden = false
        }
    }
    
    @IBAction func buttonCloseModalPressed(_ sender: Any) {
        self.viewModal.hideModal(self.viewModal.frame) { 
            self.buttonCloseModal.isHidden = true
            self.viewModalContainer.isHidden = true
            self.viewModal.removeFromSuperview()
        }
    }
    
    // MARK: GMSMapViewDelegate
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        self.viewInfoLastUpdated.alpha = 1.0
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        self.fadeOutLastUpdatedInfo()
    }
    
}

