//
//  Item.swift
//  Todoey
//
//  Created by Pranav Sharma on 17/02/19.
//  Copyright © 2019 Pranav Sharma. All rights reserved.
//

import Foundation
import RealmSwift

class Item : Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
