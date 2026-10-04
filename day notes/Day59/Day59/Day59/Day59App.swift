//
//  Day59App.swift
//  Day59
//
//  Created by Ivan Lara on 10/3/26.
//

import SwiftData
import SwiftUI

@main
struct Day59App: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: ExpenseItem.self)
    }
}
