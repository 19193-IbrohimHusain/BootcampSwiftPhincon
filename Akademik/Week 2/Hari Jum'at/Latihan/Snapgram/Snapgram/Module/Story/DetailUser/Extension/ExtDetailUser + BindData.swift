//
//  ExtDetailUser + BindData.swift
//  Snapgram
//
//  Created by Phincon on 19/12/23.
//

import Foundation

extension DetailUserViewController {
    internal func bindData() {
        bindDetailUserData()
        bindUserPostData()
        bindTagPostData()
        bindLoadingStateData()
    }
    
    private func bindDetailUserData() {
        vm.detailUser
            .asObservable()
            .subscribe(onNext: { [weak self] user in
                guard let self = self, let user = user else { return }
                self.detailUser = user
            })
            .disposed(by: bag)
    }
    
    private func bindUserPostData() {
        vm.userPost
            .asObservable()
            .subscribe(onNext: { [weak self] post in
                guard let self = self, let dataPost = post else { return }
                self.userPost = dataPost
                self.loadSnapshot()
            })
            .disposed(by: bag)
    }
    
    private func bindTagPostData() {
        vm.tagPost
            .asObservable()
            .subscribe(onNext: { [weak self] tag in
                guard let self = self, let dataTag = tag else { return }
                self.tagPost = dataTag
            })
            .disposed(by: bag)
    }
    
    private func bindLoadingStateData() {
        vm.loadingState
            .asObservable()
            .subscribe(onNext: { [weak self] state in
                guard let self = self else { return }
                switch state {
                case .notLoad:
                    self.errorView.removeFromSuperview()
                case .loading:
                    self.detailUserCollection.showAnimatedGradientSkeleton()
                case .finished:
                    self.refreshControl.endRefreshing()
                    self.detailUserCollection.hideSkeleton(reloadDataAfter: false)
                case .failed:
                    DispatchQueue.main.async {
                        self.detailUserCollection.hideSkeleton()
                        self.refreshControl.endRefreshing()
                        self.detailUserCollection.addSubview(self.errorView)
                    }
                }
            })
            .disposed(by: bag)
    }
    
    private func loadSnapshot() {
        // append sections to snapshot
        if snapshot.sectionIdentifiers.isEmpty {
            snapshot.appendSections(collections)
        }
        guard let userPost = userPost, let detailUser = detailUser, let tagPost = tagPost else { return }
        // append item to section profile
        var section1 = detailUser
        section1.detailUserSection = .profile
        snapshot.appendItems([section1], toSection: .profile)
        
        // append item to section category
        let section2 = tagPost.prefix(2).map {
            var modifiedItem = $0
            modifiedItem.detailUserSection = .category
            return modifiedItem
        }
        snapshot.appendItems(section2, toSection: .category)
        
        // append item to section category
        let section3 = tagPost.map {
            var modifiedItem = $0
            modifiedItem.detailUserSection = .post
            return modifiedItem
        }
        snapshot.appendItems(section3, toSection: .post)
        
        // apply snapshot to datasource
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}
