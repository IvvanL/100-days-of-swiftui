//
//  AddView.swift
//  Day59
//
//  Created by Ivan Lara on 10/3/26.
//

import SwiftData
import SwiftUI

struct AddView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    
    @State private var name = ""
    @State private var type = "Personal"
    @State private var amount = 0.0

    let types = ["Business", "Personal"]
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Name", text: $name)
                
                Picker("Type", selection: $type) {
                    ForEach(types, id: \.self) {
                        Text($0)
                    }
                }
                
                TextField("Amount", value: $amount, format:.currency(code: Locale.current.currency?.identifier ?? "USD"))
                    .keyboardType(.decimalPad) //changed currency to local currency not USD
            }
            .navigationTitle("Add new expense")
            .toolbar {
                Button("save") {
                    let item = ExpenseItem(name: name, type: type, amount: amount)
                    modelContext.insert(item)
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    AddView()
        .modelContainer(for: ExpenseItem.self, inMemory: true)
}
