//
//  Student.swift
//  Day53
//
//  Created by Ivan Lara on 9/19/26.
//

import Foundation
import SwiftData

@Model
class Student {
    var id: UUID
    var name: String
    
    init(id: UUID, name: String) {
        self.id = id
        self.name = name
    }
}
