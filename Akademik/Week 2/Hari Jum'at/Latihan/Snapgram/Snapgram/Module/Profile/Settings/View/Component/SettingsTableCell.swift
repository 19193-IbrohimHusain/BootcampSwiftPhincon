//
//  SettingsTableCell.swift
//  Snapgram
//
//  Created by Phincon on 04/12/23.
//

import UIKit

class SettingsTableCell: UITableViewCell {
    // MARK: - Variables
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var name: UILabel!
    
    // MARK: - Lifecycles
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    // MARK: - Functions
    internal func configure(with settings: SettingEntity) {
        imgView.image = UIImage(systemName: settings.image)
        name.text = settings.name
    }
}
