//
//  CartTableCell.swift
//  Snapgram
//
//  Created by Phincon on 18/12/23.
//

import UIKit

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
        [likeBtn, incrementBtn, decrementBtn].forEach {
            $0.setAnimateBounce()
        }
    }
    
    private func configureLike() {
        likeBtn.tintColor = isLiked ? .systemRed : .label
        likeBtn.setImage(UIImage(systemName: isLiked ? "heart.fill" : "heart"), for: .normal)
    }
    
    internal func configure(with data: CartModel) {
        productImg.image = UIImage(named: data.image)
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
