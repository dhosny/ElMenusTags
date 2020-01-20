//
//	Tag.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport


import Foundation
import RealmSwift
import Realm

class Tag: Object {

	@objc dynamic var photoURL: String!
	@objc dynamic var tagName: String!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	class func fromDictionary(dictionary: [String:Any]) -> Tag	{
		let this = Tag()
		
		if let photoURLValue = dictionary["photoURL"] as? String{
			this.photoURL = photoURLValue
		}
		if let tagNameValue = dictionary["tagName"] as? String{
			this.tagName = tagNameValue
		}
		return this
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		
		if photoURL != nil{
			dictionary["photoURL"] = photoURL
		}
		if tagName != nil{
			dictionary["tagName"] = tagName
		}
		return dictionary
	}

}
