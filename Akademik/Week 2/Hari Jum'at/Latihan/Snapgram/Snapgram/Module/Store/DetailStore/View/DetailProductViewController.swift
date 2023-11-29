//
//  DetailProductViewController.swift
//  Snapgram
//
//  Created by Phincon on 29/11/23.
//

import UIKit

enum SectionTableDetail: Int, CaseIterable {
case image, name, desc, store, recommendation
}

class DetailProductViewController: BaseViewController {
    
    @IBOutlet weak var detailTable: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        detailTable.contentInsetAdjustmentBehavior = .never
        detailTable.delegate = self
        detailTable.dataSource = self
        detailTable.registerCellWithNib(DetailImageTableCell.self)
        detailTable.registerCellWithNib(DetailNameTableCell.self)
    }
    
}

extension DetailProductViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return SectionTableDetail.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = SectionTableDetail(rawValue: section)
        switch section {
        case .image, .name:
            return 1
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = SectionTableDetail(rawValue: indexPath.section)
        switch section {
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


