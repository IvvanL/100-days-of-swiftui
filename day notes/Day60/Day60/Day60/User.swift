//
//  User.swift
//  Day60
//
//  Created by Ivan Lara on 10/18/26.
//

import SwiftUI

struct User: Identifiable, Codable {
    let id: UUID
    let isActive: Bool
    let name: String
    let age: Int
    let company: String
    let email: String
    let address: String
    let about: String
    let registered: Date
    let tags: [String]
    let friends: [Friend]
  }
