//
//  Day57App.swift
//  Day57
//
//  Created by Ivan Lara on 9/26/26.
//

import SwiftData
import SwiftUI

@main
struct Day57App: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: User.self)
    }
}
