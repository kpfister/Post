//
//  DateHelper.swift
//  Post
//
//  Created by Karl Pfister on 6/8/16.
//  Copyright © 2016 DevMountain. All rights reserved.
//

import Foundation

extension NSDate {
    
    func dateString() -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .MediumStyle
        dateFormatter.timeStyle = .MediumStyle
        
        return dateFormatter.stringFromDate(self)
    }
    
    
}