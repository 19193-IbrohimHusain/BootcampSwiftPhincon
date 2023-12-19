//
//  DetailUserViewController.swift
//  Snapgram
//
//  Created by Phincon on 19/12/23.
//

import UIKit

class DetailUserViewController: BaseViewController {

    @IBOutlet weak var detailUserCollection: UICollectionView!
    
    internal var userName: String?
    internal var vm = DetailUserViewModel()
    internal var collections = SectionDetailUser.allCases
    internal var snapshot = NSDiffableDataSourceSnapshot<SectionDetailUser, ListStory>()
    internal var dataSource: UICollectionViewDiffableDataSource<SectionDetailUser, ListStory>!
    internal var layout: UICollectionViewCompositionalLayout!
    internal var detailUser: ListStory?
    internal var tagPost: [ListStory]?
    internal var userPost: [ListStory]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshData()
    }
    
    private func setup() {
        setupNavigationBar()
        setupErrorView()
        setupCollection()
        setupDataSource()
        setupCompositionalLayout()
        bindData()
    }
    
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.tintColor = .label
        self.navigationController?.navigationItem.backButtonTitle = nil
        if let userName = userName {
            self.navigationItem.titleView = configureNavigationTitle(title: userName)
        }
    }
    
    private func setupCollection() {
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        detailUserCollection.refreshControl = refreshControl
        detailUserCollection.delegate = self
        collections.forEach {
            detailUserCollection.registerCellWithNib($0.cellTypes)
        }
    }
    
    private func setupDataSource() {
        dataSource = .init(collectionView: detailUserCollection) { [weak self] (collectionView, indexPath, user) in
            guard let self = self else { return UICollectionViewCell() }
            switch user.detailUserSection {
            case .profile:
                let cell: DetailUserProfileCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
                if let userPost = self.userPost {
                    cell.configure(with: user, postCount: userPost.count)
                }
                return cell
            case .category:
                let cell1: DetailUserCategoryCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
                cell1.configure(with: detailUserCategoryItem[indexPath.item])
                return cell1
            case .post:
                let cell2: DetailUserPostCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
                cell2.configure(with: user)
                return cell2
            default: return UICollectionViewCell()
            }
        }
    }
    
    private func clearSnapshot() {
        detailUser = nil
        userPost = nil
        tagPost = nil
        snapshot.deleteAllItems()
        snapshot.deleteSections(collections)
        detailUserCollection.hideSkeleton(reloadDataAfter: false)
        dataSource.apply(snapshot)
        self.errorView.removeFromSuperview()
    }
    
    @objc private func refreshData() {
        clearSnapshot()
        if let userName = userName {
            vm.userName = userName
            vm.fetchAllPost(param: StoryParam(size: 1000))
        }
    }
}

extension DetailUserViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.section == 2 else { return }
        let id = dataSource.snapshot(for: .post).items[indexPath.item].id
        let vc = DetailStoryViewController()
        vc.storyID = id
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
