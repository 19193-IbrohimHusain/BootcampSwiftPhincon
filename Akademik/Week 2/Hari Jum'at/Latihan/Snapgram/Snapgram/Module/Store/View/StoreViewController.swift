//
//  FolderViewController.swift
//  Snapgram
//
//  Created by Phincon on 03/11/23.
//

import UIKit

enum SectionStoreTable: Int, CaseIterable {
    case search, carousel, popular
}

class StoreViewController: BaseViewController {

    @IBOutlet weak var storeTable: UITableView!
    
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

extension StoreViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
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
            return cell2
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 2:
           return "Popular"
        default: return nil
        }
    }
    
}
