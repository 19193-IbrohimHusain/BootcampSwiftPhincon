//
//  WishlistTableCell.swift
//  Snapgram
//
//  Created by Phincon on 29/12/23.
//

import UIKit
import Kingfisher

class WishlistTableCell: UITableViewCell {

    @IBOutlet weak var productImg: UIImageView!
    @IBOutlet weak var productCategory: UILabel!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        productImg.makeCornerRadius(16.0)
        productImg.addShadow()
    }
    
    internal func configure(with data: FavoriteProducts) {
        guard let imageUrl = data.imageLink else { return }
        let url = URL(string: imageUrl)
        let size = productImg.bounds.size
        let processor = DownsamplingImageProcessor(size: size)
        productImg.kf.setImage(with: url, options: [
            .processor(processor),
            .loadDiskFileSynchronously,
            .cacheOriginalImage,
            .transition(.fade(0.25))
        ])
        productCategory.text = data.category
        productName.text = data.name
        productPrice.text = "$ \(data.price)"
    }
}
