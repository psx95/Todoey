//
//  Category.swift
//  Todoey
//
//  Created by Pranav Sharma on 17/02/19.
//  Copyright © 2019 Pranav Sharma. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    
    @objc dynamic var name: String = ""
    @objc dynamic var color: String = ""
    let items = List<Item>()
}
