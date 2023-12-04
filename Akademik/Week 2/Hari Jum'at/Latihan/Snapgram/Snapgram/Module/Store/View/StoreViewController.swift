//
//  FolderViewController.swift
//  Snapgram
//
//  Created by Phincon on 03/11/23.
//

import UIKit
import SkeletonView

class StoreViewController: BaseViewController {

    @IBOutlet weak var storeTable: UITableView!
    
    internal let vc = DetailProductViewController()
    internal let tables = SectionStoreTable.allCases
    internal let vm = StoreViewModel()
    internal var product: [ProductModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        vm.fetchProduct(param: ProductParam())
    }
    
    private func setup() {
        setupNavigationBar(title: "SnapStore", image1: "line.horizontal.3", image2: "cart", action1: nil, action2: nil)
        storeTable.delegate = self
        storeTable.dataSource = self
        tables.forEach { cell in
            storeTable.registerCellWithNib(cell.cellTypes)
        }
        bindData()
    }
    
    private func bindData() {
        vm.productData.asObservable().subscribe(onNext: { [weak self] product in
            guard let self = self, let dataProduct = product?.data.data else {return}
            self.product?.append(contentsOf: dataProduct)
        }).disposed(by: bag)
        
        vm.loadingState.asObservable().subscribe(onNext: { [weak self] state in
            guard let self = self else {return}
            switch state {
            case .notLoad:
                self.errorView.removeFromSuperview()
            case .loading:
                self.storeTable.showAnimatedGradientSkeleton()
            case .finished:
                self.storeTable.hideSkeleton()
            case .failed:
                DispatchQueue.main.async {
                    self.storeTable.hideSkeleton()
                    self.storeTable.addSubview(self.errorView)
                }
            }
        }).disposed(by: bag)
    }
}

extension StoreViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return tables.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let tableSection = SectionStoreTable(rawValue: section)
        switch tableSection {
        case .search, .carousel, .popular, .newArrival, .forYouProduct:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableSection = SectionStoreTable(rawValue: indexPath.section)
        switch tableSection {
        case .search:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as SearchTableCell
            return cell
        case .carousel:
            let cell1 = tableView.dequeueReusableCell(forIndexPath: indexPath) as CarouselTableCell
            return cell1
        case .popular:
            let cell2 = tableView.dequeueReusableCell(forIndexPath: indexPath) as PopularTableCell
            cell2.delegate = self
            return cell2
        case .newArrival:
            let cell3 = tableView.dequeueReusableCell(forIndexPath: indexPath) as NATableCell
            cell3.delegate = self
            return cell3
        case .forYouProduct:
            let cell4 = tableView.dequeueReusableCell(forIndexPath: indexPath) as FYPTableCell
            cell4.delegate = self
            return cell4
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let tableSection = SectionStoreTable(rawValue: section)
        switch tableSection {
        case .popular:
           return "Popular"
        case .newArrival:
           return "New Arrival"
        case .forYouProduct:
           return "For You"
        default: return nil
        }
    }
}

extension StoreViewController: SkeletonTableViewDataSource {
    func numSections(in collectionSkeletonView: UITableView) -> Int {
        return tables.count
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let tableSection = SectionStoreTable(rawValue: section)
        switch tableSection {
        case .search, .carousel, .popular, .newArrival, .forYouProduct:
            return 1
        default: return 0
        }
    }
    
    func collectionSkeletonView(_ tableView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        let tableSection = SectionStoreTable(rawValue: indexPath.section)
        switch tableSection {
        case .search:
            return String(describing: SearchTableCell.self)
        case .carousel:
            return String(describing: CarouselTableCell.self)
        case .popular:
            return String(describing: PopularTableCell.self)
        case .newArrival:
            return String(describing: NATableCell.self)
        case .forYouProduct:
            return String(describing: FYPTableCell.self)
        default: return ""
        }
    }
}

extension StoreViewController: PopularTableCellDelegate, NATableCellDelegate, FYPTableCellDelegate {
    func navigateToDetail() {
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
