//
//  CarouselCollectionCell.swift
//  Snapgram
//
//  Created by Phincon on 28/11/23.
//

import UIKit

class CarouselCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var carouselImg: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(with carousel: CarouselCollectionEntity) {
        carouselImg.layer.cornerRadius = 16.0
        carouselImg.image = UIImage(named: carousel.image)
    }

}
