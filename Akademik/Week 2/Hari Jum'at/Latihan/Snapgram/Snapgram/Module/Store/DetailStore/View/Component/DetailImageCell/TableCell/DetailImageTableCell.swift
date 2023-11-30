//
//  DetailImageTableCell.swift
//  Snapgram
//
//  Created by Phincon on 29/11/23.
//

import UIKit

class DetailImageTableCell: UITableViewCell {

    @IBOutlet weak var dICollection: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    private func setup() {
        dICollection.delegate = self
        dICollection.dataSource = self
        dICollection.registerCellWithNib(DetailImageCollectionCell.self)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension DetailImageTableCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as DetailImageCollectionCell
        let image = carouselItem[indexPath.row]
        cell.configure(with: image)
        
        return cell
    }
    
    
}
