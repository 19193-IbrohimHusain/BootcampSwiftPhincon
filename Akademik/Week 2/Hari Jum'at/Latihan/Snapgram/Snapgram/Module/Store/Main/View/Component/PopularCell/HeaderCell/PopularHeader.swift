//
//  PopularHeader.swift
//  Snapgram
//
//  Created by Phincon on 12/12/23.
//

import UIKit
import RxSwift

protocol PopularHeaderDelegate {
    func navigateToPopular()
}

class PopularHeader: UICollectionReusableView {
    // MARK: - Variables
    @IBOutlet weak var navigateBtn: UIButton!
    
    internal var delegate: PopularHeaderDelegate?
    private var bag = DisposeBag()
    
    // MARK: - Lifecycles
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    // MARK: - Functions
    private func setup() {
        navigateBtn.setAnimateBounce()
        btnEvent()
    }
    
    private func btnEvent() {
        navigateBtn.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.delegate?.navigateToPopular()
        }).disposed(by: bag)
    }
}
