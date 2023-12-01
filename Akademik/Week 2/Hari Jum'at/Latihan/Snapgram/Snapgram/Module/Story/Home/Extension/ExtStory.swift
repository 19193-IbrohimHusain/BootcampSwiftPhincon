import FloatingPanel
import SkeletonView

extension StoryViewController: SkeletonTableViewDataSource {
    func numSections(in collectionSkeletonView: UITableView) -> Int {
        return tables.count
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let tableSection = SectionStoryTable(rawValue: section)
        switch tableSection {
        case .story:
            return 1
        case .feed:
            return 2
        default: return 0
        }
    }
    
    func collectionSkeletonView(_ tableView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        let tableSection = SectionStoryTable(rawValue: indexPath.section)
        switch tableSection {
        case .story:
            return String(describing: StoryTableCell.self)
        case .feed:
            return String(describing: FeedTableCell.self)
        default: return ""
        }
    }
}

extension StoryViewController: FeedTableCellDelegate {
    func getLocationName(lat: Double?, lon: Double?, completion: ((String) -> Void)?) {
        if let lat = lat, let lon = lon {
            getLocationNameFromCoordinates(lat: lat, lon: lon) { name in
                completion!(name ?? "")
            }
        }
    }
    
    func openComment(index: Int) {
        self.present(floatingPanel, animated: true)
    }
    
    func addLike(cell: FeedTableCell) {
        guard let indexPath = storyTable?.indexPath(for: cell) else { return }
        var post = listStory[indexPath.item]
        if post.isLiked {
            post.isLiked = false
            post.likesCount -= 1
            self.listStory[indexPath.item] = post
            UIView.performWithoutAnimation {
                self.storyTable?.reloadRows(at: [indexPath], with: .none)
            }
        } else {
            post.isLiked = true
            post.likesCount += 1
            self.listStory[indexPath.item] = post
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
