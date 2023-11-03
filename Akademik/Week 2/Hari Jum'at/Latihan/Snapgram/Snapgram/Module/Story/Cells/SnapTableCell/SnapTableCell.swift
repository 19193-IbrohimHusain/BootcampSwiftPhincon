import UIKit

class SnapTableCell: UITableViewCell {

    @IBOutlet weak var snapColletionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollection()
    }
    
    func setupCollection() {
        snapColletionView.delegate = self
        snapColletionView.dataSource = self
        snapColletionView.registerCellWithNib(SnapCollectionCell.self)
    }
}

extension SnapTableCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return snapItem.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as SnapCollectionCell
        let snapEntity = snapItem[indexPath.row]
        cell.configureCollection(with: snapEntity)
        
        return cell
    }
}
