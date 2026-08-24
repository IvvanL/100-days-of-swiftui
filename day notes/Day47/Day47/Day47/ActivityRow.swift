//
//  ActivityRow.swift
//  Day47
//
//  Created by Ivan Lara on 8/23/26.
//

import SwiftUI

struct ActivityRow: View {
    
    @Binding var activity: Activity
    
    var body: some View {
        NavigationLink(destination: ActivityView(activity: $activity)) {
            Text(activity.title)
        }
    }
}

#Preview {
    @Previewable @State var activity = Activity(title: "Read", description: "Read book")
    ActivityRow(activity: $activity)
}
 
