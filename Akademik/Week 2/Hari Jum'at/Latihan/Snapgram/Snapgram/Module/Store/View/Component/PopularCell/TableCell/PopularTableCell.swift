//
//  PopularTableCell.swift
//  Snapgram
//
//  Created by Phincon on 28/11/23.
//

import UIKit

class PopularTableCell: UITableViewCell {

    @IBOutlet weak var popularCollection: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
        // Initialization code
    }
    
    private func setup() {
        popularCollection.delegate = self
        popularCollection.dataSource = self
        popularCollection.registerCellWithNib(PopularCollectionCell.self)
    }
}

extension PopularTableCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as PopularCollectionCell
        let popularItem = carouselItem[indexPath.row]
        cell.configure(with: popularItem)
        
        return cell
    }
}
