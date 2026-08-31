//
//  AddressView.swift
//  Day50
//
//  Created by Ivan Lara on 8/30/26.
//

import SwiftUI

struct AddressView: View {
    var order: Order
    
    var body: some View {
        Text("This is the order address")
    }
}

#Preview {
    AddressView(order: Order())
}
