//
//  Activity.swift
//  Day47
//
//  Created by Ivan Lara on 8/23/26.
//

import SwiftUI

struct Activity: Identifiable, Codable, Equatable {
    var title: String
    var description: String
    var id: UUID = UUID()
    var completionCount: Int = 0
}

