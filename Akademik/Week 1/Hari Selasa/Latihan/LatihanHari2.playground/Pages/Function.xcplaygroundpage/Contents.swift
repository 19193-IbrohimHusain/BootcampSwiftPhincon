//: [Previous](@previous)

import Foundation

//fungsi tidak menghasilkan return

func prinData(with name: String){
    print(name)
}

func printData(with name: String, age: Int){
    print("nama saya \(name), umur saya \(age)")
}

func add(number: Int) -> (Int, Int, Int) {
    let added = number + number + number
    return (added, added, added)
}

add(number: 5)

enum DayOfWeek: String {
    case sunday = "Sunday"
    case monday = "Monday"
    case tuesday = "Tuesday"
    case wednesday = "Wednesday"
    case thursday = "Thursday"
    case friday = "Friday"
    case saturday = "Saturday"
}

func getDayOfWeek() -> DayOfWeek {
    let today = "Monday"
    
    if let day = DayOfWeek(rawValue: today) {
        return day
    } else {
        return .sunday
    }
}

let currentDay = DayOfWeek.friday

switch currentDay {
case .saturday,.sunday:
    print("Hari Libur")
case .monday, .tuesday, .wednesday:
    print("Hari Kerja")
default:
    print("Cuti")
}

// fungsi yang mereturn fungsi lagi
func tambah () -> (Int, Int) -> Int {
    func penjumlahan(a: Int, b: Int) -> Int{
        return a + b
    }
    
    return penjumlahan
}

let penjumlahan = tambah()
print(penjumlahan(5, 3))


// fungsi dengan banyak return values

func minMax(array: [Int]) -> (min: Int, max: Int) {
    var currentMin = array[0]
    var currentMax = array[0]
    for value in array[1..<array.count] {
        if value < currentMin {
            currentMin = value
        } else if value > currentMax {
            currentMax = value
        }
    }
    return (currentMin, currentMax)
}

print("angka array terbesar : \(minMax(array: [2,3,4,5]).max)")
print("angka array terkecil : \(minMax(array: [2,3,4,5]).min)")


// optional tuple return

func minMax(array: [Int]) -> (min: Int, max: Int)? {
    if array.isEmpty { return nil }
    var currentMin = array[0]
    var currentMax = array[0]
    for value in array[1..<array.count] {
        if value < currentMin {
            currentMin = value
        } else if value > currentMax {
            currentMax = value
        }
    }
    return (currentMin, currentMax)
}
print("angka array terbesar : \(minMax(array: [2,3,4,5]).max)")
print("angka array terkecil : \(minMax(array: [2,3,4,5]).min)")

//: [Next](@next)
