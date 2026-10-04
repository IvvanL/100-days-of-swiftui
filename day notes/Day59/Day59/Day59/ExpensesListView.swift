//
//  ExpensesListView.swift
//  Day59
//
//  Created by Ivan Lara on 10/4/26.
//

import SwiftData
import SwiftUI

struct ExpensesListView: View {
    
    @Query var expenses: [ExpenseItem]
    @Environment(\.modelContext) var modelContext
    
    init(sortOrder: [SortDescriptor<ExpenseItem>]) {
        _expenses = Query(sort: sortOrder)
    }
    
    var body: some View {
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
    ExpensesListView(sortOrder: [SortDescriptor(\ExpenseItem.name)])
        .modelContainer(for: ExpenseItem.self, inMemory: true)
}
