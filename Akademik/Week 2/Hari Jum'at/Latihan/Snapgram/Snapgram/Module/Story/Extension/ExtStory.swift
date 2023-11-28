import FloatingPanel
import SkeletonView

extension StoryViewController {
    func bindData() {
        vm.storyData.asObservable().subscribe(onNext: { [weak self] data in
            guard let self = self else {return}
            if let validData = data?.listStory {
                self.listStory.append(contentsOf: validData)
            }
        }).disposed(by: bag)
        
        vm.loadingState.asObservable().subscribe(onNext: {[weak self] state in
            guard let self = self else {return}
            switch state {
            case .notLoad, .loading:
                guard self.isLoadMoreData else {
                    self.storyTable.showAnimatedGradientSkeleton()
                    return
                }
                self.storyTable.showLoadingFooter()
            case .failed, .finished:
                DispatchQueue.main.async {
                    UIView.performWithoutAnimation {
                        self.storyTable.reloadData()
                    }
                    self.storyTable.hideSkeleton()
                }
            }
        }).disposed(by: bag)
    }
    
    func setup(){
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        storyTable.refreshControl = refreshControl
        storyTable.delegate = self
        storyTable.dataSource = self
        storyTable.registerCellWithNib(FeedTableCell.self)
        storyTable.registerCellWithNib(StoryTableCell.self)
    }
    
    func setupCommentPanel() {
        setupBottomSheet(contentVC: cvc, floatingPanelDelegate: self)
    }
    
    func loadMoreData() {
        page += 1
        isLoadMoreData = true
        vm.fetchStory(param: StoryTableParam(page: page, location: 0))
        storyTable.hideSkeleton()
        isLoadMoreData = false
    }
    
    @objc func refreshData() {
        self.listStory.removeAll()
        vm.fetchStory(param: StoryTableParam())
        self.refreshControl.endRefreshing()
        self.storyTable.hideLoadingFooter()
    }
}

extension StoryViewController: SkeletonTableViewDataSource {
    func numSections(in collectionSkeletonView: UITableView) -> Int {
        return 2
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 2
        default: return 0
        }
    }
    
    func collectionSkeletonView(_ tableView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        let table = SectionStoryTable(rawValue: indexPath.section)
        switch table {
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

class SharedDataSource {
    static let shared = SharedDataSource()
    var tableViewOffset: CGFloat = 0
}
