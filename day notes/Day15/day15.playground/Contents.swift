////////////import Cocoa
/////////////*
///////////////** CONSTANTS AND VARIABLES
////////////
////////////var name = "ted"
////////////name = "rebecca"
////////////
////////////let user = "DAPHNE"
////////////print(user)
////////////
////////////
/////////////// **STRINGS
////////////
////////////let actor = "Tom Cruise"
////////////
////////////let quote = "He tapped a sign saying \"believe\" and walked away."
////////////
////////////let movie = """
////////////A day in
////////////the life of an
////////////apple engineer
////////////"""
////////////
////////////print(actor.count)
////////////
////////////print(quote.hasPrefix("He"))
////////////print(quote.hasSuffix("Away."))
////////////
/////////////// ** INTS
////////////
////////////let score = 10
////////////let higherScore = score + 10
////////////let halvedSCore = score / 2
////////////
////////////var count = 10
////////////counter += 5
////////////
////////////let number = 120
////////////print(number.isMultiple(of: 3))
////////////
////////////let id = Int.random(in: 1...1000)
////////////
/////////////// ** DOUBLES
////////////
////////////let score = 3.1
////////////
/////////////// ** BOOL
////////////
////////////let goodDogs = true
////////////let gameOver = false
////////////var isSaved = false
////////////isSaved.toggle()
////////////
/////////////// **STRING INTERPOLATION
////////////
////////////let name = "taylor"
////////////let age = 26
////////////let message = "I'm \(name) and im \(age) years old"
////////////print(message)
////////////
/////////////// ** ARRAYS
////////////
////////////var colors = ["Red", "Blue", "Yellow"]
////////////let numbers = [4, 8, 15, 26]
////////////var readings = [0.1, 0.4, 0.5]
////////////
////////////print(colors[0])
////////////print(readings[2])
////////////
////////////colors.append("Tartan")
////////////colors.remove(at: 0)
////////////print(colors.count)
////////////    
////////////print(colors.contains("Octarine"))
//////////// 
/////////////// ** DICTIONARY - store multiple values using keys we specify
////////////
////////////let employee = [
////////////    "name": "Taylor",
////////////    "job": "Singer"
////////////]
////////////
////////////print(employee["job", default: "Unknown"])
////////////
/////////////// ** SETS - similar to arrays, no duplicate items, dont store things in a particular order
////////////
////////////var numbers = Set([(1, 1, 3, 5, 7, 9])
////////////print(numbers)
////////////
////////////numbers.insert(10)
////////////numbers.contains(11)
////////////
/////////////// ** ENUMS - is a set of named values we can use that makes our code safer and more efficient
////////////
////////////enum Weekday {
////////////    case money, tueday, wednesday, thursday, friday
////////////}
////////////
////////////var day = Weekday.monday
////////////day = .friday
////////////
/////////////// ** Type annotation - force a specific type on a variable or constant
////////////
////////////var score: Double = 0
////////////
////////////let player: Sring = "Roy"
////////////let luckyNumber: Int = 13
////////////let pi: Double = 3.141
////////////var isEnabled: Bool = true
////////////
////////////var albums: Array<String> = ["Red", "Fearless"]
////////////// shorthand - var albums: [String] = ["Red", "Fearless"]
////////////var user: Dictionary<String, String> = ["id: "@twostraws"]
////////////// shorthand - var user: [String: String] = ["id: "@twostraws"]
////////////var books: Set<String> = Set(["The Bluest Eye", "foundation"])
////////////
////////////var teams: [String] = [String]() //empty collections
////////////var clues = [String] = [String]()v // shorthand
////////////                                        
////////////enum  UIStyle { // values of enums have the same type as the enum
////////////    case ligh, dark, system
////////////}
////////////
////////////var style: UIStyle = .light
////////////
//////////// 
/////////////// **CONDITIONS- cheks a variety of conditions
////////////
////////////let age = 16
////////////
////////////if age < 12{
////////////    print("You cant vote")
////////////} else if age < 18 {
////////////    print("You can vote soon")
////////////} else {
////////////    print("You can vote now")
////////////}
////////////
////////////let temp = 26
////////////
////////////if temp > 20 && temp < 30 {
////////////    print("It's a nice day.")
////////////}
////////////  
/////////////// ** SWITCH STATEMENTS - check a value against multiple conditions
////////////
////////////enum Weather {
////////////    case sun, rain, wind
////////////}
////////////
////////////let forecast = Weather.sun
////////////
////////////switch forecast {
////////////case .sun:
////////////    print("A nice day.")
////////////case .rain:
////////////    print("Pack an umbrella")
////////////default:
////////////    print("should be okay.")
////////////}
////////////
/////////////// ** Ternary Conditional Operator - checks a condition and returns either one item or the other depending on the result of that condition
////////////
////////////let age = 18
////////////let canVote = age >= 18 ? "Yes" : "No"
////////////print(canVote)
////////////   
/////////////// ** LOOPS - runs some code once for every item in an array, set or dictionary, or across a fixed range of numbers
////////////
////////////let platforms = ["iOS", "MacOS", "tvOS", "watchOS"]
////////////
////////////for os in platforms {
////////////    print("swift works on OS \(os)")
////////////}
////////////
////////////for i in 1...12 { // from 1-12 INCLUSIVE of 1 and 12
////////////    print("5 x \(i) is \(5 * i)")
////////////}
////////////
////////////var lyric = "Haters Gonna"
////////////
////////////for _ in 1...5 { // excludes the loop variable entirely
////////////    lyric += " hate"
////////////}
////////////
////////////print(lyric)
////////////
////////////var count = 10 // while loops - gives a condition and runs the loop body for as long as the condition is true
////////////while count > 0 {
////////////    print("\(count)...")
////////////    count -= 1
////////////}
////////////
////////////print("GO!")
////////////
////////////// you can use continue to skip a particular iteration of  a loop and go to the next iteration
////////////
////////////let files = ["me.jpg", "work.jpg", "sophie.jpg"]
////////////
////////////for file in files {
////////////    if file.hasSuffix(".jpg") == false {
////////////        continue
////////////    }
////////////    
////////////    print("Found picture: \(file)")
////////////}
////////////      
/////////////// ** FUNCTIONS
////////////
////////////func printTimesTable(number: Int) {
////////////    for i in 1...12 {
////////////        print("\(i) x \(number) is \(i * number)")
////////////    }
////////////}
////////////
////////////printTimesTable(number: 8)
////////////
////////////func rollDice() -> Int {
////////////    //return Int.random(in: 1...6)
////////////    // if the function has only a single line of code that returns our value, we can remove the "return" keyword entirely. see below
////////////    Int.random(in: 1...6)
////////////}
////////////
////////////let result = rollDice()
////////////print(result)
////////////   
/////////////// ** TUPLES - store fixed number of itesm of specific types, really convenient for returning multiple values from a function
////////////
////////////func getUser() -> (firstName: String, lastName: String) {
////////////    (firstName: "taylor", lastName: "swift")
////////////}
////////////
////////////let user = getUser()
////////////print("name: \(user.firstName) \(user.lastName)")
////////////
////////////// if you dont need all the values from a tuple you can destructure it, you can pull it apart into individual variables or constants, adn then optionally ignore the ones you dont want with _
////////////
////////////let (firstName, _) = getUser()
////////////print("name: \(firstName)")
////////////
/////////////// ** CUSTOMIZING PARAMETER LABELS - if you dont want to pass a parameters name into a function, put an underscore before it
////////////
////////////func isUppercase(_ String: String) -> Bool {
////////////    String == string.uppercased()
////////////}
////////////
////////////let string = "HELLO WORLD"
////////////let result = isUppercase(string)
////////////
////////////// alternative is to write a second name before the name, one for external use and one for internal use
////////////
////////////func printTimesTable(for number: Int) {
////////////    for i in 1...12 {
////////////        print("\(i) x \(number) is \(i * number)")
////////////    }
////////////}
////////////
////////////printTimesTable(for: 20)
////////////
/////////////// ** PROVIDING DEAFULT VALUES FOR PARAMETERS
////////////
////////////func greet(_ person: String, formal: Bool = false) {
////////////    if formal {
////////////        print("Welcome, \(person)")
////////////    } else {
////////////        print("Hi, \(person)")
////////////    }
////////////}
////////////
////////////greet("Tim", formal: true)
////////////greet("Taylor")
////////////
///////////////** HANDLING ERRORS IN FUNCTIONS - define the errors that can occur, write a function that throws 1 or more of those errors, call that function that handles the errors appropriately
////////////
////////////enum PasswordError: Error {
////////////    case short, obvious
////////////}
////////////
////////////func checkPassword(_ password: String) throws -> String {
////////////    if password.count < 5 {
////////////        throw PasswordError.short
////////////    }
////////////    
////////////    if password == "12345" {
////////////        throw PasswordError.obvious
////////////    }
////////////    
////////////    if password.count < 10 {
////////////        return "OK"
////////////    } else {
////////////        return "Good"
////////////    }
////////////}
////////////
////////////do {
////////////    let result = try checkPassword("12345")
////////////    print("Rating: \(result)")
////////////} catch PasswordError.obvious {
////////////    print("I have the same combination on my luggage!")
////////////} catch {
////////////    print("There was an error.")
////////////}
//////////// 
/////////////// ** CLOSURES -  assign functionality directly to a constant or variable
////////////
////////////let team = ["Gloria", "Susanne", "Tiffany", "Tasha"]
////////////
////////////let onlyT = team.filter({ (name: String) -> Bool in
////////////    return name.hasPrefix("T")
////////////})
////////////
////////////print(onlyT)
////////////
///////////////** TRAILING CLOSURES AND SHORTHAND SYNTAX - makes closure easier to read
////////////
////////////let team = ["Gloria", "Susanne", "Tiffany", "Tasha"]
////////////
////////////let onlyT = team.filter { $0.hasPrefix( "T")
////////////    // name.hasPrefix("T") // oonly has one line of code so we can remove the return keyword
////////////}
////////////
////////////print(onlyT)
//////////// 
/////////////// ** STRUCTS - let us make our own custom data types
////////////
////////////struct Album {
////////////    let title: String
////////////    let artist: String
////////////    var isReleased = true
////////////    
////////////    func printSummary() {
////////////        print("\(title) by \(artist)")
////////////    }
////////////    
////////////    mutating func removeFromSale() {
////////////        isReleased  = false
////////////    }
////////////    // if you want to have a struct method change one of its properties, you must mark it as mutating
////////////}
////////////
////////////let red = Album(title: "Red", artist: "Taylor Swift")
////////////print(red.title)
////////////red.printSummary()
////////////
///////////////** COMPUTED PROPERTY - calculates its value everytime its acessed
////////////
////////////struct Employee {
////////////    let name: String
////////////    var vacationAllowed = 14
////////////    var vacationTaken = 0
////////////    
////////////    var vacationRemaining: Int {
////////////        get {
////////////            vacationAllowed - vacationTaken
////////////        }
////////////        
////////////        set {
////////////            vacationAllowed = vacationTaken + newValue
////////////        }
////////////    }
////////////}
//////////
/////////////**PROPERTY OBSERVERS - are pieces of code that runs wehn a property changes. didSet, willSet
//////////
//////////struct Game {
//////////    var score = 0 {
//////////        didSet {
//////////            print("Score is now \(score)")
//////////        }
//////////    }
//////////}
//////////
//////////var game = Game()
//////////game.score += 10
//////////game.score -= 3
////////
///////////**CUSTOM INITIALIZERS - are special functions that run when a new instance of a struct is created.  it must make sure that all properties inside the struct have a value when it finishes. swift will make one of these automatically for your structs, called memberwise initializer, but you can make your own to have custom control as well
////////
////////struct Player {
////////    let name: String
////////    let number: Int
////////    
////////    init(name: String) {
////////        self.name = name
////////        number = Int.random(in: 1...99)
////////    }
////////}
////////
/////////**ACCESS CONTROL - has 4 of the most common
///////// - private - let nothing outside the struct read or write this (bank account balance)
///////// - private set - something outside can read it, only internal things can write it (instagram follower count)
///////// - file private - anything inside the current file can read and write it (a game score that multiple structs in the same file need to access)
///////// - public - let anyone anywhere read or write this (a weathers app temp reading)
//////
//////struct BankAccount {
//////    private(set) var funds = 0
//////    
//////    mutating func deposit(amount: Int) {
//////        funds += amount
//////    }
//////    
//////    mutating func withdrwaw(amount: Int) -> Bool {
//////        if funds > amount {
//////            funds -= amount
//////            return true
//////        } else {
//////            return false
//////        }
//////    }
//////}
//////
//////let account = BankAccount(funds: 100)
//////print(account.funds) //can read funds
//////account.funds += 1000 // cant add funds
////
///////**STATIC PROPERTIES AND METHODS -swift supports static properties and methods. allowing us to add them directly to a struct type rather than a perticular instance of a struct
////
////struct AppData {
////    static let version = "1.3 beta 2"
////    static let settingsFile = "settings.json"
////}
////
////print(AppData.version)
//
/////**CLASSES - let us create custom data types like structs. but are different than structs in 5 key ways:
///// 1. when you make a class you can make it inherit from or build apon another instance class. it will get all the properties and methods of that parent class
//class Employee {
//    let hours: Int
//    
//    init(hours: Int) {
//        self.hours = hours
//    }
//    
//    func printSummary() {
//        print("I work \(hours) hours a day.")
//    }
//}
//
//class Developer: Employee {
//    func work() {
//        print("I'm coding for \(hours) hours a day.")
//    }
//    
//    override func printSummary() { //must use override if you would like the child class to change a method it got from the parent class
//        print("I spend \(hours) hours a day fighting over tabs vs spaces.")
//    }
//}
//
//let novall = Developer(hours: 8)
//novall.work()
//novall.printSummary()
//
/////2. swift will never make a generated initializer for our classes.
/////3. if a subclass has no custom initializer, it will automtically inherit all those from its parent
//
//class Vehicle {
//    let isElectric: Bool
//    
//    init(isElectric: Bool) {
//        self.isElectric = isElectric
//    }
//}
//
//class Car: Vehicle {
//    let isConvertible: Bool
//    
//    init(isElectric: Bool, isConvertible: Bool) {
//        self.isConvertible = isConvertible
//        super.init(isElectric: isElectric)
//    }
//}
//
//class Actor {
//    var name = "Nicolas Cage"
//}
//
//var actor1 = Actor()
//var actor2 = actor1
//
//actor2.name = "Tom Cruise"
//print(actor1.name)
//print(actor2.name)
//
///// 4. classes can have a deinitializer if they need to, when the last referenced object is destroyed, as we run automatically by our system
//
//class Site {
//    let id: Int
//    
//    init(id: Int) {
//        self.id = id
//        print("Site \(id): Iv'e been created")
//    }
//    
//    deinit {
//        print("Site \(id): Iv'e been destroyed")
//    }
//}
//
//for i in 1...3 {
//    let site = Site(id: i)
//    print("Site \(site.id): Im in control!")
//}
//
//// classes let us change variable properties even if the class instance itself is constant
//
//class Singer {
//    var name = "adele"
//}
//
//let singer = Singer()
//singer.name = "Justin"
//print(singer.name)
//

///**PROTOCOLS - define functionality we expect other types to support

protocol Vehicle {
    var name: String { get } // must be a string, marked get, might be a constant or a computed property
    var currentPassangers: Int { get set} // must be an integer,. read and write, might be a variable, or a computed property with a getter and a setter
    // protocols can also require properties if needed, see code above
    // now all conforming types must add those 2 properties
    func estimateTime(for distance: Int) -> Int
    func travel(distance: Int)
}

struct Car: Vehicle {
    let name = "Car" // required property from Vehicle
    var currentPassangers = 1 // required property from Vehicle
    
    func estimateTime(for distance: Int) -> Int {
        distance / 50
    }
    
    func travel(distance: Int) {
        print("I'm driving \(distance)km")
    }
    
    func openSunroof() {
        print("It's a anice day!")
    }
}

func commute(distance: Int, using vehicle: Vehicle) {
    if vehicle.estimateTime(for: distance) > 100 {
        print("Too Slow!")
    } else {
        vehicle.travel(distance: distance)
    }
}

let car = Car()
commute(distance: 100, using: car)
