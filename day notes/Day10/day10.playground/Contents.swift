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

///How to take action when a property changes

/*
 -----------------------------------------------------------
 struct Game {
    var score = 0
    didSet {
        print("Score is now \(score)")
    }
  }
}

var game = Game()
game.score += 10
game.score -= 3
game.score -= 1
 -----------------------------------------------------------
 */

struct App {
    var contacts = [String]() {
        willSet {
            print("Current value is: \(contacts)")
            print("New value will be: \(newValue)")
        }
        
        didSet {
            print("There are now \(contacts.count) contacts")
            print("Old value was: \(oldValue)")
        }
    }
}

var app = App()
app.contacts.append("Adrian E")
app.contacts.append("Allen W")
app.contacts.append("Ish S")

/// property observers let you run code automatically whenever a propertys value changes
/// willSet ----- Just before the value changes
/// didSet ----- Just after the value changes

///BASIC EXAMPLE

var score: Int = 0 {
    willSet {
        print("Score is about to change to \(newValue)")
    }
    didSet {
        print("Score changed from \(oldValue) to \(score)")
    }
}

// inside willSet, swift gives you newValue - the value its about to become
// inside didSet, swift gives you oldValue - the value it used to be

/// THE MOST COMMON PATTERN: didSet
/// --didSet is used more often tha willSet

var lives: Int = 3 {
    didSet {
        if lives == 0 {
            print("Game Over!")
        }
    }
}

lives -= 1 //nothing happens
lives -= 1 //nothing happens
lives -= 1 //prints "Game over!"

/// Key Rules to Know
/// 1. they work on stored properties only, you can use willSet/didSet on computed properties (those use get/set)
/// 2. they dont fire on initialization, setting a property in ini() does not trigger observers - only subsequent changes do.
/// 3. you can rename newValue/oldValue

struct BankAccount {
    var balance: Double = 1000.0 {
        willSet {
            print("Balance will change from \(balance) to \(newValue)")
        }
        didSet {
            if balance < 0 {
                print("Warning: You're overdrawn")
            }
            print("Balance changed from \(oldValue) to \(balance)")
        }
    }
}

var account = BankAccount ()
account.balance = 500.0
account.balance = -50.0

///When should you use property observers?
/// The most important reason is convenience: using a property observer means your functionality will be executed whenever the property changes.

///When should you use willSet rather than didSet?
///most of the time you will be using didSet, because we want to take action after the change has happened so we can update our user interface, save changes, etc

///HOW TO CREATE CUSTOM INITIALIZERS
/// initializer are special functions inside structs -designed to create initial values  afor all the properties inside the struct

struct Player {
    let name: String
    let number: Int

init(name: String) { // no func, no explicit return type
    self.name = name
    number = Int.random(in: 1...99)
    }
}

let player = Player(name: "Megan R")
print(player.number)


///When would you use self in a method?
///An initializer is simply the function that runs at creation time to make sure everything gets a value
///By default, Swift gives structs a memberwise initializer — one that automatically accepts all properties as parameters. But sometimes you want more control over how an object is set up.
// By far the most common reason for using self is inside an initializer, where you’re likely to want parameter names that match the property names of your type, like this:

struct Student {
    var name: String
    var bestFriend: String
    
    init(name: String, bestFriend: String) {
        print("Enrolling \(name) in class...")
        self.name = name
        self.bestFriend = bestFriend
    }
}

//

// example:

struct  Coffee {
    var size: String
    var hasMilk: Bool
    var price: Double
    
    init(size: String) {
        self.size = size        //caller chooses the size
        self.hasMilk = false    //default: no milk
        self.price = 3.50       //always starts at 3.50
    }
}

let myCoffee = Coffee(size: "large")
// mycoffee.hasMilk = false
// mycoffee.price = 3.50

// The caller only had to say the size. The initializer handled the rest.

self.size = size
//    ^      ^
//property   parameter (what was passed in)
// self.size = property on the struct
// size(alone) = the value passed in by the caller

// The moment you write any custom init inside a struct, Swift takes away the automatic one. So if you want to keep both, put your custom one in an extension:

struct Coffee {
    var size: String
    var hasMilk: Bool
}

extension Coffee {
    init(size: String) {        // your custom one
        self.size = size
        self.hasMilk = false
    }
}
//now BOTH of these work:
let a = Coffee(size: "small")                   //custom
let b = Coffee(size: "small", hasMilk: true)    //original auto one

/// a custom initializer is just a function called init that runs when you create an object, letting you control exactly what values get set -- including providing defaults, doing calculations, or simplifying what the caller has to provide.
///
/// real world example:
///The Scenario
//When a user signs up, you collect:

//Their username (they choose it)
//Their email (they provide it)
//But some things you handle automatically:

//isVerified → always starts as false (they haven't verified email yet)
//joinDate → always today's date
//accountLevel → always starts as "basic"

/* Without a custom initializer (bad)
swiftstruct UserAccount {
    var username: String
    var email: String
    var isVerified: Bool
    var joinDate: Date
    var accountLevel: String
}

// The caller has to set EVERYTHING manually — messy and error-prone
let user = UserAccount(
    username: "sarah92",
    email: "sarah@email.com",
    isVerified: false,        // easy to forget or set wrong
    joinDate: Date(),         // caller shouldn't need to worry about this
    accountLevel: "basic"     // same here
)

 he caller has to know and set things they shouldn't need to care about. Someone could accidentally pass isVerified: true and bypass your verification system!

 With a custom initializer (good)
 swiftstruct UserAccount {
     var username: String
     var email: String
     var isVerified: Bool
     var joinDate: Date
     var accountLevel: String

     init(username: String, email: String) {
         self.username = username
         self.email = email
         self.isVerified = false       // you control this, not the caller
         self.joinDate = Date()        // automatically set to right now
         self.accountLevel = "basic"   // everyone starts basic
     }
 }

 // Now creating a user is clean and safe
 let user = UserAccount(username: "sarah92", email: "sarah@email.com")

 print(user.isVerified)    // false
 print(user.accountLevel)  // "basic"
 print(user.joinDate)      // today's date

*/

