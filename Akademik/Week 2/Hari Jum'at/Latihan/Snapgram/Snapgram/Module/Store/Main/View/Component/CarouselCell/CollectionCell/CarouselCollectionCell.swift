//
//  CarouselCollectionCell.swift
//  Snapgram
//
//  Created by Phincon on 28/11/23.
//

import UIKit
import Kingfisher

class CarouselCollectionCell: UICollectionViewCell {
    // MARK: - Variables
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var carouselImg: UIImageView!
    
    // MARK: - Lifecycles
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    // MARK: - Functions
    private func setup() {
        bgView.makeCornerRadius(16.0)
    }
    
    internal func configure(with carousel: GalleryModel) {
        let url = URL(string: carousel.url)
        carouselImg.kf.setImage(with: url, options: [
            .loadDiskFileSynchronously,
            .cacheOriginalImage,
            .transition(.fade(0.25)),
        ])
    }

}
