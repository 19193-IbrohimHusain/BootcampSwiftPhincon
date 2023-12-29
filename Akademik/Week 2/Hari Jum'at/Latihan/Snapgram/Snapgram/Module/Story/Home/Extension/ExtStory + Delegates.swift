import Foundation
import UIKit

extension StoryViewController: FeedTableCellDelegate {
    func getLocationName(lat: Double?, lon: Double?, completion: @escaping ((String) -> Void)) {
        if let lat = lat, let lon = lon {
            getLocationNameFromCoordinates(lat: lat, lon: lon) { name in
                completion(name)
            }
        }
    }
    
    func openComment(index: Int) {
        self.present(floatingPanel, animated: true)
    }
    
    func addLike(cell: FeedTableCell) {
        guard let indexPath = storyTable?.indexPath(for: cell) else { return }
        var post = listStory[indexPath.row]
        if post.isLiked {
            post.isLiked = false
            post.likesCount -= 1
            self.listStory[indexPath.row] = post
            UIView.performWithoutAnimation {
                self.storyTable?.reloadRows(at: [indexPath], with: .none)
            }
        } else {
            post.isLiked = true
            post.likesCount += 1
            self.listStory[indexPath.row] = post
            UIView.performWithoutAnimation {
                self.storyTable?.reloadRows(at: [indexPath], with: .none)
            }
        }
    }
}

extension StoryViewController: StoryTableCellDelegate {
    func navigateToDetail(id: String) {
        let vc = DetailStoryViewController()
        vc.storyID = id
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
