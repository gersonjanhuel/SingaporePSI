//
//  APIManager.swift
//  SingaporePSI
//
//  Created by Gerson Janhuel on 9/20/17.
//  Copyright © 2017 Gerson Janhuel. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class APIManager: NSObject {
    
    static let sharedInstance = APIManager()
    
    func request(endpointURL: String, params: Parameters?, completion: @escaping (Response) -> ()) {
        Alamofire.request(URL(string: Constants.ServiceAPI.url + endpointURL)!, method: HTTPMethod.get, parameters: params, encoding: URLEncoding.default, headers:Constants.ServiceAPI.headers).responseJSON { (response) in
            switch response.result {
            case .success(let responseData):
                let data = JSON(responseData)
                let dataJSON = JSON(["data":data])
                let successResponse = Response(isSuccess: true, data: dataJSON, message: "Request success")
                completion(successResponse)
            case .failure(let error):
                let emptyJSON = JSON(["data":[]])
                let failureResponse = Response(isSuccess: false, data: emptyJSON, message: "Request failed with error: \(error)")
                completion(failureResponse)
            }
        }
    }
    
}
