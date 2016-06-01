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
    
    init(username: String, text: String, timestamp: NSTimeInterval? = NSDate().timeIntervalSince1970 , identifier: NSUUID? = NSUUID()) {
        
        self.username = username
        self.text = text
        self.timestamp = timestamp!
        self.identifier = identifier!
        
    }
    
    init?(dictionary: [String: AnyObject]) {
        guard let username = dictionary[kUsername] as? String,
        text = dictionary[kText] as? String,
        timestamp = dictionary[kTimestamp] as? NSTimeInterval,
        identifier = dictionary[kIdentifier] as? String,
        uniqueIdentifier = NSUUID(UUIDString: identifier)
        else { return nil }
        self.username = username
        self.text = text
        self.timestamp = timestamp
        self.identifier = uniqueIdentifier
    }
}