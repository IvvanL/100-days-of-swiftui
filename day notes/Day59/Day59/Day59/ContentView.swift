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
    @Query var expenses: [ExpenseItem]
    @Environment(\.modelContext) var modelContext
    
    @State private var showingAddExpense = false
    
    var body: some View {
        NavigationStack {
            List {
                Section("Personal") {
                    ForEach(expenses.filter { $0.type == "Personal"}) { item in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(item.name)
                                    .font(.headline)
                                
                                Text(item.type)
                            }
                            
                            Spacer()
                            
                            Text(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD")) //changed to local preffered currency not automatically USD
                                .foregroundStyle(item.amountColor)
                        }
                    }
                    .onDelete { offsets in
                        removeItems(at: offsets, from: "Personal")
                    }
                }
                
                Section("Business") {
                    ForEach(expenses.filter { $0.type == "Business" }) { item in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(item.name)
                                    .font(.headline)
                                
                                Text(item.type)
                            }
                            
                            Spacer()
                            
                            Text(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD")) //changed to local preffered currency not automatically USD
                                .foregroundStyle(item.amountColor)
                        }
                    }
                    .onDelete { offsets in
                        removeItems(at: offsets, from: "Business")
                    }
                }
            }
            .navigationTitle("iExpense")
            .toolbar {
                Button("Add Expense", systemImage: "plus") {
                    showingAddExpense = true
                }
            }
            .sheet(isPresented: $showingAddExpense) {
                AddView()
            }
        }
    }
    
    func removeItems(at offsets: IndexSet, from type: String) {
        let filteredItems = expenses.filter { $0.type == type}
        let itemsToDelete = offsets.map { filteredItems[$0] }
        
        for item in itemsToDelete {
            modelContext.delete(item)
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: ExpenseItem.self, inMemory: true)
}
