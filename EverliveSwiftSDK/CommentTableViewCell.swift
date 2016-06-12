//
//  CommentTableViewCell.swift
//  EverliveSwiftSDK
//
//  Created by Dimitar Dimitrov on 5/27/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
class CommentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var commentText: UILabel!
    @IBOutlet weak var username: UILabel!
    
    func configure(comment: Comment){
        self.commentText.text = comment.Comment
        self.username.text = comment.Author?.DisplayName
    }
}