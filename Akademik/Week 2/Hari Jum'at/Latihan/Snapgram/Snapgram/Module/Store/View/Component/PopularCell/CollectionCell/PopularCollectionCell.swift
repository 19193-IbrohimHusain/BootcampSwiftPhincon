//
//  PopularCollectionCell.swift
//  Snapgram
//
//  Created by Phincon on 28/11/23.
//

import UIKit

class PopularCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var productImg: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bgView.makeCornerRadius(16.0)
        bgView.addShadow()
    }
    
    func configure(with product: CarouselCollectionEntity) {
        productImg.image = UIImage(named: product.image)
    }
}
