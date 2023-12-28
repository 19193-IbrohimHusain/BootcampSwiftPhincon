//
//  DetailUserPostCell.swift
//  Snapgram
//
//  Created by Phincon on 19/12/23.
//

import UIKit
import Kingfisher

class UserPostCell: UICollectionViewCell {
    // MARK: - Variables
    @IBOutlet weak var postImg: UIImageView!
    
    // MARK: - Lifecycles
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Functions
    internal func configure(with post: ListStory) {
        let url = URL(string: post.photoURL)
        let size = postImg.intrinsicContentSize
        let processor = DownsamplingImageProcessor(size: size)
        postImg.kf.setImage(with: url, options: [
            .processor(processor),
            .loadDiskFileSynchronously,
            .cacheOriginalImage,
            .transition(.fade(0.25)),
        ])
    }
}
