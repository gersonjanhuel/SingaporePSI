//
//  Response.swift
//  SingaporePSI
//
//  Created by Gerson Janhuel on 9/20/17.
//  Copyright © 2017 Gerson Janhuel. All rights reserved.
//

import Foundation
import SwiftyJSON

class Response: NSObject {
    var isSuccess: Bool
    var data: JSON
    var message: String
    
    init(isSuccess: Bool, data: JSON, message: String) {
        self.isSuccess = isSuccess
        self.data = data
        self.message = message
    }
}
