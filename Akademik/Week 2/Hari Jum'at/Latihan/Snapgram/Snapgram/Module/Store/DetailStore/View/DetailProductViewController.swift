//
//  DetailProductViewController.swift
//  Snapgram
//
//  Created by Phincon on 29/11/23.
//

import UIKit

class DetailProductViewController: BaseViewController {
    
    @IBOutlet weak var detailTable: UITableView!
    
    private let tables = SectionDetailProductTable.allCases

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        detailTable.contentInsetAdjustmentBehavior = .never
        detailTable.delegate = self
        detailTable.dataSource = self
        tables.forEach { cell in
            detailTable.registerCellWithNib(cell.cellTypes)
        }
    }
    
}

extension DetailProductViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tables.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = SectionDetailProductTable(rawValue: section)
        switch section {
        case .image, .name, .desc:
            return 1
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = SectionDetailProductTable(rawValue: indexPath.section)
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


