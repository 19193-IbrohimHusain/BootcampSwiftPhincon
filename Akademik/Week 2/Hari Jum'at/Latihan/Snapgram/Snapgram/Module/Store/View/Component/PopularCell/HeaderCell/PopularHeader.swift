//
//  PopularHeader.swift
//  Snapgram
//
//  Created by Phincon on 12/12/23.
//

import UIKit

protocol PopularHeaderDelegate {
    func navigateToPopular()
}

class PopularHeader: UICollectionReusableView {

    internal var delegate: PopularHeaderDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction private func navigate() {
        self.delegate?.navigateToPopular()
    }
}
