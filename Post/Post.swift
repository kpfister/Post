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
    private let ktimestamp = "timestamp"
    
    let username: String
    let text: String
    let timeStamp: NSTimeInterval
    let identifier: NSUUID
    
    //*************************//
    //***POSTING / PUTTING****//
    //***********************//

    var jsonValue: [String:AnyObject] {
        return [kText: text, kUsername:username, ktimestamp:timeStamp]
    }
    
    var jsonData: NSData? {
        return try? NSJSONSerialization.dataWithJSONObject(self.jsonValue, options: .PrettyPrinted)
    }
    
    var endpoint: NSURL? {
        
        return PostController.baseURL?.URLByAppendingPathComponent(self.identifier.UUIDString).URLByAppendingPathExtension("json")
    }
        
    init(username: String, text: String, identifier: NSUUID = NSUUID(), timeStamp: NSTimeInterval = NSDate().timeIntervalSince1970) {
        
        self.username = username
        self.text = text
        self.timeStamp = timeStamp
        self.identifier = identifier
    }
    
    init?(dictionary: [String:AnyObject], identifier: String) {
        guard let username = dictionary[kUsername] as? String,
        text = dictionary[kText] as? String,
        timeStamp = dictionary[ktimestamp] as? Double,
        identifier = NSUUID(UUIDString: identifier)
        else {
                return nil
        }
        self.username = username
        self.identifier = identifier
        self.text = text
        self.timeStamp = NSTimeInterval(floatLiteral: timeStamp)
    }
        
    var queryTimestamp: NSTimeInterval {
        
        return timeStamp - 0.000001
    }
    
}