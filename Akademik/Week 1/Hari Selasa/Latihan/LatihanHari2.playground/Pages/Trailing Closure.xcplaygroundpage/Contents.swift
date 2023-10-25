//: [Previous](@previous)

import Foundation

// trailing closure

func cariNama(_ nama: String, dalam daftar: [String], closure: (Bool) -> Void) {
    let hasilPencarian = daftar.contains { $0 == nama }
    closure(hasilPencarian)
}

let daftarNama = ["Sutisno", "Sugeng", "Sutrisna", "Suep", "Sutarmin"]

cariNama("Sutrisna", dalam: daftarNama) { ditemukan in
    if ditemukan {
        print("Nama ditemukan dalam daftar.")
    } else {
        print("Nama tidak ditemukan dalam daftar.")
    }
}

//: [Next](@next)
