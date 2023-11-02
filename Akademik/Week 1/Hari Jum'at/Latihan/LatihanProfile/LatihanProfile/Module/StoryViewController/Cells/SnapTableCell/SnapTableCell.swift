import UIKit

class SnapTableCell: UITableViewCell {

    @IBOutlet weak var snapCollection: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollection()
    }
    
    func setupCollection() {
        snapCollection.delegate = self
        snapCollection.dataSource = self
        snapCollection.registerCellWithNib(SnapCollectionViewCell.self)
    }
}

extension SnapTableCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return snapItem.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as SnapCollectionViewCell
        let snapEntity = snapItem[indexPath.row]
        cell.configureCollection(with: snapEntity)
        
        return cell
    }
}
