import SkeletonView

extension StoryViewController {
    func bindData() {
        vm.storyData.asObservable().subscribe(onNext: { [weak self] data in
            guard let self = self else {return}
            if let validData = data {
                self.listStory.append(contentsOf: validData.listStory)
                DispatchQueue.main.async {
                    self.storyTable.reloadData()
                }
            }
        }).disposed(by: bag)
        
        vm.loadingState.asObservable().subscribe(onNext: {[weak self] state in
            guard let self = self else {return}
            
            switch state {
            case .notLoad, .loading:
                self.storyTable.showAnimatedGradientSkeleton()
            case .failed, .finished:
                DispatchQueue.main.async {
                    self.storyTable.hideSkeleton()
                }
            }
        }).disposed(by: bag)
    }
    
    
    func setupTable(){
        storyTable.delegate = self
        storyTable.dataSource = self
        DispatchQueue.main.async {
            self.storyTable.isSkeletonable = true
        }
        vm.fetchStory(param: StoryTableParam(page: 0))
        storyTable.registerCellWithNib(StoryTableCell.self)
        storyTable.registerCellWithNib(SnapTableCell.self)
    }
    
    func loadMoreData() {
        page += 1
        storyTable.hideSkeleton()
        vm.fetchStory(param: StoryTableParam(page: page, location: 0))
        storyTable.hideSkeleton()
        refreshControl.endRefreshing()
        storyTable.hideLoadingFooter()
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
        let table = SectionTable(rawValue: indexPath.section)
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
    func addLike(index: Int, isLike: Bool) {
        if isLike {
            listStory[index].likesCount += 1
            print("menambahkan like index ke \(index)")
        } else {
            listStory[index].likesCount -= 1
            print("mengurangi like index ke \(index)")
        }
        storyTable.reloadData()
    }
}

extension StoryViewController: SnapTableCellDelegate {
    func navigateToDetail(id: String) {
        let vc = DetailStoryViewController()
        vc.storyID = id
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

class SharedDataSource {
    static let shared = SharedDataSource()
    var tableViewOffset: CGFloat = 0
}
