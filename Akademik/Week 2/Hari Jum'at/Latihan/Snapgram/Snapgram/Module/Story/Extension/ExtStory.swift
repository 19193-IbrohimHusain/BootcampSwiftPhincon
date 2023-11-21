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
                self.storyTable.showAnimatedGradientSkeleton()
            case .failed, .finished:
                DispatchQueue.main.async {
                    self.refreshControl.endRefreshing()
                    self.storyTable.hideSkeleton()
                }
            }
        }).disposed(by: bag)
    }
    
    
    func setup(){
        navigationItem.title = "Snapgram"
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        storyTable.refreshControl = refreshControl
        storyTable.delegate = self
        storyTable.dataSource = self
        storyTable.registerCellWithNib(StoryTableCell.self)
        storyTable.registerCellWithNib(SnapTableCell.self)
    }
    
    func setupCommentPanel() {
        setupBottomSheet(contentVC: cvc, floatingPanelDelegate: self)
    }
    
    func loadMoreData() {
        page += 1
        vm.fetchStory(param: StoryTableParam(page: page, location: 0))
        self.storyTable.hideSkeleton()
    }
    
    @objc func refreshData() {
        self.listStory.removeAll()
        vm.fetchStory(param: StoryTableParam())
        self.refreshControl.endRefreshing()
        self.storyTable.hideLoadingFooter()
    }
}

extension StoryViewController: FloatingPanelControllerDelegate {
    
    // Untuk membuat custom layout pada Floating Panel
    func floatingPanel(_ vc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout {
        return CustomFloatingPanelLayout()
    }
    // Untuk animasi saat membuka floating panel
    func floatingPanel(_ fpc: FloatingPanelController, animatorForPresentingTo state: FloatingPanelState) -> UIViewPropertyAnimator {
        return UIViewPropertyAnimator(duration: TimeInterval(0.16), curve: .easeOut)
    }
    // Untuk animasi saat menuntup floating panel
    func floatingPanel(_ fpc: FloatingPanelController, animatorForDismissingWith velocity: CGVector) -> UIViewPropertyAnimator {
      return UIViewPropertyAnimator(duration: TimeInterval(0.16), curve: .easeOut)
    }
    
//    func floatingPanel(
//            _ fpc: FloatingPanelController,
//            shouldAllowToScroll trackingScrollView: UIScrollView,
//            in state: FloatingPanelState
//        ) -> Bool {
//            return state == .full || state == .half
//        }
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
        case .snap:
            return String(describing: SnapTableCell.self)
        case .story:
            return String(describing: StoryTableCell.self)
        default: return ""
        }
    }
    
}

extension StoryViewController: StoryTableCellDelegate {
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
    
    func addLike(index: Int, isLike: Bool) {
        if isLike {
            listStory[index].likesCount += 1
            print("menambahkan like index ke \(index)")
        } else {
            listStory[index].likesCount -= 1
            print("mengurangi like index ke \(index)")
        }
        storyTable.reloadSections(IndexSet(integer: 1), with: .none)
    }
}

extension StoryViewController: SnapTableCellDelegate {
    func navigateToDetail(id: String) {
        let vc = DetailStoryViewController()
        vc.storyID = id
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

class SharedDataSource {
    static let shared = SharedDataSource()
    var tableViewOffset: CGFloat = 0
}
