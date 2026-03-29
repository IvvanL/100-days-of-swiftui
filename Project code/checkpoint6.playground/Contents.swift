import Cocoa

/// CHECKPOINT 6 Project
///- create a struct to store information about a car. Include:
/// + its model
/// + number of seats
/// + current gear
///- add a method to change gears up or down
///- have a think about variables and access control
///- dont allow invalid gears - 1...10 seems a fair maximum range.

///--------------------------------------------------------------------
/// Thought process..
/// car has a set number of seats that doesnt change after initial input
/// car has a set model that doesnt change after initial input
/// gears change constantly
/// whos allowed to change the gears (passanger can know what gear the driver is on but cant change it, only the driver-- private)
/// gears can only go up and down (enum for 2 cases, up and down)
//-------------------------------------------------------------------

struct Car {
    let model: String
    let seats: Int
    private(set) var currentGear: Int = 1 //anyone can READ currentGear but only struct can CHANGE it. just private wouldnt allow anyone in the car know what gear the car is in OR change it. private(set) allows the passanger to see the gear but not change it)
    
    enum GearDirection { //only 2 cases so enum is a good choice since both cases can be handled accurately
        case up, down
    }
    
    mutating func changeGear(_ direction: GearDirection) {
        switch direction {
        case .up:
            currentGear = min(currentGear + 1, 10)
            print("Shifted up to gear \(currentGear)") //added feedback to know which gear the user is on
        case .down:
            currentGear = max(currentGear - 1, 1)
            print("Shifted down to gear \(currentGear)") //added feedback to know which gear the user is on
        }
    }
}

var myCar = Car(model: "Nissan 400z", seats: 3)
myCar.changeGear(.up)
myCar.changeGear(.down)
myCar.changeGear(.down)


