import Foundation
import RxSwift
import RxCocoa

enum SectionProfileTable: Int, CaseIterable {
    case profile, category, post
    
    var cellTypes: UITableViewCell.Type {
        switch self {
        case .profile:
            return ProfileTableCell.self
        case .category:
            return CategoryTableCell.self
        case .post:
            return PostTableCell.self
        }
    }
}

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
    
