//
//  Day56App.swift
//  Day56
//
//  Created by Ivan Lara on 9/23/26.
//

import SwiftData
import SwiftUI

@main
struct Day56App: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Book.self)
    }
}
