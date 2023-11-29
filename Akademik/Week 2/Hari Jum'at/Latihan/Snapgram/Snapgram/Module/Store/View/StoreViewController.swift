//
//  FolderViewController.swift
//  Snapgram
//
//  Created by Phincon on 03/11/23.
//

import UIKit

enum SectionStoreTable: Int, CaseIterable {
    case search, carousel, popular, newArrival, forYouProduct
}

class StoreViewController: BaseViewController {

    @IBOutlet weak var storeTable: UITableView!
    
    internal let vc = DetailProductViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupNavigationBar(title: "SnapStore", image1: "line.horizontal.3", image2: "cart", action1: nil, action2: nil)
    }
    
    private func setup() {
        storeTable.delegate = self
        storeTable.dataSource = self
        storeTable.registerCellWithNib(SearchTableCell.self)
        storeTable.registerCellWithNib(CarouselTableCell.self)
        storeTable.registerCellWithNib(PopularTableCell.self)
        storeTable.registerCellWithNib(NATableCell.self)
        storeTable.registerCellWithNib(FYPTableCell.self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

extension StoreViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return SectionStoreTable.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            return 1
        case 3:
            return 1
        case 4:
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
        switch section {
        case 2:
           return "Popular"
        case 3:
           return "New Arrival"
        case 4:
           return "For You"
        default: return nil
        }
    }
}

extension StoreViewController: PopularTableCellDelegate, NATableCellDelegate, FYPTableCellDelegate {
    func navigateToDetail() {
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
