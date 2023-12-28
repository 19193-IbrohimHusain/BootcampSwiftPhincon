//
//  DetailUserCategoryCell.swift
//  Snapgram
//
//  Created by Phincon on 19/12/23.
//

import UIKit

class DetailUserCategoryCell: UICollectionViewCell {
    // MARK: - Variables
    @IBOutlet weak var categoryBtn: UIButton!
    
    override var isSelected: Bool {
        didSet {
            categoryBtn.tintColor = isSelected ? .label : .separator
        }
    }
    
    // MARK: - Lifecycles
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    // MARK: - Functions
    private func setup() {
        categoryBtn.tintColor = .separator
    }
    
    internal func configure(with image: DetailUserCategoryEntity) {
        categoryBtn.setImage(UIImage(systemName: image.image), for: .normal)
    }
}
