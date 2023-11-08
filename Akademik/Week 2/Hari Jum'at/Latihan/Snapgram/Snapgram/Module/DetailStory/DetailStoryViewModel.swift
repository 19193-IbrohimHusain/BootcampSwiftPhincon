import RxSwift
import RxCocoa

class DetailStoryViewModel {
    
    var detailStoryData = BehaviorRelay<DetailStoryResponse?>(value: nil)

    func fetchDetailStory(param: String) {
        APIManager.shared.fetchRequest(endpoint: .getDetailStory(param), expecting: DetailStoryResponse.self) { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let data):
                self.detailStoryData.accept(data)
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
}
