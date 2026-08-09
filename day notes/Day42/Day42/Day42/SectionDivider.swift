//
//  SectionDivider.swift
//  Day42
//
//  Created by Ivan Lara on 8/8/26.
//

import SwiftUI

struct SectionDivider: View {
    var body: some View {
        Rectangle()
            .frame(height: 2)
            .foregroundStyle(.lightBackground)
            .padding(.vertical)
    }
}
    
#Preview {
    SectionDivider()
}

