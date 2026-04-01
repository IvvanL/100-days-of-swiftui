import Cocoa

/// **classes are different from structs because they introduce a new feature called inheritance - the ability to make one class build on the foundations of another**
/// when you show data from some object on the creen or when you pass data bertween your layouts, youll usually be using classes

///**1. how to create your own classes**

/// - you get to create and name them
/// - add properties, methods, property observers, and access control
/// - create custom initializers to configure new instances

/// you can make one class build upon functionality in another class
/// swift wont generate a memberwise initializer for classes
/// if you copy an instance of a class, both copies share the same data
/// we can add a deinitializer to run when the final copy is destroyed
/// constant class instances can have their variable properties changed

class Game {
    var score = 0 {
        didSet {
            print("score is now \(score)")
        }
    }
}

var newGame = Game()
newGame.score += 10

/// **Why does Swift have both classes and structs?**
/// 5 important differences:
/// - classes do not come with synthesized memberwise initializers
/// - one class can be built upon ("inherit from") another class, gaining its properties and methods
/// - copies of structs are always unique, whereas copies of classes actually point to the same shared data
/// - classes have deinitializers, which are methods that are called when an instance of the class is destroyed, but structs do not
/// - variable properties in constant classes can be modified freely, but variable properties in constant structs cannot


///**2. how to make one class inherit from another**

class Employee {
    let hours: Int
    
    init(hours: Int) {
        self.hours = hours
    }
    
    func printSummary() {
        print("I work \(hours) hours a day")
    }
}

final class Developer: Employee {
    func work() {
        print("I'm writing code for \(hours) hours.")
    }
    
    override func printSummary() {
        print("I'm a developer who will sometimes work \(hours) hours a day, but other times will spend hours arguing about whether code should be indented using tabs or spaces.")
    }
}

class Manager: Employee {
    func work() {
        print("I'm going to meetings for \(hours) hours.")
    }
}

let robert = Developer(hours: 8)
let joseph = Manager(hours: 10)
robert.work()
joseph.work()

let novall = Developer(hours: 8)
novall.printSummary()

///**When would you want to override a method?**
///- you can keep all the behavior you want and just change one or two little parts in a custom subclass
///- swift makes us use the override keyword before overriding functions, which is really helpful:
///- If you use it when it isn’t needed (because the parent class doesn’t declare the same method) then you’ll get an error. This stops you from mistyping things, such as parameter names or types, and also stops your override from failing if the parent class changes its method and you don’t follow suit.
///- If you don’t use it when it is needed, then you’ll also get an error. This stops you from accidentally changing behavior from the parent class.

///**Which classes should be declared as final?**
/// - final calsses are ones that cannot be inherited from, which means its not possible for users of your code to add functionality or change what they have.
/// - final classes is not the default-- you must opt in to this behavior by adding the final keyword to your class


///**3. how to add initializers for classes**

class Vehicle {
    let isElectric: Bool
    
    init(isElectric: Bool) {
        self.isElectric = isElectric
    }
}

class Car: Vehicle {
    let isConvertible: Bool
    
    init(isElectric: Bool, isConvertible: Bool) {
        self.isConvertible = isConvertible
        super.init(isElectric: isElectric)
    }
//if a child class doest not have any of its own initializers, it will inherit the initializers of its parent class.
}

let teslaX = Car(isElectric: true, isConvertible: false)

///**4. how to copy classes classes**
/// In Swift, all copies of a class instance share the same data, meaning that any changes you make to one copy will automatically change the other copies.

/* class User {
    var username = "Anonymous"
    
    func copy() -> User {
        let user = User()
        user.username = username
        return user
    }
}

var user1 = User()
var user2 = user1.copy()
user2.username = "Taylor"

print(user1.username)
print(user2.username)
*/
///**Why do copies of a class share their data?**
///- behaviors of its classes and structs differ when they are copied: copies of the same class share their underlying data, meaning that changing one changes them all, whereas structs always have their own unique data, and changing a copy does not affect the others
///- structs -> value types
///- classes -> reference types

///**5. How to create a deinitializer for a class**
/// 1. you dont use func with deinitialiZers
/// 2. deinitializers can never take parameters or return data
/// 3. deinitializers run when the last copy of a class instance is destroyed
/// 4. we never call deinitializers directly
/// 5. structs dont have deinitializers

class User {
    let id: Int
    
    init(id: Int) {
        self.id = id
        print("User \(id): I'm Alive!")
    }
    
    deinit {
        print("User \(id): I'm dead!")
    }
}

for i in 1...3 {
    let user = User(id: i)
    print("user \(user.id): I'm in control!")
}

/// Rule     --------------------- Detail
/// Only for classes         -> structs and enums dont have deinit
/// no parameters           -> you cant pass anything into deinit
/// called automatically   -> swift handles it, you never call deinit yourself
/// one per class             -> you can only have a single deinit
///
/// whats it used for?
/// cleanup tasks before the object disappears, for example:
///
/// class FileManager {
///     deinit {
///     closeFile()       // close an open file
///     saveData()     // save any unsaved data
///     disconnect()  // close a network connection
///
///real world example:
///Chat App — Active Call Screen
/*
 ///class CallSession {
 var participant = ""
 var callDuration = 0
 
 init(participant: String) {
 self.participant = participant
 print("Call started with \(participant)")
 // connect to server
 // turn on microphone
 // start camera
 }
 
 deinit {
 print("Call ended")
 disconnectFromServer()   // drop the connection
 turnOffMicrophone()      // release mic
 turnOffCamera()          // release camera
 saveCallToHistory()      // log the call duration
 }
 }
 
 How it Plays Out
 
 var call: CallSession? = CallSession(participant: "Mom")
 // "Call started with Mom"
 // microphone on, camera on, server connected
 
 // ... user is on the call ...
 
 call = nil
 // user hangs up
 // "Call ended"
 // mic off, camera off, server disconnected, call logged
 
 without deinit the app could end up with some problems:
 
 forgotten cleanup                     consequence
 - mic not released         ->         other apps cant use the mic
 - server not disconnected  ->         battery drain, data usage
 - call not saved           ->         missing chat history
*/

///**Why do classes have deinitializers and structs don’t?**
/// structs dont have deinitializers
/// Behind the scenes Swift performs something called automatic reference counting, or ARC. ARC tracks how many copies of each class instance exists: every time you take a copy of a class instance Swift adds 1 to its reference count, and every time a copy is destroyed Swift subtracts 1 from its reference count. When the count reaches 0 it means no one refers to the class any more, and Swift will call its deinitializer and destroy the object.

/// he simple reason for why structs don’t have deinitializers is because they don’t need them: each struct has its own copy of its data, so nothing special needs to happen when it is destroyed.

///**6.How to work with variables inside classes**
