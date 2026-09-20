//
//  Day53App.swift
//  Day53
//
//  Created by Ivan Lara on 9/19/26.
//

import SwiftData
import SwiftUI

@main
struct Day53App: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Student.self)
    }
}
