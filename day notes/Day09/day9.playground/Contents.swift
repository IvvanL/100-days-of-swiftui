import Cocoa

///Write a function called describeNumber that accepts an integer. If the number is positive, return the string "positive". If the number is negative, return the string "negative". If the number is zero, return the string "zero".

/* func describeNumber(_ n: Int) -> String {
    if n > 0 {
        return "Positive"
    } else if n < 0 {
        return "Negative"
    } else {
        return "Zero"
    }
}

print(describeNumber(-90))

// Regular function
func double(_ n: Int) -> Int {
    return n * 2
}

// Same thing as a closure
let double = { (n: Int) -> Int in
    return n * 2
}


func greetUser() {
    print("Hithere!")
}

greetUser()
var greetCopy = greetUser
greetCopy()

let sayHello = {
    print("Hi There")
}

sayHello()

 
///how to create and use closures

let sayHello = { (name: String) -> String in
        "Hi \(name)!"
}

func greetUser() {
    print("Hi there!")
}

var greetCopy: () -> Void = greetUser

func getUserData(for id: Int) -> String {
    if id == 1989 {
        return "Taylor Swift"
    } else {
        return "Anonymous"
    }
}

let data: (Int) -> String = getUserData
let user = data(1989)
print(user)


let team = ["Gloria", "Suzanne", "Piper", "Tiffany", "Tasha"]
let sortedTeam = team.sorted()
print(sortedTeam)
/// if we want suzanne to come first no matter what since shes team captain, follow the code below
func captainFirstSorted(name1: String, name2: String) -> Bool {
    if name1 == "Suzanne" {
        return true
    } else if name2 == "Suzanne" {
        return false
    }
    
    return name1 < name2
}

///let captainFirstTeam = team.sorted(by: captainFirstSorted)
///print(captainFirstTeam)

let captainFirstTeam = team.sorted(by: { (name1: String, name2: String) -> Bool in
    if name1 == "Suzanne" {
        return true
    }  else if name2 == "Suzanne" {
        return false
    }
    
    return name1 < name2
})

print(captainFirstTeam)


/* One of the most common reasons for closures in Swift is to store functionality – to be able to say “here’s some work I want you to do at some point, but not necessarily now.” Some examples:
 
 Running some code after a delay.
 Running some code after an animation has finished.
 Running some code when a download has finished.
 Running some code when a user has selected an option from your menu.
 
 Here’s a function that accepts a string and an integer:
 
 func pay(user: String, amount: Int) {
 // code
 }
 
 And here’s exactly the same thing written as a closure:
 
 let payment = { (user: String, amount: Int) in
 // code
 }
 
 here’s a closure that accepts one parameter and returns nothing:
 
 let payment = { (user: String) in
 print("Paying \(user)…")
 }
 
 Now here’s a closure that accepts one parameter and returns a Boolean:
 
 let payment = { (user: String) -> Bool in
 print("Paying \(user)…")
 return true
 }
 
 If you want to return a value without accepting any parameters, you can’t just write -> Bool in – Swift won’t understand what you mean. Instead, you should use empty parentheses for your parameter list, like this:
 
 let payment = { () -> Bool in
 print("Paying an anonymous person…")
 return true
 }
 
 */
 */

/// How to use trailing closures and shorthand syntax


let team = ["Gloria", "Suzanne", "Piper", "Tiffany", "Tasha"]

let captainFirstTeam = team.sorted {
    if $0 == "Suzanne" {
        return true
    } else if $1 == "Suzanne" {
        return false
    }
    return $0 < $1
}

let reverseTeam = team.sorted { $0 > $1 }

let tOnly = team.filter  { $0.hasPrefix("T") }
    print(tOnly)
  
let uppercaseTeam = team.map { $0.uppercased() }
print(uppercaseTeam)


///Why does Swift have trailing closure syntax?
///Trailing closures work best when their meaning is directly attached to the name of the function – you can see what the closure is doing because the function is called animate().

///Let’s start with a simple example first. Here’s a function that accepts a Double then a closure full of changes to make:

///func animate(duration: Double, animations: () -> Void) {
///    print("Starting a \(duration) second animation…")
///    animations()
///}

///We can call that function without a trailing closure like this:

///animate(duration: 3, animations: {
   /// print("Fade out the image")
///})
///
///Trailing closures allow us to clean that up, while also removing the animations parameter label. That same function call becomes this:

///animate(duration: 3) {
   /// print("Fade out the image")
///}


/// When should you use shorthand parameter names?
///When working with closures, Swift gives us a special shorthand parameter syntax that makes it extremely concise to write closures. This syntax automatically numbers parameter names as $0, $1, $2, and so on – we can’t use names such as these in our own code, so when you see them it’s immediately clear these are shorthand syntax for closures.

