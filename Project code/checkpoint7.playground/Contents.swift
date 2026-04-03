import Cocoa

///**CHECKPOINT 7**
///- make a class hierarchy for animals
///- start with Animal, add a legs property for the number of legs an animal has
///- make Dog a subclass of Animal, giving it a speak() method that prints a dog barking string, but each subclass should print something different
///- make Corgi and Poodle subclasses of dog
///- make Cat an Animal subclass. Add a speak() method, with each subclass oprinting something different, and an isTame Boolean, set with an initializer
///- Make Persian and Lion as subclasses of Cat

class Animal {
    var legs = 0
    
    init(legs: Int) {
        self.legs = legs
    }
}

class Dog: Animal {
    func speak() {
        print("I'm a dawg")
    }
}

class Corgi: Dog {
   override func speak() {
        print("WAAFF WAFFFF")
    }
}

class Poodle: Dog {
    override func speak() {
        print("YIPP YIPPP")
    }
}

class Cat: Animal {
    func speak() {
        print("I'm garfield")
    }
    var isTame: Bool
    
    init (isTame: Bool, legs: Int) {
        self.isTame = isTame
        super.init(legs: legs)
    }
}

class Persian: Cat {
    override func speak() {
        print("Purrr")
    }
    override init(isTame: Bool, legs: Int) {
        super.init(isTame: isTame, legs: legs)
    }
}

class Lion: Cat {
    override func speak() {
        print("ROAR..")
    }
    override init(isTame: Bool, legs: Int) {
        super.init(isTame: isTame, legs: legs)
    }
}


let corgi = Corgi(legs: 10)
corgi.speak()
print(corgi.legs)

let lion = Lion(isTame: false, legs: 20)
lion.speak()
print(lion.isTame)

///**What i learned**
///- class hierarchy and inheritance
///- properties with default values
///- overriding methods
///- initializers
///- chaining initializers
///- debugging
