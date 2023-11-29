//
//  DetailImageCollectionCell.swift
//  Snapgram
//
//  Created by Phincon on 29/11/23.
//

import UIKit

class DetailImageCollectionCell: UICollectionViewCell {

    @IBOutlet private weak var productImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    internal func configure(with product: CarouselCollectionEntity) {
        productImg.image = UIImage(named: product.image)
    }

}
