import Cocoa

//How to limit access to internal data using access control
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