/* As for when you should use them it’s really a big “it depends”:
 
 Are there many parameters? If so, shorthand syntax stops being useful and in fact starts being counterproductive – was it $3 or $4 that you need to compare against $0 Give them actual names and their meaning becomes clearer.
 Is the function commonly used? As your Swift skills progress, you’ll start to realize that there are a handful – maybe 10 or so – extremely common functions that use closures, so others reading your code will easily understand what $0 means.
 Are the shorthand names used several times in your method? If you need to refer to $0 more than maybe two or three times, you should probably just give it a real name.
 What matters is that your code is easy to read and easy to understand. Sometimes that means making it short and simple, but not always – choose shorthand syntax on a case by case basis.
 
 
 Think of it like a nickname:
 Style
 ExampleFull -> name(a: Int, b: Int) -> Bool in a < b
 Nickname(shorthand) -> $0 < $1
 
 */

/// How to accept functions as parameters

func greetUser() {
    print("Hi there!")
}

greetUser()
var greetCopy: () -> Void = greetUser
greetCopy()

func makeArray(size: Int, using generator: () -> Int) -> [Int] {
    var numbers = [Int] ()
    
    for _ in 0..<size {
        let newNumber = generator()
        numbers.append(newNumber)
    }
    return numbers
}

let rolls = makeArray(size: 50) {
    Int.random(in: 1...20)
}

print(rolls)

func generateNumber() -> Int {
    Int.random(in: 1...20)
}

let newRolls = makeArray(size: 5, using: generateNumber)
print(newRolls)

/// we are going to write a function that accepts 3 function parameters, each of which accept no parameters and returns nothing

func doImportantWork(first: () -> Void, second: () -> Void, third: () -> Void) {
    print("About to start first work") // 1. prints this
    first()                             // 2. runs the first closure
    print("About to start second work")// 3. prints this
    second()                            // 4. runs second closure
    print("About to start third work") // 5. prints this
    third()                             // 6. runs third closure
    print("Done")                      // 7/ prints this
}

doImportantWork {
    print("Just getting started") // this runs when first() is called
} second: {
    print("About half way done") // this runs when second() is called
} third: {
    print("Almost there!") // this runs when third() is called
}

/// think of it like a recipe
///      step                               who controls it
/// print("about to start...") -------> the function itself
///first(), second(), third() ---------> the closures YOU passed in
///
///the function controls the order and the closures control the work. thats the power of passing closures as parameters

/// why closures exist:
///        REASON                                           REAL WORLD COMPARISON
///Dont freeze the UI                                       Restaurant - sit down, get called when ready
///handle slow taks                                         mail - keep working, get notified on arrival
///pass behavior around                                recipe - tell someone what to do when done
///
/// closures let you say "do this work, and when you're finished, HERE is what I want you to do next" without everything grinding to a halt while you wait.

/// examples
let helicopterTravel = {
    print("get to the chopper!")
}
func travel(by travelMeans: () -> Void) {
    print("Lets go on vacation...")
    travelMeans()
}
travel(by: helicopterTravel)

let evilRobot = {
    print("EXTERMINATE")
}
func buildRobot(personality: () -> Void) {
    print("Time to turn on the robot!")
    personality()
}
buildRobot(personality: evilRobot)

var goOnBike = {
    print("I'll take my bicycle")
}
func race(using vehicleType: () -> Void) {
    print("Let's Race!")
    vehicleType()
}

race(using: goOnBike)

var payCash = {
    print("Here's the money.")
}
func buyClothes(item: String, using payment: () -> Void) {
    print("I'll take this \(item).")
    payment()
}
buyClothes(item: "jacket", using: payCash)

let resignation = { (name: String) in
    print("Dear \(name), I'm outta here!")
}

func printDocument(contents: (String) -> Void) {
    print("Connecting to printer...")
    print("sending document...")
    contents("Boss")
}
printDocument(contents: resignation)

var learnWithUnwrap = {
    print("Hey, this is fun!")
}
func learnSwift(using approach: () -> Void) {
    print("I'm learning Swift")
    approach()
}
learnSwift(using: learnWithUnwrap)

///summary: closures
///- you can copy functions in swift
///- you can create closures directly by assigning to a constant or variables
///- closure parameters and return value are declared inside their braces
///- functions are able to accept other functions as parameters
///- anywhere you can pass a function, you can also pass a closure
///- when passing a closure as a function parameter, you dont need to write out the types inside your closure if Swift can figure it out
///- if a functions final parameters are function, use trailing closure syntax
///- you can also use shorthand parameter names such as 0$ and $1
///- you can make your own functions that accept functions as parameters
