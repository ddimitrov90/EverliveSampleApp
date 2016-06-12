//
//  ViewController.swift
//  EverliveSDK
//
//  Created by Dimitar Dimitrov on 03/15/2016.
//  Copyright (c) 2016 Dimitar Dimitrov. All rights reserved.
//

import UIKit
import EverliveSDK

class LoginViewController: UIViewController {
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBAction func loginButtonClick(sender: UIButton) {
        
        let usernameValue = self.username.text!
        let passwordValue = self.password.text!
        
        Utilities.showLoading(self.view)
        
        EverliveSwiftApp.sharedInstance.Authentication().login(usernameValue, password: passwordValue).execute { (_:AccessToken?, err:EverliveError?) -> Void in
            
            Utilities.hideLoading()
            if err != nil {
                let alertCtrl: UIAlertController = UIAlertController(title: "", message: "Invalid credentials", preferredStyle: UIAlertControllerStyle.Alert)
                let defaultAction: UIAlertAction = UIAlertAction(title: "Try Again", style: UIAlertActionStyle.Default, handler: nil)
                alertCtrl.addAction(defaultAction)
                self.presentViewController(alertCtrl, animated: false, completion: nil)
            } else {
                EverliveSwiftApp.sharedInstance.Users().getMe().execute({ (currentUser: User?, err: EverliveError?) -> Void in
                    if err == nil {
                        EverliveSwiftApp.currentUser = currentUser
                        self.performSegueWithIdentifier("loginSegue", sender: self)
                    }
                })
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        EverliveSwiftApp.sharedInstance.Users().getMe().execute({ (currentUser: User?, err: EverliveError?) -> Void in
            if err == nil {
                EverliveSwiftApp.currentUser = currentUser
                self.performSegueWithIdentifier("loginSegue", sender: self)
            }
        })
    }
    
    @IBAction func cancelToLoginViewController(segue:UIStoryboardSegue) {
    }
}

