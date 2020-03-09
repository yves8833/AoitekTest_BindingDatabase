//
//  RMModel.swift
//  AoitekTechnicalTest
//
//  Created by Yves Chen on 2020/3/6.
//  Copyright © 2020 YvesChen. All rights reserved.
//

import Foundation
import RealmSwift

class RMModel: Object {
    @objc dynamic var id = ""
    @objc dynamic var title = ""
    @objc dynamic var imageUrl = ""
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
