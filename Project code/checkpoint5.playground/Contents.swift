import Cocoa

///checkpoint 5:
///- your input is this:
///      + let luckyNumbers = [7,4,38,21,16,15,12,33,31,49]
///- your job is to:
///      + filter out any numbers that are even
///      + sort the array in ascending order
///      + map them to sdtring s in the format "7 is a lucky number"
///      + print the resulting array, one item per line
///- output should be as follows:
///     7 is a lucky number
///     15 is a lucky number
///     21 is a lucky number
///     31 is a lucky number
///     33 is a lucky number
///     49 is a lucky number

let luckyNumbers = [7,4,38,21,16,15,12,33,31,49]

luckyNumbers
    .filter { $0 % 2 != 0 }
    .sorted { $0 < $1 }
    .map { print("\($0) is a lucky number")}


    


