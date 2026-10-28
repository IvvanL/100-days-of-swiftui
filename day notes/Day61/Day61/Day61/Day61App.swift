//
//  Day61App.swift
//  Day61
//
//  Created by Ivan Lara on 10/27/26.
//

import SwiftData
import SwiftUI

@main
struct Day61App: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: User.self)
        }
    }
}

