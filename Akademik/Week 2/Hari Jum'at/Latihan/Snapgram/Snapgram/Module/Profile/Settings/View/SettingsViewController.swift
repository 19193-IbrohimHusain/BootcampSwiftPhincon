//
//  SettingsViewController.swift
//  Snapgram
//
//  Created by Phincon on 04/12/23.
//

import UIKit

class SettingsViewController: UIViewController {
    // MARK: - Variables
    @IBOutlet weak var settingTable: UITableView!
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    // MARK: - Functions
    private func setup() {
        settingTable.delegate = self
        settingTable.dataSource = self
        settingTable.registerCellWithNib(SettingsTableCell.self)
    }
}

// MARK: - Extension for UITableView
extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listSetting.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as SettingsTableCell
        let settingEntity = listSetting[indexPath.row]
        cell.configure(with: settingEntity)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
