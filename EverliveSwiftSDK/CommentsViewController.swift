//
//  CommentsViewController.swift
//  EverliveSwiftSDK
//
//  Created by Dimitar Dimitrov on 5/27/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import EverliveSDK

class CommentsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var activityId: String = ""
    var comments:[Comment] = []
    var refreshControl: UIRefreshControl!
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl?.addTarget(self, action: #selector(CommentsViewController.refreshComments(_:)), forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl)
        refreshComments(nil)
    }
    
    func refreshComments(sender: AnyObject?){
        let userExpand = ExpandDefinition(relationField: "CreatedBy", returnAs: "Author")
        let sortExp = Sorting(fieldName: "CreatedAt", orderDirection: OrderDirection.Descending)
        
        let activityFilter = EverliveQuery()
        activityFilter.filter("ActivityId", equalTo: self.activityId)
        
        EverliveSwiftApp.sharedInstance.Data().getByFilter(activityFilter).expand(userExpand).sort(sortExp).execute { (comments:[Comment]?, err: EverliveError?) in
            
            if let activityComments = comments, let commentsCount = comments?.count where commentsCount > 0 {
                self.comments = []
                for index in 0...commentsCount-1 {
                    let currentComment = activityComments[index]
                    self.comments.append(currentComment)
                    if self.comments.count == commentsCount {
                        dispatch_async(dispatch_get_main_queue(),{
                            self.tableView.reloadData()
                            self.refreshControl?.endRefreshing()
                        });
                    }
                }
            }
        }
    }
    
    @IBOutlet weak var newComment: UITextField!
    
    
    @IBAction func addNewComment(sender: UIButton) {
        Utilities.showLoading(self.view)
        let newComment = Comment()
        newComment.Comment = self.newComment.text!
        newComment.ActivityId = self.activityId
        newComment.Author = SampleUser()
        newComment.Author?.DisplayName = EverliveSwiftApp.currentUser?.DisplayName
        EverliveSwiftApp.sharedInstance.Data().create(newComment).execute { (success:Bool, err:EverliveError?) in
            if success {
                self.comments.append(newComment)
                Utilities.hideLoading()
                dispatch_async(dispatch_get_main_queue(),{
                    self.tableView.reloadData()
                });
            }
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.comments.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("commentCell", forIndexPath: indexPath) as! CommentTableViewCell
        
        let currentComment = self.comments[indexPath.row]
        cell.configure(currentComment)
        return cell
    }
}
