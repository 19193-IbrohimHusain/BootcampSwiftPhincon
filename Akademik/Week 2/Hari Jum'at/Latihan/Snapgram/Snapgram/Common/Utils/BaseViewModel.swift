import Foundation
import RxSwift
import RxCocoa

enum StateLoading: Int {
    case notLoad
    case loading
    case finished
    case failed
}

class BaseViewModel {
    internal let bag: DisposeBag = DisposeBag()
    var loadingState = BehaviorRelay<StateLoading>(value: .notLoad)
}
    

