//
//  Day54App.swift
//  Day54
//
//  Created by Ivan Lara on 9/19/26.
//

import SwiftData
import SwiftUI

@main
struct Day54App: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Book.self)
    }
}
