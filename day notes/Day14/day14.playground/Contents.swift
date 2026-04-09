import Cocoa

///**DAY 14 - OPTIONALS**
///- in essence, an optional is trying to answer the question "what if our variable doesnt have any sort of valie at all?"
///- optionals: Swift forces you to acknowledge that a value might be missing before you can use it. You can't just pretend it's there. An optional is basically Swift asking "are you SURE this has a value? Prove it."
///- Optionals are Swift's way of making you deal with missing data properly instead of letting it silently crash your app.

/*
1. Optionals — a variable marked with ? that might have a value or might be nil
2. Unwrapping with if let — the safe way to check "does this have a value? If yes, use it"
3. Unwrapping with guard let — similar to if let but flips the logic — "if this has NO value, bail out early"
4. Nil coalescing ?? — provide a default fallback value if something is nil. Think of it as "use this, OR if it's nil, use that instead"
5. Optional chaining ?. — safely dig through multiple optionals in a chain without crashing
*/


///**Section 1. how to handle missing data with optionals**

let opposites = ["Mario" : "Wario", "Luigi" : "Waluigi"]
let peachOpposite = opposites["Peach"]

if let marioOpposite = opposites["Mario"] {
    print("Mario's opposite is \(marioOpposite)")
}

var username: String? = nil

if let unwrappedName = username {
    print("We got a user: \(unwrappedName)")
} else {
    print("The optional was empty.")
}

/*
var num1 = 1_000_000
var num2 = 0
var num3: Int? = nil

var str1 = "Hello"
var str2 = ""
var str3: String? = nil

var arr1 = [0]
var arr2 = [Int]()
var arr3: [Int]? = nil
*/
/*
func square(number: Int) -> Int {
    number * number
}

var number: Int? = nil

if let number = number {
    //valid
    
    
    
    print(square(number: number))
    
    
    //valid
}
*/
/// **why does swift have optionals?**

/// - swift optionals allow us to represent the absence of some data - a string that isnt just empty but literally doesnt exist
/// Any data type can be optional in swift:
/// + An integer might be 0, -1, 500, or any other range of numbers.
/// + An optional integer might be all the regular integer values, but also might be nil – it might not exist.
/// + A string might be “Hello”, it might be the complete works of Shakespeare, or it might be “” – an empty string.
/// + An optional string might be any regular string value, but also might be nil.
/// + A custom User struct could contain all sorts of properties that describe a user.
/// + An optional User struct could contain all those same properties, or not exist at all.

/// **Why does Swift make us unwrap optionals?**

///- As you might imagine, trying to add two numbers together is only possible if the numbers are actually there, which is why Swift won’t let us try to use the values of optionals unless we unwrap them – unless we look inside the optional, check there’s actually a value there, then take the value out for us.
///example:
    /// func getUsername() -> String? {
    /// "Taylor"
    ///}

    ///if let username = getUsername() {
    ///print("Username is \(username)")
    ///} else {
    ///print("No username")
    ///}

///- The getUsername() function returns an optional string, which means it could be a string or it could be nil. I’ve made it always return a value here to make it easier to understand, but that doesn’t change what Swift thinks – it’s still an optional string.

/// That single if let line combines lots of functionality:

///- It calls the getUsername() function.
///- It receives the optional string back from there.
///- It looks inside the optional string to see whether it has a value.
///- As it does have a value (it’s “Taylor”), that value will be taken out of the optional and placed into a new username constant.
///- The condition is then considered true, and it will print “Username is Taylor”.
///- So, if let is a fantastically concise way of working with optionals, taking care of checking and extracting values all at once.

///-----------------------------------------------------------------------------

///**Section 2.How to unwrap optionals with guard**
/*
func printSquare(of number: Int?) {
    guard let number = number else {
        print("Missing input")
        return
    }
    
    print("\(number) x \(number) is \(number * number)")
}

var myVar: Int? = 3

if let unwrapped = myVar {
    // Run if myVar has a value inside
}

guard let unwrapped = myVar else {
    //run if myVar doesnt have a value inside
}
*/
/// - swift requires you to use return if a guard check fails
/// - if the optional you're unwrapping has a value, you can use it after the guard code finishes

///**When to use guard let rather than if let**
///- both "if let" and "guard let" safely unwrap optionals, but they handle failure differently
///      + IF LET - wraps the success code inside a block. if the optional is nil, the blocj is skipped and the function keeps going. the unwrapped value only exists inside that block
///      + GUARD LET - flips this around. it says: "Check the condition up front - if it fails, bail out immediately (with a return). The unwrapped value then lives in the outer scope, available for everything that follows
/// - the practical rule is use IF LET when you just need to unwrap something and prefer GUARD LET when youre validating preconditions at the top of a function. GUARD LET keeps your "happy path" - the code that runs when everything works - at the top level instead of buried inside nested blocks

///----------------------------------------------------------------------------

