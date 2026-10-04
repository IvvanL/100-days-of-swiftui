//
//  ContentView.swift
//  Day59
//
//  Created by Ivan Lara on 10/3/26.
//

import SwiftData
import SwiftUI

@Model
class ExpenseItem {
    var name: String
    var type: String
    var amount: Double
    
    init (name: String, type: String, amount: Double) {
        self.name = name
        self.type = type
        self.amount = amount
    }
    
    var amountColor: Color {
        switch amount {
        case 0..<10:
            return .green
        case 10..<100:
            return .orange
        default:
            return .red
        }
    }
}

struct ContentView: View {
    
    @State private var showingAddExpense = false
    @State private var sortOrder = [SortDescriptor(\ExpenseItem.name)]
    
    var body: some View {
        NavigationStack {
            ExpensesListView(sortOrder: sortOrder)
            .navigationTitle("iExpense")
            .toolbar {
                Button("Add Expense", systemImage: "plus") {
                    showingAddExpense = true
                }
                Menu("Sort", systemImage: "arrow.up.arrow.down") {
                    Picker(selection: $sortOrder, label: Text("Sort by")) {
                        Text("Name").tag([SortDescriptor(\ExpenseItem.name)])
                        Text("Amount").tag([SortDescriptor(\ExpenseItem.amount)])
                    }
                }
            }
            .sheet(isPresented: $showingAddExpense) {
                AddView()
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: ExpenseItem.self, inMemory: true)
}
