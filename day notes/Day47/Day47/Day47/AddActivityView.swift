//
//  AddActivityView.swift
//  Day47
//
//  Created by Ivan Lara on 8/23/26.
//

import SwiftUI

struct AddActivityView: View {
    
    @State private var title: String = ""
    @State private var description: String = ""
    @Binding var activities: [Activity]
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Form {
            Section(header: Text("Add a new activity")) {
                TextField("Title", text: $title)
                TextField("Description", text: $description)
            }
            Button("Save") {
                activities.append(Activity(title: title, description: description))
                dismiss()
            }
        }
    }
}

#Preview {
    AddActivityView(activities: .constant([]))
}
