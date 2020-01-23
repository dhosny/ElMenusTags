
//
//  Created by MAC on 1/31/19.
//  Copyright © 2019 Dalia Hosny. All rights reserved.
//
import Foundation


protocol TagGateway {
    
    func getTags(online: Bool, In page: Int, completion: @escaping (_ success: Bool,_ responce: [Tag],_ error: APIError?) -> ())
    func getItems(online: Bool, By tagName: String, completion: @escaping (_ success: Bool,_ responce: [Item],_ error: APIError?) -> ())
   
    //func getItemData(By id: Int, completion: @escaping (_ responce : Item,_ message : String,_ status : ResponceStatus) -> ())
}

class TagGatewayImp: TagGateway {

    let apiClient: APIClient
    let localStorage: LocalDataManagerProtocol
    
    init(apiClient: APIClient = APIClientImp(), localStorage: LocalDataManagerProtocol = RealmLocalDataManager()) {
    
        self.apiClient = apiClient
        self.localStorage = localStorage
    }
    
    func getTags(online: Bool, In page: Int,completion: @escaping (_ success: Bool,_ responce: [Tag],_ error: APIError?) -> ()) {
        if online {
            loadTags(In: page){ [weak self] (success, tags, error) in
                if success {
                    //cach
                    self?.localStorage.saveTags(tags: tags, inPage: page)
                }
                completion(success, tags, error)
            }
        }else{
            let tags = localStorage.getAllTage(inPage: page)
            completion(true, tags, nil)
        }
    }
    
    func loadTags(In page: Int,completion: @escaping (_ success: Bool,_ responce: [Tag],_ error: APIError?) -> ())  {
        let apiURL = "/tags/\(page)"
        //let parameter = "\(page)"
        apiClient.getApiRequest(apiURL: apiURL, withParameter: ""){ (success, responce, error) in
            if success {
                //print(responce!)
                if let result = responce {
                    var tags = [Tag]()
                    if let tagsArray = result["tags"] as? [[String:Any]]{
                        for dic in tagsArray{
                            let value = Tag.fromDictionary(page: page, dictionary: dic)
                            tags.append(value)
                        }
                        completion(true, tags, nil)
                    }else{
                       completion(false, [], .parsingError)
                    }
                    
                }else{
                   completion(false, [], .parsingError)
                }
            } else {
               completion(false, [], error)
            }
        }
    }
    
    func getItems(online: Bool, By tagName: String, completion: @escaping (_ success: Bool,_ responce: [Item],_ error: APIError?) -> ()) {
        if online {
            loadItems(By: tagName){ [weak self] (success, items, error) in
                if success {
                    //cach
                    self?.localStorage.saveItems(items: items, tagName: tagName)
                    
                }
                completion(success, items, error)
            }
        }else{
            let items = localStorage.getAllItems(tagName: tagName)
            completion(true, items, nil)
        }
        
    }
    
    func loadItems(By tagName: String, completion: @escaping (_ success: Bool,_ responce: [Item],_ error: APIError?) -> ()){
        let apiURL = "/items/\(tagName)"
        //let parameter = "\(page)"
        apiClient.getApiRequest(apiURL: apiURL, withParameter: ""){ (success, responce, error) in
            if success {
                //print(responce!)
                if let result = responce {
                    var items = [Item]()
                    if let itemsArray = result["items"] as? [[String:Any]]{
                        for dic in itemsArray{
                            let value = Item.fromDictionary(dictionary: dic, tagName: tagName)
                            items.append(value)
                        }
                        completion(true, items, nil)
                    }else{
                        completion(false, [], .parsingError)
                    }
                    
                }else{
                    completion(false, [], .parsingError)
                }
            } else {
                completion(false, [], error)
            }
        }
    }
}
