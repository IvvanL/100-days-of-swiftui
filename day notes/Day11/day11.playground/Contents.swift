import Cocoa

//How to limit access to internal data using access control---------------------
/*
struct BankAccount {
    var funds = 0
    
    mutating func deposit(amount: Int) {
        funds += amount
    }
    
    mutating func withdraw(amount: Int) -> Bool {
        if funds > amount {
           funds -= amount
            return true
        } else {
            return false
        }
    }
}
*/
/*
var account = BankAccount()
account.deposit(amount: 100)

let success = account.withdraw(amount: 200)

if success {
    print("Withdrew money successfully")
} else {
    print("Failed to get the money")
}

account.funds -= 1000 //this shouldnt be allowed
*/

struct BankAccount {
    private(set) var funds = 0
    
    mutating func deposit(amount: Int) {
        funds += amount
    }
    
    mutating func withdraw(amount: Int) -> Bool {
        if funds > amount {
            funds -= amount
            return true
        } else {
            return false
        }
    }
}

var account = BankAccount()
account.deposit(amount: 100)
/*
private -- Dont let anything outside the struct use anything
fileprivate -- Dont let anything outside the current file use this
public -- let aqnyone, anywhere use this.
private(set) -- Dont let anyone outside the struct use this, but allow them to read it

- Essentially access control is how you hide or expose parts of your code. it lets you say "this data is private - only I can touch it or this is public - anyone can use it.
 - for example, a building:
 🏢 The lobby is open to everyone (public)
 🏢 The offices are open to employees only (internal)
 🏢 The CEO's files are locked away (private)
 
 
 
 ***private — Only this type can use it***
 Nothing outside the struct/class can see or touch it.
 
 example:
 struct BankAccount {
 private var balance: Double = 1000.0
 
 func showBalance() {
    print("Your balance is \(balance)") // ok - inside the struct
    }
 }
 
 let account = BankAccount()
 print(account.balance) // error-balance is private!
 
 
 
 ***fileprivate - Only this file can use it***
 anything in the saqme .swift file can access it, but nothing outside
 
 example:
 // File: Payments.swift
 
 struct Payment {
 fileprivate var transasctionID: String = "TXN-4892"
 }
 
 struct Receipt {
 func printReceipt() {
    let p = Payment()
    print(p.transactionID) // Ok - same file
 
 // file: Dashborad.swift
 let p = Payment()
 print(p.transactionID) // error - different file
 
 real wworld analogy: employees in the same department can share internal memos, but staff in another department cant see them
 
 
 
 ***internal - the whole module(default)
 this is the deault if you write nothing. the entire app/framework can use it, but outside code cannot
 
 example:
 struct userProfile {
    var username: String = "taylor_swift" // internal by default
 }
 
 
 
 ***public - anyone can use it, but cant override/subclass***
 used when building framework or libraries. other modules can use it but cant change its behavior
 
 example:
 public struct NetworkManager {
    public func fetchData() {...}
 }
 
 real world analogy: a librarys public API - developers can call your functions but cant modify how they work internally
 
 ***** private(set) *****
 super useful access control patern - it lets people read a value, but only your struct/class can write to it
 
 example:
 struct BankAccount {
    private(set) var balance: Double = 1000.0
 
    mutating func deposit(_ amount: Double) {
        balance += amount // we can change it internally
    }
 }
 
 var account = BankAccount()
 print(account.balance) // reading is fine
 account.balance = 9999 // error cant write from outside
 account.deposit(500) // use the proper method instead
 
 real world analogy: you can see how many likes a post has(read), but you cant directly set it to a million - you have to press the like button(the approved method)
 
  *Problem without access control*                *how access control helps*
 >other code accidentally breaks your data      >private keeps data safe
 >Hard to know whats safe to use       >clear public API tells you whats intended
 > bugs are hard to track down    >changes are funneled through controlled methods
 
 
 The golden rule: make everything private by default, and only open things up when you need to. This is called encapsulation and it's one of the foundations of good software design.
 */

//Static properties and methods---------------------

/* struct School {
    static var studentCount = 0
    
    static func add(student: String) {
        print("\(student) joined the school")
        studentCount += 1
    }
}

School.add(student: "Taylor Swift")
print(School.studentCount)
*/
  
// self --- the current value of a struct 55, "Hello", true
// Self --- the current type of struc Int, String, Bool

struct AppData {
    static let version = "1.3 beto 22"
    static let saveFilename = "settings.json"
    static let homeURL = "https://www,hackingwithswift.com"
}

struct Employee {
    let username: String
    let password: String
    
    static let example = Employee(username: "cfederighi", password: "h4irf0rceOne")
}

// What’s the point of static properties and methods in Swift?

//- one common use for static properties and methods is to store common functionality you use across an entire app.
//- The core idea: static means the property/method belongs to the type itself, not to any instance of it
// without static:
/// struct  School {
///     var name: String
/// }
/// let s = School(name: "Eton") // need an instance to access .name
///
/// with static:
/// struct App {
/// static let version = "1.0"
///}
///App.version // access directly, no instance needed

/// this is useful when the data is shared/global - not unique to each instance
/// A URL, an app version, an ID — these don't change per instance, so it makes no sense to attach them to one. You just want one copy, always accessible.


/* //// struct Unwrap {
 static let appURL = "https://itunes.apple.com/app/id1440611372"
 private static var entropy = Int.random(in: 1...1000)
 
 static func getEntropy() -> Int {
 entropy += 1
 return entropy
 }
 }
 
 ///for the unwrap example above ---
 /// - appURL - one shared URL, accesible anywhere as Unwrap.appURL
 /// - entropy - a single shared counter, priovate so nothing can mess with it directly
 /// - getEntropy() - the only way to reaqd entropy, and it nudges the value each time to avoid repeats
 
 /// ENUM TIP
 /// Since you never need to create an instance of Unwrap, Paul suggests using an enum with no cases instead of a struct. This prevents anyone from accidentally doing let u = Unwrap():
 
 /// enum Unwrap {
 static let appURL = "https://itunes.com"
 }
 
 /// same behaviour, but now the type is "instance-proof" - its only purpose is to hold shared static data
 
 ///                     can it change?
 /// static let ->           NO
 /// static var ->           YES
 /// let        ->           NO
 /// var        ->           YES
 
 /// static only means "BELONGS TO THE TYPE, NOT AN INSTANCE"
 
 /// summary: STRUCTS
 /// - Create own struct using the struct keyword
 /// - structs can have their own properties and methods
 /// - if a method modifies properties of its stuct, it must be mutating
 /// - structs can have stored properties and computed properties
 /// - we can attach didSet and willSet property observers to properties
 /// - swift generates an initializer for all structs using their property names
 /// - you can create custom initializers to override swifts default
 /// - access control limits what code can use properties and methods
 /// - static properties and methods are attached directly to a struct
