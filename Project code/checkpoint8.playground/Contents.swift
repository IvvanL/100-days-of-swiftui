import Cocoa

///** CHECKPOINT 8**

/// - make a protocol that describes a building
/// - your protocol should require the following:
///     + a property storing how many rooms it has
///     + a property storing the cost as an integer
///     + a property storing the name of the estate agent selling the building
///     + a method for printing the sales summary of the building
///= create 2 structs, House and Office, that conform to it
///
///train of thought:
/// + Protocol for Building needs to have rooms, cost, estate agent and sales summary
/// + House and Office strucs need to conform to said protocol minimum, but can have extra structs if needed.
/// + do any  of these get get or get set?
///         + rooms - {get} - readable, wont change
///         + cost - {get} - readable, wont change
///         + estate agent - {get set} - readable and changeable, since the estate agent can change (in this example)
///         + printSummary() - does not get get or get set since its a func

/// ---------------------------------------------------------------------------------------------

protocol Building {
    var rooms: Int { get }
    var cost: Int { get }
    var estateAgent: String { get set}
    func printSummary()
    }

extension Building {
    func printSummary() {
        print("This building has \(rooms) rooms")
        print("This building costs \(cost)")
        print("the real estate agent for this building is \(estateAgent)")
    }
}

struct House: Building {
    var rooms: Int
    var cost: Int
    var estateAgent: String
}

struct Office: Building {
    var rooms: Int
    var cost: Int
    var estateAgent: String
    }


let office = Office(rooms: 200, cost: 3000000, estateAgent: "Ivan Lara")
office.printSummary()

let house = House(rooms: 5, cost: 200000, estateAgent: "willis morris")
house.printSummary()
