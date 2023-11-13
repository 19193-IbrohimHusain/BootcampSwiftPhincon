import UIKit
import RxSwift
import RxRelay

class AddStoryViewModel {
    var loadingState = BehaviorRelay<StateLoading>(value: .notLoad)
    var addStory = BehaviorRelay<AddStoryResponse?>(value: nil)
    
    func postStory(param: AddStoryParam) {
        loadingState.accept(.loading)
        APIManager.shared.fetchRequest(endpoint: .addNewStory(param: param), expecting: AddStoryResponse.self) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.loadingState.accept(.finished)
                self.addStory.accept(response)
            case .failure(let error):
                self.loadingState.accept(.failed)
                print(String(describing: error))
            }
        }
    }
}
