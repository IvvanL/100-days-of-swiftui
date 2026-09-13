//
//  Order.swift
//  Day52
//
//  Created by Ivan Lara on 9/12/26.
//

// added

import SwiftUI

@Observable
class Order: Codable {
    enum CodingKeys: String, CodingKey {
        case _type = "type"
        case _quantity = "quantity"
        case _specialRequestEnabled = "specialRequestEnabled"
        case _extraFrosting = "extraFrosting"
        case _addSprinkles = "addSprinkles"
        case _name = "name"
        case _streetAddress = "streetAddress"
        case _city = "city"
        case _zip = "zip"
    }
    
    init() {
        if let savedOrder = UserDefaults.standard.data(forKey: "Order") {
            if let decodedOrder = try? JSONDecoder().decode(Order.self, from: savedOrder) {
                print("Order loaded successfully")
                type = decodedOrder.type
                quantity = decodedOrder.quantity
                specialRequestEnabled = decodedOrder.specialRequestEnabled
                extraFrosting = decodedOrder.extraFrosting
                addSprinkles = decodedOrder.addSprinkles
                name = decodedOrder.name
                streetAddress = decodedOrder.streetAddress
                city = decodedOrder.city
                zip = decodedOrder.zip
            } else {
                print("Found saved data but failed to decode it")
            }
        } else {
        print("No saved order found")
        }
    }
    
    static let types = ["Vanilla","Strawberry","Chocolate", "Rainbow"]
    
    var type = 0
    var quantity = 3
    
    var specialRequestEnabled = false  {
        didSet {
            if specialRequestEnabled == false {
                extraFrosting = false
                addSprinkles = false
            }
        }
    }
    
    var extraFrosting = false
    var addSprinkles = false
    
    var name = ""
    var streetAddress = ""
    var city = ""
    var zip = ""
    
    var hasValidAddress: Bool {
        // added trimmmingCharacters and .whitespaces modifier so that the checkout button is still greyed out if only spaces are entered on the name, street address, city and zip fields
        if name.trimmingCharacters(in: .whitespaces).isEmpty ||
            streetAddress.trimmingCharacters(in: .whitespaces).isEmpty ||
            city.trimmingCharacters(in: .whitespaces).isEmpty ||
            zip.trimmingCharacters(in: .whitespaces).isEmpty {
            return false
        }
        
        return true
    }
    
    var cost: Decimal {
        // $2 per cake
        var cost = Decimal(quantity) * 2
        
        // complicated cakes cost more
        cost += Decimal(type) / 2
        
        // $1/cake for extra frosting
        if extraFrosting {
            cost += Decimal(quantity)
        }
        
        // $0.50/cake for Sprinkles
        if addSprinkles {
            cost += Decimal(quantity) / 2
        }
        
        return cost
    }
    
    func save() {
        if let encoded = try? JSONEncoder().encode(self) {
            UserDefaults.standard.set(encoded, forKey: "Order")
            print("Order saved successfully")
        } else {
            print("Failed to encode order")
        }
    }
    
}

