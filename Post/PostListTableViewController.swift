//
//  PostListTableViewController.swift
//  Post
//
//  Created by Caleb Hicks on 5/16/16.
//  Copyright © 2016 DevMountain. All rights reserved.
//

import UIKit

class PostListTableViewController: UITableViewController, PostControllerDelegate {
    
    var postController = PostController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        postController.delegate = self
        
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    @IBAction func addNewPost(sender: UIBarButtonItem) {
        presentNewPostAlert()
        
    }
    
    @IBAction func refreshControlPull(sender: UIRefreshControl) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        postController.fetchPosts() { (newPosts) in
            sender.endRefreshing()
            
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }
    }
    
    func presentNewPostAlert() {
        var userNameTextField: UITextField?
        var messageTextField: UITextField?
        
        let alertController = UIAlertController(title:"Add new post", message: "Whats on your mind?", preferredStyle: .Alert)
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "Display Name"
            userNameTextField = textField
        }
        alertController.addTextFieldWithConfigurationHandler{ (messageField) in
            messageField.placeholder = "Post Body..."
            messageTextField = messageField
        }
        
        let createAction = UIAlertAction(title: "Add", style: .Default) { (action) in
            guard let username = userNameTextField?.text where !username.isEmpty, let text = messageTextField?.text where !text.isEmpty else {
                self.presentErrorAlert()
                return
            }
            self.postController.addPost(username, text: text)
        }
        alertController.addAction(createAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    func presentErrorAlert() {
        
        let alertController = UIAlertController(title: "Uh oh!", message: "You may be missing information or have network connectivity issues. Please try again.", preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "Ok", style: .Cancel, handler: nil)
        
        alertController.addAction(cancelAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    func postsUpdated(posts: [Post]) {
        tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row + 1 == postController.posts.count {
            postController.fetchPosts(reset: false, completion: { (posts) in
                if !posts .isEmpty {
                    tableView.reloadData()
                }
            })
        }
    }
    
    
    
    // MARK: - Table view data source
    
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postController.posts.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("postCell", forIndexPath: indexPath)
        let post = postController.posts[indexPath.row]
        let date = NSDate(timeIntervalSince1970: post.timeStamp)
        cell.textLabel?.text = post.text
        cell.detailTextLabel?.text = "\(post.username) \(date.dateString())\(indexPath.row)"
        
        
        
        return cell
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
     if editingStyle == .Delete {
     // Delete the row from the data source
     tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
     } else if editingStyle == .Insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
