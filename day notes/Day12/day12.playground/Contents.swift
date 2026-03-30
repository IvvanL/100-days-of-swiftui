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
