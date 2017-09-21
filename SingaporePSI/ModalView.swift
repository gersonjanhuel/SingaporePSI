//
//  ModalView.swift
//  SingaporePSI
//
//  Created by Gerson Janhuel on 9/21/17.
//  Copyright © 2017 Gerson Janhuel. All rights reserved.
//

import UIKit

class ModalView: UIView {
    
    @IBOutlet var modalContainer: UIView!
    @IBOutlet var viewBlur: UIView!
    @IBOutlet var labelEast: UILabel!
    @IBOutlet var labelWest: UILabel!
    @IBOutlet var labelCentral: UILabel!
    @IBOutlet var labelSouth: UILabel!
    @IBOutlet var labelNorth: UILabel!
    @IBOutlet var labelLastUpdated: UILabel!
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "Modal", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
    
    func showModalWithDataPSI(_ psi: [PSI], lastUpdatedInfo: String, frame: CGRect, completion: @escaping () -> Void) {
        self.modalContainer.layer.cornerRadius = 5
        
        self.labelLastUpdated.text = lastUpdatedInfo
        for item in psi {
            if (item.locationName == "east") {
                self.labelEast.text = "\(item.psi)"
            } else if (item.locationName == "west") {
                self.labelWest.text = "\(item.psi)"
            } else if (item.locationName == "central") {
                self.labelCentral.text = "\(item.psi)"
            } else if (item.locationName == "south") {
                self.labelSouth.text = "\(item.psi)"
            } else if (item.locationName == "north") {
                self.labelNorth.text = "\(item.psi)"
            }
        }
        
        self.frame = CGRect(x: frame.origin.x, y: frame.origin.y+500, width: frame.size.width, height: frame.size.height)
        
        UIView.animate(withDuration: 0.3, delay: 0.1, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            self.frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.size.width, height: frame.size.height)
        }, completion: { (Bool) in
            let blurEffect = UIBlurEffect(style: .dark)
            let blurredEffectView = UIVisualEffectView(effect: blurEffect)
            blurredEffectView.frame = self.bounds
            self.viewBlur.addSubview(blurredEffectView)
            
            completion()
        })
    }
    
    func hideModal(_ frame: CGRect, completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0.3, delay: 0.1, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            self.modalContainer.frame = CGRect(x: self.modalContainer.frame.origin.x, y: self.modalContainer.frame.origin.y+500, width: self.modalContainer.frame.size.width, height: self.modalContainer.frame.size.height)
        }, completion: { (Bool) in
            self.viewBlur.subviews.forEach({ $0.removeFromSuperview() })
            completion()
        })
    }
    
}
