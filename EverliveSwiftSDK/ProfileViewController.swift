//
//  ProfileViewController.swift
//  EverliveSDK
//
//  Created by Dimitar Dimitrov on 5/14/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import EverliveSDK
import Kingfisher

class ProfileViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.profilePicture.layer.cornerRadius = 90
        self.profilePicture.clipsToBounds = true
        
        if let userId = EverliveSwiftApp.currentUser?.Id {
            let picExpand = ExpandDefinition(relationField: "Picture", returnAs: "ProfilePicture")
            picExpand.TargetTypeName = "System.Files"
            EverliveSwiftApp.sharedInstance.Users().getById(userId).expand(picExpand).execute { (rez: SampleUser?, err:EverliveError?) in
                if let profilePic = rez?.ProfilePicture?.Uri {
                    self.profilePicture.kf_setImageWithURL(NSURL(string: profilePic)!)
                }
            }
        }
        self.emailTextField.text = EverliveSwiftApp.currentUser?.Email
        self.displayNameTextField.text = EverliveSwiftApp.currentUser?.DisplayName
    }

    @IBOutlet weak var profilePicture: UIImageView!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var displayNameTextField: UITextField!
    
    @IBAction func signOut(sender: UIButton) {
        EverliveSwiftApp.sharedInstance.Authentication().logout().execute { (success:Bool, err:EverliveError?) in
            if !success {
                let alertCtrl: UIAlertController = UIAlertController(title: "", message: "Failed signout", preferredStyle: UIAlertControllerStyle.Alert)
                let defaultAction: UIAlertAction = UIAlertAction(title: "Try Again", style: UIAlertActionStyle.Default, handler: nil)
                alertCtrl.addAction(defaultAction)
                self.presentViewController(alertCtrl, animated: false, completion: nil)
            } else {
                self.performSegueWithIdentifier("signOutSegue", sender: self)
            }
        }
    }
}
