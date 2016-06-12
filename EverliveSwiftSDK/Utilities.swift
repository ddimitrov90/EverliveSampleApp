//
//  Utilities.swift
//  EverliveSwiftSDK
//
//  Created by Dimitar Dimitrov on 6/11/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

public class Utilities {
    
    static let indicator:UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
    
    static func showLoading(view: UIView){
        Utilities.indicator.frame = CGRectMake(0, 0, 40, 40)
        Utilities.indicator.center = view.center
        view.addSubview(Utilities.indicator)
        Utilities.indicator.bringSubviewToFront(view)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        Utilities.indicator.startAnimating()
    }
    
    static func hideLoading(){
        Utilities.indicator.stopAnimating()
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
}