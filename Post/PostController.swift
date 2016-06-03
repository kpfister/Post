//
//  PostController.swift
//  Post
//
//  Created by Caleb Hicks on 5/16/16.
//  Copyright © 2016 DevMountain. All rights reserved.
//

import Foundation


class PostController {
    
    static let baseURL = NSURL(string: "https://devmtn-post.firebaseio.com")
    static let endPoint = baseURL?.URLByAppendingPathComponent("/posts.json")  //Wat
    
    weak var delegate: PostControllerDelegate?
    
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
         let post = Post(username: String, text: String)
        guard let requestURL = post.endpoint else {
            fatalError("URL is nil")
            
        }
        NetworkController.performRequestForURL(requestURL, httpMethod: .Put) { (data, error) in
            self.fetchPosts()
        }
    }
    
    func fetchPosts(completion: ((posts: [Post]) -> Void)? = nil) {
        guard let url = PostController.endPoint else {
            fatalError("URL optional is nil in \(#file)")
        }
        
        NetworkController.performRequestForURL(url, httpMethod: .Get) { (data, error) in
            guard let data = data,
                postDictionaries = (try? NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)) as? [String:[String:AnyObject]]
                else {
                    print("Unable to serialize JSON.")
                    if let completion = completion {
                        completion(posts: [])
                    }
                    return
            }
            let posts = postDictionaries.flatMap ({Post(dictionary: $0.1, identifier: $0.0)})
            let sortedPosts = posts.sort({$0.timestamp > $1.timestamp})
            dispatch_async(dispatch_get_main_queue(), {
                self.posts = sortedPosts
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



