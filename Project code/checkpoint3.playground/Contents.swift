import Cocoa

for i in 1...100 {
    if i.isMultiple(of: 3) && i.isMultiple(of: 5) {
        print("FizzBuzz")
    } else if i.isMultiple(of: 3) {
        print("Fizz")
    } else if i.isMultiple(of: 5) {
        print("Buzz")
    } else {
            print(i)
        }
    }

/* shorter code version
 for i in 1...100 {
var output = ""

if i.isMultiple(of: 3) { output += "Fizz" }
if i.isMultiple(of: 5) { output += "Buzz" }

print(output.isEmpty ? "\(i)" : output)
}
*/
