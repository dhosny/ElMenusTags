//
//  Config.swift
//
//  Created by MAC on 1/16/19.
//  Copyright © 2019 Dalia Hosny. All rights reserved.
//

import Foundation

class Config {
    
    static let sharedInstance = Config()
    
    var properties: NSMutableDictionary?
    
    fileprivate init() {
        let pListFileURL = Bundle.main.url(forResource: "Config", withExtension: "plist", subdirectory: "")
        if let pListPath = pListFileURL?.path,
            let pListData = FileManager.default.contents(atPath: pListPath) {
            do {
                let pListObject = try PropertyListSerialization.propertyList(from: pListData, options:PropertyListSerialization.ReadOptions(), format:nil)
                //Cast pListObject - If expected data type is Dictionary
                guard let pListDict = pListObject as? Dictionary<String, AnyObject> else {
                    return
                }
                
                self.properties = NSMutableDictionary(dictionary: pListDict)
            } catch {
                print("Error reading regions plist file: \(error)")
                return
            }
        }
    }
    
    var baseUrl: String? {
        let key = isTest ? "TestUrl" : "LiveUrl"
        if let baseUrl = properties?.object(forKey: key) as? String {
            return baseUrl
        }
        return nil
    }
    
    var isTest: Bool {
        if let offline = properties?.object(forKey: "TestMode") as? Bool {
            return offline
        }
        return false
    }
    
}
