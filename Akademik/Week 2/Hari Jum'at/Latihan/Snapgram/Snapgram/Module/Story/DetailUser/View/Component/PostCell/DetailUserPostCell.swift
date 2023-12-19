//
//  DetailUserPostCell.swift
//  Snapgram
//
//  Created by Phincon on 19/12/23.
//

import UIKit
import Kingfisher

class DetailUserPostCell: UICollectionViewCell {

    @IBOutlet weak var postImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    internal func configure(with post: ListStory) {
        let url = URL(string: post.photoURL)
        let processor = DownsamplingImageProcessor(size: CGSize(width: postImg.bounds.width, height: postImg.bounds.height))
        postImg.kf.setImage(with: url, options: [
            .processor(processor),
            .loadDiskFileSynchronously,
            .cacheOriginalImage,
            .transition(.fade(0.25)),
        ])
    }

}
