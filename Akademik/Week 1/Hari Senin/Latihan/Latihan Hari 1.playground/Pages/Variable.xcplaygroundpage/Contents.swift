//: [Previous](@previous)

import Foundation

var name: String = "Akbar"
var greeting = "playground"

name = "agung"

print("Nama Saya Adalah" , name , "Hello \(greeting)")

var number: Int = 10
number = 11

print("Umur saya \(number) tahun")


var namaKelas: String = String()
var jumlahHewan: Int = Int()

namaKelas = "kelas Fisika"

print(namaKelas)


let hariLibur: String = "minggu"
let π = 3.14159
let 你好 = "你好世界"
let 🐶🐮 = "dogcow"


// inisiasi banyak variable
var red, green, blue: Double

// penggunaan semicolon

let cat = "🐱"; print(cat)


// penggunaan type alias

typealias AudioSample = UInt16
var maxAmplitudeFound = AudioSample.min

let orangesAreOrange = true
let turnipsAreDelicious = false

if turnipsAreDelicious {
    print("Mmm, tasty turnips!")
} else {
    print("Eww, turnips are horrible.")
}

// penggunaan Tuple

let http404Error = (404, "Not Found")

let (statusCode, statusMessage) = http404Error

print("The status code is \(statusCode)")
print("The status message is \(statusMessage)")

//: [Next](@next)
