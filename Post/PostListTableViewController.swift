//
//  PostListTableViewController.swift
//  Post
//
//  Created by Caleb Hicks on 5/16/16.
//  Copyright © 2016 DevMountain. All rights reserved.
//

import UIKit

class PostListTableViewController: UITableViewController {
    override func viewDidLoad() {
        PostController.fetchPosts { (posts) in
        }
    }
   
    
    var postController = PostController()
    
    
    
    
    
    
    
    
}