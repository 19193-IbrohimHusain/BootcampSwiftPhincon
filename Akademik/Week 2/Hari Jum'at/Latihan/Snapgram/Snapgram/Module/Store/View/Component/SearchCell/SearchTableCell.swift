//
//  SearchTableCell.swift
//  Snapgram
//
//  Created by Phincon on 28/11/23.
//

import UIKit

class SearchTableCell: UITableViewCell {

    @IBOutlet weak var searchInputField: CustomInputField!
    
    private var leftView = UIView()
    private var image = UIImageView(image: UIImage(systemName: "magnifyingglass"))
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
        // Initialization code
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
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
