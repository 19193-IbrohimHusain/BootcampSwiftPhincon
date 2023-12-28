import Foundation
import RxSwift
import RxCocoa

class ProfileViewModel : BaseViewModel {
    internal var userPost = BehaviorRelay<[ListStory]?>(value: nil)
    internal var taggedPost = BehaviorRelay<[ListStory]?>(value: nil)
    internal var currentUser = BehaviorRelay<User?>(value: nil)
    
    func fetchStory(param: StoryParam) {
        loadingState.accept(.loading)
        APIManager.shared.fetchRequest(endpoint: .fetchStory(param: param), expecting: StoryResponse.self) { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let data):
                self.loadingState.accept(.finished)
                let tagData = Array(data.listStory.prefix(200))
                self.taggedPost.accept(tagData)
                if let savedUser = BaseConstant.userDef.data(forKey: "userData") {
                    do {
                        let user = try JSONDecoder().decode(User.self, from: savedUser)
                        self.currentUser.accept(user)
                        let story = data.listStory
                        let filteredStory = story.filter { $0.name == self.currentUser.value?.username }
                        self.userPost.accept(filteredStory)
                    } catch {
                        print("Error decoding user data: \(error)")
                    }
                }
            case .failure(let error):
                self.loadingState.accept(.failed)
                print(String(describing: error))
            }
        }
    }
}
