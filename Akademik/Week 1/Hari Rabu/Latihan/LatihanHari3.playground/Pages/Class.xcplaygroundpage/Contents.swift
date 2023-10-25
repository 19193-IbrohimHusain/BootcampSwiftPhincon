class MathOperations {
    // Closure berbentuk property yang berfungsi untuk melakukan pertambahan
    var addClosure: (Int, Int) -> Int = { a, b in
        return a + b
    }
    
    // Closure berbentuk method yang berfungsi untuk melakukan pengurangan
    func subtractClosure(_ a: Int, _ b: Int, completion: (Int) -> Void) {
        let substractionResult = a - b
        completion(substractionResult)
    }
}

// Objek baru untuk mengakses class MathOperations
let math = MathOperations()

// Hasil penambahan menggunakan property closure
let additionResult = math.addClosure(5, 3)
print("Addition Result: \(additionResult)") // Output: Addition Result: 8

//Hasil pengurangan menggunakan method closure
math.subtractClosure(10, 3) { substractionResult in
    print("Subtraction Result: \(substractionResult)")
}

struct Bullet {
    let caliber: String
    let damage: Int
}

class Pistol {
    var magazine: [Bullet] = []

    init(bullets: [Bullet]) {
        magazine = bullets
    }

    func fire() {
        if magazine.isEmpty {
            print("Click! Out of ammo.")
        } else {
            let bullet = magazine.removeFirst()
            print("Bang! Fired a \(bullet.caliber) bullet causing \(bullet.damage) damage.")
        }
    }
}

extension Pistol {
    func reload(_ bullets: [Bullet]) {
        magazine += bullets
        print("Reloaded with \(bullets.count) bullets.")
    }
}

// Example usage:
let bullets: [Bullet] = [
    Bullet(caliber: "9mm", damage: 30),
    Bullet(caliber: ".45 ACP", damage: 45),
    Bullet(caliber: "5.56mm", damage: 20)
]

var myPistol = Pistol(bullets: bullets)
myPistol.fire()
myPistol.fire()
myPistol.reload([Bullet(caliber: "9mm", damage: 30)])
myPistol.fire()
