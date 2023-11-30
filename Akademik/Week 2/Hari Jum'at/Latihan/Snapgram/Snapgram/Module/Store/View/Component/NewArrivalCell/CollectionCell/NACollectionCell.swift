//
//  NACollectionCell.swift
//  Snapgram
//
//  Created by Phincon on 29/11/23.
//

import UIKit

class NACollectionCell: UICollectionViewCell {

    @IBOutlet private weak var bgView: UIView!
    @IBOutlet private weak var productImg: UIImageView!
    @IBOutlet private weak var productName: UILabel!
    @IBOutlet private weak var productPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupBgView()
    }
    
    private func setupBgView() {
        bgView.addShadow()
        bgView.makeCornerRadius(16)
        bgView.layer.masksToBounds = false
    }
    
    internal func configure(with product: CarouselCollectionEntity) {
        productImg.layer.cornerRadius = 16
        productImg.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        productImg.image = UIImage(named: product.image)
    }

}