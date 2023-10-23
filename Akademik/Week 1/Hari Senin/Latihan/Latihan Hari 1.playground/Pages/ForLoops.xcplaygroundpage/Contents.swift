//: [Previous](@previous)

import Foundation

for index in 1...5 {
    print("\(index) times 5 is \(index * 5)")
}

let names = ["Anna", "Alex", "Brian", "Jack"]
for i in 0..<names.count {
    print("Person \(i + 1) is called \(names[i])")
}

for name in names[2...] {
    if name == "Bro" {
        print(name + "Gokilll")
    }
    else {
        print(name)
    }
}

for name in names[...2] {
    print(name)
}
//: [Next](@next)
