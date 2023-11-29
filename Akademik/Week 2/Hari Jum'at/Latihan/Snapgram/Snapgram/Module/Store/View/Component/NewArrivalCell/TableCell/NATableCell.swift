//
//  NewArrivalTableCell.swift
//  Snapgram
//
//  Created by Phincon on 29/11/23.
//

import UIKit

protocol NATableCellDelegate {
    func navigateToDetail()
}

class NATableCell: UITableViewCell {

    @IBOutlet weak var nACollection: UICollectionView!
    
    internal var delegate: NATableCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    private func setup() {
        nACollection.delegate = self
        nACollection.dataSource = self
        nACollection.registerCellWithNib(NACollectionCell.self)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension NATableCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as NACollectionCell
        let nAProduct = carouselItem[indexPath.row]
        cell.configure(with: nAProduct)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.navigateToDetail()
    }
}
