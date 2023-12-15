//
//  SearchProductViewController.swift
//  Snapgram
//
//  Created by Phincon on 14/12/23.
//

import UIKit

class SearchProductViewController: BaseViewController {
    
    @IBOutlet weak var searchCollection: UICollectionView!
    
    private var vm = SearchProductViewModel()
    private var product: [ProductModel]?
    private var snapshot = NSDiffableDataSourceSnapshot<SectionSearchProduct, ProductModel>()
    private var dataSource: SearchCollectionDataSource!
    private var layout: UICollectionViewCompositionalLayout!
    private var searchBar = CustomSearchNavBar()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        clearSnapshot()
    }
    
    private func setup() {
        setupNavigationBar()
        setupErrorView()
        searchCollection.delegate = self
        searchCollection.registerCellWithNib(FYPCollectionCell.self)
        setupDataSource()
        setupCompositionalLayout()
        bindData()
    }
    
//    private func handleSearch() {
//        searchBar.
//    }
    
    private func setNavBarHeight(height: Double) {
        self.navigationController?.navigationBar.invalidateIntrinsicContentSize()
        self.navigationController?.navigationBar.frame = CGRect(x: 0, y: 60, width: 430, height: height)
    }
    
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.tintColor = .label
        self.navigationController?.navigationItem.backButtonTitle = nil
        self.navigationItem.titleView = searchBar
    }
    
    private func setupDataSource() {
        dataSource = .init(collectionView: searchCollection) { (collectionView, indexPath, product) in
            let cell:FYPCollectionCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
            cell.configure(with: product)
            return cell
        }
    }
    
    private func setupCompositionalLayout() {
        layout = .init(sectionProvider: { [weak self] (sectionIndex, env) in
            guard let self = self else { fatalError("Invalid section index") }
            return NSCollectionLayoutSection.createFYPLayout(env: env, items: self.product ?? searchEntity, section: 0, sectionHorizontalSpacing: 20, leading: 20, trailing: 20, top: 20)
        })
        
        searchCollection.collectionViewLayout = layout
    }
    
    private func loadSnaphot(animatingDifferences: Bool = true) {
        guard let product = product else { return }
        snapshot.appendSections([.main])
        snapshot.appendItems(product)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    private func bindData() {
        vm.productData.asObservable().subscribe(onNext: { [weak self] product in
            guard let self = self, let data = product else { return }
            self.product = data
        }).disposed(by: bag)
        
        vm.loadingState.asObservable().subscribe(onNext: { [weak self] state in
            guard let self = self else { return }
            
            switch state {
            case .notLoad:
                self.errorView.removeFromSuperview()
            case .loading:
                self.searchCollection.showAnimatedGradientSkeleton()
            case .finished:
                self.searchCollection.hideSkeleton()
                self.loadSnaphot()
            case .failed:
                self.searchCollection.addSubview(self.errorView)
            }
            
        }).disposed(by: bag)
    }
    
    private func clearSnapshot() {
        product?.removeAll()
        snapshot.deleteAllItems()
        snapshot.deleteSections([.main])
        dataSource.apply(snapshot)
        self.errorView.removeFromSuperview()
    }
    
    @objc private func refreshData() {
        clearSnapshot()
        vm.getProduct(param: ProductParam())
    }
}

extension SearchProductViewController: UICollectionViewDelegate {
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        <#code#>
//    }
}
