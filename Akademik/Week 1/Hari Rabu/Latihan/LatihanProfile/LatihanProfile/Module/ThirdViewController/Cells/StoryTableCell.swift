//
//  StoryTableCell.swift
//  LatihanProfile
//
//  Created by Phincon on 26/10/23.
//

import UIKit

class StoryTableCell: UITableViewCell {

    @IBOutlet weak var profileView: UIImageView!
    
    @IBOutlet weak var likeButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        profileView.layer.cornerRadius = 12
        likeButton.isSelected = false
        // Initialization code
    }
    
    @IBAction func onLikeBtnTap(_ sender: UIButton) {
        sender.isSelected.toggle()
        if sender.isSelected {
            likeButton.setImage(UIImage(systemName: "heart.fill"), for: .selected)
            sender.tintColor = UIColor.systemRed
        } else {
            likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
            sender.tintColor = UIColor.label
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
