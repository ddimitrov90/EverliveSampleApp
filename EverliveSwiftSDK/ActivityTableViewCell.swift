//
//  ActivityTableViewCell.swift
//  EverliveSDK
//
//  Created by Dimitar Dimitrov on 4/24/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import Kingfisher

class ActivityTableViewCell: UITableViewCell {
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var activityTextLabel: UILabel!
    //@IBOutlet weak var activityTimestampLabel: UILabel!
    @IBOutlet weak var activityPicture: UIImageView!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    
    weak var delegate: CellDelegate?
    var cellIndex: Int?
    var isLiked:Bool = false
    
    @IBAction func likePicture(sender: UIButton){
        var params:[String:AnyObject] = [:]
        params["key"] = "like"
        self.likeButton.enabled = false
        self.delegate!.onCellClick(self.cellIndex!, data: params)
    }
    
    @IBAction func openComments(sender: UIButton){
        var params:[String:String] = [:]
        params["key"] = "comments"
        self.delegate!.onCellClick(self.cellIndex!, data: params)
    }
    
    func changeLikeButton() {
        let newState = self.isLiked ? false : true
        let likeIcon = self.isLiked ? "like" : "like-color"
        self.isLiked = newState
        if let img = UIImage(named: likeIcon) {
            self.likeButton.setImage(img, forState: .Normal)
            self.likeButton.enabled = true
        }
    }
    
    func configure(activity: Activity){
        self.usernameLabel.text = activity.UserProfile?.DisplayName
        self.activityTextLabel.text = activity.Text
        //self.activityTimestampLabel.text = activity.CreatedAt
        
        self.activityPicture.kf_setImageWithURL(NSURL(string: activity.ActivityPic!.Uri!)!)
        self.profilePicture.kf_setImageWithURL(NSURL(string: activity.UserProfile!.ProfilePicture!.Uri!)!)
        
        self.profilePicture.layer.cornerRadius = 15.0
        self.profilePicture.clipsToBounds = true
        if let currentUserId = EverliveSwiftApp.currentUser?.Id {
            if activity.Likes.count > 0 && activity.Likes.indexOf(currentUserId) > -1 {
                if let img = UIImage(named: "like-color") {
                    self.likeButton.setImage(img, forState: .Normal)
                    self.isLiked = true
                }
            }
        }
    }
}
