//
//  DetailUserCategoryCell.swift
//  Snapgram
//
//  Created by Phincon on 19/12/23.
//

import UIKit

class DetailUserCategoryCell: UICollectionViewCell {

    @IBOutlet weak var categoryBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    internal func configure(with image: DetailUserCategoryEntity) {
        categoryBtn.setImage(UIImage(systemName: image.image), for: .normal)
    }

}
