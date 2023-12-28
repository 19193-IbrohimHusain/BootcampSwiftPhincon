//
//  PopularViewController.swift
//  Snapgram
//
//  Created by Phincon on 14/12/23.
//

import UIKit

class PopularProductViewController: BaseViewController {
    // MARK: - Variables
    @IBOutlet weak var popularCollection: UICollectionView!
    
    private var vm = PopularProductViewModel()
    private var product: [ProductModel]?
    private var snapshot = NSDiffableDataSourceSnapshot<SectionPopularProduct, ProductModel>()
    private var dataSource: PopularProductDataSource!
    private var layout: UICollectionViewCompositionalLayout!

    // MARK: - Lifecycles
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
    
    // MARK: - Functions
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
        self.navigationItem.titleView = configureNavigationTitle(title: "Popular Product")
    }
    
    private func setupCollection() {
        refreshControl.rx.controlEvent(.valueChanged).subscribe(onNext: { self.refreshData() }).disposed(by: bag)
        popularCollection.refreshControl = refreshControl
        popularCollection.delegate = self
        popularCollection.registerCellWithNib(FYPCollectionCell.self)
    }
    
    private func setupDataSource() {
        dataSource = .init(collectionView: popularCollection) { (collectionView, indexPath, product) in
            let cell: FYPCollectionCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
            cell.configure(with: product)
            return cell
        }
    }
    
    private func setupCompositionalLayout() {
        layout = .init(sectionProvider: { [weak self] (sectionIndex, env) in
            guard let self = self else { fatalError("Invalid section index") }
            return NSCollectionLayoutSection.createFYPLayout(env: env, items: self.product ?? popularEntity, section: 0, sectionHorizontalSpacing: 20, leading: 20, trailing: 20, top: 20)
        })
        
        popularCollection.collectionViewLayout = layout
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
                self.popularCollection.showAnimatedGradientSkeleton()
            case .finished:
                self.refreshControl.endRefreshing()
                self.popularCollection.hideSkeleton(reloadDataAfter: false)
                self.loadSnaphot()
            case .failed:
                self.refreshControl.endRefreshing()
                self.popularCollection.addSubview(self.errorView)
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
    
    private func refreshData() {
        clearSnapshot()
        vm.getProduct(param: ProductParam())
    }
}

// MARK: - Extension for UICollectionViewDelegate
extension PopularProductViewController: UICollectionViewDelegate {
    private func navigateToDetail(index: Int) {
        if let productID = product?[index].id {
            let vc = DetailProductViewController()
            vc.id = productID
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.item
        navigateToDetail(index: index)
    }
}
