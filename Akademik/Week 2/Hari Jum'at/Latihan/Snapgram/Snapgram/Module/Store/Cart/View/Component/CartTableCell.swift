//
//  CartTableCell.swift
//  Snapgram
//
//  Created by Phincon on 18/12/23.
//

import UIKit
import Kingfisher

class CartTableCell: UITableViewCell {

    @IBOutlet weak var productImg: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var incrementBtn: UIButton!
    @IBOutlet weak var productQuantity: UILabel!
    @IBOutlet weak var decrementBtn: UIButton!
    
    private var isLiked: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.addShadow()
        productImg.makeCornerRadius(16.0)
        [likeBtn, incrementBtn, decrementBtn].forEach {
            $0.setAnimateBounce()
        }
    }
    
    private func configureLike() {
        likeBtn.tintColor = isLiked ? .systemRed : .label
        likeBtn.setImage(UIImage(systemName: isLiked ? "heart.fill" : "heart"), for: .normal)
    }
    
    internal func configure(with data: Cart) {
        guard let imageUrl = data.image else { return }
        let url = URL(string: imageUrl)
        let size = productImg.bounds.size
        let processor = DownsamplingImageProcessor(size: size)
        productImg.kf.setImage(with: url, options: [
            .processor(processor),
            .loadDiskFileSynchronously,
            .cacheOriginalImage,
            .transition(.fade(0.25))
        ])
        productName.text = data.name
        productPrice.text = "$ \(data.price)"
        productQuantity.text = "\(data.quantity)"
    }
    
    @IBAction func incrementQty(_ sender: UIButton) {
        
    }
    
    @IBAction func decrementQty(_ sender: UIButton) {
        
    }
    
    @IBAction func likeBtnTap(_ sender: UIButton) {
        isLiked.toggle()
        configureLike()
    }
    
}
