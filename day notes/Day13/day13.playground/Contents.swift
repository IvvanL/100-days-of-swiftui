import Cocoa

/// **Day 13 -- protocols and extensions**

///**SECTION 1. How to create and use protocols**

///func commute(distance: Int, using vehicle: Car) {
    // lots of code here
///}
/*
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
*/
 
 
 
///**Why does Swift need protocols?**
///- protocols let us create blueprints of how our types share functionality, then use those blueprints in our functions to let them work on a wider variety of data.
///- protocols are contracts that say - whatever type you are, you must have these properties/methods and swift enforces that for us
///- flexibility - without protocols a buy() func only works with one specific type - like book. but WITH a protocol that same function can accept a book, movie, car, coffee and anything  that adheres to the contract. you write the func once and it works everywhere
///- types can still have their own extras - a book can have an author, a car can have a manufacturer - the protocol only enforces the minimum. everything else is up to the individual type
///- protocols let you write code that works with the concept of a thing, not a specific thing
/// - The get only on distance and duration makes sense because you don't want to edit those after the workout is recorded — that data should be locked in. But caloriesBurned has get set because the app might want to recalculate it later based on updated user weight or heart rate data.

///--------------------------------------------------------------------------

///**SECTION 2. How to use opaque return types**
///- issue: protocols are great for hiding WHAT TYPE something is, but sometimes hiding the type breaks things.
///- fix: - some. adding SOME in front of a return type tells swift "im not going to spell out the exact type, but ttrust me its always the same one"
///- for swiftUI: - instead of writing that out, you just say- some view - "It's a view, figure out the rest yourselft swift"
///for example: Vehicle means "could be any vehicle", some vehicle means "It's one specific vehicle, i just dont want to tell you which"

protocol View {}

func getRandomNumber() -> some Equatable {
    Int.random(in: 1...6)
}

func getRandomBool() -> some Equatable {
    Bool.random()
}

print(getRandomNumber() == getRandomNumber())

///--------------------------------------------------------------------------

///**SECTION 3. How to create and use extensions**

///- extensions let you add new functionality to any type - your own, someone elses, or even apples built-in types like String or Int
///- extensions vs global funcs: you can write a regular func to do the same job, but extensions are better because
/// + xcode autocomplete will suggest them when you type . on a type <-- code completion
/// + they keep your code organized - grouped by the type they belong to <-- code organization
/// + they have full access to the types internal data <-- internal access

/// - mutating inside extensions: if you want to modify a value IN PLACE rather than return a new one, use mutating.
///     + tip: returning a new value -> use <ed/ing> endings (trimmed, reversed).
///     + changing in place -> drop the suffix (trim, sort)

/// -computed properties only: you can add properties in extensions, but they must be computed not stored. stored properties would change how much memory every instance ofd that type takes up - swift wont allow that
/// - sneaky initializer trick: normally adding a custom init to a struct kills the automatic memberwise initializer. but if you put your custom init in an extension instead, swift keeps both, your custom one AND the auto-generated one

///-------
extension String {
    func trimmed() -> String {
        self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    mutating func trim() {
        self = self.trimmed()
    }
    
    var lines: [String]  {
        self.components(separatedBy: .newlines)
    }
}

var quote = "   The truth is rarely pure and never simple   "
let trimmed = quote.trimmingCharacters(in: .whitespacesAndNewlines)
quote.trim()

let lyrics = """
but i keep cruising
Can't stop, wont stop
its like i got this music in my mind
saying its gonna be alright
"""
print(lyrics.lines.count)

struct Book {
    let title: String
    let pageCount: Int
    let readingHours: Int
}

extension Book {
    init(title: String, pageCount: Int) {
        self.title = title
        self.pageCount = pageCount
        self.readingHours = pageCount / 50
    }
}

let lotr = Book(title: "The Lord of the Rings", pageCount: 1178, readingHours: 24)
Book(title: "The prisoner of Azkaban", pageCount: 500)
///--------

///**When should you use extensions in Swift?**

///- extensions have 3 main cases:
///**1. adding to types you dont own** - you can add methods to Apples types like String, Int, Array - and they look native
///**2. conformance grouping** - keep protocol-related code together in its own extension block. instead of one massive jumbled struct, you split it clearly:
/// Struct User {
///     var name: String
///     var age: Int
///}
///
/// All printable stuff lives here
/// extension User: Printable {
///     func printDetails() { . . . }
///}
///
/// All saveable stuff lives here
/// extension User: Saveable {
///     func save() { . . . }
///     func load() { . . . }
///}
///
///**3. purpose grouping** - split a big type into  focused chunks by WHAT THEY DO
/// Networking stuff
/// extension User {
///     func fetchFromServer() { . . . }
/// }
///
///UI stuff
///extension User {
///     func formatForDisplay() { . . . }
///--------------------------------------------------------------------------

///**SECTION 4. How to create and use protocol extensions**
///- core idea: protocol extensions combine both protocols (contracts) and extensions (adding functionality) - you add functionality directly to a protocol, and every single type that conforms to it gets that functionality for free
///- why it matters: instead of copying the same code into extensions for Array, then Set, then Dictionary separately, you extend the protocol they all share (Collection) once, and they all benefit instantly.
///- default implementations: you can define a method in a protocol, then provide a default version of it in a protocol extension. conforming types can either use the default, or override it with their own version. They dont have to do anything if the default works for them.
///-  reaal world payoff: apple calls this PROTOCOL-ORIENTED PROGRAMMING. instead of building big class hierarchies, you define small focused protocols and extend them with default behaviors. SwfitUI is built almost entirely this way - view itself works exaclty like this.
///- one liner: a regular extension adds features to one type. A protocol extension adds features to every type that conforms to it - all at once.

extension Collection {
    var isNotEmpty: Bool {
        isEmpty == false
    }
}

let guests = ["Mario", "Luigi", "Yoshi"]

if guests.isNotEmpty {
    print("Guest count: \(guests.count)")
}

protocol Person {
    var name : String { get }
    func sayHello()
}

extension Person {
    func sayHello() {
        print("Hi, im \(name)")
    }
}

struct Employee: Person {
    let name: String
}

let taylor = Employee(name: "Taylor Swift")
taylor.sayHello()

///**When are protocol extensions useful in Swift?**
///- without protocols extension: if you want allSatisfy() to work on arrays, sets and dictionaries, you'd have to write the exact same method three separate times.
///- solution: all 3 types conform to a shared protocol called Sequence. write allSatisfy() one on Sequence and every type that conforms to it gets it instantly - arrays, sets, dictionaries, and anything else
///- protocol extensions let swifts debelopers write a method once and have it work everywhere, and you can do the exact same thing in your own code


///--------------------------------------------------------------------------

/// SUMMARY: Protocols and extensions
/// - protocols are like contracts for code
/// - opaque return types let us hide some information in our code
/// - extensions let us add functionality to existing types
/// - protocol extensions let us add functionality to many types all at once
