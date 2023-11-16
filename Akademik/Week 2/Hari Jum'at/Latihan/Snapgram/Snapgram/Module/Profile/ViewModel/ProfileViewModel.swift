import Foundation
import RxSwift
import RxCocoa

class ProfileViewModel : BaseViewModel {
    var storyData = BehaviorRelay<StoryResponse?>(value: nil)
    
    func fetchStory(param: StoryTableParam) {
        loadingState.accept(.loading)
        APIManager.shared.fetchRequest(endpoint: .fetchStory(param: param), expecting: StoryResponse.self) { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let data):
                self.loadingState.accept(.finished)
                self.storyData.accept(data)
            case .failure(let error):
                self.loadingState.accept(.failed)
                print(String(describing: error))
            }
        }
    }
}
    
