//
//  APIClient.swift
//
//  Created by MAC on 1/21/19.
//  Copyright © 2019 Dalia Hosny. All rights reserved.
//

import Foundation
import Alamofire

protocol APIClient {
    func getApiRequest(apiURL: String, withParameter parameter: String,  completion: @escaping (_ responce : Any?, _ statue: ResponceStatus, _ message: String) -> ())
}

class APIClientImp: APIClient {
    
    func getApiRequest(apiURL: String, withParameter parameter: String = "",  completion: @escaping (_ responce : Any?, _ statue: ResponceStatus, _ message: String) -> ()) {
        
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
                            completion(JSON, .success, NSLocalizedString("Done", comment: ""))
                        }
                    }else{
                        completion(nil, .serverError, NSLocalizedString("Problem in Server please wait and try again later.", comment: "") )
                    }
                    break
                case.failure(let error):
                    print(error)
                    completion(nil, .serverError, NSLocalizedString("Problem in Server please wait and try again later.", comment: "") )
                    
                    break
                }
        }
    }
    
}
