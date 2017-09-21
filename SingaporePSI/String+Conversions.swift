//
//  String+Conversions.swift
//  SingaporePSI
//
//  Created by Gerson Janhuel on 9/21/17.
//  Copyright © 2017 Gerson Janhuel. All rights reserved.
//

import Foundation

extension String {
    
    func stringDateWithFormat(_ format: String, timezone: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssxxxxx"
        let dateObj = dateFormatter.date(from: self)
        
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone(abbreviation: timezone)
        
        return dateFormatter.string(from: dateObj!)
    }
     
}
