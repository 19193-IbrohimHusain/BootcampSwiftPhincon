import UIKit

func greet(person: String, greeting: (String) -> String) {
    let message = greeting(person)
    print(message)
}

func simpleGreeting(name: String) -> String {
    return "Hello, \(name)!"
}

greet(person: "Agus", greeting: simpleGreeting)

greet(person: "Agus") { name in
    return  "Hello, \(name)!"
}
print(greet(person: "Agus", greeting: simpleGreeting))

// variable closure
let perkalian: (Int, Int) -> Int = { (a, b) in
    return a * b
}

print(perkalian(5,3))

let daftarNama = ["Sutisno", "Sugeng", "Sutrisna", "Suep", "Sutarmin"]

let reversedName = daftarNama.sorted(by: {
    (s1: String, s2: String) -> Bool in
    return s1 > s2
})

print(reversedName)
