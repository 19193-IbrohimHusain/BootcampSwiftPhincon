import UIKit

class SnapTableCell: UITableViewCell {

    @IBOutlet weak var snapColletionView: UICollectionView!
    
    var data: [ListStory]?
    
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
        return data?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let validData = data {
            let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as SnapCollectionCell
            let snapEntity = validData[indexPath.row]
            cell.configureCollection(with: snapEntity)
            
            return cell
        }
        return UICollectionViewCell()
        
    }
}
