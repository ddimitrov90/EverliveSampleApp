//
//  CellDelegate.swift
//  EverliveSwiftSDK
//
//  Created by Dimitar Dimitrov on 5/24/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

protocol CellDelegate: class{
    func onCellClick(index: Int, data: NSDictionary) -> Void
}