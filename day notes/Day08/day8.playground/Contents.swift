import Cocoa

///how to provide default values for parameters

func printTimesTables(for number: Int , end: Int = 12) {
    for i in 1...end {
        print("\(i) x \(number) is \(i * number)")
    }
}

printTimesTables(for: 5, end: 20)
printTimesTables(for: 8)

var characters = ["lana", "pam", "ray", "rebecca"]
print(characters.count)
characters.removeAll(keepingCapacity: true)
print(characters.count)

enum PasswordError: Error {
    case short, obvious
}

func checkPassword(_ password: String) throws -> String {
    if password.count < 5 { throw PasswordError .short }
    if password == "12345" { throw PasswordError.obvious }
    
    if password.count < 8 {
        return "OK"
    } else if password.count < 10 {
        return "Good"
    } else {
        return "Excellent"
    }
}

let string = "12345"

do {
    let result = try checkPassword(string)
       print("Password Rating: \(result)")
} catch   {
    print("There was an error")
}

/// functions reuse code by caqrving off chunks and giving it a name
/// funcs start with the word func, followed by the functions nqame
/// funcs can accept parameters to control their behavior
/// you can add custom external parameter names, or use _ to skiip one
/// _Function p[arameters can have default   values for common scenarios
/// functions can optionally return a value, but you can return multiple pieces of data from a function using a tuple
/// functions can throw errors using do, try, and catch
