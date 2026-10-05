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
    
    init(sortOrder: [SortDescriptor<ExpenseItem>], filter: String) {
        _expenses = Query(filter: #Predicate<ExpenseItem> {
            filter == "All" || $0.type == filter
        }, sort: sortOrder)
    }
    
    var personalExpenses: [ExpenseItem] {
        expenses.filter { $0.type == "Personal" }
    }
    
    var businessExpenses: [ExpenseItem] {
        expenses.filter { $0.type == "Business" }
    }
    
    var body: some View {
        List {
            if !personalExpenses.isEmpty {
                Section("Personal") {
                    ForEach(personalExpenses) { item in
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
            }
            
            if !businessExpenses.isEmpty {
                Section("Business") {
                    ForEach(businessExpenses) { item in
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
    ExpensesListView(sortOrder: [SortDescriptor(\ExpenseItem.name)], filter: "All")
        .modelContainer(for: ExpenseItem.self, inMemory: true)
}
