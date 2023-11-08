import UIKit
import SkeletonView

protocol SnapTableCellDelegate {
    func navigateToDetail(id: String)
}

class SnapTableCell: UITableViewCell {

    @IBOutlet weak var snapColletionView: UICollectionView!
    
    var delegate: SnapTableCellDelegate?
    
    var data: [ListStory]? {
        didSet {
            DispatchQueue.main.async {
                self.snapColletionView.reloadData()
            }
        }
    }
    
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.row
        if let storyID = data?[index].id {
            self.delegate?.navigateToDetail(id: storyID)
        }
    }
}

extension SnapTableCell: SkeletonCollectionViewDataSource {
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return String(describing: SnapCollectionCell.self)
    }
}
