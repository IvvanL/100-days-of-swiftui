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

func square(number: Int) -> Int {
    number * number
}

var number: Int? = nil

if let number = number {
    //valid
    
    
    
    print(square(number: number))
    
    
    
    //valid
}

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
