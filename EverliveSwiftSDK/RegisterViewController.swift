//
//  RegisterViewController.swift
//  EverliveSDK
//
//  Created by Dimitar Dimitrov on 3/26/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import EverliveSDK

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var name: UITextField!
    
    override func viewDidLoad() {
        //self.navigationController!.navigationBar.barTintColor = UIColor(red: 0, green: 188, blue: 212, alpha: 1)
    }
    
    @IBAction func registerUser(sender: UIButton){
        let newUser = User()
        newUser.Username = self.username.text
        newUser.Password = self.password.text
        newUser.Email = self.email.text
        newUser.DisplayName = self.name.text
        EverliveSwiftApp.sharedInstance.Users().create(newUser).execute { (success:Bool, err:EverliveError?) in
            if success {
                EverliveSwiftApp.sharedInstance.Authentication().login(newUser.Username!, password: newUser.Password!).execute { (_:AccessToken?, err:EverliveError?) -> Void in
                    self.performSegueWithIdentifier("registerSegue", sender: self)
                }
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier where identifier == "registerSegue" {
            EverliveSwiftApp.sharedInstance.Users().getMe().execute({ (currentUser: User?, err: EverliveError?) -> Void in
                EverliveSwiftApp.currentUser = currentUser
            })
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
