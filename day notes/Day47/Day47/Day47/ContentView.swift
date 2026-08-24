//
//  ContentView.swift
//  Day47
//
//  Created by Ivan Lara on 8/23/26.
//

import SwiftUI

struct ContentView: View {
    
    func deleteActivity(at offsets: IndexSet) {
        activities.remove(atOffsets: offsets)
    }

    @State private var activities: [Activity] = {
        if let savedData = UserDefaults.standard.data(forKey: "Activities") {
            if let decoded = try? JSONDecoder().decode([Activity].self, from: savedData) {
                return decoded
            }
        }
        
        return [
            Activity(title: "Read", description:  "Read book"),
            Activity(title: "Analyze", description: "Analyze stock charts"),
            Activity(title: "Backtest", description: "Backtest strategy"),
            Activity(title: "Review", description: "Review notes")
        ]
    }()
    
    @State private var showingAddActivity = false
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    var body: some View {
        NavigationStack {
            Text("Habit wiz")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            List {
                Text("Activity List")
                    .font(.title)
                ForEach($activities) { $activity in
                    ActivityRow(activity: $activity)
                }
                .onDelete(perform: deleteActivity)
            }
            
            .onChange(of: activities) {
                let encoder = JSONEncoder()
                if let encoded = try? encoder.encode(activities) {
                    UserDefaults.standard.set(encoded, forKey: "Activities")
                }
            }
            
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isDarkMode.toggle()
                    } label: {
                        Image(systemName: isDarkMode ? "moon.fill" : "sun.max.fill")
                            .font(.title3)
                            .foregroundStyle(isDarkMode ? .yellow : .orange)
                    }
                }
                
                ToolbarSpacer(.fixed, placement: .topBarTrailing)
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add") {
                        showingAddActivity.toggle()
                    }
                }
            }
            
            .sheet(isPresented: $showingAddActivity) {
                AddActivityView(activities: $activities)
            }
            
        }
        .preferredColorScheme(isDarkMode ? .dark : .light)
    }
}

#Preview {
    ContentView()
}
