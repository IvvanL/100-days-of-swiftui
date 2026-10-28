//
//  Detailview.swift
//  Day61
//
//  Created by Ivan Lara on 10/27/26.
//

import SwiftUI

struct DetailView: View {
    
    let user: User
    
    var body: some View {
        List {
            Section("User Info") {
                LabeledContent("Company", value: user.company)
                LabeledContent("Age", value: user.age.description)
                LabeledContent("Email", value: user.email)
                LabeledContent("Address", value: user.address)
                LabeledContent("Registered") {
                    Text(user.registered, format: .dateTime.day().month().year())
                }
            }
            Section("About") {
                Text(user.about)
            }
            Section("Tags") {
                ForEach(user.tags, id: \.self) { tag in
                    Text("#\(tag)")
                }
            }
            Section("Friends") {
                ForEach(user.friends) { friend in
                    Text(friend.name)
                }
            }
            .navigationTitle(user.name)
        }
    }
}

#Preview {
    let user = User(
        id: UUID(),
        isActive: true,
        name: "Ivan Lara",
        age: 30,
        company: "Apple Inc.",
        email: "Apple@apple.com",
        address: "Apple Park",
        about: "This is a very loyal customer",
        registered: Date.now,
        tags: ["Swift", "Apple", "Xcode"],
        friends: [Friend(id: UUID(), name: "John")]
    )
    
    NavigationStack {
        DetailView(user: user)
    }
}
