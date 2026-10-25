//
//  ContentView.swift
//  Day60
//
//  Created by Ivan Lara on 10/18/26.
//

import SwiftUI

struct ContentView: View {
    
    @State private var users: [User] = []
    
    func loadData() async {
        
        guard users.isEmpty else { return }
        
        guard let url = URL(string: "https://www.hackingwithswift.com/samples/friendface.json") else {
            print("Invalid URL")
            return
        }
        print(url)
        do {
            let(data, _) = try await URLSession.shared.data(from: url)
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let decodedUsers = try decoder.decode([User].self, from: data)
            
            users = decodedUsers
            
            print(users.count)
            
        } catch {
            print("Error: \(error)")
        }
    }
    
    var body: some View {
        NavigationStack {
            List(users) { user in
                NavigationLink {
                    DetailView(user: user)
                } label: {
                    HStack {
                        Text(user.name)
                        
                        Spacer()
                        
                        Text(user.isActive ? "Active" : "Inactive")
                            .foregroundStyle(user.isActive ? .green : .red)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(user.isActive ? Color.green.opacity(0.1) : Color.red.opacity(0.1), in:.capsule)
                    }
                }
            }
            .navigationTitle("Friendface")
            .task {
                await loadData()
            }
        }
    }
}

#Preview {
    ContentView()
}
