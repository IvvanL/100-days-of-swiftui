import Cocoa

/* let platforms = ["macOS", "iOS", "tvOS", "watchOS"]

for os in platforms {
    print("swift works great on \(os).")
}

for i in 1...12 {
    print("The \(i) times table")
    
    for j in 1...12 {
        print(" \(j) x \(i) is \(j * i)")
    }
    print()
}

for i in 1...5 {
    print("Counting from 1 through 5: \(i)")
}

for i in 1..<5 {
    print("Counting from 1 up to 5: \(i)")
}


var lyric = "Haters gonna"

for _ in 1...5 {
    lyric += " hate"
}

print(lyric)


let names = ["Alice", "Bob", "Charlie"]
for names in names {
    print("\(names) is a secret agent")
}

let names = ["Alice", "Bob", "Charlie"]
for _ in names {
    print("[CENSORED] is a secret agent")
}
*/

let names = ["piper", "alex", "susy", "steven", "curtis"]
print(names[0])
print(names[1...3])
print(names[1...])

 var countdown = 10

while countdown > 0 {
    print("\(countdown)...")
    countdown -= 1
}

print("Blast off")


let id = Int.random(in: 1...1000)
let amount = Double.random( in: 0...1)

var roll = 0

while roll != 20 {
    roll = Int.random(in:1...20)
    print("I rolled a \(roll)")
}

print("Critical hit!!!!! ")

var bottles = 10
while bottles > 0 {
    bottles -= 2
    print("\(bottles) green bottles.")
}

var position  = 5
while position > 0 {
    print("\(position)!")
    position -= 1
}

var averageScore = 2.5
while averageScore < 15.0 {
    averageScore += 2.5
    print("The average score is \(averageScore)")
}

var speed = 50
while speed <= 55 {
    print("Accelerating to \(speed)")
    speed += 1
}

var page: Int = 0
while page <= 5 {
    page += 1
    print("I'm reading page \(page).")
}

var pianoLesson = 1
while pianoLesson < 5 {
    print("this is lesson \(pianoLesson)")
    pianoLesson += 1
}

var cats: Int = 0
while cats < 10 {
    cats += 1
    print("im getting another cat.")
    if cats == 4 {
        print("Enough dam cats!")
        cats = 10
    }
}

var number: Int = 10
while number > 0 {
    number -= 2
    if number.isMultiple(of: 2) {
        print("\(number) is an even number")
    }
}

let filenames = ["me.jpg", "work.txt", "sophie.jpg"]

for filename in filenames {
    if filename.hasSuffix(".jpg") == false {
        continue
    }
    print("Found Picture: \(filename)")
}

let number1 = 4
let number2 = 14
var multiples = [Int]()

for i in 1...100_000 {
    if i.isMultiple(of: number1) && i.isMultiple(of: number2) {
        multiples.append(i)
        
        if multiples.count == 10 {
            break
        }
    }
}

print(multiples)

let scores = [1, 8, 4, 3, 0, 5, 2]
var count = 0

for score in scores {
    if score == 0 {
        break
    }
    count += 1
}

print("you had \(count) scores before you got 0.")


let options = ["up", "down", "left", "right"]
let secretCombination = ["up", "up", "right"]

outerLoop: for option1 in options {
    for option2 in options {
        for option3 in options {
            print("in Loop")
            let attempt = [option1, option2, option3]
            
            if attempt == secretCombination {
                print("The combination is \(attempt)!")
                break outerLoop
            }
        }
    }
}


// summary:
//- use if, else and else if statements to check conditions
//- you can combine conditions using ||(or) and && (and)
//- switch statements can be easier than using if and else if a lot
//- the ternary conditional operator  lets us check WTF: what?, true, false
//- for loops let us loop over arrays, sets, dictionaries, and ranges
//- while loops create loops that continue running until a condition is false
//- we can skip loop items using continue(skip the rest of the remaining iteration and go on to the next one) or break (exits the whole loop altogether)
