//
//  MarkerView.swift
//  SingaporePSI
//
//  Created by Gerson Janhuel on 9/21/17.
//  Copyright © 2017 Gerson Janhuel. All rights reserved.
//

import UIKit

class MarkerView {
    
    class var shared: MarkerView {
        struct Static {
            static let instance: MarkerView = MarkerView()
        }
        return Static.instance
    }
    
    func customMarkerViewWithPSI(_ psi: Int) -> UIView {
        let markerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 42, height: 42))
        let pinImageView: UIImageView = UIImageView(image: UIImage(named: "marker_custom"))
        
        let label: UILabel = UILabel(frame: CGRect(x: 10, y: 7, width: 25, height: 20))
        label.text = "\(psi)"
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont(name: "Avenir-Medium", size: 18)
        label.textColor = UIColor.init(hex: 0x4EB3F0, alpha: 1.0)
        
        pinImageView.addSubview(label)
        markerView.addSubview(pinImageView)
        
        return markerView
    }
    
}
