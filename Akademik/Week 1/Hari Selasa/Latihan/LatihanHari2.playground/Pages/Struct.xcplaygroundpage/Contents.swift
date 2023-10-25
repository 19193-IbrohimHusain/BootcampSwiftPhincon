//: [Previous](@previous)

import Foundation

struct Person: Codable {
    let name: String
    let age: Int
    let marriedStatus: Bool
}

let jsonData = """
{
    "name": "nova",
    "age": 24,
    "marriedStatus": false
}
""".data(using: .utf8)!

do {
    let person = try JSONDecoder().decode(Person.self, from: jsonData)
    print(person)
} catch {
    print("Gagal menguraikan JSON: \(error)")
}

// buatkan struct dengan banyak tipe data dengan inisialisasi dan mempunyai method dengan equatable

enum DeadStatus{
    case alive
    case dead
}

struct Player {
    var playerName: String
    var hitPoint: Int
    var attackPower: Int
    var deadStatus: DeadStatus
    var items: [String]
    
    init(playerName: String, hitPoint:Int ,attackPoint: Int, experience: Int, items: [String]=[], attackPower: Int) {
        self.playerName = playerName
        self.hitPoint = hitPoint
        self.items = items
        self.attackPower = attackPower
        
        if self.hitPoint <= 0 {
                self.hitPoint = 0
                self.deadStatus = .dead
        } else {
                self.deadStatus = .alive
        }
    }
    
    mutating func takeDamage(enemy: Enemy){
        
        self.hitPoint = self.hitPoint - enemy.attackPower
        
        if(self.hitPoint <= 0){
            self.hitPoint = 0
            self.deadStatus = .dead
        }else{
            self.deadStatus = .alive
        }
    }
    
    mutating func getItem(enemy: Enemy){
        
        if(enemy.deadStatus == DeadStatus.dead){
            self.items.append(enemy.dropItems[Int.random(in: 0...enemy.dropItems.count - 1)])
        }
    }
}



struct Enemy {
    var enemyName: String
    var attackPower: Int
    var hitPoint: Int
    var dropItems: [String]
    var deadStatus: DeadStatus
    
    init(enemyName: String, attackPower: Int, hitPoint: Int, dropItems: [String]=["Rare Weapon", "Epic Weapon"]) {
        self.enemyName = enemyName
        self.attackPower = attackPower
        self.hitPoint = hitPoint
        self.dropItems = dropItems
        self.attackPower = attackPower
        self.deadStatus = DeadStatus.alive
    }
    
    mutating func takeDamage(player: Player){
        
        self.hitPoint = self.hitPoint - player.attackPower
        
        if(self.hitPoint <= 0){
            self.hitPoint = 0
            self.deadStatus = .dead
        }else{
            self.deadStatus = .alive
        }
    }
}

var enemyHitPoint = Int.random(in: 1000...2000)
var playerHitPoint = Int.random(in: 1000...2000)
var enemyAttackPower = Int.random(in: 200...300)
var playerAttackPower = Int.random(in: 200...300)

var player = Player.init(playerName: "Minerva", hitPoint: playerHitPoint, attackPoint: playerAttackPower, experience: 0, attackPower: playerAttackPower)
var enemy = Enemy.init(enemyName: "Slime", attackPower: enemyAttackPower, hitPoint: enemyHitPoint)

repeat {
    player.takeDamage(enemy: enemy)
    print("\(player.playerName) get hit by monster, current hit point is \(player.hitPoint)")
    enemy.takeDamage(player: player)
    print("\(enemy.enemyName) get hit by monster, current hit point is \(enemy.hitPoint)")
    
    if(player.deadStatus == DeadStatus.dead){
        print("You're dead")
        break
    }
    
    if(enemy.deadStatus == DeadStatus.dead){
        print("enemy is dead, you got an item")
        player.getItem(enemy: enemy)
        print("current items \(player.items)")
        break
    }
 
} while player.deadStatus == DeadStatus.alive || enemy.deadStatus == DeadStatus.alive


//: [Next](@next)
