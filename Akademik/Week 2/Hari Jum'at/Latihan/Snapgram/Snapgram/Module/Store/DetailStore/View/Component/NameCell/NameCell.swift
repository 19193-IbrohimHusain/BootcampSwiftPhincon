//
//  DetailNameCell.swift
//  Snapgram
//
//  Created by Phincon on 18/12/23.
//

import UIKit
import RxSwift

class NameCell: UICollectionViewCell {
    // MARK: - Variables
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var soldAmount: UILabel!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var reviewBtn: UIButton!
    @IBOutlet weak var reviewerPhotoBtn: UIButton!
    @IBOutlet weak var discussionBtn: UIButton!
    
    private var isLiked = false
    private var bag = DisposeBag()
    
    // MARK: - Lifecycles
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
        btnEvent()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        setup()
    }

    // MARK: - Functions
    private func setup() {
        reviewBtn.imageView?.tintColor = .systemYellow
        [reviewerPhotoBtn, discussionBtn].forEach {$0?.imageView?.tintColor = .systemGray}
        likeBtn.setAnimateBounce()
    }
    
    private func btnEvent() {
        likeBtn.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.isLiked.toggle()
            self.setLikeBtn()
        }).disposed(by: bag)
    }
    
    internal func configure(with product: ProductModel) {
        productName.text = product.name
        productPrice.text = "$ \(product.price)"
    }
    
    private func setLikeBtn() {
        likeBtn.setImage(isLiked ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart"), for: .normal)
        likeBtn.tintColor = isLiked ? .systemRed : .label
    }
}
