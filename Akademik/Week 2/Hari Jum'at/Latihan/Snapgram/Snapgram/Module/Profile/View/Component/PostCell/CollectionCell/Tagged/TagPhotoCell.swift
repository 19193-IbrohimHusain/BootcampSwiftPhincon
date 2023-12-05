//
//  TagPhotoCell.swift
//  Snapgram
//
//  Created by Phincon on 05/12/23.
//

import UIKit
import Kingfisher

class TagPhotoCell: UICollectionViewCell {

    @IBOutlet weak var taggedImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCollection(_ post: ListStory) {
        let url = URL(string: post.photoURL)
        let processor = DownsamplingImageProcessor(size: CGSize(width: 150, height: 150))
        taggedImg.kf.setImage(with: url, options: [
            .processor(processor),
            .loadDiskFileSynchronously,
            .cacheOriginalImage,
            .transition(.fade(0.25)),
        ])
    }
}
