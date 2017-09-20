//
//  PSI.swift
//  SingaporePSI
//
//  Created by Gerson Janhuel on 9/20/17.
//  Copyright © 2017 Gerson Janhuel. All rights reserved.
//

import Foundation

class PSI {
    var locationName: String
    var latitude: Double
    var longitude: Double
    var psi: Int
    
    init(locationName: String, latitude: Double, longitude: Double, psi: Int) {
        self.locationName = locationName
        self.latitude = latitude
        self.longitude = longitude
        self.psi = psi
    }
}
