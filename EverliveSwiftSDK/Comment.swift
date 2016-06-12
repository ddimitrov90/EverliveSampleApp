//
//  Comment.swift
//  EverliveSwiftSDK
//
//  Created by Dimitar Dimitrov on 5/27/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import EverliveSDK

public class Comment: DataItem {
    var Comment: String = ""
    var ActivityId: String?
    var Author: SampleUser?
    
    override public func getTypeName() -> String {
        return "Comments"
    }
    
    public override func getSkippedProperties() -> Set<String> {
        return ["Author"]
    }
}