///**Section 3.How to unwrap optionals with nil coalescing**
/*
let captains = [
    "Enterprise" : "Picard",
    "Voyaher" : "Janeway",
    "Defiant" : "Sisko"
]

let new = captains[ "Serenity", default: "N/A"]

let tvShows = ["Archer", "Babylon 5", "Ted Lasso"]
let favorite = tvShows.randomElement() ?? "None"

struct Book {
    let title: String
    let author: String?
}

let book = Book(title: "beowulf", author: "nil")
let author = book.author ?? "Anonymous"
print(author)

let input = ""
let number = Int(input) ?? 0
print(number)
*/

/// **When should you use nil coalescing in Swift?**

///- nil coalescing - is like saying "Go find my toy, but if its not there, just give me this other toy instead so im never left with nothing"
///-example:
///let savedData = first() ?? second() ?? ""
/// ^^^^^^^ the code above is saying, check my room for the toy. not there? check the living room. stil not there? ok, just use this backup toy
/// - a dictionary in coding is like a scoreboard with names and scores. if you ask someones score who isnt on the board, you'd get nothing - but with ?? you can say "if theyre not on the board, just give me a 0"
/// let crusherScore = scores["Crusher"] ?? 0
/// ?? makes sure you always end up with something real, never nothing

///----------------------------------------------------------------------------

///**Section 4.How to handle multiple optionals using optional chaining**

let names = ["Arya", "Bran", "Robb", "Sansa"]
let chosen = names.randomElement()?.uppercased() ?? "no one"
print("next in line: \(chosen)")
//"if the optional has a value inside, unwrap it then"

//example:
// we have an optional instance of a Book struct
// the book might have an author, or it might be anonymous
// if it has an author, attempt to read the first letter
// if the first letter is there, uppercase it

struct Book {
    let title: String
    let author: String?
}

var book: Book? = nil
let author = book?.author?.first?.uppercased() ?? "a"
print(author)

/// **Why is optional chaining so important?**
// - Optional chaining in swift lets you safely access properties or methods through multiple layers of optionals in a single line. If any part of the chain is nil , the whole expression returns nil instead of crashing.
// example:
// let names = ["Vincent": "van Gogh", "Pablo": "Picasso", "Claude": "Monet"]
// let surnameLetter = names["Vincent"]?.first?.uppercased()

//Returning to our surname example, we could automatically return “?” if we were unable to read the first letter of someone’s surname:

// let surnameLetter = names["Vincent"]?.first?.uppercased() ?? "?"

// - optional chaining uses ? to safely traverse multiple optional layers in one expression
// - if any layers is nil, the entire expression short-ciorcuits to nil
// - combine with ?? (nil coalescing) to provide a default fallback value
// - makes code cleaner and safer compared to manually unwrapping each optional

///----------------------------------------------------------------------------

///**Section 5.How to handle function failure with optionals**

enum UserError: Error {
    case badID, networkFailed
}

func getUser(id: Int) throws -> String {
    throw UserError.networkFailed
}

if let user = try? getUser(id: 23) {
    print("User: \(user)")
}

let user = (try? getUser(id: 23)) ?? "anonymous"
print(user)

/*
- try? lets you call a function that might fail, and turns the result into an optional instead of forcing you to handle the error.
- The three possible ways to call a throwing function:
 + try — you handle any errors with do/catch
 + try! — you're certain it won't fail (crashes if it does — use rarely!)
 + try? — you don't care why it failed, just whether it worked

 What try? does:
- If the function succeeds → you get the return value
- If the function fails → you get nil
- You lose the specific error details, but often that's fine

 Three common uses:
- With guard let — exit a function early if something fails
- With nil coalescing (??) — use a fallback value if it fails, e.g. (try? getUser(id: 23)) ?? "Anonymous"
- When calling a function that returns nothing and you truly don't care if it worked (e.g., logging, analytics)


 *** use try? when you only care about success vs. failure, not the reason for failure. It keeps your code clean and avoids the crash risk of try! */

///**When should you use optional try?**
///-If you want to run a function and care only that it succeeds or fails - you dont need to disgtinguish between the various reasons why it might fail - then using optional try is a gereat fit, because you can boil the whole thing down to "did it work?"
///- example:
///- rather than writing this:
/// do {
///     let result = try runRiskyFucntion()
///     print(result)
/// } catch {
/// // it failed!
/// }

/// you can instead write this:
/// if let result = try? runRiskyFucntion() {
///     print(result)
/// }


/// summary: OPTIONALS
///
///- optionals let us represent the absence of data, which means were able to say "this integer has no value" - thats different from a fixed number such as 0
///- Everything that isnt optional definitely has a value inside, even if thats just an empty string
///- unwrapping an optional is the process of looking inside a box to see what it contains: if theres a value inside its sent back for use, otherwise there will be nil inside
///- we can use if let to run some code if the optional has a value, or guard let to run some code if the optional doesnt have a value - but with guard we must alwauys exit the function afterwards
///- the nil coalescing operator, ??, unwraps and returns an optionals value, or uses a default value instead
///- optional chaining lets us read an optional inside another optional with a convenient syntax
///- if a function might throw errors you can convert it into an optional using try? - youll either get back the functions return value or nil if an error is thrown
