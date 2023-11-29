//
//  DetailNameTableCell.swift
//  Snapgram
//
//  Created by Phincon on 29/11/23.
//

import UIKit

class DetailNameTableCell: UITableViewCell {

    @IBOutlet private weak var productName: UILabel!
    @IBOutlet private weak var productPrice: UILabel!
    @IBOutlet private weak var soldAmount: UILabel!
    @IBOutlet private weak var likeBtn: UIButton!
    @IBOutlet private weak var reviewBtn: UIButton!
    @IBOutlet private weak var reviewerPhotoBtn: UIButton!
    @IBOutlet private weak var discussionBtn: UIButton!
    
    private var isLiked = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    private func setup() {
        reviewBtn.imageView?.tintColor = .systemYellow
        [reviewerPhotoBtn, discussionBtn].forEach {$0?.imageView?.tintColor = .systemGray}
        likeBtn.setAnimateBounce()
    }
    
    private func configure() {
        likeBtn.setImage(isLiked ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart"), for: .normal)
        likeBtn.tintColor = isLiked ? .systemRed : .label
    }
    
    @IBAction func onTapLikeBtn() {
        isLiked.toggle()
        configure()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
