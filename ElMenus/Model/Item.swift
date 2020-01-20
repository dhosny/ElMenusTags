//
//	Item.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import RealmSwift
import Realm

class Item: Object {

	@objc dynamic var descriptionField: String!
    @objc dynamic var id: Int = 0
	@objc dynamic var name: String!
	@objc dynamic var photoUrl: String!
    @objc dynamic var tagName: String!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
    class func fromDictionary(dictionary: [String:Any], tagName: String) -> Item	{
		let this = Item()
		
		if let descriptionFieldValue = dictionary["description"] as? String{
			this.descriptionField = descriptionFieldValue
		}
		if let idValue = dictionary["id"] as? Int{
			this.id = idValue
		}
		if let nameValue = dictionary["name"] as? String{
			this.name = nameValue
		}
		if let photoUrlValue = dictionary["photoUrl"] as? String{
			this.photoUrl = photoUrlValue
		}
        
        this.tagName = tagName
		return this
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		
		if descriptionField != nil{
			dictionary["description"] = descriptionField
		}
		dictionary["id"] = id
		if name != nil{
			dictionary["name"] = name
		}
		if photoUrl != nil{
			dictionary["photoUrl"] = photoUrl
		}
		return dictionary
	}


}
