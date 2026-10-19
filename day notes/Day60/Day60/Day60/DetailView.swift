//
//  DetailView.swift
//  Day60
//
//  Created by Ivan Lara on 10/18/26.
//

import SwiftUI

struct DetailView: View {

    let user: User

    var body: some View {
        Text(user.name)
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
