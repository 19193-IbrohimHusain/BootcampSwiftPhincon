//: [Previous](@previous)

import Foundation

enum DeadStatus {
    case alive
    case dead
}

class Character {
    var name: String
    var hitPoint: Int
    var deadStatus: DeadStatus
    var items: [String]

    init(name: String, hitPoint: Int, items: [String] = []) {
        self.name = name
        self.hitPoint = hitPoint
        self.items = items

        if self.hitPoint <= 0 {
            self.hitPoint = 0
            self.deadStatus = .dead
        } else {
            self.deadStatus = .alive
        }
    }

    func takeDamage(_ amount: Int) {
        hitPoint -= amount

        if hitPoint <= 0 {
            hitPoint = 0
            deadStatus = .dead
        } else {
            deadStatus = .alive
        }
    }

    func addItem(_ item: String) {
        items.append(item)
    }
}

class Player: Character {
    var attackPower: Int

    init(playerName: String, hitPoint: Int, attackPower: Int) {
        self.attackPower = attackPower
        super.init(name: playerName, hitPoint: hitPoint)
    }

    func takeDamage(from enemy: Enemy) {
        takeDamage(enemy.attackPower)
    }

    func getItem(from enemy: Enemy) {
        if enemy.deadStatus == .dead {
            if let item = enemy.dropItems.randomElement() {
                addItem(item)
            }
        }
    }
}

class Enemy: Character {
    var attackPower: Int
    var dropItems: [String]

    init(enemyName: String, attackPower: Int, hitPoint: Int, dropItems: [String] = ["Rare Weapon", "Epic Weapon"]) {
        self.attackPower = attackPower
        self.dropItems = dropItems
        super.init(name: enemyName, hitPoint: hitPoint)
    }

    func takeDamage(from player: Player) {
        takeDamage(player.attackPower)
    }
}

var enemyHitPoint = Int.random(in: 1000...2000)
var playerHitPoint = Int.random(in: 1000...2000)
var enemyAttackPower = Int.random(in: 200...300)
var playerAttackPower = Int.random(in: 200...300)

var player = Player(playerName: "Minerva", hitPoint: playerHitPoint, attackPower: playerAttackPower)
var enemy = Enemy(enemyName: "Slime", attackPower: enemyAttackPower, hitPoint: enemyHitPoint)

repeat {
    player.takeDamage(from: enemy)
    print("\(player.name) gets hit by the monster, current hit point is \(player.hitPoint)")
    enemy.takeDamage(from: player)
    print("\(enemy.name) gets hit by the player, current hit point is \(enemy.hitPoint)")

    if player.deadStatus == .dead {
        print("You're dead")
        break
    }

    if enemy.deadStatus == .dead {
        print("Enemy is dead, you got an item")
        player.getItem(from: enemy)
        print("Current items: \(player.items)")
        break
    }
} while player.deadStatus == .alive || enemy.deadStatus == .alive


//: [Next](@next)
