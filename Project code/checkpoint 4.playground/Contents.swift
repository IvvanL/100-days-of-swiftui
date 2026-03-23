import Cocoa

enum SquareRootError: Error {
    case outOfBounds
    case noRoot
}

func integerSquareRoot(_ n: Int) throws -> Int {
    guard n >= 1 && n <= 10000 else {
        throw SquareRootError.outOfBounds
    }
    for i in 1...100 {
        if i * i == n {
            return i
        }
    }
    throw SquareRootError.noRoot
}

do {
    let result = try integerSquareRoot(99999)
    print(result)
} catch SquareRootError.outOfBounds {
    print("Out of bounds!")
} catch SquareRootError.noRoot {
    print("No integer square root found")
}

/// Simple validation + return
///Write a function that accepts an integer from 1 to 100. If the number is even, return it doubled. If the number is outside the range, throw an "out of bounds" error. If the number is odd, throw an "odd number" error.

enum DoubleNumberError: Error {
    case outOfBounds
    case oddNumber
}

func doubleIfEven(_ n: Int) throws -> Int {
    ///1. check bounds first
    guard n >= 1 && n <= 100 else {
        throw DoubleNumberError.outOfBounds
    }
    ///2. check if even, return doubled
    if n % 2 == 0 {
        return n * 2
    }
    ///3. if we get here, number must be odd
    throw DoubleNumberError.oddNumber
}

do {
    let result = try doubleIfEven(3)
    print(result)
} catch DoubleNumberError.outOfBounds {
    print("Out of bounds!")
} catch DoubleNumberError.oddNumber {
    print("Odd number error!")
}
///Error handling -> throws, throw, do/catch
///guard statements -> guard n >= 1 else { ... }
///type safety -> Int, -> Int
///enums for errors -> enum MyError: Error
