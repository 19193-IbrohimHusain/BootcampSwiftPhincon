//
//  CartTableCell.swift
//  Snapgram
//
//  Created by Phincon on 18/12/23.
//

import UIKit
import RxSwift

class CartTableCell: UITableViewCell {
    // MARK: - Variables
    @IBOutlet weak var productImg: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var incrementBtn: UIButton!
    @IBOutlet weak var productQuantity: UILabel!
    @IBOutlet weak var decrementBtn: UIButton!
    
    private var isLiked: Bool = false
    private var bag = DisposeBag()
    
    // MARK: - Lifecycles
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    // MARK: - Functions
    private func setup() {
        contentView.addShadow()
        productImg.makeCornerRadius(16.0)
        [likeBtn, incrementBtn, decrementBtn].forEach { $0.setAnimateBounce() }
        btnEvent()
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
    
    private func btnEvent() {
        likeBtn.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.isLiked.toggle()
            self.configureLike()
        }).disposed(by: bag)
        
        incrementBtn.rx.tap.subscribe(onNext: { _ in
            
        }).disposed(by: bag)
        
        decrementBtn.rx.tap.subscribe(onNext: { _ in
            
        }).disposed(by: bag)
    }
}
