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
        setupBgView()
    }
    
    private func setupBgView() {
        bgView.addShadow()
        bgView.makeCornerRadius(16)
        bgView.layer.masksToBounds = false
    }
    
    func configure(with product: CarouselCollectionEntity) {
        productImg.layer.cornerRadius = 16
        productImg.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        productImg.image = UIImage(named: product.image)
    }
}