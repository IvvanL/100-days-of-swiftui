//
//  ContentView.swift
//  iExpense
//
//  Created by Ivan Lara on 6/27/26.
//
 
import SwiftUI

struct User: Codable {
    let firstName: String
    let lastName: String
}

struct ContentView: View {
    @State private var user =  User(firstName: "Taylor", lastName: "Swift")
    
    var body: some View {
        Button("Save User") {
            let encoder = JSONEncoder()
            
            if let data = try? encoder.encode(user) {
                UserDefaults.standard.set(data, forKey: "userData")
            }
        }
    }
}
    

#Preview {
    ContentView()
}
