//
//  SingaporePSITests.swift
//  SingaporePSITests
//
//  Created by Gerson Janhuel on 9/18/17.
//  Copyright © 2017 Gerson Janhuel. All rights reserved.
//

import XCTest
@testable import SingaporePSI

class SingaporePSITests: XCTestCase {
    
    
    func testExpectedValuePSIModel() {
        let psi:PSI = PSI(locationName: "Bandung", latitude: -6.917500, longitude: 107.618120, psi: 30)
        
        XCTAssertEqual(psi.locationName, "Bandung")
        XCTAssertEqual(psi.latitude, -6.917500)
        XCTAssertEqual(psi.longitude, 107.618120)
        XCTAssertEqual(psi.psi, 30)
    }
    
}
