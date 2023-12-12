//
//  CategoryCollectionCell.swift
//  Snapgram
//
//  Created by Phincon on 12/12/23.
//

import UIKit

protocol StoreCategoryCellDelegate {
    func onSelected(index: Int)
}

class StoreCategoryCell: UICollectionViewCell {

    @IBOutlet private weak var categoryBtn: UIButton!
    
    internal var index = Int()
    internal var delegate: StoreCategoryCellDelegate?
    
    override var isHighlighted: Bool {
        didSet {
            categoryBtn.tintColor = isHighlighted ? .systemGray : .label
        }
    }
    
    override var isSelected: Bool {
        didSet {
            categoryBtn.tintColor = isSelected ? .label : .systemGray
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    internal func configure(data category: CategoryModel) {
        categoryBtn.setTitle(category.name, for: .normal)
    }
    
    @IBAction func onCategoryBtnTap() {
        self.delegate?.onSelected(index: index)
    }
}
