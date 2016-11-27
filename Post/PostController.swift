//
//  PostController.swift
//  Post
//
//  Created by Caleb Hicks on 5/16/16.
//  Copyright © 2016 DevMountain. All rights reserved.
//

import Foundation

class PostController {
    
    static let baseURL = NSURL(string: "https://devmtn-post.firebaseio.com/posts/")
    static let endpoint = baseURL?.URLByAppendingPathExtension("json")
    
    
    weak var delegate = PostControllerDelegate?()
    
    var posts: [Post] = [] {
        didSet {
            delegate?.postsUpdated(posts)
        }
    }
    
    init() {
        fetchPosts()
    }
    
    // Mark Create post
    func addPost(username: String, text: String) {
        let post = Post(username: username, text: text)
        guard let requestURL = post.endpoint else {
            fatalError("URL is nil")
            
        }
        
        
        
        NetworkController.performRequestForURL(requestURL, httpMethod: .Put, body: post.jsonData ) { (data, error) in
            if error != nil {
                print("Error -> \(error!.localizedDescription)")
            } else {
                print("Its working!")
            }
            print("HEY DATA!!! \(data)")
            self.fetchPosts()
        }
    }
    
    func fetchPosts(reset reset:Bool = true, completion: ((posts: [Post]) -> Void)? = nil) {
        guard let url = PostController.endpoint else {
            fatalError("URL optional is nil in \(#file)")
        }
        let queryEndInterval = reset ? NSDate().timeIntervalSince1970 : posts.last?.queryTimestamp ?? NSDate().timeIntervalSince1970
        
        //TODO update to query timestamp
        
        let urlParameters = [
            "orderBy": "\"timestamp\"",
            "endAt": "\(queryEndInterval)",
            "limitToLast": "15",
            ]
        NetworkController.performRequestForURL(url, httpMethod: .Get, urlParameters: urlParameters, body: nil) { (data, error) in
       
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
                if reset {
                    self.posts = sortedPosts
                    } else {
                
                        self.posts.appendContentsOf(sortedPosts)
                    }
                
                if let completion = completion {
                    completion(posts: sortedPosts)
                    
                }
                return
            })
        }
    }
}

protocol PostControllerDelegate: class {
    func postsUpdated(posts: [Post])
    
    
}
