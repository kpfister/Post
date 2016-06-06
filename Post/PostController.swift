//
//  PostController.swift
//  Post
//
//  Created by Caleb Hicks on 5/16/16.
//  Copyright © 2016 DevMountain. All rights reserved.
//

import Foundation

class PostController {
    
    weak var delegate = PostControllerDelegate?()
    
    
    static let baseURL = NSURL(string: "https://devmtn-post.firebaseio.com/posts")
    static let endpoint = baseURL?.URLByAppendingPathExtension("json")
    
    
    var posts: [Post] = [] // I think this will change
    
    init() {
        fetchedPosts()
        
    }
    
    static func fetchPosts(completion: ((posts: [Post]) -> Void)?) {
        guard let url = endpoint else {return}
        
        NetworkController.performRequestForURL(url, httpMethod: .Get) { (data, error) in
            guard let data = data,
                postDictionary = (try? NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)) as? [String:[String: AnyObject]] else {
                    if let completion = completion {
                        completion(posts: [])
                    }
                    return
            }
            let post = postDictionary.flatMap({Post(dictionary: $0.1, identifier: $0.0)})
            let sortedPosts = post.sort({$0.timeStamp > $1.timeStamp})
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
               self.posts = sortedPosts
                if let completion = completion {
                    completion(posts: sortedPosts)
                    print(sortedPosts)
                }
            })
        }
    }
}

protocol PostControllerDelegate: class {
    func postUpdated()
    
    
}
