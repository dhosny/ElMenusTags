//
//  APIClient.swift
//
//  Created by MAC on 1/21/19.
//  Copyright © 2019 Dalia Hosny. All rights reserved.
//

import Foundation
import Alamofire

protocol APIClient {
    func getApiRequest(apiURL: String, withParameter parameter: String,  completion: @escaping  ( _ success: Bool, _ responce: [String: Any]?, _ error: APIError? ) -> ())
}

class APIClientImp: APIClient {
    
    func getApiRequest(apiURL: String, withParameter parameter: String = "",  completion: @escaping ( _ success: Bool, _ responce: [String: Any]?, _ error: APIError?) -> ()) {
        
        var urlString = "\(Config.sharedInstance.baseUrl!)\(apiURL)"
        if parameter != "" {
            urlString = "\(urlString)?\(parameter)"
        }
        print(urlString)
        
        let escapedAddress = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        
        let method: HTTPMethod = .get
        Alamofire.request(escapedAddress!, method: method, parameters: nil,encoding: JSONEncoding.default).responseJSON {
            response in
                switch response.result {
                case .success:
                    let statusCode = response.response?.statusCode
                    print(statusCode!)
                    if statusCode == 200 {
                        if let JSON = response.result.value {
                            //print(JSON)
                            completion(true, JSON as? [String : Any], nil)
                        }
                    }else{
                        completion(false, nil, .serverOverload )
                    }
                    break
                case.failure(let error):
                    print(error)
                    completion(false, nil, .serverOverload )
                    break
                }
        }
    }
    
}
