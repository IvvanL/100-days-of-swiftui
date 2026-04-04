import Cocoa

/// **Day 13 -- protocols and extensions**

///**SECTION 1. How to create and use protocols**

///func commute(distance: Int, using vehicle: Car) {
    // lots of code here
///}

protocol Vehicle {
    var name: String {get}
    var currentPassangers: Int {get set}
    func estimateTime(for distance: Int) -> Int
    func travel(distance: Int)
}

struct Car: Vehicle {
    let name = "Car"
    var currentPassangers = 1
    
    func estimateTime(for distance: Int) -> Int {
        distance / 50
    }
    
    func travel(distance: Int) {
        print("imm driving \(distance)km")
    }
    
    func openSunroof() {
        print("It's a nice day")
    }
}

struct Bicycle: Vehicle {
    let name = "Bicycle"
    var currentPassangers = 1
    
    func estimateTime(for distance: Int) -> Int {
         distance / 10
    }
    
    func travel(distance: Int) {
        print("I'm Cycling \(distance)km")
    }
}

func commute(distance: Int, using vehicle: Vehicle) {
    if vehicle.estimateTime(for: distance) > 100 {
        print("That's too slow! I'll try a difference vehicle.")
    } else {
        vehicle.travel(distance: distance)
    }
}

func getTravelEstimates(using vehicles: [Vehicle], distance: Int) {
    for vehicle in vehicles {
        let estimate = vehicle.estimateTime(for: distance)
        print("\(vehicle.name): \(estimate) hours to travel \(distance)km")
    }
}

let car = Car()
commute(distance: 100, using: car)

let bike = Bicycle()
commute(distance: 50, using: bike)

getTravelEstimates(using: [car, bike], distance: 150)

///**Why does Swift need protocols?**
///- protocols let us create blueprints of how our types share functionality, then use those blueprints in our functions to let them work on a wider variety of data.
///- protocols are contracts that say - whatever type you are, you must have these properties/methods and swift enforces that for us
///- flexibility - without protocols a buy() func only works with one specific type - like book. but WITH a protocol that same function can accept a book, movie, car, coffee and anything  that adheres to the contract. you write the func once and it works everywhere
///- types can still have their own extras - a book can have an author, a car can have a manufacturer - the protocol only enforces the minimum. everything else is up to the individual type
///- protocols let you write code that works with the concept of a thing, not a specific thing
/// - The get only on distance and duration makes sense because you don't want to edit those after the workout is recorded — that data should be locked in. But caloriesBurned has get set because the app might want to recalculate it later based on updated user weight or heart rate data.

------------------------------------------------------------------------------
