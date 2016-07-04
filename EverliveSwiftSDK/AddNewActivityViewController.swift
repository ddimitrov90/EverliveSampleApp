//
//  AddNewActivityViewController.swift
//  EverliveSwiftSDK
//
//  Created by Dimitar Dimitrov on 5/15/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import EverliveSDK
import CoreLocation


class AddNewActivityViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager!
    var currentLocation: CLLocationCoordinate2D = CLLocationCoordinate2D()

    override func viewDidLoad() {
        super.viewDidLoad()
        //self.newActivityImage.layer.masksToBounds = true
        //self.newActivityImage.layer.borderColor = UIColor(red: 212.0, green: 212.0, blue: 212.0, alpha: 0.0).CGColor
        //self.newActivityImage.layer.borderWidth = 3.0
        // Do any additional setup after loading the view.
        
        let selectImageTap = UITapGestureRecognizer(target: self, action: #selector(AddNewActivityViewController.pickImage(_:)))
        selectImageTap.numberOfTapsRequired = 1
        self.newActivityImage.addGestureRecognizer(selectImageTap)
        
        self.newActivityText.layer.masksToBounds = true
        self.newActivityText.layer.borderColor = UIColor(red: 212.0/255.0, green: 212.0/255.0, blue: 212.0/255.0, alpha: 0.5).CGColor
        self.newActivityText.layer.borderWidth = 2.0
        self.newActivityText.layer.cornerRadius = 5.0
        
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    func locationManager(manager:CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.currentLocation = manager.location!.coordinate
    }
    
    @IBAction func pickImage(sender: UIButton) {
        let imgPicker = UIImagePickerController()
        imgPicker.delegate = self
        self.presentViewController(imgPicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        self.newActivityImage.image = image
        self.newActivityImage.contentMode = UIViewContentMode.ScaleToFill
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func saveActivity(sender: UIButton) {
        Utilities.showLoading(self.view)
        let newFile = File()
        newFile.Filename = "newfile.jpeg"
        newFile.ContentType = "image/jpeg"
        newFile.Data = UIImageJPEGRepresentation(self.newActivityImage.image!, 0.4)
        EverliveSwiftApp.sharedInstance.Files().upload(newFile).execute { (success: Bool, err: EverliveError?) in
            print(newFile.Uri!)
            let newActivity = Activity()
            newActivity.Text = self.newActivityText.text
            newActivity.Picture = newFile.Id
            newActivity.UserId = EverliveSwiftApp.currentUser?.Id
            newActivity.Location = GeoPoint()
            newActivity.Location?.Latitude = self.currentLocation.latitude
            newActivity.Location?.Longitude = self.currentLocation.longitude
            EverliveSwiftApp.sharedInstance.Data().create(newActivity).execute({ (suc:Bool, err:EverliveError?) in
                Utilities.hideLoading()
                self.locationManager.stopUpdatingLocation()
                self.performSegueWithIdentifier("showAllActivities", sender: self)
            })
        }
    }
    
    @IBOutlet weak var newActivityImage: UIImageView!

    @IBOutlet weak var newActivityText: UITextView!
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
