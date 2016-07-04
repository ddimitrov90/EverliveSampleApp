//
//  ActivitiesTableViewController.swift
//  EverliveSDK
//
//  Created by Dimitar Dimitrov on 3/27/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import EverliveSDK
import Alamofire
import Kingfisher

class ActivitiesTableViewController: UITableViewController, CellDelegate {
    var currentUser: User = User()
    var activities: [Activity] = []
    var selectedActivityId = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        self.refreshControl?.addTarget(self, action: #selector(ActivitiesTableViewController.refreshFeed(_:)), forControlEvents: UIControlEvents.ValueChanged)
        refreshFeed(nil)
    }
    
    func refreshFeed(sender: AnyObject?){
        let pictureExpand = ExpandDefinition(relationField: "Picture", returnAs: "ActivityPic")
        pictureExpand.TargetTypeName = "System.Files"
        let userExpand = ExpandDefinition(relationField: "UserId", returnAs: "UserProfile")
        userExpand.TargetTypeName = "Users"
        let profilePicExpand = ExpandDefinition(relationField: "Picture", returnAs: "ProfilePicture")
        profilePicExpand.TargetTypeName = "System.Files"
        userExpand.ChildExpand = profilePicExpand
        
        let multipleExpand = MultipleExpandDefinition(expandDefinitions: [pictureExpand, userExpand])
        let sortExp = Sorting(fieldName: "CreatedAt", orderDirection: OrderDirection.Descending)
        
        
        EverliveSwiftApp.sharedInstance.Data().getAll().expand(multipleExpand).sort(sortExp).execute { (activities:[Activity]?, err: EverliveError?) in
            self.activities = []
            for index in 0...(activities?.count)!-1 {
                let currentActivity = activities![index]
                self.activities.append(currentActivity)
                if self.activities.count == activities?.count {
                    dispatch_async(dispatch_get_main_queue(),{
                        self.tableView.reloadData()
                        self.refreshControl?.endRefreshing()
                    });
                }
                /*
                 EverliveSwiftApp.sharedInstance.Files().download(currentActivity.ActivityPic!.Id!).execute { (fileData: File?, err: EverliveError?) in
                 currentActivity.ActivityPic?.Data = fileData?.Data
                 self.activities.append(currentActivity)
                 
                 if self.activities.count == activities?.count {
                 dispatch_async(dispatch_get_main_queue(),{
                 self.tableView.reloadData()
                 });
                 }
                 }
                 */
            }
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.activities.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("activityCell", forIndexPath: indexPath) as! ActivityTableViewCell
        
        let currentActivity = self.activities[indexPath.row]
        cell.delegate = self
        cell.cellIndex = indexPath.row
        cell.configure(currentActivity)
        
        return cell
    }
    
    func onCellClick(index: Int, data: NSDictionary) {
        if data["key"] as? String == "like" {
            let currentActivityId = self.activities[index].Id!
            let likeRequest = EverliveRequest(httpMethod: "GET", url: "Functions/likeActivity?activityId=\(currentActivityId)")
            EverliveSwiftApp.sharedInstance.connection.executeRequest(likeRequest, completionHandler: { (response:Response<AnyObject, NSError>) in
                switch response.result {
                case .Success( _):
                    let indexPath = NSIndexPath(forRow: index, inSection: 0)
                    let currentCell = self.tableView.cellForRowAtIndexPath(indexPath) as! ActivityTableViewCell
                    currentCell.changeLikeButton()
                case .Failure(let error):
                    print("Request failed with error: \(error)")
                }
            })
        } else if data["key"] as? String == "comments" {
            let activityId = self.activities[index].Id
            self.selectedActivityId = activityId!
            self.performSegueWithIdentifier("showCommentsSegue", sender: self)
        }
    }
    
    @IBAction func backToAllActivities(segue:UIStoryboardSegue) {
    }
    
    @IBAction func cancelAddNewActivity(segue:UIStoryboardSegue) {
    }
    
    
    /*
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 500.0
    }*/
    

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
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "showCommentsSegue")
        {
            let secondViewController = segue.destinationViewController as! CommentsViewController
            secondViewController.activityId = self.selectedActivityId
        }
    }

}
