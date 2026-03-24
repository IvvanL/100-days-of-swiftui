import Cocoa

/// structs are one of the ways swift lets us create our own data types out of several small types

///1, how to create your own structs

/* struct Album {
    let title: String
    let artist: String
    let year: Int
    
    func printSummary() {
        print("\(title) (\(year)) by \(artist)")
    }
}

let red = Album(title: "red", artist: "Taylor Swift", year: 2012)
let wings = Album(title: "Wings", artist: "BTS", year: 2026)

print(red.title)
print(wings.artist)

red.printSummary()
wings.printSummary()

struct Employee {
    let name: String ///property of struct
    var vacationRemaining: Int ///property of struct
    
    mutating func takeVacation(days: Int) { ///methods of struct
        if vacationRemaining > days {
            vacationRemaining -= days
            print("I'm going on vacation!")
            print("Days remaining: \(vacationRemaining)")
        } else {
            print("oops! There arent enough days remaining!")
        }
    }
}
 

/// instance of struct
var archer = Employee(name: "Sterling Archer", vacationRemaining: 14)
                      ///initializer of struct ^^^
archer.takeVacation(days: 5)
print(archer.vacationRemaining)
 
///What’s the difference between a struct and a tuple?
///a tuple is effectively just a struct without a name, like an anonymous struct
///use tuples when you want to return two or more arbitrary pieces of values from a function, but prefer structs when you have some fixed data you want to send or receive multiple times.
///Tuple — quick, unnamed, throwaway grouping
///let person = ("Ivan", 25)
///print(person.0) // "Ivan"
///print(person.1) // 25
///Struct — a proper, reusable custom type
///struct Person {
///var name: String
///var age: Int

///func greet() {
///    print("Hi, I'm \(name)!")
///}
///}

///let ivan = Person(name: "Ivan", age: 25)
///ivan.greet() // "Hi, I'm Ivan!"

///Think of it this way:
///A tuple is like a sticky note — quick, temporary, no structure
///A struct is like a blueprint — rusable, named, can have methods


///What’s the difference between a function and a method?
///functions - stand alone, belong to no one
///func wakeUp() {
///print("Time to wake up!")
///}
///wakeUp() // called on its own

///methods - live inside a type, belong to it
///struct User {
///var name: String

///func wakeUp() {
    ///print("\(name) needs to wake up!") // can access name!
///}
///}

///let ivan = User(name: "Ivan"
///ivan.wakeUp() // called ON the user

///Functions are global and know nothing about your types
///Methods are owned by a type, can see its properties, and keep your code organized


///Why do we need to mark some methods as mutating?
///It’s possible to modify the properties of a struct, but only if that struct is created as a variable
///any time a struct’s method tries to change any properties, you must mark it as mutating
///Marking methods as mutating will stop the method from being called on constant structs, even if the method itself doesn’t actually change any properties
///A method that is not marked as mutating cannot call a mutating function – you must mark them both as mutating


///How to compute property values dynamically
///Structs can have two kinds of property: a stored property is a variable or constant that holds a piece of data inside an instance of the struct, and a computed property calculates the value of the property dynamically every time it’s accessed

*/
  
struct Employee {
    let name: String
    var vacationAllocated = 14
    var vacationTaken = 0
    
    var vacationRemaining: Int {
        get {
        vacationAllocated - vacationTaken
        }
        
        set {
            vacationAllocated = vacationTaken + newValue
        }
    }
}

var archer = Employee(name: "Sterling Archer", vacationAllocated: 14)
archer.vacationTaken += 4
archer.vacationRemaining = 5
print(archer.vacationAllocated)

/// When should you use a computed property or a stored property?

/// Properties let us attach information to structs, and Swift gives us two variations: stored properties, where a value is stashed away in some memory to be used later, and computed properties, where a value is recomputed every time it’s called. Behind the scenes, a computed property is effectively just a function call that happens to belong to your struct.

///computed property example
struct Wine {
    var age: Int
    var isVintage: Bool
    var price: Int {
        if isVintage {
            return age + 20
        } else {
            return age + 5
        }
    }
}
let malbec = Wine(age: 2, isVintage: true)
print(malbec.price)

struct Swordfighter {
    var name: String
    var introduction: String {
        return "Hello, my name is \(name)."
    }
}
let inigo = Swordfighter(name: "Inigo Montoya")

