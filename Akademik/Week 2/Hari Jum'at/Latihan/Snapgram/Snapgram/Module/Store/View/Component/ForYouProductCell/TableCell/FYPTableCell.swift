//
//  FYPTableCell.swift
//  Snapgram
//
//  Created by Phincon on 29/11/23.
//

import UIKit

protocol FYPTableCellDelegate {
    func navigateToDetail()
}

class FYPTableCell: UITableViewCell {

    @IBOutlet weak var fYPCollection: UICollectionView!
    
    internal var delegate: FYPTableCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    private func setup() {
        fYPCollection.delegate = self
        fYPCollection.dataSource = self
        fYPCollection.registerCellWithNib(FYPCollectionCell.self)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension FYPTableCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as FYPCollectionCell
        let fYPProduct = carouselItem[indexPath.row]
        cell.configure(with: fYPProduct)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.navigateToDetail()
    }
}
