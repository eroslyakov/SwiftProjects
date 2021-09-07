//
//  TodoCategory.swift
//  Todoey
//
//  Created by Rosliakov Evgenii on 04.08.2021.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class TodoCategory: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var color: String?
    var items = List<TodoItem>()
}
