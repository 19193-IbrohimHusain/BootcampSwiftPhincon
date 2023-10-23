import Foundation

let possibleNumber = "123"

func checkGuardLet() {
    guard let number = Int(possibleNumber) else {
        fatalError("The number was invalid")
    }
    print(number)
}

checkGuardLet()
