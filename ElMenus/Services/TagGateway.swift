
//
//  Created by MAC on 1/31/19.
//  Copyright © 2019 Dalia Hosny. All rights reserved.
//
import Foundation

enum ResponceStatus {
    case success
    case fail
    case unathorize
    case noConnection
    case serverError
    case parsingError
}

protocol TagGateway {
    func getTags(In page: Int, completion: @escaping (_ responce : [Tag],_ message : String,_ status : ResponceStatus) -> ())
    func getItems(By tagName: String, completion: @escaping (_ responce : [Item],_ message : String,_ status : ResponceStatus) -> ())
    func getItemData(By id: Int, completion: @escaping (_ responce : Item,_ message : String,_ status : ResponceStatus) -> ())
}

class TagGatewayImp: TagGateway {

    let apiClient: APIClient
    let localStorage: LocalDataManagerProtocol
    
    init(apiClient: APIClient = APIClientImp(), localStorage: LocalDataManagerProtocol = RealmLocalDataManager()) {
    
        self.apiClient = apiClient
        self.localStorage = localStorage
    }
    
    func getTags(In page: Int,completion: @escaping ([Tag], String, ResponceStatus) -> ()) {
        
        let apiURL = "/tags/\(page)"
        //let parameter = "\(page)"
        apiClient.getApiRequest(apiURL: apiURL, withParameter: ""){
            (responce, status, msg) in
            switch status {
            case .success:
                //print(responce!)
                if let result = responce as? [String:Any] {
                    var tags = [Tag]()
                    if let tagsArray = result["tags"] as? [[String:Any]]{
                        for dic in tagsArray{
                            let value = Tag.fromDictionary(dictionary: dic)
                            tags.append(value)
                        }
                        completion(tags, msg, .success)
                    }else{
                       completion([], NSLocalizedString("Parsing Error", comment: ""), .parsingError)
                    }
                    
                }else{
                   completion([], NSLocalizedString("Parsing Error", comment: ""), .parsingError)
                }
        
            default:
                completion([], msg , status)
            }
        }
    }
    
    func getItems(By tagName: String, completion: @escaping ([Item], String, ResponceStatus) -> ()) {
        let apiURL = "/items/\(tagName)"
        //let parameter = "\(page)"
        apiClient.getApiRequest(apiURL: apiURL, withParameter: ""){
            (responce, status, msg) in
            switch status {
            case .success:
                //print(responce!)
                if let result = responce as? [String:Any] {
                    var items = [Item]()
                    if let itemsArray = result["items"] as? [[String:Any]]{
                        for dic in itemsArray{
                            let value = Item.fromDictionary(dictionary: dic, tagName: tagName)
                            items.append(value)
                        }
                        completion(items, msg, .success)
                    }else{
                        completion([], NSLocalizedString("Parsing Error", comment: ""), .parsingError)
                    }
                    
                }else{
                    completion([], NSLocalizedString("Parsing Error", comment: ""), .parsingError)
                }
                
            default:
                completion([], msg , status)
            }
        }
    }
    
    func getItemData(By id: Int, completion: @escaping (Item, String, ResponceStatus) -> ()) {
        
    }
}
