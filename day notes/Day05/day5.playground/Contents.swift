import Cocoa

/* var characters = ["lana" ,  "ivan" , "esther"]
print(characters.count)

characters.remove(at:2)
print(characters.count)

characters.removeAll()
print(characters.count)

let bondMovies = ["casino royale" , "golden eye" , "no time to die"]
print(bondMovies.contains("frozen"))

let cities = ["london" , "tokyo" , "rome" , "budapest"]
print(cities.sorted())

let presidents = ["bush" , "obama" , "trump" , "biden"]
let reversedPresidents = presidents.reversed()
print(reversedPresidents)

var actors = Set<String>()
actors.insert("denzel washington")
actors.insert("Tom Cruise")
actors.insert("Nicolas cage")
actors.insert("Samuel jackson")
print(actors)

enum Weekday {
    case monday, tuesday, wednesday, thursday, friday}

var day = Weekday.monday
day = Weekday.tuesday
day = Weekday.friday


let items = ["apple" , "banana" , "orange"]
print(items.count)

var colors = Set(["red", "yellow", "blue", "green", "black"])
print(colors.count)

let score = 85

if score > 80 {
    print("good fucking job")
}

let speed = 88
let percentage = 85
let age = 18

if speed >= 88 {
    print ("where we're going i dont need a dam road")
}

if percentage < 85 {
    print("you failed sucka")
}

if age >= 18 {
    print("You're eligible to vote")
}

let ourName = "dave"
let friendName = "ivan lara"

if ourName < friendName {
    print("It's \(ourName) vs \(friendName)")
}

if ourName > friendName {
    print("It's \(friendName) vs \(ourName)")
}

var numbers = [1, 2, 3]
numbers.append(4)

if numbers.count > 3 {
    numbers.remove(at:0)
}

print(numbers)

let country = "canada"

if country == "australai" {
    print("g day mate")
}

let name = "taylor swee"

if name != "anonymous" {
    print("welcome, \(name)")
}

var username = ""

if username.isEmpty {
    username = "anonymous"
}

print("welcome, \(username)")

enum Sizes: Comparable {
    case small, medium, large
}

let first  = Sizes.medium
let second = Sizes.large
print(first > second)


let age  = 16

if age >= 18 {
    print("You can vote in the next election")
} else {
    print("sorry, you're too young to vote")
}

if a {
    print("Code to run if a is true")
} else if b {
    print("Code to run if a is false but b is true")
} else {
    print("Code to run if both a and b are false")
}

let temp = 25

if temp > 20 && temp < 30 {
        print("It's a nice day after all...isn't it")
    }

let userAge = 14
let hasParentalConsent = true

if userAge >= 18 || hasParentalConsent {
    print("You can get the fuckin game son")
}

enum transportOption {
    case airplane, helicopter, bicycle, car, escooter
}

let transport = transportOption.bicycle

if transport == .airplane || transport == .helicopter {
    print("Let's fly")
} else if transport == .bicycle {
    print("I hope there's a bike path...")
} else if transport == .car {
    print("Time to get stuck in traffic")
} else {
    print("im going to hire a scooter now")
}

let score = 8999

if score > 9000 {
    print("ITS OVER 9000!")
} else if score == 9000 {
         print("ITS EXACTLY 9000!")
} else {
         print("WOW YOU ARE WEAK AS HELL")
}


if isOwner == true || isAdmin == true {
    print("You can delete this post")
}

 
 
enum Weather {
    case sun, rain, wind, snow, unknown
}

let forecast = Weather.unknown

switch forecast {
case .sun:
    print("it should be a nice day")
case .rain:
    print("pack an umbrella")
case .wind:
    print("wear something warm")
case .snow:
    print("school is cancelled")
case .unknown:
    print("this thing is broken mang")
}

let place = "metropolos"

switch place {
case "Gotham":
    print("You are batman")
case "mega-city One":
    print("you are judge dredd")
case "Wakanda":
    print("You are black panther")
default:
    print("Who the heck are you")
}

let day = 5
print("My true love gave to me...")

switch day {
case 5:
    print("5 golden rings")
    fallthrough
case 4:
    print("4 calling birds")
    fallthrough
case 3:
    print("3 French hens")
    fallthrough
case 2:
    print("2 turtle doves")
    fallthrough
default:
    print("a partridsge in a pear tree")
}
 */

//Ternary conditional operator
let age = 18
let canVote = age >= 18 ? "Yes" : "no"
// condition > reply for true or reply for false
// what we're checking: what, is it true or false
print(canVote)

let hour = 23
print(hour < 12 ? "It's before noon" : "It's after noon")

let names = ["Jayne", "Kaylee", "Mal"]
let crewCount = names.isEmpty ? "no one" : "\(names.count) people"
print(crewCount)


enum Theme {
    case light, dark
}

let theme = Theme.light

let background = theme == .dark ? "black" : "white"
print(background)
