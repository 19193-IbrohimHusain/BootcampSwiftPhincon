//
//  DetailProductViewController.swift
//  Snapgram
//
//  Created by Phincon on 29/11/23.
//

import UIKit
import SkeletonView

class DetailProductViewController: BaseViewController {
    
    @IBOutlet weak var detailTable: UITableView!
    
    private let tables = SectionDetailProductTable.allCases
    private let vm = DetailProductViewModel()
    internal var id: Int?
    private var product: [ProductModel]?

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let id = id {
            vm.fetchDetailProduct(param: ProductParam(id: id))
        }
    }
    
    private func setup() {
        detailTable.contentInsetAdjustmentBehavior = .never
        detailTable.delegate = self
        detailTable.dataSource = self
        tables.forEach { cell in
            detailTable.registerCellWithNib(cell.cellTypes)
        }
    }
    
    private func bindData() {
        vm.dataProduct.asObservable().subscribe(onNext: { [weak self] product in
            guard let self = self, let dataProduct = product?.data.data else { return }
            self.product = dataProduct
        }).disposed(by: bag)
        
        vm.loadingState.asObservable().subscribe(onNext: { [weak self] state in
            guard let self = self else { return }
            switch state {
            case .notLoad, .loading:
                self.detailTable.showAnimatedGradientSkeleton()
            case .failed, .finished:
                DispatchQueue.main.async {
                    self.detailTable.hideSkeleton()
                }
            }
        }).disposed(by: bag)
    }
}

extension DetailProductViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return tables.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let tableSection = SectionDetailProductTable(rawValue: section)
        switch tableSection {
        case .image, .name, .desc:
            return 1
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableSection = SectionDetailProductTable(rawValue: indexPath.section)
        switch tableSection {
        case .image:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as DetailImageTableCell
            
            return cell
        case .name:
            let cell1 = tableView.dequeueReusableCell(forIndexPath: indexPath) as DetailNameTableCell
            
            return cell1
        default:
            return UITableViewCell()
        }
    }
}

extension DetailProductViewController: SkeletonTableViewDataSource {
    func numSections(in collectionSkeletonView: UITableView) -> Int {
        tables.count
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let tableSection = SectionDetailProductTable(rawValue: section)
        switch tableSection {
        case .image, .name, .desc:
            return 1
        default: return 0
        }
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        let tableSection = SectionDetailProductTable(rawValue: indexPath.section)
        guard let section = tableSection else { return "" }
        
        if let identifier = SectionDetailProductTable.sectionIdentifiers[section] {
            return identifier
        } else {
            return ""
        }
    }
}


