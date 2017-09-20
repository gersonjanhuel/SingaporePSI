//
//  PSIManager.swift
//  SingaporePSI
//
//  Created by Gerson Janhuel on 9/20/17.
//  Copyright © 2017 Gerson Janhuel. All rights reserved.
//

import UIKit
import Foundation
import SwiftyJSON

enum ServiceEndpoints {
    static let ENVIRONMENT_PSI = "/environment/psi"
}

class PSIManager: NSObject {
    static let sharedInstance = PSIManager()
    let API: APIManager = APIManager.sharedInstance
    
    //get data PSI
    func getPSI(_ dateTime: String? = nil, completion: @escaping (_ dataPSI: [PSI], _ isSuccess: Bool, _ message: String) -> ()) {
        
        var params = [String: Any]()
        if ((dateTime) != nil) {
            params = ["date_time":dateTime!]
        }
        
        API.request(endpointURL: ServiceEndpoints.ENVIRONMENT_PSI, params: params) { (response: Response) in
            if (response.isSuccess) {
                
                let dataJSON = response.data["data"]
                
                if (dataJSON.count > 0) {
                    var dataPSI:[PSI] = [PSI]() //init
                    
                    let regions = dataJSON["region_metadata"]
                    
                    for (_,region):(String, JSON) in regions {
                        
                        if region["name"].string! == "national" {
                            continue //skip region "national"
                        }
                        
                        let psiIndex:Int = dataJSON["items"][0]["readings"]["psi_twenty_four_hourly"][region["name"].string!].int!
                        
                        let psi: PSI = PSI(locationName: region["name"].string!, latitude: region["label_location"]["latitude"].double!, longitude: region["label_location"]["longitude"].double!, psi: psiIndex)
                        
                        dataPSI.append(psi)
                    }
                    
                    // save/update last updated info to local
                    let defaults = UserDefaults.standard
                    defaults.set("Last updated \(dataJSON["items"][0]["update_timestamp"])", forKey: Constants.DefaultsKeys.keyLastUpdatedInfo)
                    
                    completion(dataPSI, response.isSuccess, response.message)
                } else {
                    // data empty
                    completion([PSI](), false, "Empty PSI Data")
                }
            } else {
                // request failed
                completion([PSI](), response.isSuccess, response.message)
            }
        }
    }
}
