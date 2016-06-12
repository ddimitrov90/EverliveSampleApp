//
//  Activity.swift
//  EverliveSDK
//
//  Created by Dimitar Dimitrov on 4/21/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import EverliveSDK

public class Activity : DataItem {
    var Text: String? {
        didSet {
            super.propertyChanged.raise("Text")
        }
    }
    
    var UserId: String?
    var UserProfile: SampleUser?
    var Picture: String?
    var ActivityPic: File?
    var Likes: [String] = []
    
    override public func getTypeName() -> String {
        return "Activities"
    }
    
    public override func getSkippedProperties() -> Set<String> {
        return ["UserProfile", "ActivityPic"]
    }
}