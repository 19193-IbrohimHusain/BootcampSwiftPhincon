//
//  SearchCollectionCell.swift
//  Snapgram
//
//  Created by Phincon on 07/12/23.
//

import UIKit

protocol SearchCollectionCellDelegate {
    func search()
}

class SearchCollectionCell: UICollectionViewCell {

    @IBOutlet weak var searchInputField: CustomInputField!
    
    internal var delegate: SearchCollectionCellDelegate?
    private var leftView = UIView()
    private var image = UIImageView(image: UIImage(systemName: "magnifyingglass"))
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    private func setup() {
        searchInputField.setup(placeholder: "Search", errorText: "")
        configureLeftView()
    }

    private func configureLeftView() {
        leftView.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        leftView.addSubview(image)
        image.center = CGPoint(x: leftView.bounds.width / 2, y: leftView.bounds.height / 2)
        image.tintColor = .label
        searchInputField.textField.leftView = leftView
        searchInputField.textField.leftViewMode = .always
    }
}
