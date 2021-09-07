//
//  TodoItem.swift
//  Todoey
//
//  Created by Rosliakov Evgenii on 04.08.2021.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class TodoItem: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done = false
    @objc dynamic var dateCreated = Date().timeIntervalSince1970
    var parentCategory = LinkingObjects<TodoCategory>(fromType: TodoCategory.self, property: "items")
}
