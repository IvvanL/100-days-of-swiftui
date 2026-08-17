//
//  ContentView.swift
//  Day46
//
//  Created by Ivan Lara on 8/16/26.
//


// ** DAY 46 CHALLENGE **
/*
 1. Change project 7 (iExpense) so that it uses NavigationLink for adding new expenses rather than a sheet. (Tip: The dismiss() code works great here, but you might want to add the navigationBarBackButtonHidden() modifier so they have to explicitly choose Cancel.)
 2. Try changing project 7 so that it lets users edit their issue name in the navigation title rather than a separate textfield. Which option do you prefer? -- I prefer the TextField, since it's a bit more intuitive.
*/

import SwiftUI

struct ExpenseItem: Identifiable, Codable {
    var id = UUID()
    let name: String
    let type: String
    let amount: Double
    
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

@Observable
class Expenses {
    var items = [ExpenseItem]() {
        didSet {
            if let encoded = try? JSONEncoder().encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
    
    init() {
        if let savedItems = UserDefaults.standard.data(forKey: "Items") {
            if let decodedItems = try? JSONDecoder().decode([ExpenseItem].self, from: savedItems) {
                items = decodedItems
                return
            }
        }
        
        items = []
    }
}

struct ContentView: View {
    @State private var expenses = Expenses()
    
    var body: some View {
        NavigationStack {
            List {
                Section("Personal") {
                    ForEach(expenses.items.filter { $0.type == "Personal" }) { item in
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
                    ForEach(expenses.items.filter { $0.type == "Business" }) { item in
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
                    NavigationLink {
                        AddView(expenses: expenses)
                    } label: {
                        Label("Add Expense", systemImage: "plus")
                    }
                }
            }
        }
        
        func removeItems(at offsets: IndexSet, from type: String) {
            let filteredItems = expenses.items.filter { $0.type == type}
            let itemsToDelete = offsets.map { filteredItems[$0] }
            
            expenses.items.removeAll(where: { item in
                itemsToDelete.contains(where: { $0.id == item.id })
            })
        }
    }
    
#Preview {
    ContentView()
}
