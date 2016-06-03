//
//  Post.swift
//  Post
//
//  Created by Caleb Hicks on 5/16/16.
//  Copyright © 2016 DevMountain. All rights reserved.
//

import Foundation

class Post {
    
    private let kUsername = "username"
    private let kText = "text"
    private let kTimestamp = "timestamp"
    private let kIdentifier = "identifier"
    
    
    let username: String
    let text: String
    let timestamp: NSTimeInterval
    let identifier: NSUUID
    
    var endpoint: NSURL? {
            return PostController.baseURL?.URLByAppendingPathComponent(identifier.UUIDString).URLByAppendingPathExtension("json")
    }
    
    var jsonValue: [String: AnyObject] {
        let json: [String: AnyObject] = [
        
        kUsername: self.username,
        kText: self.text,
        kTimestamp: self.timestamp
        ]
        
        return json
    }
    
    var jsonData: NSData? {
        return try? NSJSONSerialization.dataWithJSONObject(self.jsonValue, options: NSJSONWritingOptions.PrettyPrinted)
    }
    
    var queryTimestamp: NSTimeInterval {
        return timestamp - 0.000001
    }
    
    init(username: String, text: String) {
        
        self.username = username
        self.text = text
        self.timestamp = NSDate().timeIntervalSince1970
        self.identifier = NSUUID()
        
    }
    
    init?(dictionary: [String: AnyObject], identifier: String?) {
        guard let username = dictionary[kUsername] as? String,
            text = dictionary[kText] as? String,
            timestamp = dictionary[kTimestamp] as? NSTimeInterval,
            identifier = identifier,
            uniqueIdentifier = NSUUID(UUIDString: identifier)
            else {
                return nil
        }
        self.username = username
        self.text = text
        self.timestamp = timestamp
        self.identifier = uniqueIdentifier
    }
}

