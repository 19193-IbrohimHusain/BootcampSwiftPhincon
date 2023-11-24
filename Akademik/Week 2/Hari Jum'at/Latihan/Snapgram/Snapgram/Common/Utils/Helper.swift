import Foundation

// UserDefaults
class AppSetting {
    static let shared = AppSetting()
    let userDef = UserDefaults.standard
    
    var isFirstTime: Bool{
        get{
            return userDef.value(forKey: "isFirstTime") as? Bool ?? true
        }
        set(_isNewDevice){
            userDef.set(_isNewDevice, forKey: "isFirstTime")
            userDef.synchronize()
        }
    }
    
    var paid: Double {
        get {
            return userDef.value(forKey: "paid") as? Double ?? Double()
        }
        set(newValue){
            userDef.set(newValue, forKey: "paid")
            userDef.synchronize()
        }
    }
}
