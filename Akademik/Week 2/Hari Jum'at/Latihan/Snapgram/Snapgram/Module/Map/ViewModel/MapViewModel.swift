import RxSwift
import RxCocoa

class MapViewModel {
    
    var loadingState = BehaviorRelay<StateLoading>(value: .notLoad)
    var mapData = BehaviorRelay<StoryResponse?>(value: nil)
    
    func fetchLocationStory(param: StoryTableParam) {
        loadingState.accept(.notLoad)
        APIManager.shared.fetchRequest(endpoint: .fetchStory(param: param), expecting: StoryResponse.self) { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let data):
                self.loadingState.accept(.finished)
                self.mapData.accept(data)
            case .failure(let error):
                self.loadingState.accept(.failed)
                print(String(describing: error))
            }
        }
    }
}
    
