import Cocoa

func showWelcome() {
    print("well hello there")
    print("by default, this is a debug build")
    print("chartreuse is awesome")
    print("can also slow down your build")
}

showWelcome()

let number = 139

if number.isMultiple(of: 2) {
    print("even")
} else {
    print("odd")
}

let roll = Int.random(in: 1...20)

func printTimesTables(number: Int) {
    for i in 1...12 {
        print("\(i) * \(number) is \(i * number)")
    }
}

printTimesTables(number: 5)

/// 3 times you want to use functions
///- same functionality in many places
///- if you break up a function into 3 or 4 smaller functions then it becomes easier to follow
///- swift lets us build new functions out of existing functions. a technique called function composition. like lego bricks

/// - ask whether the function is doing too much work
/// - does it need all six parameters? could that function be split up into smalled functions that take fewer parameters?
/// - should those parameters be grouped somehow?

func shareToTwitter() {
    print("Sharing...")
}
shareToTwitter()

let root = sqrt(169)
print(root)

func rollDice() -> Int {
    return Int.random(in: 1...6)
}

// let result = rollDice()
print(result)


/// do 2 strings contain the same letters regardless of their order?
/// this function should:
/// + accept two string  parameters
/// + return true if their letters are the same
/// TIP: call sorted() on a string to get its letters in alphabetical order

func areLettersIdentical(string1: String, string2: String) -> Bool {
    string1.sorted() == string2.sorted()
}

func pythagoras(a: Double, b: Double) -> Double {
    sqrt(a * a + b * b)
}

let c = pythagoras(a: 3, b: 4)
print(c)

func sayHello() {
    return
}

func read(books: [String]) -> Bool {
    for book in books {
        print("I'm reading \(book)")
    }
    return true
}


///how to return multiple values from functions

func isUppercase(string: String) -> Bool {
    string == string.uppercased()
}

func getUser() -> (firstName: String, lastName: String) {
    (firstName: "Taylor", lastName: "Swift")
}
                   
let user = getUser()
print("Name: \(user.firstName) \(user.lastName)")

/// swift cant know ahead of time if dictionary keys are present
/// when you access tuple values, swift knows it will be there
/// we access values using user.firstName, not a string
/// dictionary might contain hundreds of other values

///arrays keep the order and can hace duplicates
///sets are unordered and can't have duplicates
///tuples have a fixed number of values of fixed types inside them
///
///if you wanto store a list of all words in a dictionary for a game, that has no duplicates and the order doesnt matter, you would go for a set
///if you want to store all the articles read b y a user, you would use a set if the order didnt matter (if all you cared about was whether they had read it or not), or use an array if the order did matter.
///if you want to store a list of high scores for a video game, that has an order that matters and might contain duplicates (if 2 players get the same score), you'd use an array
///if you want to store items for a todo list, that works best when the order is predicatble, you should use an array
///if you want to hold precisely 2 strings, or precisely two strings and an integer, or precisely 3 booleans or similar, you should use a tuple

func rollDice(sides: Int, count: Int) -> [Int] {
    var rolls = [Int]()
    
    for _ in 1...count {
        let roll = Int.random(in: 1...sides)
        rolls.append(roll)
    }
    
    return rolls
}
 
let rolls = rollDice(sides: 6, count:4)

let lyric = "I see a red door and i want it painted black"
print(lyric.hasPrefix("I see"))


func isUppercase(_ string: String) -> Bool {
    string == string.uppercased()
}

let string = "hello world"
let result = isUppercase(string)

func printTimesTable(for number: Int) {
    for i in 1...12 {
        print("\(i) x \(number) is \(i * number)")
    }
}

printTimesTable(for: 5)

/// the main reason for skipping a parameter name is when your function name is a verb and the first parameter is a noun the verb is acting on. EX:
/// Greeting a person would be greet(taylor) rather than greet(person: taylor)
//  Buying a product would be buy(toothbrush) rather than buy(item: toothbrush)
/// Finding a customer would be find(customer) rather than find(user: customer)

///This is particularly important when the parameter label is likely to be the same as the name of whatever you’re passing in:

///Singing a song would be sing(song) rather than sing(song: song)
///Enabling an alarm would be enable(alarm) rather than enable(alarm: alarm)
///Reading a book would be read(book) rather than read(book: book)

func bounceOnTrampoline(times: Int) {
    for _ in 1...times {
        print("Boing!")
    }
}

func climbMountain(_ name: String) {
    print("I'm going to climb \(name).")
}
climbMountain("Everest")
