import Foundation

class BaseConstant {
    static let urlStory: String = "https://story-api.dicoding.dev/v1"
    static let urlProduct: String = "https://shoe121231.000webhostapp.com/api"
    static let fpcCornerRadius: CGFloat = 24.0
    static let userDef = UserDefaults.standard
}


class SharedDataSource {
    static let shared = SharedDataSource()
    var tableViewOffset: CGFloat = 0
}
