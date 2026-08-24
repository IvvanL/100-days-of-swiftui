//
//  ActivityView.swift
//  Day47
//
//  Created by Ivan Lara on 8/23/26.
//

import SwiftUI

struct ActivityView: View {
    
    @Binding var activity: Activity
    
    var body: some View {
        VStack {
            Text(activity.title)
                .font(Font.largeTitle.bold())
            Text(activity.description)
            Text("Completed \(activity.completionCount) times")
            
            Button("Mark as Done") {
                activity.completionCount += 1
            }
            .buttonStyle(.borderedProminent)
            .padding()
        }
    }
}

#Preview {
    @Previewable @State var activity = Activity(title: "Read", description: "Read book")
    ActivityView(activity: $activity)
}
